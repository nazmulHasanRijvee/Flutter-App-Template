import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logger/app_logger.dart';
import 'secure_token.dart';
import 'token_store.dart';

/// Owns the application's access and refresh tokens.
///
/// [TokenManager] loads, exposes, saves,
/// updates, and clears tokens for the rest of the app.
/// Token storage with session-change notifications for Riverpod. It contains
/// no refresh HTTP logic; the refresh interceptor owns that flow.
class TokenManager {
  TokenManager({
    required this._store,
  }) {
    _ready = _loadTokens();
  }

  final TokenStore _store;
  final StreamController<bool> _sessionController =
      StreamController<bool>.broadcast();
  late final Future<void> _ready;
  String? _accessToken;
  String? _refreshToken;
  // 1. Session epoch counter
  int _sessionEpoch = 0;

  /// The current session epoch. Incremented whenever the session is cleared.
  int get sessionEpoch => _sessionEpoch;

  /// Emits `true` when tokens are saved and `false` when the session is cleared.
  ///
  /// .distinct() filters the Stream so it only fires when the session status
  /// (true <-> false) actually changes. This way repeated true -> true emissions
  /// from silent token refreshes are dropped
  Stream<bool> get sessionStream => _sessionController.stream.distinct();

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

  /// True if an active session exists (i.e. refresh token is present).
  /// Returns false once a logout occurs or a refresh definitively fails.
  bool get hasSession => _refreshToken != null;

  Future<bool> saveTokens({
    required String access,
    String? refresh,
    int? expectedEpoch,
  }) async {
    await _ready;

    if (expectedEpoch != null && expectedEpoch != _sessionEpoch) {
      return false;
    }

    // Complete storage writes before changing memory, so a failed secure
    // storage write cannot leave the in-memory session ahead of storage.
    await _store.write(TokenKey.access, access);

    if (refresh != null && refresh.isNotEmpty) {
      await _store.write(TokenKey.refresh, refresh);
    }

    _accessToken = access;
    if (refresh != null && refresh.isNotEmpty) _refreshToken = refresh;

    _sessionController.add(true);
    return true;
  }

  /// Removes the current session from memory and secure storage.
  Future<void> clearSession() async {
    _sessionEpoch++; // Immediately invalidates any in-flight refresh
    await _ready;
    await _store.clear();
    _accessToken = null;
    _refreshToken = null;
    _sessionController.add(false);
  }

  /// Closes the session broadcast controller and _refreshDio's socket pool.
  void dispose() {
    _sessionController.close();
  }

  Future<void> _loadTokens() async {
    try {
      _accessToken = await _store.read(TokenKey.access);
      _refreshToken = await _store.read(TokenKey.refresh);
    } catch (error, stackTrace) {
      AppLogger.error(
        "TokenManager._loadTokens failed",
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return SecureTokenStore();
});

final tokenManagerProvider = Provider<TokenManager>((ref) {
  final manager = TokenManager(
    store: ref.read(tokenStoreProvider),
  );

  ref.onDispose(manager.dispose);
  return manager;
});
