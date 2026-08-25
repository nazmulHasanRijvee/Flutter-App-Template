import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/navigator_key_provider.dart'
    show navigatorKeyProvider;
import '../auth/auth_service.dart';
import 'endpoints.dart';
import 'interceptors/access_token_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

class DioClient {
  static Dio getInstance(Ref ref) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.base,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AccessTokenInterceptor(
        // onRequest: attach token
        authService: ref.read(authServiceProvider),
      ),
      TokenRefreshInterceptor(
        // onError: refresh token
        baseUrl: Endpoints.base,
        refreshTokenEndpoint: Endpoints.refreshToken,
        authService: ref.read(authServiceProvider),
        navigatorKey: ref.read(navigatorKeyProvider),
        dio: dio,
      ),
      if (kDebugMode)
        LogInterceptor(requestBody: true, responseBody: true), // always last
    ]);

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance(ref);
});
