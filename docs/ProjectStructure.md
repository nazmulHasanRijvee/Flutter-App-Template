# Project structure

## Top-level directories

```text
assets/                  Images and SVG icons
env/                     Compile-time environment JSON files
lib/                     Application source
test/                    Tests
android/, ios/, web/     Flutter platform targets
linux/, macos/, windows/ Flutter desktop targets
```

## Source tree

```text
lib/
├── main.dart
├── app.dart
└── src/
    ├── core/
    │   ├── base/
    │   │   ├── crash_reporter.dart
    │   │   ├── initialize_crash_reporting.dart
    │   │   └── reporters/
    │   │       ├── logging_crash_reporter.dart
    │   │       └── firebase_crashlytics_reporter.dart
    │   ├── const/
    │   ├── extensions/
    │   ├── gen/
    │   ├── logger/
    │   └── utils/
    ├── data/
    │   ├── models/
    │   ├── repositories/
    │   └── services/
    │       ├── auth/
    │       ├── cache/
    │       └── network/
    ├── domain/
    │   └── repositories/
    └── presentation/
        ├── core/
        │   ├── application_state/
        │   ├── providers/
        │   ├── routes/
        │   ├── theme/
        │   └── widgets/
        └── feature/
            ├── ask/
            ├── auth/
            ├── community/
            ├── home/
            ├── onboarding/
            └── splash/
```

## Feature layout

Feature-specific presentation code follows this pattern where needed:

```text
feature/<feature_name>/<screen_name>/
├── view/                Screen widgets
├── view_model/          Providers and screen state
└── widgets/             Widgets private to the screen
```

Not every screen needs all three directories. Shared widgets belong in `presentation/core/widgets`.

## Routing files

Routes are split into focused files under `presentation/core/routes/`:

- `routes.dart` defines the route enum and path values.
- `route_config.dart` creates the `GoRouter` provider.
- `redirect_gate.dart` contains the pure redirect policy.
- `parts/` contains onboarding, authentication, and shell route definitions.
- `router_state/` derives the current gate from startup, onboarding, and session state.

When adding a route, update the enum and the matching route-part file. See [Routing](Routing.md).
