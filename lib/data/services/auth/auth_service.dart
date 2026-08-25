import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../cache/cache_service.dart';

class AuthService {
  AuthService({required this.cache});

  final CacheService cache;

  String? get accessToken => cache.get<String>(CacheKey.accessToken);

  String? get refreshToken => cache.get<String>(CacheKey.refreshToken);

  Map<String, dynamic>? get user =>
      cache.get<Map<String, dynamic>>(CacheKey.user);

  bool get isLoggedIn => accessToken != null && user != null;

  bool? get rememberMe => cache.get<bool>(CacheKey.rememberMe);

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required Map<String, dynamic> user,
  }) async {
    await cache.save(CacheKey.accessToken, accessToken);
    await cache.save(CacheKey.refreshToken, refreshToken);
    await cache.save(CacheKey.user, user);
  }

  Future<void> updateAccessToken(String value) async {
    await cache.save(CacheKey.accessToken, value);
  }

  Future<void> setRememberMe(bool value) {
    return cache.save(CacheKey.rememberMe, value);
  }

  Future<void> clearSession() async {
    await cache.remove([
      CacheKey.accessToken,
      CacheKey.refreshToken,
      CacheKey.user,
    ]);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  return AuthService(cache: cacheService);
});
