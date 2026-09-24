import 'package:dio/dio.dart';

import '../auth/token_manager.dart';

/// Job: attach the current access token to every outgoing request.
/// Nothing else. No refresh logic, no queue, no navigation.
class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor({required this.tokenManager});

  final TokenManager tokenManager;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenManager.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }
}
