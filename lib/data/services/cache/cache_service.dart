import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preference_service.dart';

enum CacheKey {
  accessToken,
  refreshToken,
  isOnBoardingCompleted,
  isLoggedIn,
  rememberMe,
  role,
  language,
  themeMode,
  user,
}

abstract interface class CacheService {
  Future<void> save<T>(CacheKey key, T value);

  T? get<T>(CacheKey key);

  Future<void> remove(List<CacheKey> keys);

  Future<void> clear();
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main');
});

final cacheServiceProvider = Provider<CacheService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPreferencesService(prefs);
});
