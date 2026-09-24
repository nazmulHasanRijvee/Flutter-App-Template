enum TokenKey { access, refresh }

/// Storage contract for auth tokens.

abstract class TokenStore {
  Future<String?> read(TokenKey key);

  Future<void> write(TokenKey key, String value);

  Future<void> delete(TokenKey key);

  Future<void> clear();
}
