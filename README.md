# Flutter App Template

A Flutter starter project with a layered architecture, Riverpod state management, state-driven routing, reusable UI primitives, and a small sample application flow.

The included sample flow contains onboarding, authentication screens, a home/devotion area, an ask/chat area, and a community area. Use it as a starting point: replace the sample features and API contracts with the requirements of your app.

## What is included

- Flutter application bootstrap with portrait orientation and system UI configuration
- Riverpod for dependency injection and application state
- go_router with splash, onboarding, authentication, and authenticated route gates
- Stateful bottom-navigation shell for Home, Ask, and Community
- Clean separation between core, data, domain, and presentation code
- Dio and Retrofit for HTTP requests
- Access-token and token-refresh interceptor hooks
- SharedPreferences-backed cache, session, theme, and locale persistence
- Light and dark themes with custom color, typography, spacing, and sizing extensions
- Responsive layout initialization with `flutter_screenutil`
- Centralized logging and injectable crash reporting
- Generated asset and Retrofit client support

## Requirements

- Flutter with Dart SDK `^3.12.2`
- Git
- Android Studio, Xcode, or another Flutter-capable IDE

Check the local toolchain with:

```bash
flutter doctor
```

## Run the project

```bash
git clone <repository-url>
cd flutter_app_template
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

The development environment file currently points to the API host `10.10.10.3:5000`. Update `env/dev.json` for your machine, emulator, or backend before running the app. The file is passed to Dart at build time; the app does not load it at runtime.

To run without environment values, use `flutter run`, but network calls that depend on `BASE_URL` will not have a configured base URL.

## Common commands

```bash
# Fetch packages
flutter pub get

# Regenerate Retrofit and asset files
dart run build_runner build --delete-conflicting-outputs

# Format Dart code
dart format lib test

# Analyze the project
flutter analyze

# Run tests
flutter test

# Build an Android release using the development defines
flutter build apk --release --dart-define-from-file=env/dev.json
```

The checked-in generated files should be regenerated whenever their source annotations or API definitions change.

## Project structure

```text
lib/
├── main.dart                         # Entry point and ProviderScope setup
├── app.dart                          # MaterialApp.router and app-wide UI setup
└── src/
    ├── core/                         # Shared infrastructure
    │   ├── base/                     # Bootstrap and crash reporting
    │   ├── const/                    # Shared constants
    │   ├── extensions/               # Dart, Flutter, and Riverpod extensions
    │   ├── gen/                     # Generated asset references
    │   ├── logger/                  # Application and Riverpod logging
    │   └── utils/                   # Reusable helpers and validation
    ├── data/                         # External data access and persistence
    │   ├── models/                  # Data-transfer models
    │   ├── repositories/            # Implementations of domain contracts
    │   └── services/                # Auth, cache, and network services
    ├── domain/                       # Application-facing contracts
    │   └── repositories/            # Repository interfaces
    └── presentation/                 # UI and presentation state
        ├── core/                    # Routes, providers, theme, and widgets
        └── feature/                 # Feature screens, providers, and widgets
```

See [docs/getting_started/project_structure.md](docs/getting_started/project_structure.md) for the detailed map and feature conventions.

## Architecture at a glance

`main.dart` creates the shared preferences instance and passes it into Riverpod through an override. `bootstrap.dart` installs global error handlers, configures the device UI, and then starts `MyApp`.

`MyApp` watches the router and theme providers. The router derives its current gate from startup completion, onboarding status, and session status:

```text
startup pending or failed → splash
onboarding incomplete     → onboarding
authenticated             → home shell
unauthenticated           → login flow
```

The route policy lives in `lib/src/presentation/core/routes/` and is intentionally state-driven. Screens update providers or persisted state; go_router reacts and redirects.

More detail is available in:

- [Architecture](docs/architecture/architecture.md)
- [State management](docs/architecture/state_management.md)
- [Project structure](docs/getting_started/project_structure.md)

## Networking and environment values

The network layer is organized as follows:

- `Endpoints` reads `BASE_URL` and `COMMUNITY_URL` with `String.fromEnvironment`.
- `DioClient` configures timeouts, JSON headers, authentication, token refresh, and debug request logging.
- `RestClient` declares typed Retrofit endpoints and is backed by the generated `rest_client.g.dart` file.
- `Api.call` converts Dio and unexpected exceptions into success/error callbacks and logs failures.
- `TokenManager` & `TokenRefreshInterceptor` handle automatic token refreshing and rotation.

See [docs/network/networking.md](docs/network/networking.md) and [docs/network/token_refresh_logic.md](docs/network/token_refresh_logic.md) for details.

## Error reporting

The active implementation is `LoggingCrashReporter`. It receives Flutter framework errors and uncaught platform/asynchronous errors through `initializeCrashReporting`, then sends them to `AppLogger`.

A Firebase Crashlytics reporter skeleton is present for future use, but Firebase packages and initialization are not currently enabled. See [docs/error_handling/error_handling.md](docs/error_handling/error_handling.md).

## Adding a feature

1. Add or update domain contracts in `lib/src/domain/` when the feature needs a new capability.
2. Add models, repository implementations, and services in `lib/src/data/`.
3. Create the feature under `lib/src/presentation/feature/<feature_name>/`.
4. Add the route to `Routes` and the appropriate route-part file.
5. Add providers for feature state and keep persistence/network access outside widgets.
6. Add tests and run `flutter analyze` and `flutter test`.

Use [docs/architecture/conventions.md](docs/architecture/conventions.md) for naming, provider, route, and feature guidelines.

## Platform support

The repository includes Flutter targets for Android, iOS, Web, Windows, macOS, and Linux. Platform-specific setup may still be required for permissions, signing, API connectivity, icons, and release builds.

## Documentation

The [docs](docs/) directory contains the full documentation suite:

- 🚀 [Getting started](docs/getting_started/getting_started.md)
- 📁 [Project structure](docs/getting_started/project_structure.md)
- 🏛️ [Architecture](docs/architecture/architecture.md)
- 🔄 [State management](docs/architecture/state_management.md)
- 🌐 [Networking](docs/network/networking.md)
- 🔑 [Token refresh logic](docs/network/token_refresh_logic.md)
- 🔐 [Authentication and persistence](docs/auth_and_storage/authentication_and_storage.md)
- 🧭 [Routing](docs/routing/routing.md)
- 🎨 [Theming](docs/theming/theming.md)
- 🛡️ [Error handling](docs/error_handling/error_handling.md)
- 📏 [Conventions](docs/architecture/conventions.md)

## License

This repository is provided as a template. And Open Sourced
