# Architecture

The project uses a lightweight layered architecture. The layers are separated by responsibility rather than by a framework-specific code generator.

## Application startup

The startup path is:

1. `main.dart` ensures Flutter is initialized.
2. `SharedPreferences` is created once.
3. `bootstrap` installs global error handlers, configures system UI, locks the app to portrait mode, and invokes the app callback.
4. `ProviderScope` supplies the shared preferences instance and Riverpod observers.
5. `MyApp` creates `MaterialApp.router`, watches the theme, and obtains the router from Riverpod.

The bootstrap callback keeps platform setup separate from widget creation and makes the startup sequence easy to extend.

## Layers

### Core

`lib/src/core/` contains infrastructure shared by more than one feature:

- bootstrap and crash reporting
- logging
- extensions
- validation and helper utilities
- generated asset references

Core code should not contain feature-specific UI or business rules.

### Data

`lib/src/data/` talks to external systems and local persistence:

- `services/network/` contains Dio configuration, interceptors, Retrofit declarations, endpoints, and API error handling.
- `services/cache/` wraps SharedPreferences behind `CacheService`.
- `services/auth/` reads and updates the persisted session.
- `repositories/` implements domain repository contracts.
- `models/` contains API/data-transfer models.

### Domain

`lib/src/domain/` contains contracts used by the rest of the application, currently repository interfaces for authentication and locale persistence. Keep this layer independent of Flutter, Dio, SharedPreferences, and widgets whenever possible.

### Presentation

`lib/src/presentation/` contains screens, widgets, Riverpod state, routes, and theme code:

- `core/` holds reusable presentation infrastructure.
- `feature/` groups user-facing features by feature and screen.

Widgets should read state from providers and delegate data work to repositories or services rather than constructing network clients directly.

## Dependency direction

The intended dependency flow is:

```text
presentation → domain contracts → data implementations → external services
      ↓              ↓                 ↓
     core infrastructure and shared utilities
```

Some existing providers intentionally connect presentation and data through Riverpod. Keep new code consistent with the existing provider composition while avoiding direct service creation inside widgets.

## Adding application-wide behavior

Startup work belongs in `startupProvider`; route decisions belong in `routerStateProvider`; persistent values belong behind `CacheService`; and cross-cutting failures belong in the crash reporter or API error boundary. This keeps individual screens focused on rendering and user interaction.
