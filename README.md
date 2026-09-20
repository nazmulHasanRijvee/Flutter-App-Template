# Flutter App Template

A comprehensive Flutter application template with production-ready architecture, best practices, and organized code structure.

## 📋 Overview

This is a professional Flutter template project designed to accelerate development with:
- **Clean Architecture** implementation (Core, Data, Domain, Presentation layers)
- **Riverpod** for state management and dependency injection
- **Go Router** for navigation and routing
- **Retrofit** for API client generation
- **Responsive UI** with Flutter ScreenUtil
- **Theme System** supporting light and dark modes
- **Organized Project Structure** with clear conventions

Perfect for starting new Flutter projects with a solid foundation and scalable architecture.

## ✨ Features

- ✅ Clean Architecture pattern with clear layer separation
- ✅ Reactive state management with Riverpod
- ✅ Type-safe routing with Go Router
- ✅ REST API integration with Retrofit & Dio
- ✅ Comprehensive theme system (colors, typography, spacing)
- ✅ Form validation with validators
- ✅ Local storage with SharedPreferences
- ✅ Responsive design with ScreenUtil
- ✅ Localization support (intl package)
- ✅ Loading indicators and toast notifications
- ✅ Cached network images
- ✅ Input pinning widget for OTP/verification
- ✅ Comprehensive documentation

## 🛠️ Prerequisites

Before you begin, ensure you have:
- **Flutter SDK** v3.12.2 or higher
- **Dart SDK** v3.12.2 or higher
- **Git** for version control
- A code editor (VS Code, Android Studio, or similar)

### Installation

1. Install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Verify installation:
   ```bash
   flutter doctor
   ```

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone <repository-url>
cd flutter_app_template
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Build Generated Files
Some packages require code generation:
```bash
flutter pub run build_runner build
```

### 4. Run the Application
```bash
flutter run
```

### 5. Build for Production
```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release

# Web
flutter build web --release
```

## 📁 Project Structure

```
lib/
├── main.dart                 # Application entry point with bootstrap & DI
├── app.dart                  # Root widget configuring ScreenUtil & router
│
└── src/                      # Internal implementation
    ├── core/                 # Shared infrastructure, bootstrap, crash reporting, logger
    │   ├── bootstrap.dart
    │   ├── initialize_crash_reporting.dart
    │   ├── logger/
    │   ├── extensions/
    │   └── utils/
    │
    ├── data/                 # Data layer (network, cache, repositories)
    │   ├── models/           # DTO response models
    │   ├── repositories/     # Repository implementations
    │   └── services/         # Network (Dio/Retrofit/Api.call), cache, auth
    │
    ├── domain/               # Domain layer (business logic)
    │   ├── entities/         # Business logic entities
    │   └── repositories/     # Repository contracts
    │
    └── presentation/         # Presentation layer (UI & UX)
        ├── core/             # Shared providers, modular routes, theme, widgets
        └── feature/          # Feature packages (view, view_model, widgets)
```

See [docs/ProjectStructure.md](docs/ProjectStructure.md) for detailed documentation.

## 🔧 Key Technologies

| Package | Purpose |
|---------|---------|
| **flutter_riverpod** | State management & dependency injection |
| **go_router** | Navigation and routing |
| **dio** | HTTP client |
| **retrofit** | API client generation |
| **flutter_screenutil** | Responsive design |
| **shared_preferences** | Local data persistence |
| **intl** | Localization and internationalization |
| **form_builder_validators** | Form validation |
| **cached_network_image** | Network image caching |
| **toastification** | Toast notifications |

## 📚 Documentation

Complete documentation is available in the `docs/` directory:

- **[Getting Started](docs/GettingStarted.md)** - Quick setup and common commands
- **[Architecture Guide](docs/Architecture.md)** - Understanding the Clean Architecture layers
- **[Project Structure](docs/ProjectStructure.md)** - Detailed folder organization
- **[State Management](docs/StateManagement.md)** - Riverpod patterns and examples
- **[Theme System](docs/Theme.md)** - Color, typography, and spacing management
- **[API Integration](docs/ApiIntegration.md)** - Backend connectivity with Retrofit
- **[Conventions](docs/Conventions.md)** - Coding standards and best practices

## 🎨 Customization

### Add a New Feature
1. Define entity & repository interface in `lib/src/domain/`
2. Implement model & repository in `lib/src/data/`
3. Build UI module under `lib/src/presentation/feature/[feature]/[screen]/` (`view/`, `view_model/`, `widgets/`)
4. Register route in `lib/src/presentation/core/routes/routes.dart` and route parts

See [docs/ProjectStructure.md](docs/ProjectStructure.md) for detailed instructions.

### Modify Theme
Edit `lib/src/presentation/core/theme/` to customize:
- Colors
- Typography
- Spacing and dimensions
- Component themes

See [docs/Theme.md](docs/Theme.md) for examples.

## 🔄 Development Workflow

### Code Generation
When modifying models or Retrofit clients:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Code Formatting
```bash
dart format lib/
```

### Linting
```bash
flutter analyze
```

### Running Tests
```bash
flutter test
```

## 📱 Platform Support

This template supports:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

When contributing to this template:
1. Follow the conventions in [docs/Conventions.md](docs/Conventions.md)
2. Maintain the Clean Architecture structure
3. Add tests for new features
4. Update documentation as needed

## 📖 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Go Router Guide](https://pub.dev/packages/go_router)
- [Clean Architecture in Flutter](https://codewithandrea.com/articles/flutter-clean-architecture-tdd/)

## 📝 License

This project is provided as a template. Modify the license as needed for your project.

## ❓ FAQ

**Q: How do I add a new API endpoint?**  
A: See [docs/ApiIntegration.md](docs/ApiIntegration.md) for step-by-step instructions.

**Q: How do I manage global state?**  
A: See [docs/StateManagement.md](docs/StateManagement.md) for Riverpod patterns.

**Q: How do I add a new route?**  
A: Edit `lib/core/routes/` and follow the routing conventions.

**Q: How do I support dark mode?**  
A: The theme system automatically handles light/dark modes. See [docs/Theme.md](docs/Theme.md).

## 🆘 Support

For issues or questions:
1. Check the [docs](docs/) directory
2. Review Flutter and Riverpod documentation
3. Open an issue in the repository

---

**Happy coding! 🚀**
