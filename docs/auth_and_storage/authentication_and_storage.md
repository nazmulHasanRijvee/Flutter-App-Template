# Authentication & Local Persistence

The project employs a dual-storage strategy: **Encrypted Secure Storage** for sensitive credentials (access/refresh tokens) and **SharedPreferences** for non-sensitive local user preferences.

---

## 1. Storage Architecture

```text
 ┌─────────────────────────────────────────────────────────────┐
 │                      Application Layer                      │
 └──────────────┬───────────────────────────────┬──────────────┘
                │                               │
       Sensitive Auth Tokens            User Preferences / Flags
                │                               │
                ▼                               ▼
 ┌─────────────────────────────┐ ┌─────────────────────────────┐
 │      TokenManager           │ │       CacheService          │
 │ (In-Memory + Secure Storage)│ │   (SharedPreferences)       │
 └──────────────┬──────────────┘ └──────────────┬──────────────┘
                │                               │
                ▼                               ▼
 ┌─────────────────────────────┐ ┌─────────────────────────────┐
 │      SecureTokenStore       │ │   SharedPreferenceService   │
 │   (FlutterSecureStorage)    │ │   • isOnBoardingCompleted   │
 │   • TokenKey.access         │ │   • rememberMe              │
 │   • TokenKey.refresh        │ │   • isLoggedIn (flag)       │
 └─────────────────────────────┘ │   • theme_mode, locale      │
                                 └─────────────────────────────┘
```

---

## 2. Token Management & Security

`TokenManager` (`lib/src/data/services/network/auth/token_manager.dart`) owns the auth lifecycle:

- **Atomic Storage Writes**: Writes to `SecureTokenStore` before updating memory state, preventing stale in-memory state if storage write fails.
- **Session Notification**: Emits `true` on `sessionStream` when tokens are saved, and `false` when `clearSession()` is invoked.
- **Single-Flight Concurrency**: Deduplicates concurrent 401 token refresh requests. See [Token Refresh Logic](../network/token_refresh_logic.md).

---

## 3. Authentication Repository (`AuthenticationRepositoryImpl`)

The authentication contract handles login, session restoration, and logout:

- **`login({username, password, shouldRemember})`**:
  1. Authenticates against remote API via `RestClient`.
  2. Saves access & refresh tokens to `TokenManager`.
  3. If `shouldRemember` is true, persists `CacheKey.isLoggedIn = true` in `CacheService`.
- **`restoreSession()`**:
  1. Checks if `isLoggedIn` was remembered in `CacheService`.
  2. If not remembered, clears stored tokens via `TokenManager.clearSession()`.
- **`logout()`**:
  1. Clears `CacheKey.isLoggedIn` and `CacheKey.rememberMe`.
  2. Clears tokens via `TokenManager.clearSession()`, triggering `sessionStatusProvider` to redirect the user to the login screen.

---

## 4. Reactive Session Stream (`sessionStatusProvider`)

`sessionStatusProvider` derives the real-time auth status from `RouterRepository.sessionStream`:

```dart
final sessionStatusProvider = StreamProvider<SessionStatus>((ref) async* {
  final repository = ref.watch(routerRepoProvider);

  // 1. Initial status check
  final hasInitialSession = await repository.hasSession();
  yield hasInitialSession ? SessionStatus.authenticated : SessionStatus.unauthenticated;

  // 2. React to all stream changes (login / refresh failure / logout)
  await for (final hasSession in repository.sessionStream) {
    yield hasSession ? SessionStatus.authenticated : SessionStatus.unauthenticated;
  }
});
```
