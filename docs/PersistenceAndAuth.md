# Persistence and authentication

Local persistence is abstracted behind `CacheService`, with SharedPreferences as the current implementation.

## Cache service

`CacheKey` defines the supported persisted values:

- access and refresh tokens
- user data
- remember-me preference
- onboarding completion
- language
- theme mode
- role

Use `cacheServiceProvider` instead of accessing SharedPreferences directly. This keeps storage replaceable and makes tests easier to isolate.

## Provider initialization

`sharedPreferencesProvider` intentionally throws until it is overridden. `main.dart` performs the initialization once:

```dart
final prefs = await SharedPreferences.getInstance();

ProviderScope(
  overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ],
  child: const MyApp(),
)
```

If a test creates providers without `ProviderScope` or without this override, it must provide a fake SharedPreferences dependency or a replacement cache provider.

## Session rules

`AuthService.isLoggedIn` is true only when both an access token and user data are present. `saveSession` stores the access token, refresh token, and user map. `clearSession` removes those three values and is used by logout.

The router derives the authenticated/unauthenticated gate from this service. After login or logout, update the underlying persisted state so Riverpod and go_router can recalculate the destination.

## Adding persisted data

1. Add a stable enum value to `CacheKey`.
2. Add the read/write behavior to the relevant service or repository.
3. Keep serialization explicit for maps and custom models.
4. Decide whether the value should be cleared on logout.
5. Add tests for missing, valid, and malformed values.

SharedPreferences is local device storage, not a secure vault. Use a secure storage solution for sensitive secrets in a production application.
