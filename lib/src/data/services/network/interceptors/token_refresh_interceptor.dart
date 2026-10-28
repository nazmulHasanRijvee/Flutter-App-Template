import 'package:dio/dio.dart';

import '../auth/token_manager.dart';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required this.baseUrl,
    required this.refreshEndpoint,
    required this.tokenManager,
    required this.dio
    }) : _refreshDio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
         ),
       );

  final String baseUrl;
  final String refreshEndpoint;
  final Dio _refreshDio;
  final TokenManager tokenManager;
  final Dio dio;

  bool _isRefreshing = false;
  final List<_QueuedRequest> _queue = [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    final options = err.requestOptions;

    if (_shouldHandleError(statusCode, options)) {
      await _handleUnauthorizedError(err, handler);
      return;
    }

    handler.next(err);
  }

  bool _shouldHandleError(int? statusCode, RequestOptions options) {
    return statusCode == 401 && options.extra['retry'] != true;
  }

  Future<void> _handleUnauthorizedError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isRefreshing) {
      _queue.add(_QueuedRequest(error: err, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshAccessToken();

      await _retryFailedRequest(err.requestOptions, handler, newToken);
      await _retryQueuedRequests(newToken);
    } catch (e) {
      await _handleRefreshFailure(err, handler);
    } finally {
      _isRefreshing = false;
      _queue.clear();
    }
  }

  Future<String> _refreshAccessToken() async {
    final currentEpoch = tokenManager.sessionEpoch;
    final refreshToken = await tokenManager.refreshToken;
    
    if (refreshToken == null) {
      throw DioException(
        requestOptions: RequestOptions(),
        error: 'No refresh token available',
      );
    }

    final refreshResp = await _refreshDio.fetch(
      RequestOptions(
        baseUrl: baseUrl,
        path: refreshEndpoint,
        method: 'GET',
        headers: {'Authorization': 'Bearer $refreshToken'},
      ),
    );

    if (refreshResp.statusCode != 200) {
      throw DioException(
        requestOptions: RequestOptions(),
        error:
            'Refresh token request failed with status: '
            '${refreshResp.statusCode}',
      );
    }

    final newToken = refreshResp.data['data']['accessToken'] as String;
    final saved = await tokenManager.saveTokens(
      access: newToken,
      expectedEpoch: currentEpoch,
    );

    if (!saved) {
      throw DioException(
        requestOptions: RequestOptions(),
        error: 'Session was invalidated during token refresh',
      );
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
    for (final queuedRequest in _queue) {
      try {
        await _retryFailedRequest(
          queuedRequest.error.requestOptions,
          queuedRequest.handler,
          newToken,
        );
      } on DioException catch (e) {
        queuedRequest.handler.reject(e);
      }
    }
  }

  Future<void> _handleRefreshFailure(
    DioException originalError,
    ErrorInterceptorHandler handler,
  ) async {
    await tokenManager.clearSession();

    handler.reject(originalError);
    _rejectQueuedRequests();
  }

  void _rejectQueuedRequests([DioException? fallbackError]) {
    for (final queued in _queue) {
      queued.handler.reject(fallbackError ?? queued.error);
    }
  }

}

class _QueuedRequest {
  const _QueuedRequest({required this.error, required this.handler});

  final DioException error;
  final ErrorInterceptorHandler handler;
}
