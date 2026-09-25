import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../services/cache/cache_service.dart';
import '../services/network/api_handler.dart';
import '../services/network/auth/token_manager.dart';
import '../services/network/rest_client.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.local,
    required this.tokens,
  });

  final RestClient remote;
  final CacheService local;
  final TokenManager tokens;

  @override
  Future<bool> login({
    required String username,
    required String password,
    bool shouldRemember = true,
  }) async {
    bool loggedIn = false;

    await Api.call(
      action: remote.login({'username': username, 'password': password}),
      onSuccess: (data) async {
        await tokens.saveTokens(
          access: data['accessToken'] as String,
          refresh: data['refreshToken'] as String,
        );

        if (shouldRemember) {
          try {
            await _saveSession();
          } catch (_) {
            await tokens.clearSession();
            rethrow;
          }
        }

        loggedIn = true;
      },
      onError: (_) {},
    );

    return loggedIn;
  }

  Future<void> _saveSession() async {
    await local.save(CacheKey.isLoggedIn, true);
  }

  @override
  Future<bool> rememberMe({bool? rememberMe}) async {
    if (rememberMe == null) {
      /// Defaults to true
      return local.get<bool>(CacheKey.rememberMe) ?? true;
    }

    await local.save(CacheKey.rememberMe, rememberMe);
    return rememberMe;
  }

  @override
  Future<bool> restoreSession() async {
    final remembered = local.get<bool>(CacheKey.isLoggedIn) ?? false;

    final refreshToken = await tokens.refreshToken;
    final hasSession = refreshToken != null && refreshToken.isNotEmpty;

    if (!remembered && hasSession) {
      await tokens.clearSession();
    }
    return remembered;
  }

  @override
  Future<bool> logout() async {
    await local.remove([CacheKey.isLoggedIn, CacheKey.rememberMe]);
    await tokens.clearSession();
    return true;
  }
}

final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    remote: ref.watch(restClientProvider),
    local: ref.watch(cacheServiceProvider),
    tokens: ref.watch(tokenManagerProvider),
  );
});
