# Project Structure Guide

This document explains the folder organization and naming conventions used in this project.

## Directory Tree

```
{{project_name.snakeCase()}}/
│
├── lib/                              # Main source code
│   ├── main.dart                    # Application entry point
│   ├── app.dart                     # Root widget (MyApp)
│   │
│   ├── core/                        # Shared layer
│   │   ├── const/                   # Application constants
│   │   ├── gen/                     # Generated files (build_runner output)
│   │   ├── logger/
│   │   │   └── app_logger.dart      # Centralized logging utility
│   │   ├── providers/               # Global Riverpod providers
│   │   │   ├── theme_provider.dart  # Theme state management
│   │   │   └── navigator_key_provider.dart
│   │   ├── routes/                  # Routing configuration
│   │   │   ├── route_config.dart    # Go Router setup
│   │   │   ├── route_const.dart     # Route names/paths
│   │   │   ├── custom_transition_page.dart
│   │   │   └── part_of.dart         # Route definitions
│   │   └── static/                  # Static resources
│   │       ├── extensions/          # Dart extensions
│   │       │   ├── context_extension.dart    # BuildContext extensions
│   │       │   ├── string_extension.dart
│   │       │   ├── date_time_format.dart
│   │       │   └── localization_extension.dart
│   │       ├── theme/               # Theme system
│   │       │   ├── theme.dart       # Main theme file + BuildContextExtension
│   │       │   └── src/
│   │       │       ├── theme_data.dart     # Light & Dark ThemeData
│   │       │       ├── theme_extensions/  # Custom theme classes
│   │       │       │   ├── extensions.dart
│   │       │       │   └── src/
│   │       │       │       ├── colors/
│   │       │       │       │   ├── colors.dart    # Color definitions
│   │       │       │       │       └── ...
│   │       │       │       ├── text_style.dart    # TextStyle definitions
│   │       │       │       ├── dimensions.dart    # Spacing/padding/radius
│   │       │       │       └── ...
│   │       │       └── part/        # Theme component themes
│   │       │           ├── app_bar_theme.dart
│   │       │           ├── button_theme_data.dart
│   │       │           └── ...
│   │       └── utils/               # Utility functions
│   │           └── ...
│   │
│   ├── data/                        # Data layer
│   │   ├── models/                  # Data models (JSON serializable)
│   │   │   ├── user_model.dart
│   │   │   └── ...
│   │   ├── repositories/            # Repository implementations
│   │   │   ├── user_repository.dart
│   │   │   └── ...
│   │   └── services/                # External services
│   │       ├── api/                 # API services (Dio/Retrofit)
│   │       │   ├── api_service.dart
│   │       │   └── ...
│   │       ├── cache/               # Local storage services
│   │       │   ├── cache_service.dart
│   │       │   └── ...
│   │       └── ...
│   │
│   ├── domain/                      # Domain layer (Business logic)
│   │   └── entities/                # Core business entities
│   │       ├── user.dart
│   │       └── ...
│   │
│   └── src/                         # Presentation layer (UI)
│       ├── feature/                 # Feature modules
│       │   ├── home/
│       │   │   ├── pages/
│       │   │   │   └── home_page.dart     # Main screen widget
│       │   │   ├── widgets/
│       │   │   │   ├── home_app_bar.dart
│       │   │   │   └── home_body.dart
│       │   │   ├── providers/
│       │   │   │   └── home_provider.dart
│       │   │   └── models/          # Feature-specific models
│       │   │
│       │   ├── profile/
│       │   │   ├── pages/
│       │   │   ├── widgets/
│       │   │   ├── providers/
│       │   │   └── models/
│       │   │
│       │   ├── auth/
│       │   │   ├── pages/
│       │   │   ├── widgets/
│       │   │   ├── providers/
│       │   │   └── models/
│       │   │
│       │   └── ...
│       │
│       └── widgets/                 # Reusable widgets (shared across features)
│           ├── buttons/
│           │   ├── custom_button.dart
│           │   ├── icon_button.dart
│           │   └── ...
│           ├── cards/
│           │   ├── user_card.dart
│           │   └── ...
│           ├── dialogs/
│           │   ├── confirm_dialog.dart
│           │   └── ...
│           ├── loaders/
│           │   ├── skeleton_loader.dart
│           │   └── ...
│           └── ...
│
├── test/                            # Unit and widget tests
│   └── widget_test.dart
│
├── assets/                          # Static assets
│   ├── icons/                       # SVG/PNG icons
│   └── images/                      # Images
│
├── android/                         # Android platform code
├── ios/                             # iOS platform code
├── linux/                           # Linux platform code
├── macos/                           # macOS platform code
├── windows/                         # Windows platform code
├── web/                             # Web platform code
│
├── pubspec.yaml                     # Dependencies
├── analysis_options.yaml            # Lint rules
├── {{project_name.snakeCase()}}.iml # IDE configuration
└── README.md                        # Project documentation
```

## Layer Descriptions

### Core Layer (`lib/core/`)

**Purpose**: Shared infrastructure and utilities used across all layers.

**Contents**:
- **const/**: Constants like API endpoints, cache keys, etc.
- **logger/**: Centralized logging with `AppLogger`
- **providers/**: Global Riverpod providers (theme, routing)
- **routes/**: Go Router configuration and route definitions
- **static/extensions/**: Dart extensions for cleaner code
- **static/theme/**: Comprehensive theme system
- **static/utils/**: Helper functions and utilities

**When to add**: Infrastructure code, shared logic, app-wide configuration

### Data Layer (`lib/data/`)

**Purpose**: Handles all data operations and integration with external services.

**Contents**:
- **models/**: JSON-serializable data classes
- **repositories/**: Concrete implementations of data repositories
- **services/api/**: API client using Dio and Retrofit
- **services/cache/**: Local storage implementation

**When to add**: API endpoints, database operations, caching logic

### Domain Layer (`lib/domain/`)

**Purpose**: Pure business logic independent of frameworks.

**Contents**:
- **entities/**: Immutable business objects

**When to add**: Business logic, validation rules, entity definitions

### Presentation Layer (`lib/src/`)

**Purpose**: User interface and feature implementations.

**Structure**:

#### Features (`lib/src/feature/`)

Each feature is a self-contained module:

```
feature/home/
├── pages/           # Full-screen widgets
├── widgets/         # Feature-specific components
├── providers/       # State management (Riverpod)
└── models/          # Feature-specific models
```

**Example**: If implementing a Home feature:
- **pages/home_page.dart**: Main screen displayed by router
- **widgets/home_app_bar.dart**: App bar component
- **widgets/home_body.dart**: Main content
- **providers/home_provider.dart**: State management
- **models/home_model.dart**: Local data structures

#### Shared Widgets (`lib/src/widgets/`)

Reusable widgets used across multiple features:

```
widgets/
├── buttons/         # Button variants
├── cards/           # Card widgets
├── dialogs/         # Dialog components
├── inputs/          # Form inputs
├── loaders/         # Loading states
└── ...
```

## Naming Conventions

### Files

```
my_feature.dart     # Snake case for filenames
MyFeature           # PascalCase for class names
myFeature           # camelCase for variables/methods
MY_CONSTANT         # UPPER_SNAKE_CASE for constants
```

### Directories

```
my_feature/         # Snake case for directory names
my_feature_page.dart    # Feature name in filename
my_feature_provider.dart
```

### Classes

| Type | Naming | Example |
|------|--------|---------|
| Widgets | `[Feature][Type]Widget` | `HomePageWidget`, `UserCardWidget` |
| Pages | `[Feature]Page` | `HomePage`, `ProfilePage` |
| Providers | `[feature][Type]Provider` | `homeProvider`, `userListProvider` |
| Repositories | `[Entity]Repository` | `UserRepository`, `PostRepository` |
| Models | `[Entity]Model` | `UserModel`, `PostModel` |
| Services | `[Service]Service` | `ApiService`, `CacheService` |
| Entities | `[Entity]` | `User`, `Post` |

## File Organization Rules

### Rule 1: Imports Order

```dart
// 1. Dart imports
import 'dart:async';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 4. Relative imports
import '../models/user.dart';
import 'widgets/app_bar.dart';

// 5. Exports (if any)
export 'models/user.dart';
```

### Rule 2: File Size

- **Keep files focused**: One feature/component per file
- **Max file size**: ~400-500 lines
- **Widget files**: ~200-300 lines
- **Provider files**: ~100-150 lines

### Rule 3: Export Files

Use index files for cleaner imports:

```dart
// lib/src/feature/home/index.dart
export 'pages/home_page.dart';
export 'widgets/home_app_bar.dart';
export 'providers/home_provider.dart';

// Usage in another file
import 'feature/home/index.dart';  // Cleaner than individual imports
```

## Example: Adding a New Feature

### Step 1: Create Feature Directory

```
lib/src/feature/products/
├── pages/
├── widgets/
├── providers/
└── models/
```

### Step 2: Create Main Page

```dart
// lib/src/feature/products/pages/products_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(child: Text('Products')),
    );
  }
}
```

### Step 3: Add Provider

```dart
// lib/src/feature/products/providers/products_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:{{project_name.snakeCase()}}/domain/entities/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  // Fetch products
  return [];
});
```

### Step 4: Add Route

```dart
// lib/core/routes/route_config.dart
GoRoute(
  path: '/products',
  name: 'products',
  builder: (context, state) => const ProductsPage(),
),
```

### Step 5: Export from Index

```dart
// lib/src/feature/products/index.dart
export 'pages/products_page.dart';
export 'providers/products_provider.dart';
```

## Best Practices

### ✅ DO:

1. **Keep features self-contained**: Everything a feature needs is in its folder
2. **Use proper layer separation**: Data stays in data layer, UI in presentation
3. **Follow naming conventions**: Makes code predictable and searchable
4. **Organize by features, not by type**: Easier to maintain and scale
5. **Use index files**: Cleaner imports and easier refactoring

### ❌ DON'T:

1. **Create deeply nested folders**: Maximize 3-4 levels deep
2. **Mix concerns across layers**: Data logic doesn't go in widgets
3. **Create god classes**: Keep classes focused and small
4. **Use generic folder names**: `utils/`, `helpers/` should be specific
5. **Ignore the structure for "quick" additions**: Structure benefits compound

## Quick Reference

| Need | Location |
|------|----------|
| API endpoint | `lib/data/services/api/` |
| Cache logic | `lib/data/services/cache/` |
| Business entity | `lib/domain/entities/` |
| Color/Font | `lib/core/static/theme/src/theme_extensions/src/` |
| Global state | `lib/core/providers/` |
| Screen | `lib/src/feature/[feature]/pages/` |
| Reusable widget | `lib/src/widgets/` |
| Constants | `lib/core/const/` |
| Routing | `lib/core/routes/` |
| Logging | `lib/core/logger/` |

---

**Remember**: A well-organized structure makes the codebase maintainable and helps new team members understand the project quickly.
