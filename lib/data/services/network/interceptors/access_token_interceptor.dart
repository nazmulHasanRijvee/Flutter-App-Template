import 'package:dio/dio.dart';

import '../../auth/auth_service.dart';

/// Job: attach the current access token to every outgoing request.
/// Nothing else. No refresh logic, no queue, no navigation.
class AccessTokenInterceptor extends Interceptor {
  AccessTokenInterceptor({required this.authService});

  final AuthService authService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = getAccessToken;
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  String? get getAccessToken => authService.accessToken;
}
