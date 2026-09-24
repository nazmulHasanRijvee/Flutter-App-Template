import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logger/app_logger.dart';
import 'secure_token.dart';
import 'token_store.dart';

/// Owns the application's access and refresh tokens.
///
/// [TokenManager] does not perform authentication or refresh requests. The
/// refresh interceptor owns that flow; this class only loads, exposes, saves,
/// updates, and clears tokens for the rest of the app.
/// Token storage with session-change notifications for Riverpod. It contains
/// no refresh HTTP logic; the refresh interceptor owns that flow.
class TokenManager {
  TokenManager({required this._store}) {
    _ready = _loadTokens();
  }

  final TokenStore _store;

  late final Future<void> _ready;
  String? _accessToken;
  String? _refreshToken;

  /// The token used by the access-token interceptor.
  Future<String?> get accessToken async {
    await _ready;
    return _accessToken;
  }

  /// The token used by the refresh interceptor.
  Future<String?> get refreshToken async {
    await _ready;
    return _refreshToken;
  }

  /// Removes the current session from memory and secure storage.
  Future<void> clearSession() async {
    await _ready;
    _accessToken = null;
    _refreshToken = null;
    await _store.clear();
  }

  Future<void> saveTokens({required String access, String? refresh}) async {
    await _ready;

    // Complete storage writes before changing memory, so a failed secure
    // storage write cannot leave the in-memory session ahead of storage.
    await _store.write(TokenKey.access, access);
    if (refresh != null) {
      await _store.write(TokenKey.refresh, refresh);
    }

    _accessToken = access;
    if (refresh != null) {
      _refreshToken = refresh;
    }
  }

  Future<void> _loadTokens() async {
    try {
      _accessToken = await _store.read(TokenKey.access);
      _refreshToken = await _store.read(TokenKey.refresh);
    } catch (error, stackTrace) {
      AppLogger.error('TokenManager._loadTokens failed: $error\n$stackTrace');
    }
  }
}

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return SecureTokenStore();
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager(
    store: ref.read(tokenStoreProvider),
  );
});
