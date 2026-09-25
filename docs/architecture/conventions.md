# Code & Design Conventions

## 1. Naming Standards

- **Files & Folders**: `snake_case` (e.g. `token_refresh_interceptor.dart`, `session_status_provider.dart`).
- **Classes, Enums & Extensions**: `PascalCase` (e.g. `TokenManager`, `SessionStatus`, `ThemeContextExtensions`).
- **Variables, Methods & Providers**: `camelCase` (e.g. `authRepositoryProvider`, `clearSession()`).
- **Riverpod Providers**: Must end with the `Provider` suffix (e.g. `dioProvider`, `themeModeProvider`).

---

## 2. Layer & Architectural Rules

- **Zero UI in Core & Domain**: Core and domain layers must not import Flutter widgets or presentation libraries.
- **Contract-Driven Development**: Repositories in `lib/src/domain/repositories/` define abstract interfaces. Concrete implementations reside in `lib/src/data/repositories/`.
- **Decoupled Widgets**: Widgets must not directly invoke network clients (`Dio`, `RestClient`) or low-level storage. All operations must pass through Riverpod providers and repositories.

---

## 3. Error Handling & Privacy

- **Never Log Secrets**: Never log plain-text passwords, authorization headers, access tokens, or refresh tokens.
- **Structured Logging**: Use `AppLogger.debug()`, `AppLogger.info()`, or `AppLogger.error()` instead of `print()`.
- **User-Facing Error Boundaries**: Catch network and serialization failures at repository/service boundaries (`Api.call`) and pass clean, localized, or user-friendly messages to the presentation layer.

---

## 4. Pre-Commit Checklist

```bash
# 1. Format code
dart format lib test

# 2. Analyze code for lints & warnings
flutter analyze

# 3. Verify test suite passes
flutter test
```
