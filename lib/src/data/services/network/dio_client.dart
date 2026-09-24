import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/token_manager.dart';
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

    final tokenManager = ref.read(tokenManagerProvider);

    dio.interceptors.addAll([
      AccessTokenInterceptor(
        // onRequest: attach token
        tokenManager: tokenManager,
      ),
      TokenRefreshInterceptor(
        // onError: refresh token
        tokenManager: tokenManager,
        dio: dio,
      ),
      if (kDebugMode) // disable logging only in production (release mode)
        // Auth request and response bodies may contain passwords and tokens.
        LogInterceptor(requestBody: false, responseBody: false), // always last
    ]);

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance(ref);
});
