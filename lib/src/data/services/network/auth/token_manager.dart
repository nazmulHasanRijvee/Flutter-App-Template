import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_app_template/src/data/services/network/endpoints.dart';
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
  TokenManager({
    required this._store,
    required String refreshBaseUrl,
    required this._refreshEndpoint,
  }) : _refreshDio = Dio(
         BaseOptions(
           baseUrl: refreshBaseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
         ),
       ) {
    _ready = _loadTokens();
  }

  final TokenStore _store;
  final String _refreshEndpoint;
  final Dio _refreshDio;

  late final Future<void> _ready;
  String? _accessToken;
  String? _refreshToken;
  Completer<String>? _inflightRefresh;

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

  /// True once a refresh has definitively failed and cleared the session.
  /// Sync is fine here, by the time anything calls this, [refresh] has
  /// already awaited [_ready] internally.
  bool get hasSession => _refreshToken != null;

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

  /// Removes the current session from memory and secure storage.
  Future<void> clearSession() async {
    await _ready;
    _accessToken = null;
    _refreshToken = null;
    await _store.clear();
  }

  /// Refreshes the access token. Concurrent callers share one HTTP roundtrip.
  Future<String> refresh() async {
    await _ready;

    final existing = _inflightRefresh;
    if (existing != null) return existing.future;

    final completer = Completer<String>();
    _inflightRefresh = completer;
    unawaited(_runRefresh(completer));
    return completer.future;
  }

  Future<void> _runRefresh(Completer<String> completer) async {
    try {
      final newAccess = await _performRefresh();
      completer.complete(newAccess);
    } catch (e, stackTrace) {
      if (_isAuthDefinitive(e)) {
        try {
          await clearSession();
        } catch (clearError, clearStack) {
          AppLogger.error(
            "TokenManager.clearSession() failed", error: clearError, stackTrace: clearStack,
          );
        }
      }
      completer.completeError(e, stackTrace);
    } finally {
      _inflightRefresh = null;
    }
  }

  /// Only an explicit rejection of the refresh token counts as "session
  /// dead." Timeouts, 5xx, connection errors prove nothing about the token
  /// — keep the session and let the caller's request fail this once.
  bool _isAuthDefinitive(Object error) {
    if (error is StateError) return true;
    if (error is DioException && error.type == DioExceptionType.badResponse) {
      return switch (error.response?.statusCode) {
        400 || 401 || 403 => true,
        _ => false,
      };
    }

    return false;
  }

  Future<String> _performRefresh() async {
    final refreshToken = _refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('No refresh token available');
    }

    final response = await _refreshDio.get<dynamic>(
      _refreshEndpoint,
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw StateError('Refresh response was not a JSON object');
    }

    final newAccess = data['accessToken'];
    if (newAccess is! String || newAccess.isEmpty) {
      throw StateError('Refresh response missing accessToken');
    }

    await _store.write(.access, newAccess);
    _accessToken = newAccess;

    final newRefresh = data['refreshToken'];
    if (newRefresh is String && newRefresh.isNotEmpty) {
      await _store.write(.refresh, newRefresh);
      _refreshToken = newRefresh;
    }

    return newAccess;
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
    refreshBaseUrl: Endpoints.base,
    refreshEndpoint: Endpoints.refreshToken,
  );
});
