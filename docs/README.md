# Project Documentation

Welcome to the comprehensive architecture and developer guides for the Flutter App Template.

---

## 📚 Documentation Index

```text
docs/
├── getting_started/
│   ├── getting_started.md          # Setup, commands, environment variables & build_runner
│   └── project_structure.md        # Top-level directory layout & clean architecture breakdown
│
├── architecture/
│   ├── architecture.md             # Startup lifecycle, layer boundaries & dependency rules
│   ├── state_management.md         # Riverpod providers & global reactive application state
│   └── conventions.md              # Naming rules, layer constraints & pre-commit checklist
│
├── network/
│   ├── networking.md               # Dio, Retrofit client, endpoints & Api.call boundary
│   └── token_refresh_logic.md      # Deep-dive: TokenManager, 401 interceptor & token rotation
│
├── auth_and_storage/
│   └── authentication_and_storage.md # SecureTokenStore, TokenManager, CacheService & sessions
│
├── routing/
│   └── routing.md                  # go_router branches, stateful shells & redirect gates
│
├── theming/
│   └── theming.md                  # ThemeExtensions, light/dark themes & responsive ScreenUtil
│
└── error_handling/
    └── error_handling.md           # Global error dispatchers, AppLogger & crash reporting
```

---

## 📑 Quick Links by Topic

### 🚀 [Getting Started](getting_started/getting_started.md)
* [Getting Started](getting_started/getting_started.md) — Tooling, running with environment JSONs, build runner, quality checks.
* [Project Structure](getting_started/project_structure.md) — Directory layout from `lib/src/core` to `lib/src/presentation`.

### 🏛️ [Architecture](architecture/architecture.md)
* [Application Architecture](architecture/architecture.md) — Clean Layered architecture, startup phases, and dependency constraints.
* [State Management](architecture/state_management.md) — Riverpod data flow, startup gates, session stream, and theme provider.
* [Code Conventions](architecture/conventions.md) — Coding conventions, layer boundaries, and linting rules.

### 🌐 [Networking & Security](network/networking.md)
* [Networking & API Integration](network/networking.md) — Dio HTTP client, Retrofit REST client, and `Api.call` error boundaries.
* [Token Refresh & Rotation Logic](network/token_refresh_logic.md) — Concurrency control (`Completer`), token rotation, replay mechanism, and Eraser/Mermaid diagrams.

### 🔐 [Authentication & Persistence](auth_and_storage/authentication_and_storage.md)
* [Authentication & Local Persistence](auth_and_storage/authentication_and_storage.md) — `TokenManager`, `SecureTokenStore` (encrypted storage), `CacheService` (SharedPreferences), and `sessionStatusProvider`.

### 🧭 [Routing & Navigation](routing/routing.md)
* [Navigation & Routing](routing/routing.md) — `go_router` setup, `StatefulShellRoute` multi-tab state preservation, and dynamic redirect gates.

### 🎨 [UI & Theming](theming/theming.md)
* [UI & Theming](theming/theming.md) — Custom theme extensions (colors, typography, dimensions), ScreenUtil responsiveness, and dynamic theme switching.

### 🛡️ [Error Handling](error_handling/error_handling.md)
* [Error Handling & Reporting](error_handling/error_handling.md) — Framework error hooks, `AppLogger`, and crash reporter interfaces.
