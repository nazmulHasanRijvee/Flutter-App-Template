import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/router_repository.dart';
import '../services/cache/cache_service.dart';
import '../services/network/auth/token_manager.dart';

class RouterRepositoryImpl extends RouterRepository {
  RouterRepositoryImpl({required this.cacheService, required this.tokens});

  final CacheService cacheService;
  final TokenManager tokens;

  @override
  bool isOnboardingCompleted() {
    return cacheService.get(CacheKey.isOnBoardingCompleted) ?? false;
  }

  @override
  Stream<bool> get sessionStream => tokens.sessionStream;

  @override
  Future<bool> hasSession() async {
    final refreshToken = await tokens.refreshToken;

    return refreshToken != null && refreshToken.isNotEmpty;
  }

  @override
  Future<void> saveOnboardingAsCompleted() async {
    await cacheService.save(CacheKey.isOnBoardingCompleted, true);
  }
}

final routerRepoProvider = Provider<RouterRepository>((ref) {
  final cacheService = ref.watch(cacheServiceProvider);
  final tokenManager = ref.watch(tokenManagerProvider);
  return RouterRepositoryImpl(cacheService: cacheService, tokens: tokenManager);
});
