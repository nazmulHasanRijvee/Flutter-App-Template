import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_const.dart';
import '../../auth/auth_service.dart';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required this.baseUrl,
    required this.refreshTokenEndpoint,
    required this.authService,
    required this.navigatorKey,
    required this.dio,
  });

  final String baseUrl;
  final String refreshTokenEndpoint;
  final AuthService authService;
  final GlobalKey<NavigatorState> navigatorKey;
  final Dio dio;

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
      _queue.add(_QueuedRequest(options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshAccessToken();
      await _retryFailedRequest(err.requestOptions, handler, newToken);
      await _retryQueuedRequests(newToken);
    } catch (e) {
      await _handleRefreshFailure(err, handler);
      for (final queuedRequest in _queue) {
        queuedRequest.handler.reject(
          err,
        ); // resolve or reject queued requests with the original error
      }
    } finally {
      _isRefreshing = false;
      _queue.clear();
    }
  }

  Future<String> _refreshAccessToken() async {
    final refreshToken = getRefreshToken;
    if (refreshToken == null) {
      throw DioException(
        requestOptions: RequestOptions(),
        error: 'No refresh token available',
      );
    }

    // Use the bare _refreshDio — no interceptors, no retry loop risk.
    final refreshResp = await _refreshDio.get(
      refreshTokenEndpoint,
      options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
    );

    if (refreshResp.statusCode != 200) {
      throw DioException(
        requestOptions: RequestOptions(),
        error: 'Refresh failed with status: ${refreshResp.statusCode}',
      );
    }

    final newToken = refreshResp.data['data']['accessToken'] as String;
    await saveToken(newToken);

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
          queuedRequest.options,
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
    await _removeTokens();
    _navigateToLoginScreen();
    handler.reject(originalError);
  }

  Future<void> _removeTokens() async {
    await authService.clearSession();
  }

  void _navigateToLoginScreen() {
    if (navigatorKey.currentState?.mounted == true) {
      navigatorKey.currentState?.context.goNamed(RouteConst.login, extra: true);
    }
  }

  Future<void> saveToken(String value) async {
    await authService.updateAccessToken(value);
  }

  // SharedPreferences.get() is synchronous — no async needed.
  String? get getRefreshToken => authService.refreshToken;
}

class _QueuedRequest {
  const _QueuedRequest({required this.options, required this.handler});

  final RequestOptions options;
  final ErrorInterceptorHandler handler;
}
