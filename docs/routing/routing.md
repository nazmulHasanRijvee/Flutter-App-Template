# Navigation & Routing Architecture

The routing architecture uses **go_router** combined with **Riverpod** for reactive redirection gates and state-preserving shell routes.

---

## 1. Route Hierarchy

Routes are organized into logical groups under `lib/src/presentation/core/routes/parts/`:

```text
Routes Enum (lib/src/presentation/core/routes/routes.dart)
├── Onboarding Routes (parts/onboarding_routes.dart)
│   ├── /splash
│   └── /onboarding
│
├── Authentication Routes (parts/authentication_routes.dart)
│   ├── /login
│   ├── /register_screen
│   ├── /reset_pass_screen
│   ├── /email_verification_screen
│   └── /create_new_pass_screen
│
└── Authenticated Shell Routes (parts/shell_routes.dart)
    └── StatefulShellRoute.indexedStack
        ├── Branch 0: /home_screen
        ├── Branch 1: /chat_screen
        └── Branch 2: /community_screen
```

---

## 2. Dynamic Redirection Gate Policy

`routerStateProvider` evaluates the active gate using three reactive inputs:

```mermaid
flowchart TD
    Start[App Boot / Navigation Request] --> GateCheck{Evaluate routerStateProvider}
    
    GateCheck -->|startup loading or failed| Splash[/splash]
    GateCheck -->|onboarding incomplete| Onboard[/onboarding]
    GateCheck -->|no active session| Login[/login]
    GateCheck -->|authenticated & ready| HomeShell[/home_screen]
```

### `RedirectGate.redirect`
`RedirectGate.redirect` is a pure function executed on every route transition:
- If on `/splash` and startup completes, it redirects to the appropriate destination.
- Prevents authenticated users from accessing login/register screens (auto-redirecting to `/home_screen`).
- Prevents unauthenticated users from accessing protected shell routes (auto-redirecting to `/login`).

---

## 3. Adding a New Route

1. **Add Route Constant**: Add enum value and path to `Routes` in `routes.dart`.
2. **Register GoRoute**: Add the route definition to the appropriate part file (`onboarding_routes.dart`, `authentication_routes.dart`, or `shell_routes.dart`).
3. **Mount Screen Widget**: Create screen in `lib/src/presentation/feature/<feature>/<screen>/view/`.
