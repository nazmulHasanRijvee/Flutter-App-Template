import 'package:dio/dio.dart';

import '../../../../core/logger/app_logger.dart';
import '../../network/auth/token_manager.dart';

/// Thrown when there is no refresh token to send. This is NOT a network
/// problem. It's positive proof there's no session to refresh, so it's
/// treated the same as an explicit rejection from the server.
class _NoRefreshTokenException implements Exception {}

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required this.baseUrl,
    required this.refreshTokenEndpoint,
    required this.tokenManager,
    required this.dio,
    required this.onSessionExpired,
  });

  final String baseUrl;
  final String refreshTokenEndpoint;
  final TokenManager tokenManager;
  final Dio dio;
  final void Function() onSessionExpired;

  /// A bare Dio instance with NO interceptors, used exclusively for
  /// the token refresh call. This prevents re-entering the interceptor loop
  /// if the refresh endpoint itself returns a 401.
  late final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  bool _isRefreshing = false;
  final List<_QueuedRequest> _queue = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    if (statusCode == 401 && options.extra['retry'] != true) {
      await _handleUnauthorizedError(err, handler);
      return;
    }

    handler.next(err);
  }

  Future<void> _handleUnauthorizedError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isRefreshing) {
      _queue.add(_QueuedRequest(options: err.requestOptions, handler: handler, error: err));
      return;
    }

    _isRefreshing = true;

    try {
      final String newToken;
      try {
        newToken = await _refreshAccessToken();
      } catch (refreshError, stackTrace) {
        AppLogger.error('Token refresh failed: $refreshError\n$stackTrace');

        if (_isRefreshTokenRejected(refreshError)) {
          // Positive proof the refresh token itself is dead — real logout.
          await _handleRefreshFailure(err, handler);
        } else {
          // Transient failure: offline, timeout, server 5xx, malformed
          // response body. The refresh token might still be perfectly
          // valid — do NOT clear the session. Just fail this one request;
          // the next request the user (or a retry) makes will attempt to
          // refresh again from scratch.
          handler.reject(err);
        }

        _rejectQueuedRequests();
        return;
      }

      // Keep request replay outside the refresh try/catch. A 401/403 from the
      // original endpoint says nothing about whether the refresh token was valid.
      try {
        await _retryFailedRequest(err.requestOptions, handler, newToken);
      } on DioException catch (retryError) {
        handler.reject(retryError);
      }

      await _retryQueuedRequests(newToken);
    } finally {
      _isRefreshing = false;
      _queue.clear();
    }
  }

  /// True only when we have positive proof the refresh token is invalid:
  /// there was no refresh token to send at all, or the refresh endpoint
  /// explicitly returned 401/403 for it. Every other failure like timeouts,
  /// no internet, 5xx, a malformed response body must NOT be treated
  /// as "the refresh token is bad," because it isn't proof of that.
  bool _isRefreshTokenRejected(Object error) {
    if (error is _NoRefreshTokenException) return true;
    if (error is! DioException) return false;

    final statusCode = error.response?.statusCode;
    return statusCode == 401 || statusCode == 403;
  }

  Future<String> _refreshAccessToken() async {
    final refreshToken = await tokenManager.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw _NoRefreshTokenException();
    }

    // Use the bare _refreshDio — no interceptors, no retry loop risk.
    final refreshResp = await _refreshDio.get(
      refreshTokenEndpoint,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );

    if (refreshResp.statusCode != 200) {
      throw DioException(
        requestOptions: refreshResp.requestOptions,
        response: refreshResp,
        error: 'Refresh failed with status: ${refreshResp.statusCode}',
      );
    }

    final newToken = refreshResp.data['data']['accessToken'] as String;
    // if only backend rotates refresh token after one usage
    final newRefreshToken = refreshResp.data['data']['refreshToken'] as String?;

    if (newRefreshToken != null) {
      // Backend rotated the refresh token — must save both or the
      // next refresh attempt uses a now-dead refresh token.
      await tokenManager.saveTokens(
        access: newToken,
        refresh: newRefreshToken,
      );
    } else {
      // Backend doesn't rotate — access token only.
      await tokenManager.saveTokens(access: newToken);
    }

    return newToken;
  }

  Future<void> _retryFailedRequest(
    RequestOptions options,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    options.headers['Authorization'] = 'Bearer $newToken';
    options.extra['retry'] = true;

    final retryResponse = await dio.fetch(options);
    handler.resolve(retryResponse);
  }

  Future<void> _retryQueuedRequests(String newToken) async {
    // Work from a snapshot so a retried request cannot mutate the queue being
    // iterated if another unauthorized request arrives during replay.
    while (_queue.isNotEmpty) {
      final queuedRequests = List<_QueuedRequest>.of(_queue);
      _queue.clear();
      for (final queuedRequest in queuedRequests) {
        try {
          await _retryFailedRequest(
            queuedRequest.options,
            queuedRequest.handler,
            newToken,
          );
        } on DioException catch (e) {
          queuedRequest.handler.reject(e);
        }
      }
    }
  }

  void _rejectQueuedRequests() {
    for (final queuedRequest in _queue) {
      queuedRequest.handler.reject(queuedRequest.error);
    }
    _queue.clear();
  }

  Future<void> _handleRefreshFailure(
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    // remove tokens and go_router listening throgh [sessionProvider] will redirect to login page
    //await authService.clearSession();
    await tokenManager.clearSession();
    onSessionExpired();
    handler.reject(originalError);
  }
}

class _QueuedRequest {
  const _QueuedRequest({required this.options, required this.handler, required this.error});

  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  final DioException error;
}
