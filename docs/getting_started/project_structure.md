# Project Structure

## Top-Level Layout

```text
├── .agents/                 AI agent configuration, rules, and customizations
├── assets/                  Static SVG icons, fonts, and images
├── env/                     Compile-time environment JSON configurations (e.g., dev.json)
├── lib/                     Application source code
├── test/                    Unit, widget, and integration tests
├── android/, ios/, web/     Flutter platform targets
└── docs/                    Modular documentation repository
```

## Source Tree (`lib/`)

```text
lib/
├── main.dart                App entry point (Async initialization & ProviderScope)
├── app.dart                 Root MaterialApp.router configuration & theme bindings
└── src/
    ├── core/                Shared infrastructure (independent of features)
    │   ├── base/            Crash reporting contracts and initialization
    │   ├── bootstrap.dart   Bootstrap lifecycle (system UI, orientations, loggers)
    │   ├── const/           Application-wide constants
    │   ├── extensions/      Dart & Flutter extension methods
    │   ├── gen/             Generated assets & colors (build_runner)
    │   ├── logger/          Structured AppLogger wrapper
    │   └── utils/           Shared utility helpers & validators
    │
    ├── data/                External communications and data implementations
    │   ├── models/          Data transfer objects (DTOs) and serialization models
    │   ├── repositories/    Concrete implementations of domain repository contracts
    │   └── services/
    │       ├── cache/       SharedPreferences caching service
    │       └── network/     Dio transport, Retrofit REST client, and endpoints
    │           ├── auth/    TokenManager, TokenStore, and SecureTokenStore
    │           └── interceptors/ AccessTokenInterceptor, TokenRefreshInterceptor
    │
    ├── domain/              Pure business contracts & interfaces (zero UI/framework dependency)
    │   └── repositories/    Repository interfaces (AuthRepository, RouterRepository, etc.)
    │
    └── presentation/        User Interface, State Management & Routing
        ├── core/            Shared UI utilities, routing & global state
        │   ├── application_state/ App-level reactive providers (Session, Startup, Theme, Locale)
        │   ├── routes/      go_router setup, route branches, and dynamic redirect gates
        │   ├── theme/       ThemeData, ThemeExtensions, and responsive layout tokens
        │   └── widgets/     Shared UI components across multiple features
        └── feature/         Feature-scoped UI and state
            ├── ask/         Feature: Ask / Inquiry module
            ├── auth/        Feature: Login, Register, Password Recovery
            ├── community/   Feature: Community feed / discussions
            ├── home/        Feature: Dashboard / Home screen
            ├── onboarding/  Feature: First-run walkthrough experience
            └── splash/      Feature: Animated startup splash screen
```

## Feature Architecture

Each business feature inside `presentation/feature/<feature_name>/` follows a modular layout:

```text
feature/<feature_name>/<screen_name>/
├── view/                    Declarative Widget / Screen views
├── view_model/              Riverpod StateNotifiers / AsyncNotifiers & UI State
└── widgets/                 Widgets private to this specific feature/screen
```
