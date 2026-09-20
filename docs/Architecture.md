# Architecture Guide

Welcome to the team! This document explains the architecture of the project and how it is organized. This project follows **Clean Architecture** principles structured inside `lib/src/` to ensure high scalability, separation of concerns, testability, and maintainability.

## Table of Contents

- [Overview](#overview)
- [Layered Architecture](#layered-architecture)
- [Core Layer (`lib/src/core/`)](#core-layer-libsrccore)
- [Data Layer (`lib/src/data/`)](#data-layer-libsrcdata)
- [Domain Layer (`lib/src/domain/`)](#domain-layer-libsrcdomain)
- [Presentation Layer (`lib/src/presentation/`)](#presentation-layer-libsrcpresentation)
- [Dependency Flow](#dependency-flow)
- [Key Principles](#key-principles)
- [Folder Organization Summary](#folder-organization-summary)

---

## Overview

The application is structured into **4 core architectural layers** encapsulated under `lib/src/`, with entry point files `main.dart` and `app.dart` located at the root of `lib/`:

```
┌─────────────────────────────────────────────────────────────┐
│                 Presentation Layer                          │
│               (lib/src/presentation/)                       │
│   • core/ (providers, routes, theme, widgets)               │
│   • feature/ (view/, view_model/, widgets/)                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                    Domain Layer                             │
│                  (lib/src/domain/)                          │
│   • entities/ (immutable business models)                   │
│   • repositories/ (abstract interface contracts)            │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                     Data Layer                              │
│                   (lib/src/data/)                           │
│   • models/ (DTOs, JSON serialization)                      │
│   • repositories/ (concrete repository implementations)     │
│   • services/ (network with Dio/Retrofit, cache, auth)      │
└──────────────────────────────┬──────────────────────────────┘
                               │
┌──────────────────────────────▼──────────────────────────────┐
│                     Core Layer                              │
│                   (lib/src/core/)                           │
│   • bootstrap.dart, crash reporting, AppLogger,             │
│   • extensions, constants, utilities, asset gen             │
└─────────────────────────────────────────────────────────────┘
```

---

## Layered Architecture

### Dependency Rule
- **Higher layers depend on lower layers.**
- **Lower layers never depend on higher layers.**
- **The Domain layer is the heart of the business logic** and depends on no external packages or Flutter UI.
- **Components depend on abstractions** (repository contracts), not concrete implementations.

---

## Core Layer (`lib/src/core/`)

The Core layer contains universal, non-UI infrastructure and utilities utilized throughout the application.

### Subdirectories & Key Files:

```
lib/src/core/
├── bootstrap.dart                  # App initialization, orientations, system UI, zone guards
├── initialize_crash_reporting.dart # Telemetry / Crashlytics error reporting
├── const/                          # App-wide constants (e.g. image paths)
├── extensions/                     # Dart extensions (BuildContext, String, DateTime)
├── gen/                            # Asset code generators (flutter_gen output)
├── localization/                   # Localization delegates and utilities
├── logger/
│   ├── app_logger.dart             # Centralized logger (production-safe logging levels)
│   └── riverpod_log.dart           # RiverpodObserver tracking provider lifecycle
└── utils/                          # Validators (email), image picker helpers, etc.
```

### Key Components:
- **`bootstrap()`**: Sets up status bar appearance, locks portrait orientation, initializes crash reporting, and runs the application inside a `runZonedGuarded` to catch unhandled async errors.
- **`AppLogger`**: Production-aware logging helper that enables trace/debug in development and restricts output to errors in production.
- **`RiverpodObserver`**: Logs state transitions, additions, and errors across all Riverpod providers.

---

## Data Layer (`lib/src/data/`)

The Data layer handles all external data sources, network communications, caching, and mapping between remote representations and domain entities.

### Subdirectories:

```
lib/src/data/
├── models/                         # DTOs with JSON serialization (fromJson/toJson)
├── repositories/                   # Concrete implementations of domain repository interfaces
└── services/
    ├── auth/                       # AuthService (token storage and auth session)
    ├── cache/                      # CacheService, SharedPreferencesService, CacheKey
    └── network/
        ├── dio_client.dart         # Configured Dio instance + dioProvider
        ├── rest_client.dart        # Retrofit API client + restClientProvider
        ├── api_handler.dart        # Api.call<T> standardized response/error wrapper
        ├── endpoints.dart          # Backend API endpoints
        └── interceptors/           # AccessTokenInterceptor & TokenRefreshInterceptor
```

### Responsibilities:

- **Network Client (`DioClient`)**: Configures Dio with default timeouts, headers, automatic auth token attachment (`AccessTokenInterceptor`), 401 token refresh (`TokenRefreshInterceptor`), and conditional debug logging.
- **API Handler (`Api.call<T>`)**: Wraps API calls to parse `DioException`, log detailed error context via `AppLogger`, and return clean error messages through an `onError` callback.
- **Cache Management (`CacheService`)**: Provides type-safe key-value persistence with `CacheKey` enum abstraction over `SharedPreferences`.
- **Repository Implementations**: Implement domain contracts by coordinating remote services and local caching.

---

## Domain Layer (`lib/src/domain/`)

The Domain layer encapsulates pure enterprise and application business rules. It contains no dependencies on Flutter, Dio, or platform APIs.

### Subdirectories:

```
lib/src/domain/
├── entities/                       # Pure business models (immutable)
└── repositories/                   # Abstract repository interfaces (contracts)
```

### Key Concepts:

- **Entities**: Business domain representations without serialization or network baggage.
- **Repository Contracts**: Abstract interfaces specifying what data operations exist, not how they are executed:
  ```dart
  abstract interface class AuthenticationRepository {
    Future<Map<String, dynamic>> login(Map<String, dynamic> data);
    Future<Map<String, dynamic>> register(Map<String, dynamic> data);
    Future<void> logout();
  }
  ```

---

## Presentation Layer (`lib/src/presentation/`)

The Presentation layer contains all UI logic, design tokens, navigation, and screen states. It is partitioned into **Core Presentation** and **Feature Modules**.

### 1. Presentation Core (`lib/src/presentation/core/`)

Foundational elements shared across all screens:
- **`providers/`**: Presentation state providers (e.g. `theme_provider.dart` with `ThemeModeNotifier`, `navigator_key_provider.dart`).
- **`routes/`**: Modular GoRouter architecture:
  - `routes.dart`: Type-safe `enum Routes` with path definitions.
  - `route_config.dart`: Central `routerProvider`.
  - `part_of.dart`: Master orchestrator linking modular route files.
  - `parts/`: Sub-routes partitioned by flow (`authentication_routes.dart`, `onboarding_routes.dart`, `shell_routes.dart`).
- **`theme/`**: Design system with `ThemeExtension` (colors, typography, dimensions, component styles) and `BuildContext` accessors (`context.color`, `context.textStyle`, `context.spacing`).
- **`widgets/`**: Reusable generic widgets (form fields, buttons, custom loaders, empty states, toasts).

### 2. Feature Modules (`lib/src/presentation/feature/`)

Features are modular packages structured by feature domain and screen:

```
feature/[feature_name]/[screen_name]/
├── view/                           # Screen UI (StatelessWidget or ConsumerWidget)
├── view_model/                     # Riverpod state notifiers/providers for the screen
└── widgets/                        # Components specific to this screen
```

---

## Dependency Flow

```
Screen Widget (lib/src/presentation/feature/.../view/)
        │
        ├── watches ──→ ViewModel Provider (lib/src/presentation/feature/.../view_model/)
        │                     │
        │                     ├── uses ──→ Domain Repository Interface (lib/src/domain/repositories/)
        │                     │                   ▲
        │                     │                   │ implemented by
        │                     │            Data Repository Impl (lib/src/data/repositories/)
        │                     │                   │
        │                     │                   ├── calls ──→ RestClient / DioClient (Data Services)
        │                     │                   │                   │
        │                     │                   │                   └── wraps with Api.call<T>
        │                     │                   │
        │                     │                   └── maps to ──→ Domain Entity (lib/src/domain/entities/)
        │                     │
        │                     └── updates ──→ AsyncValue / Notifier State
        │
        └── styles with ──→ context.color, context.textStyle (Presentation Core Theme)
```

### Complete End-to-End Example

```dart
// 1. Domain Layer: Contract
// lib/src/domain/repositories/auth_repository.dart
abstract interface class AuthenticationRepository {
  Future<Map<String, dynamic>> login(Map<String, dynamic> data);
}

// 2. Data Layer: Implementation
// lib/src/data/repositories/auth_repository_impl.dart
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({required this.remote, required this.authService});

  final RestClient remote;
  final AuthService authService;

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    final response = await remote.login(data);
    return response.data as Map<String, dynamic>;
  }
}

// 3. Presentation Layer: ViewModel
// lib/src/presentation/feature/auth/sign_in_screen/view_model/sign_in_provider.dart
final signInProvider = AsyncNotifierProvider<SignInNotifier, void>(SignInNotifier.new);

class SignInNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.login({'email': email, 'password': password});
    });
  }
}

// 4. Presentation Layer: View
// lib/src/presentation/feature/auth/sign_in_screen/view/sign_in_screen.dart
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signInProvider);

    return Scaffold(
      body: state.isLoading
          ? const CustomLoadingIndicator()
          : Center(
              child: ElevatedButton(
                onPressed: () => ref.read(signInProvider.notifier).login('user@test.com', '123456'),
                child: const Text('Sign In'),
              ),
            ),
    );
  }
}
```

---

## Key Principles

1. **Scalable Modular Organization**: Moving everything under `lib/src/` enforces clean encapsulation, while partitioning presentation into `core/` and `feature/` prevents circular dependencies and bloated folders.
2. **Robust Error Handling**: The combination of `bootstrap()` with `runZonedGuarded`, `AppLogger`, and `Api.call<T>` guarantees that uncaught exceptions and network failures are captured with detailed context without crashing the app.
3. **Type-Safe Navigation**: `enum Routes` paired with partitioned route parts eliminates hardcoded string URLs, makes route lists manageable, and guarantees compile-time route verification.
4. **Separation of Presentation Concerns**: `view/` handles layout, `view_model/` handles state and business coordination, and `widgets/` isolates localized components.

---

## Folder Organization Summary

```
lib/
├── main.dart                       # App entry with SharedPreferences override & bootstrap
├── app.dart                        # Root MaterialApp with ScreenUtil & theme binding
└── src/
    ├── core/                       # App-wide infrastructure, bootstrap, logger, utils
    ├── data/                       # Models, repositories, network, cache, auth services
    ├── domain/                     # Entities and repository interfaces
    └── presentation/               # Presentation layer
        ├── core/                   # Shared providers, modular routes, theme, shared widgets
        └── feature/                # Feature packages organized by screen (view, view_model, widgets)
```
