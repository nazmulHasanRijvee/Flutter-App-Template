import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_const.dart';
import '../../cache/cache_service.dart';

class TokenManager extends Interceptor {
  TokenManager({
    required this.baseUrl,
    required this.refreshTokenEndpoint,
    required this.cacheService,
    required this.navigatorKey,
    required this.dio,
  });

  final String baseUrl;
  final String refreshTokenEndpoint;
  final CacheService cacheService;
  final GlobalKey<NavigatorState> navigatorKey;
  final Dio dio;

  /// A bare Dio instance with NO interceptors, used exclusively for
  /// the token refresh call. This prevents re-entering [TokenManager]
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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

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
    } finally {
      _isRefreshing = false;
      _queue.clear();
    }
  }

  Future<String> _refreshAccessToken() async {
    final refreshToken = getRefreshToken();
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
    await saveToken(CacheKey.accessToken, newToken);

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
    await cacheService.remove([CacheKey.accessToken, CacheKey.refreshToken]);
  }

  void _navigateToLoginScreen() {
    if (navigatorKey.currentState?.mounted == true) {
      navigatorKey.currentState?.context.goNamed(RouteConst.login, extra: true);
    }
  }

  Future<void> saveToken(CacheKey key, String value) async {
    await cacheService.save(key, value);
  }

  // SharedPreferences.get() is synchronous — no async needed.
  String? getAccessToken() => cacheService.get(CacheKey.accessToken);

  String? getRefreshToken() => cacheService.get(CacheKey.refreshToken);
}

class _QueuedRequest {
  const _QueuedRequest({required this.options, required this.handler});

  final RequestOptions options;
  final ErrorInterceptorHandler handler;
}
