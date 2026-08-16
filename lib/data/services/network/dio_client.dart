import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/navigator_key_provider.dart'
    show navigatorKeyProvider;
import '../cache/cache_service.dart';
import 'endpoints.dart';
import 'interceptor/token_manager.dart';

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
      TokenManager(
        baseUrl: Endpoints.base,
        refreshTokenEndpoint: Endpoints.refreshToken,
        cacheService: ref.read(cacheServiceProvider),
        navigatorKey: ref.read(navigatorKeyProvider),
        dio: dio,
      ),
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);

    return dio;
  }
}

final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance(ref);
});
