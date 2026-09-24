import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../presentation/core/application_state/session_status_provider/session_status_provider.dart';
import '../services/cache/cache_service.dart';
import '../services/network/api_handler.dart';
import '../services/network/auth/token_manager.dart';
import '../services/network/rest_client.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.local,
    required this.tokens,
    required this.onSessionChanged,
  });

  final RestClient remote;
  final CacheService local;
  final TokenManager tokens;

  /// Notifies the presentation layer after the stored session changes.
  final void Function() onSessionChanged;

  @override
  Future<bool> login({
    required String username,
    required String password,
    bool shouldRemember = false,
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

        onSessionChanged();

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
      return local.get<bool>(CacheKey.rememberMe) ?? false;
    }

    await local.save(CacheKey.rememberMe, rememberMe);
    return rememberMe;
  }


  @override
  Future<bool> restoreSession() async {
    final remembered = local.get<bool>(CacheKey.isLoggedIn) ?? false;
    if (!remembered || await tokens.refreshToken == null) {
      await tokens.clearSession();
      onSessionChanged();
    }
    return remembered;
  }

  @override
  Future<bool> logout() async {
    await local.remove([CacheKey.isLoggedIn, CacheKey.rememberMe]);
    await tokens.clearSession();
    onSessionChanged();
    return true;
  }
}

final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepositoryImpl(
    remote: ref.watch(restClientProvider),
    local: ref.watch(cacheServiceProvider),
    tokens: ref.watch(tokenManagerProvider),
    onSessionChanged: () => ref.invalidate(sessionStatusProvider),
  );
});
