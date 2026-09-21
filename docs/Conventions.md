# Conventions

## Naming

- Use `snake_case` for Dart file and directory names.
- Use `PascalCase` for classes, enums, and extensions.
- Use `camelCase` for variables, methods, and provider names.
- Name Riverpod providers with a `Provider` suffix where the type is not already obvious.

## Feature organization

Keep feature UI under `presentation/feature/<feature_name>`. A screen may contain `view`, `view_model`, and `widgets` directories. Put widgets shared by multiple features under `presentation/core/widgets`.

## State and dependencies

- Compose dependencies through Riverpod providers.
- Keep API and persistence work out of widgets.
- Put reusable external-system behavior in data services or repositories.
- Expose domain behavior through interfaces when more than one implementation or test double is useful.
- Prefer derived state over imperative navigation or duplicated flags.

## Routes

Declare paths in `Routes` and register them in the matching route-part file. Keep gate decisions in `routerStateProvider` and `RedirectGate`, not in individual screens.

## Generated code

Do not edit `rest_client.g.dart` or generated asset files manually. Update their source declarations and run build_runner.

## Logging and privacy

Use `AppLogger` instead of `print`. Include useful context and stack traces, but never log credentials, tokens, passwords, or unnecessary personal data.

## Before opening a change

Run:

```bash
dart format lib test
flutter analyze
flutter test
```

Update the relevant documentation when adding a public pattern, route group, environment value, or generated workflow.
