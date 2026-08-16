# Architecture Guide

Welcome to the team! This document explains the architecture of the project and how it's organized. This project follows **Clean Architecture** principles to maintain scalability, testability, and maintainability.

## Table of Contents

- [Overview](#overview)
- [Layered Architecture](#layered-architecture)
- [Core Layer](#core-layer)
- [Data Layer](#data-layer)
- [Domain Layer](#domain-layer)
- [Presentation Layer (src/)](#presentation-layer-src)
- [Dependency Flow](#dependency-flow)
- [Key Principles](#key-principles)

## Overview

The application is structured in **4 layers**, each with specific responsibilities:

```
┌─────────────────────────────────────┐
│   Presentation Layer (src/)         │
│   Features, Screens, Widgets        │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│   Domain Layer                      │
│   Business Logic, Entities          │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│   Data Layer                        │
│   Models, Repositories, Services    │
└────────────┬────────────────────────┘
             │
┌────────────▼────────────────────────┐
│   Core Layer                        │
│   Shared utilities, Theme, Routing  │
└─────────────────────────────────────┘
```

## Layered Architecture

### Dependency Rule
- **Higher layers depend on lower layers**
- **Lower layers never depend on higher layers**
- **Only depend on abstractions, not concrete implementations**

This ensures loose coupling and makes it easy to test and modify code.

## Core Layer

Located in: `lib/core/`

The core layer contains shared utilities and infrastructure used across the entire application.

### Subdirectories:

```
core/
├── const/                    # Application constants
├── gen/                      # Generated files (from build_runner)
├── logger/                   # Logging utilities (AppLogger)
├── providers/                # Riverpod providers (theme, routing)
├── routes/                   # Routing configuration (Go Router)
├── static/
│   ├── extensions/           # Dart extensions for BuildContext
│   ├── theme/                # Theme system (colors, text styles, dimensions)
│   └── utils/                # Utility functions
```

### Key Components:

- **AppLogger**: Centralized logging for debugging and monitoring
- **ThemeProvider**: Manages light/dark theme state
- **Go Router**: Client-side routing configuration
- **ThemeExtensions**: Custom theme classes for styling

## Data Layer

Located in: `lib/data/`

The data layer handles all data operations including API calls, local storage, and data transformation.

### Subdirectories:

```
data/
├── models/                   # Data models (JSON serializable)
├── repositories/             # Repository implementations (concrete)
└── services/
    ├── api/                  # API calls using Dio/Retrofit
    ├── cache/                # Local storage (SharedPreferences)
    └── ...                   # Other services
```

### Responsibilities:

- **Models**: Define data structures with JSON serialization
  ```dart
  class UserModel {
    final String id;
    final String name;
    
    factory UserModel.fromJson(Map<String, dynamic> json) => ...
  }
  ```

- **Repositories**: Implement data fetching and transformation
  ```dart
  class UserRepository {
    Future<User> getUser(String id) async {
      final model = await _apiService.getUser(id);
      return model.toEntity();
    }
  }
  ```

- **Services**: Handle external integrations
  - API services (Dio, Retrofit)
  - Cache services (SharedPreferences)

## Domain Layer

Located in: `lib/domain/`

The domain layer contains pure business logic and entities. It's independent of any framework.

### Subdirectories:

```
domain/
└── entities/                 # Business entities (immutable)
```

### Key Concepts:

- **Entities**: Represent core business objects
  ```dart
  class User {
    final String id;
    final String name;
    
    const User({required this.id, required this.name});
  }
  ```

- **Pure Functions**: No side effects, predictable outputs
- **Independent**: No dependencies on Flutter or external packages

## Presentation Layer (src/)

Located in: `lib/src/`

The presentation layer handles UI and user interactions.

### Subdirectories:

```
src/
├── feature/                  # Feature modules
│   ├── home/
│   ├── profile/
│   └── ...
└── widgets/                  # Reusable widgets
    ├── buttons/
    ├── cards/
    └── ...
```

### Feature Structure:

Each feature typically follows this pattern:

```
feature/home/
├── pages/
│   └── home_page.dart
├── widgets/
│   └── home_widgets.dart
├── providers/
│   └── home_provider.dart
└── models/
    └── home_models.dart
```

### Key Principles:

- **One Screen = One Provider**: Each screen has its own state provider
- **Reusable Widgets**: Common UI components in `widgets/` directory
- **Separation of Concerns**: Providers handle logic, widgets handle UI

## Dependency Flow

```
HomeScreen (Presentation)
        │
        ├── uses ──→ homeProvider (Provider)
        │              │
        │              ├── uses ──→ UserRepository
        │              │              │
        │              │              ├── uses ──→ UserApiService (Data)
        │              │              │              │
        │              │              │              └── API calls
        │              │              │
        │              │              └── converts ──→ User (Domain Entity)
        │              │
        │              └── returns ──→ AsyncValue<User>
        │
        └── accesses ──→ context.color, context.textStyle (Theme)
```

### Example: Fetching User Data

```dart
// 1. Domain Layer (Pure Business Logic)
class User {
  final String id;
  final String name;
  const User({required this.id, required this.name});
}

// 2. Data Layer (API Integration)
class UserModel {
  final String id;
  final String name;
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
  );
  
  User toEntity() => User(id: id, name: name);
}

// 3. Data Layer (Repository)
class UserRepository {
  Future<User> getUser(String id) async {
    final model = await _apiService.getUser(id);
    return model.toEntity();
  }
}

// 4. Presentation Layer (Provider)
final userProvider = FutureProvider<User>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUser('user_id');
});

// 5. Presentation Layer (Widget)
class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

## Key Principles

### 1. Single Responsibility
Each class should have one reason to change:
- Models format data
- Repositories fetch data
- Entities represent business logic
- Widgets display UI

### 2. Separation of Concerns
- **UI Logic** ≠ **Business Logic** ≠ **Data Access Logic**
- Use Riverpod providers to bridge these concerns

### 3. DRY (Don't Repeat Yourself)
- Extract common logic into utilities or base classes
- Reuse widgets and providers

### 4. SOLID Principles
- **S**ingle Responsibility: One class, one job
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subtypes should be substitutable
- **I**nterface Segregation: Specific interfaces over general ones
- **D**ependency Inversion: Depend on abstractions, not implementations

### 5. Testability
- Pure functions are easy to test
- Mock repositories for widget tests
- Use providers for dependency injection

## Best Practices

### ✅ DO:
- Keep entities and domain logic framework-agnostic
- Use repositories as the single source of data
- Organize features by domain, not by type
- Use type-safe models with proper serialization
- Handle errors gracefully with AsyncValue

### ❌ DON'T:
- Mix UI logic with business logic
- Access data services directly from widgets
- Create god classes with too many responsibilities
- Use global state when Riverpod providers work better
- Ignore null safety and type safety

## Folder Organization Summary

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # App configuration
├── core/                     # Shared layer
│   ├── const/
│   ├── gen/
│   ├── logger/
│   ├── providers/
│   ├── routes/
│   └── static/
├── data/                     # Data layer
│   ├── models/
│   ├── repositories/
│   └── services/
├── domain/                   # Domain layer
│   └── entities/
└── src/                      # Presentation layer
    ├── feature/
    └── widgets/
```

## Getting Help

- 📚 Read the [Flutter Documentation](https://flutter.dev/docs)
- 🏗️ Learn about [Clean Architecture](https://resocoder.com/clean-architecture)
- 📦 Check [Riverpod Documentation](https://riverpod.dev)
- 🎨 See [Theme Guide](./Theme.md)

---

**Remember**: The goal of this architecture is to make the codebase scalable, testable, and maintainable. Always think about dependencies and responsibilities when organizing code.
