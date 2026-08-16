# Quick Start Guide

Get up and running with the project in just a few minutes!

## Prerequisites

Before starting, make sure you have:
- ✅ Flutter SDK installed ([Download](https://flutter.dev/docs/get-started/install))
- ✅ Dart SDK (comes with Flutter)
- ✅ An IDE (VS Code or Android Studio)
- ✅ A device or emulator

## First-Time Setup

### Step 1: Get Dependencies

```bash
flutter pub get
```

### Step 2: Generate Files (if needed)

If the project has generated files:

```bash
flutter pub run build_runner build
```

### Step 3: Run the App

```bash
flutter run
```

Your app should now be running! 🎉

## Common Commands

### Development

```bash
# Run app in debug mode
flutter run

# Run app in release mode (faster)
flutter run --release

# Run on specific device
flutter run -d <device_id>

# Run with verbose output (debugging)
flutter run --verbose

# List available devices
flutter devices
```

### Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
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

# Build web
flutter build web
```

### Code Quality

```bash
# Format code
dart format lib/

# Analyze code
dart analyze

# Fix issues automatically
dart fix --apply
```

## Project Structure Quick Reference

```
lib/
├── main.dart          ← Entry point
├── app.dart           ← Root widget
├── core/              ← Shared utilities
├── data/              ← API & Database
├── domain/            ← Business logic
└── src/               ← UI & Features
```

**Detailed guide**: See [ProjectStructure.md](./ProjectStructure.md)

## Key Files to Know

| File | Purpose |
|------|---------|
| `lib/main.dart` | Application entry point |
| `lib/app.dart` | Root widget configuration |
| `lib/core/routes/route_config.dart` | Route definitions |
| `lib/core/static/theme/` | Theme system |
| `pubspec.yaml` | Dependencies |
| `analysis_options.yaml` | Lint rules |

## Understanding the Architecture

This project follows **Clean Architecture** with 4 layers:

```
Presentation (UI)
        ↓
     Domain (Business Logic)
        ↓
     Data (API/Database)
        ↓
     Core (Shared Utilities)
```

**Learn more**: See [Architecture.md](./Architecture.md)

## State Management with Riverpod

The app uses **Riverpod** for state management:

```dart
// Watch a provider for changes
final userData = ref.watch(userProvider);

// Read a provider once
ref.read(userProvider);

// Execute async operations
userAsync.when(
  data: (user) => Text(user.name),
  loading: () => CircularProgressIndicator(),
  error: (err, st) => Text('Error: $err'),
)
```

**Deep dive**: See [StateManagement.md](./StateManagement.md)

## Theme System

Access theme values easily:

```dart
// Colors
context.color.primary
context.color.error
context.color.surface

// Text Styles
context.textStyle.headingLarge
context.textStyle.bodyMedium
context.textStyle.labelSmall

// Dimensions
context.spacing.s16
context.padding.p12
context.radius.r8
```

**Learn more**: See [Theme.md](./Theme.md)

## Adding a New Feature

### 1. Create Feature Directory

```bash
mkdir -p lib/src/feature/my_feature/{pages,widgets,providers,models}
```

### 2. Create Main Page

```dart
// lib/src/feature/my_feature/pages/my_feature_page.dart
import 'package:flutter/material.dart';

class MyFeaturePage extends StatelessWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Feature')),
      body: const Center(child: Text('Hello')),
    );
  }
}
```

### 3. Add Route

```dart
// In lib/core/routes/route_config.dart
GoRoute(
  path: '/my-feature',
  name: 'myFeature',
  builder: (context, state) => const MyFeaturePage(),
),
```

### 4. Navigate

```dart
context.pushNamed('myFeature');
```

## Debugging Tips

### Enable Hot Reload

Press `r` in terminal during `flutter run` to reload code changes instantly.

### View Logs

```bash
# Filter by tag
flutter logs | grep MyTag

# Real-time logs
flutter logs --follow
```

### Use DevTools

```bash
# Open DevTools UI in browser
flutter pub global run devtools

# Or automatic launch
flutter run --devtools-server-address localhost:9100
```

### Common Issues

**Issue**: App won't start

**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

**Issue**: Hot reload not working

**Solution**:
```bash
flutter run --no-fast-start
```

**Issue**: Port already in use

**Solution**:
```bash
flutter run -d android-device --verbose
```

## File Locations Guide

| Need | Path |
|------|------|
| Add a screen | `lib/src/feature/[feature]/pages/` |
| Add state logic | `lib/src/feature/[feature]/providers/` |
| Add reusable widget | `lib/src/widgets/` |
| Fetch data from API | `lib/data/services/api/` |
| Store local data | `lib/data/services/cache/` |
| Business logic | `lib/domain/entities/` |
| Colors/Fonts | `lib/core/static/theme/` |
| Global state | `lib/core/providers/` |

## Next Steps

1. 📚 **Read the Architecture Guide** - Understand how the code is organized
2. 🎨 **Learn the Theme System** - Customize colors and fonts
3. 🔄 **Master Riverpod** - State management patterns
4. 📝 **Check Conventions** - Coding standards
5. 🔌 **Integrate APIs** - Add backend connectivity

## Need Help?

- 📖 [Architecture Guide](./Architecture.md) - Project structure & design
- 🎨 [Theme Guide](./Theme.md) - Styling system
- 🔄 [State Management](./StateManagement.md) - Riverpod patterns
- 📂 [Project Structure](./ProjectStructure.md) - File organization
- ✅ [Conventions](./Conventions.md) - Coding standards

**External Resources**:
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Docs](https://riverpod.dev)
- [Go Router Docs](https://pub.dev/packages/go_router)

## Welcome to the Team! 👋

You're all set! Start by exploring the project structure and running the app. Happy coding!

---

**Pro Tip**: Bookmark this guide and the others for quick reference while developing.
