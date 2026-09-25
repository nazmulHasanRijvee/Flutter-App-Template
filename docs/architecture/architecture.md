# Application Architecture

This project adopts a **Clean, Layered Architecture** with strict separation of concerns, powered by **Riverpod** for declarative dependency injection and state observation.

---

## 1. Architectural Layers & Boundaries

```text
 ┌─────────────────────────────────────────────────────────┐
 │                   Presentation Layer                    │
 │    Screens, Widgets, ViewModels, Theme, go_router       │
 └────────────────────────────┬────────────────────────────┘
                              │ calls contracts
                              ▼
 ┌─────────────────────────────────────────────────────────┐
 │                      Domain Layer                       │
 │      Repository Interfaces & Pure Business Contracts     │
 └────────────────────────────▲────────────────────────────┘
                              │ implements
 ┌────────────────────────────┴────────────────────────────┐
 │                       Data Layer                        │
 │   Repository Impls, RestClient, Dio, TokenManager, Cache│
 └────────────────────────────┬────────────────────────────┘
                              │ utilizes
 ┌────────────────────────────┴────────────────────────────┐
 │                       Core Layer                        │
 │    AppLogger, Extensions, Utilities, Base Crash Handlers│
 └─────────────────────────────────────────────────────────┘
```

### Dependency Rules:
1. **Presentation Layer** depends on **Domain Contracts** and shared presentation state. It never constructs Dio clients or interacts directly with low-level databases.
2. **Domain Layer** is pure Dart. It has **zero dependencies** on Flutter UI, Dio, or SharedPreferences.
3. **Data Layer** implements the domain contracts by coordinating remote network calls (`RestClient` / `Dio`) and local storage (`CacheService` / `TokenStore`).
4. **Core Layer** supplies shared utilities, crash reporting, logging, and extensions across the entire codebase.

---

## 2. Application Startup Lifecycle

```text
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. main.dart                                                                                                │
│  • WidgetsFlutterBinding.ensureInitialized()                                                                │
│  • SharedPreferences.getInstance() (Awaited once)                                                           │
│  • initializeCrashReporting() & bootstrap()                                                                 │
└──────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 2. bootstrap.dart                                                                                           │
│  • Installs FlutterError.onError & PlatformDispatcher error hooks                                           │
│  • Locks orientations to portrait mode                                                                      │
│  • Configures edge-to-edge System UI overlays                                                               │
└──────────────────────────────────────┬──────────────────────────────────────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ 3. ProviderScope & app.dart                                                                                 │
│  • Overrides `sharedPreferencesProvider` with initialized instance                                          │
│  • Registers `RiverpodObserver` for debug logging                                                           │
│  • Mounts `MaterialApp.router` with reactive `themeModeProvider` and `routerConfigProvider`                 │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Application State Lifecycle (`startupProvider` & `sessionStatusProvider`)

* **Startup Gate**: `startupProvider` restores application-level settings (such as persisted locale and app configurations) before unblocking the initial splash screen.
* **Session Stream**: `TokenManager` provides a reactive `sessionStream`. When login succeeds, or token refresh succeeds/fails, `sessionStatusProvider` updates go_router dynamically via `routerStateProvider`.
