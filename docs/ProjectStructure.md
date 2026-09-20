# Project Structure Guide

This document explains the folder organization, layer boundaries, and naming conventions used in this project.

## Directory Tree

```
{{project_name.snakeCase()}}/
│
├── lib/
│   ├── main.dart                             # Application entry point with bootstrap & DI
│   ├── app.dart                              # Root widget (MyApp) with ScreenUtil & MaterialApp.router
│   │
│   └── src/                                  # Internal codebase implementation
│       ├── core/                             # App-wide infrastructure (non-UI)
│       │   ├── bootstrap.dart                # System UI, orientations, zones, crash reporting init
│       │   ├── initialize_crash_reporting.dart # Firebase Crashlytics / custom error reporting
│       │   ├── const/                        # Application constants (assets, static keys)
│       │   ├── extensions/                   # Dart extensions (BuildContext, String, DateTime)
│       │   ├── gen/                          # Generated asset code (flutter_gen)
│       │   ├── localization/                 # App localization setup and delegates
│       │   ├── logger/                       # AppLogger (Talker/Logger) & RiverpodObserver
│       │   └── utils/                        # Utilities & validators (email, image picker)
│       │
│       ├── data/                             # Data layer (Remote & Local sources)
│       │   ├── models/                       # JSON-serializable data models
│       │   ├── repositories/                 # Repository implementations (concrete)
│       │   └── services/                     # External & internal service integrations
│       │       ├── auth/                     # AuthService (token & session management)
│       │       ├── cache/                    # CacheService & SharedPreferencesService
│       │       └── network/                  # Network client, interceptors & handlers
│       │           ├── dio_client.dart       # Dio instance configuration & provider
│       │           ├── rest_client.dart      # Retrofit REST API client & provider
│       │           ├── api_handler.dart      # Standard Api.call<T> error/response wrapper
│       │           ├── endpoints.dart        # Centralized API endpoint constants
│       │           └── interceptors/         # AccessToken & TokenRefresh interceptors
│       │
│       ├── domain/                           # Domain layer (Pure business logic)
│       │   ├── entities/                     # Core business entities (immutable)
│       │   └── repositories/                 # Repository contracts/interfaces
│       │
│       └── presentation/                     # Presentation layer (UI & UX)
│           ├── core/                         # Shared presentation foundations
│           │   ├── providers/                # Theme & navigation providers
│           │   ├── routes/                   # Modular GoRouter setup
│           │   │   ├── route_config.dart     # Central routerProvider definition
│           │   │   ├── routes.dart           # Type-safe enum Routes (path & name)
│           │   │   ├── part_of.dart          # Route orchestrator file
│           │   │   ├── custom_transition_page.dart # Custom page transitions
│           │   │   └── parts/                # Feature-specific sub-routes (part files)
│           │   │       ├── authentication_routes.dart
│           │   │       ├── onboarding_routes.dart
│           │   │       └── shell_routes.dart
│           │   ├── theme/                    # Theme system & extensions
│           │   │   ├── theme.dart            # Main theme configuration & BuildContext extensions
│           │   │   └── src/                  # ThemeData, extensions (colors, typography, dimensions)
│           │   └── widgets/                  # Reusable presentation widgets (buttons, dropdowns, dialogs)
│           │
│           └── feature/                      # Feature modules
│               ├── auth/                     # Authentication feature
│               │   ├── sign_in_screen/
│               │   │   ├── view/             # Screen UI widgets
│               │   │   ├── view_model/       # Screen-specific Riverpod providers/notifiers
│               │   │   └── widgets/          # Screen-specific sub-widgets
│               │   ├── register_screen/
│               │   ├── reset_password/
│               │   └── ...
│               ├── home/                     # Home feature
│               │   ├── home_screen/
│               │   └── bottom_nav_bar/
│               ├── onboarding/               # Onboarding flow
│               └── ...
│
├── test/                                    # Unit, widget, and integration tests
├── assets/                                  # Static assets (images, icons, fonts)
├── android/                                 # Android platform configuration
├── ios/                                     # iOS platform configuration
├── linux/                                   # Linux platform configuration
├── macos/                                   # macOS platform configuration
├── windows/                                 # Windows platform configuration
├── web/                                     # Web platform configuration
│
├── pubspec.yaml                             # Dependencies & configuration
├── analysis_options.yaml                    # Lint rules & static analysis
└── README.md                                # Project documentation
```

---

## Layer Descriptions

### 1. App-Wide Core (`lib/src/core/`)

**Purpose**: Non-UI shared infrastructure, low-level utilities, and application bootstrap logic.

**Contents**:
- **bootstrap.dart**: Orchestrates app initialization, error reporting, orientation locking, and `runZonedGuarded`.
- **initialize_crash_reporting.dart**: Integrates Crashlytics or external telemetry.
- **logger/**: `AppLogger` for structured logging and `RiverpodObserver` for state lifecycle debugging.
- **extensions/**: Dart extensions on `BuildContext`, `String`, `DateTime`, etc.
- **const/**: Global constants (static image paths, asset identifiers).
- **gen/**: Generated asset helpers (e.g. `flutter_gen`).
- **utils/**: Common helpers such as validation functions and file pickers.

**When to add**: Universal application helpers, platform-level setup, or non-UI cross-cutting utilities.

---

### 2. Data Layer (`lib/src/data/`)

**Purpose**: Concrete data retrieval, local persistence, network operations, and data transformations.

**Contents**:
- **models/**: DTOs (Data Transfer Objects) with JSON serialization (`fromJson`/`toJson`).
- **repositories/**: Concrete implementations of domain repository interfaces (e.g. `AuthenticationRepositoryImpl`).
- **services/network/**:
  - `dio_client.dart`: Configured `Dio` instance with timeouts, headers, and interceptors.
  - `rest_client.dart`: Retrofit client declaration and `restClientProvider`.
  - `api_handler.dart`: Reusable `Api.call<T>` helper for structured exception unwrapping.
  - `endpoints.dart`: Centralized backend API URLs.
  - `interceptors/`: `AccessTokenInterceptor` and `TokenRefreshInterceptor` for automated auth token lifecycle.
- **services/cache/**: `CacheService` interface, `CacheKey` enum, and `SharedPreferencesService`.
- **services/auth/**: `AuthService` handling session tokens and credential cache.

**When to add**: API endpoints, database operations, caching routines, and DTO definitions.

---

### 3. Domain Layer (`lib/src/domain/`)

**Purpose**: Pure business logic, core entities, and abstract repository contracts. Framework-agnostic and free from UI/Network dependencies.

**Contents**:
- **entities/**: Immutable business domain objects.
- **repositories/**: Repository interfaces (`abstract interface class`) defining data access contracts for the application.

**When to add**: Business models, domain rules, and repository contracts.

---

### 4. Presentation Layer (`lib/src/presentation/`)

**Purpose**: User interface, screens, state management, routing, and design system.

The presentation layer is cleanly divided into two parts:

#### A. Presentation Core (`lib/src/presentation/core/`)

Shared foundations that all features rely upon:
- **providers/**: Presentation-level global providers (`theme_provider.dart` with `ThemeModeNotifier`, `navigator_key_provider.dart`).
- **routes/**: Modular GoRouter architecture:
  - `routes.dart`: Strongly-typed `enum Routes` containing route paths and names.
  - `route_config.dart`: Core `routerProvider` definition assembling sub-routes.
  - `part_of.dart`: Central routing orchestrator connecting sub-route part files.
  - `parts/`: Sub-route definitions partitioned by domain (`authentication_routes.dart`, `onboarding_routes.dart`, `shell_routes.dart`).
  - `custom_transition_page.dart`: Shared animated route transitions.
- **theme/**: Comprehensive theme system:
  - `theme.dart`: `BuildContext` extensions (`context.color`, `context.textStyle`, `context.spacing`, `context.padding`, `context.radius`).
  - `src/theme_data.dart`: Light and Dark `ThemeData`.
  - `src/theme_extensions/`: Custom `ThemeExtension` implementations for colors, typography, and dimensions.
  - `src/part/`: Component theme styling (AppBars, buttons, inputs, checkboxes).
- **widgets/**: Generic UI components used across multiple features (`app_text_field.dart`, `app_dropdown.dart`, `custom_loading_indicator.dart`, `empty_state_widget.dart`, `custom_toast.dart`).

#### B. Feature Modules (`lib/src/presentation/feature/`)

Self-contained feature packages. Each screen or sub-flow is organized with:

```
feature/[feature_name]/[screen_name]/
├── view/            # Screen widget (e.g. SignInScreen, HomeScreen)
├── view_model/      # Riverpod Notifiers / State Providers (e.g. ChatProvider)
└── widgets/         # Screen-specific sub-widgets (e.g. UserBubble, FilterSheet)
```

**Example Structure**:
```
lib/src/presentation/feature/auth/
├── sign_in_screen/
│   ├── view/
│   │   └── sign_in_screen.dart
│   ├── view_model/
│   │   └── sign_in_provider.dart
│   └── widgets/
│       └── social_auth_button.dart
├── register_screen/
│   └── view/
│       └── register_screen.dart
└── reset_password/
    └── view/
        └── reset_pass_screen.dart
```

---

## Naming Conventions

### Files & Folders

```
my_feature/                 # snake_case for directories
my_feature_screen.dart      # snake_case for filenames
my_feature_provider.dart    # Provider file name
```

### Classes & Types

| Type | Pattern | Example |
|------|---------|---------|
| Screens / Pages | `[Feature]Screen` or `[Feature]Page` | `HomeScreen`, `SignInScreen` |
| Feature Widgets | `[Feature][Component]` | `UserBubble`, `ExitConfirmDialog` |
| ViewModels / Notifiers | `[Feature]Notifier` / `[Feature]Provider` | `ThemeModeNotifier`, `chatProvider` |
| Repositories (Interface) | `[Entity]Repository` | `AuthenticationRepository` |
| Repositories (Impl) | `[Entity]RepositoryImpl` | `AuthenticationRepositoryImpl` |
| DTO Models | `[Entity]Model` or `[Entity]` | `DailyVerse`, `UserModel` |
| Services | `[Service]Service` | `AuthService`, `CacheService` |
| Route Enum | `Routes` | `Routes.login`, `Routes.homeScreen` |

---

## Modular Route System

Rather than keeping all routes in a single monolithic file, routes are segmented into logical parts using Dart's `part` / `part of` directive:

1. **`routes.dart`**: Declares all routes in an enum:
   ```dart
   enum Routes {
     splash('/splash'),
     login('/login'),
     homeScreen('/home_screen');

     const Routes(this.path);
     final String path;
   }
   ```
2. **`parts/[domain]_routes.dart`**: Defines sub-route groups:
   ```dart
   part of "../part_of.dart";

   List<GoRoute> _authenticationRoutes(Ref ref) {
     return [
       GoRoute(
         path: Routes.login.path,
         name: Routes.login.name,
         pageBuilder: (context, state) => const MaterialPage(child: SignInScreen()),
       ),
     ];
   }
   ```
3. **`route_config.dart`**: Combines sub-route lists into the main `GoRouter`:
   ```dart
   part of 'part_of.dart';

   final routerProvider = Provider<GoRouter>((ref) {
     return GoRouter(
       navigatorKey: ref.watch(navigatorKeyProvider),
       initialLocation: Routes.splash.path,
       routes: [
         ..._onboardingRoutes(ref),
         ..._authenticationRoutes(ref),
         _shellRoutes(ref),
       ],
     );
   });
   ```

---

## Example: Adding a New Feature

Follow this standard flow when adding a new feature (e.g. `products`):

### Step 1: Define Domain Entity & Contract
```dart
// lib/src/domain/entities/product.dart
class Product {
  final String id;
  final String title;
  final double price;

  const Product({required this.id, required this.title, required this.price});
}

// lib/src/domain/repositories/product_repository.dart
abstract interface class ProductRepository {
  Future<List<Product>> getProducts();
}
```

### Step 2: Implement Data Model & Repository
```dart
// lib/src/data/models/product_model.dart
class ProductModel {
  final String id;
  final String title;
  final double price;

  ProductModel({required this.id, required this.title, required this.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ...;
  Product toEntity() => Product(id: id, title: title, price: price);
}

// lib/src/data/repositories/product_repository_impl.dart
class ProductRepositoryImpl implements ProductRepository {
  final RestClient remote;
  ProductRepositoryImpl({required this.remote});

  @override
  Future<List<Product>> getProducts() async {
    // invoke remote and map to entities
    return [];
  }
}
```

### Step 3: Create Feature Presentation Module
```
lib/src/presentation/feature/products/
└── product_list/
    ├── view/
    │   └── product_list_screen.dart
    ├── view_model/
    │   └── product_list_provider.dart
    └── widgets/
        └── product_card.dart
```

```dart
// lib/src/presentation/feature/products/product_list/view_model/product_list_provider.dart
final productListProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// lib/src/presentation/feature/products/product_list/view/product_list_screen.dart
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) => ListView.builder(...),
        loading: () => const CustomLoadingIndicator(),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
```

### Step 4: Register Route in `routes.dart` and Route Parts
1. Add entry to `lib/src/presentation/core/routes/routes.dart`:
   ```dart
   enum Routes {
     ...
     productList('/product_list');
   }
   ```
2. Add route definition to a sub-route part (e.g. `shell_routes.dart` or a new `product_routes.dart`):
   ```dart
   GoRoute(
     path: Routes.productList.path,
     name: Routes.productList.name,
     pageBuilder: (context, state) => const MaterialPage(child: ProductListScreen()),
   )
   ```

---

## Quick Reference Table

| Need | Location |
|------|----------|
| Bootstrap & App Lifecycle | `lib/src/core/bootstrap.dart` |
| Crash Reporting / Telemetry | `lib/src/core/initialize_crash_reporting.dart` |
| Central Logging | `lib/src/core/logger/app_logger.dart` |
| Network Config & Dio | `lib/src/data/services/network/dio_client.dart` |
| REST Endpoints & Retrofit | `lib/src/data/services/network/rest_client.dart` |
| Standard API Handler | `lib/src/data/services/network/api_handler.dart` |
| Local Cache & Storage | `lib/src/data/services/cache/cache_service.dart` |
| Business Entity | `lib/src/domain/entities/` |
| Repository Interfaces | `lib/src/domain/repositories/` |
| Repository Implementations | `lib/src/data/repositories/` |
| Theme Configuration & Colors | `lib/src/presentation/core/theme/` |
| Global UI State (Theme, Nav) | `lib/src/presentation/core/providers/` |
| Routing Configuration | `lib/src/presentation/core/routes/` |
| Reusable UI Widgets | `lib/src/presentation/core/widgets/` |
| Screen UI Widgets | `lib/src/presentation/feature/[feature]/[screen]/view/` |
| Screen Riverpod Providers | `lib/src/presentation/feature/[feature]/[screen]/view_model/` |
| Screen-Specific Widgets | `lib/src/presentation/feature/[feature]/[screen]/widgets/` |
