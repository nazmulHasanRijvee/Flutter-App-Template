# State management

Riverpod is used for dependency injection, persisted application state, async startup work, and feature state.

## Provider scope

`main.dart` creates `ProviderScope` with two important pieces:

- `sharedPreferencesProvider` is overridden with the initialized SharedPreferences instance.
- `RiverpodObserver` is registered for provider lifecycle logging.

This keeps platform initialization out of individual providers and makes the cache dependency replaceable in tests.

## Application state providers

The main application state flow is:

```text
startupProvider
      ↓
routerStateProvider ← onboardingStatusProvider
      ↑              ← sessionStatusProvider ← authServiceProvider ← cacheServiceProvider
      ↓
     go_router redirect
```

- `startupProvider` performs startup tasks, currently loading the saved locale.
- `onboardingStatusProvider` reads whether onboarding is complete.
- `sessionStatusProvider` derives authentication from the stored access token and user.
- `routerStateProvider` combines those values into a `Routes` gate.

The router watches the derived gate instead of reading tokens or startup details directly.

## Theme and locale

`themeModeProvider` is an `AsyncNotifier` that loads and saves `ThemeMode` through `CacheService`. `MyApp` watches it and supplies the selected mode to `MaterialApp.router`.

`localizationProvider` stores the current `Locale`, and `startupProvider` restores the saved language. The current `MyApp` does not yet pass this provider into `MaterialApp.router` as `locale`; add that wiring when localized resource loading is introduced.

## Provider guidelines

- Use providers for dependencies and observable state.
- Keep derived providers pure when possible.
- Put async work in an `AsyncNotifier`, `FutureProvider`, or feature-specific notifier.
- Keep persistence behind a service or repository.
- Avoid calling `ref.read` from build methods when `ref.watch` expresses a dependency.
- Invalidate or update the state that drives routing after login, logout, or onboarding completion; do not duplicate redirect logic in widgets.
