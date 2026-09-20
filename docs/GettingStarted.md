# Quick Start Guide

Get up and running with the project in just a few minutes!

## Prerequisites

Before starting, make sure you have:
- ✅ Flutter SDK installed ([Download](https://flutter.dev/docs/get-started/install))
- ✅ Dart SDK (bundled with Flutter)
- ✅ An IDE (VS Code or Android Studio)
- ✅ A device, emulator, or simulator

---

## First-Time Setup

### Step 1: Get Dependencies

```bash
flutter pub get
```

### Step 2: Generate Files

Run `build_runner` to generate Retrofit clients, JSON serializable models, and asset files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Run the App

```bash
flutter run
```

Your app should now be running! 🎉

---

## Common Commands

### Development

```bash
# Run app in debug mode
flutter run

# Run app in release mode (faster performance)
flutter run --release

# Run on specific target device
flutter run -d <device_id>

# Run with verbose output for debugging
flutter run --verbose

# List available connected devices
flutter devices
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Build

```bash
# Build APK for Android
flutter build apk

# Build app bundle for Google Play
flutter build appbundle

# Build iOS app
flutter build ios

# Build web application
flutter build web
```

### Code Quality

```bash
# Format code across the project
dart format lib/

# Analyze code for warnings and errors
dart analyze

# Apply automatic lint fixes
dart fix --apply
```

---

## Project Structure Quick Reference

```
lib/
├── main.dart                             ← Entry point (bootstrap & DI setup)
├── app.dart                              ← Root widget (ScreenUtil & router binding)
└── src/                                  ← Encapsulated application implementation
    ├── core/                             ← App-wide utilities, bootstrap & logging
    ├── data/                             ← API clients, cache & repository implementations
    ├── domain/                           ← Pure entities & repository contracts
    └── presentation/                     ← UI layer
        ├── core/                         ← Shared providers, routes, theme & widgets
        └── feature/                      ← Feature screens (view, view_model, widgets)
```

**Detailed guide**: See [ProjectStructure.md](./ProjectStructure.md)

---

## Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | Application entry point with SharedPreferences DI |
| `lib/src/core/bootstrap.dart` | App initialization, orientation locking, uncaught error zones |
| `lib/app.dart` | Root widget configuring ScreenUtil, themes, and GoRouter |
| `lib/src/presentation/core/routes/routes.dart` | Type-safe `enum Routes` defining paths and names |
| `lib/src/presentation/core/routes/route_config.dart` | Main GoRouter configuration assembling modular sub-routes |
| `lib/src/presentation/core/theme/` | Central design system (colors, typography, dimensions) |
| `lib/src/data/services/network/dio_client.dart` | Dio client configuration with auth & refresh interceptors |
| `pubspec.yaml` | App dependencies and metadata |
| `analysis_options.yaml` | Linting rules and analyzer configurations |

---

## Understanding the Architecture

This project follows **Clean Architecture** with 4 distinct layers:

```
Presentation (lib/src/presentation/)
        ↓
Domain (lib/src/domain/)
        ↓
Data (lib/src/data/)
        ↓
Core (lib/src/core/)
```

**Learn more**: See [Architecture.md](./Architecture.md)

---

## State Management with Riverpod

The app uses **Riverpod** for reactive state management and dependency injection:

```dart
// Watch a provider inside a ConsumerWidget
final userData = ref.watch(userProvider);

// Read a provider once inside a callback or method
ref.read(userProvider.notifier).updateName('Jane');

// Render async operations gracefully
userAsync.when(
  data: (user) => Text(user.name),
  loading: () => const CustomLoadingIndicator(),
  error: (err, st) => Text('Error: $err'),
);
```

**Deep dive**: See [StateManagement.md](./StateManagement.md)

---

## Theme System

Access design tokens directly through `BuildContext` extensions:

```dart
// Colors
context.color.primary
context.color.error
context.color.surface

// Typography
context.textStyle.headingLarge
context.textStyle.bodyMedium
context.textStyle.labelSmall

// Dimensions
context.spacing.s16
context.padding.p12
context.radius.r8
```

**Learn more**: See [Theme.md](./Theme.md)

---

## Adding a New Feature

### 1. Create Feature Directory

```bash
mkdir -p lib/src/presentation/feature/my_feature/my_feature_screen/{view,view_model,widgets}
```

### 2. Create the Screen Widget

```dart
// lib/src/presentation/feature/my_feature/my_feature_screen/view/my_feature_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyFeatureScreen extends ConsumerWidget {
  const MyFeatureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: const Center(child: Text('Hello from My Feature!')),
    );
  }
}
```

### 3. Register Route in `routes.dart`

```dart
// lib/src/presentation/core/routes/routes.dart
enum Routes {
  // ...
  myFeature('/my_feature');

  const Routes(this.path);
  final String path;
}
```

### 4. Add Route Definition to a Route Part

```dart
// lib/src/presentation/core/routes/parts/shell_routes.dart (or custom part file)
GoRoute(
  path: Routes.myFeature.path,
  name: Routes.myFeature.name,
  pageBuilder: (context, state) => const MaterialPage(child: MyFeatureScreen()),
),
```

### 5. Navigate

```dart
context.pushNamed(Routes.myFeature.name);
```

---

## Debugging Tips

### Hot Reload & Hot Restart
- Press `r` in the terminal for hot reload.
- Press `R` in the terminal for hot restart.

### View Logs
App logs are formatted cleanly via `AppLogger`:
```bash
flutter logs
```

### Use Flutter DevTools
```bash
flutter pub global run devtools
```

---

## File Locations Guide

| Need | Path |
|------|------|
| App Bootstrap / Initialization | `lib/src/core/bootstrap.dart` |
| Add a screen | `lib/src/presentation/feature/[feature]/[screen]/view/` |
| Add screen state logic | `lib/src/presentation/feature/[feature]/[screen]/view_model/` |
| Add screen-specific widget | `lib/src/presentation/feature/[feature]/[screen]/widgets/` |
| Add shared UI widget | `lib/src/presentation/core/widgets/` |
| Fetch data from API | `lib/src/data/services/network/` |
| Store local data / cache | `lib/src/data/services/cache/` |
| Business domain entities | `lib/src/domain/entities/` |
| Repository contracts | `lib/src/domain/repositories/` |
| Repository implementations | `lib/src/data/repositories/` |
| Colors / Typography / Spacing | `lib/src/presentation/core/theme/` |
| Global UI state (Theme / Nav) | `lib/src/presentation/core/providers/` |
| Route setup | `lib/src/presentation/core/routes/` |

---

## Next Steps

1. 📚 **[Architecture Guide](./Architecture.md)** - Understand the Clean Architecture layout
2. 🎨 **[Theme Guide](./Theme.md)** - Learn how styling, colors, and fonts work
3. 🔄 **[State Management](./StateManagement.md)** - Master Riverpod patterns
4. 🔌 **[API Integration](./ApiIntegration.md)** - Connect to backends using Dio and Retrofit
5. 📝 **[Conventions](./Conventions.md)** - Explore code style guidelines
