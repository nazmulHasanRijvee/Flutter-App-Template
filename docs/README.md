# Documentation Index

Welcome to the project documentation! This directory contains comprehensive guides to help you understand and work with the codebase.

## 📚 Documentation Files

### Getting Started
- **[Getting Started](./GettingStarted.md)** - Your first steps with the project
  - Quick setup instructions
  - Common commands
  - Debugging tips
  - First feature checklist

### Architecture & Design
- **[Architecture Guide](./Architecture.md)** - Understanding the project structure
  - Clean Architecture principles
  - Layer descriptions (Core, Data, Domain, Presentation)
  - Dependency flow
  - Best practices

- **[Project Structure](./ProjectStructure.md)** - How files are organized
  - Directory tree with explanations
  - Naming conventions
  - File organization rules
  - Adding new features

### Features & Systems
- **[Theme System](./Theme.md)** - Colors, fonts, and spacing
  - ThemeExtension<T> architecture
  - ColorExtension, TextStyleExtension, Dimensions
  - How to use theme values in widgets
  - Customizing and extending themes
  - Light and dark mode

- **[State Management](./StateManagement.md)** - Riverpod and reactive programming
  - Core concepts and terminology
  - Provider types (Provider, FutureProvider, AsyncNotifier, etc.)
  - Practical examples
  - Common patterns
  - Best practices

- **[API Integration](./ApiIntegration.md)** - Backend connectivity
  - Dio and Retrofit setup
  - Creating API clients
  - Making HTTP requests
  - Error handling
  - Real-world examples

### Standards & Best Practices
- **[Conventions](./Conventions.md)** - Coding standards
  - Dart style guide
  - Flutter best practices
  - Riverpod patterns
  - Code organization
  - Error handling
  - Comments and documentation

---

## 🗺️ Quick Navigation Guide

### I want to...

**Get started quickly** → [Getting Started](./GettingStarted.md)

**Understand the codebase** → [Architecture](./Architecture.md) → [Project Structure](./ProjectStructure.md)

**Add a new feature** → [Project Structure](./ProjectStructure.md) → [State Management](./StateManagement.md)

**Work with the theme** → [Theme](./Theme.md)

**Connect to an API** → [API Integration](./ApiIntegration.md) → [State Management](./StateManagement.md)

**Write better code** → [Conventions](./Conventions.md) → [Architecture](./Architecture.md)

**Manage app state** → [State Management](./StateManagement.md)

**Debug issues** → [Getting Started](./GettingStarted.md#debugging-tips) → [Architecture](./Architecture.md)

---

## 📖 Reading Order for New Team Members

### Week 1: Foundation
1. [Getting Started](./GettingStarted.md) - Set up and run the app
2. [Project Structure](./ProjectStructure.md) - Understand the codebase organization
3. [Architecture Guide](./Architecture.md) - Learn the layered architecture

### Week 2: Core Systems
4. [State Management](./StateManagement.md) - Master Riverpod patterns
5. [Theme System](./Theme.md) - Learn how styling works
6. [Conventions](./Conventions.md) - Understand coding standards

### Week 3+: Advanced
7. [API Integration](./ApiIntegration.md) - Connect to backends
8. Deep dive into specific features based on your task

---

## 🔍 Quick Reference by Topic

### Architecture & Structure
- [Layer descriptions](./Architecture.md#layered-architecture)
- [Dependency flow](./Architecture.md#dependency-flow)
- [Folder organization](./ProjectStructure.md#directory-tree)
- [Naming conventions](./ProjectStructure.md#naming-conventions)

### State Management
- [Provider types](./StateManagement.md#provider-types)
- [Practical examples](./StateManagement.md#practical-examples)
- [Common patterns](./StateManagement.md#common-patterns)
- [Best practices](./StateManagement.md#best-practices)

### Theme & UI
- [ThemeExtension overview](./Theme.md#architecture)
- [Using theme in widgets](./Theme.md#how-to-use)
- [Adding custom themes](./Theme.md#adding-custom-themes)
- [Text styles reference](./Theme.md#3-textstyleextension)
- [Spacing reference](./Theme.md#4-dimensions)

### Data & APIs
- [API setup](./ApiIntegration.md#setting-up-services)
- [Making requests](./ApiIntegration.md#making-requests)
- [Error handling](./ApiIntegration.md#error-handling)
- [Repository pattern](./ApiIntegration.md#architecture)

### Code Quality
- [Dart style guide](./Conventions.md#dart-style-guide)
- [Flutter best practices](./Conventions.md#flutter-best-practices)
- [Error handling](./Conventions.md#error-handling)
- [Testing patterns](./Conventions.md#testing)
- [Performance tips](./Conventions.md#performance)

---

## 🎯 Common Tasks

### Adding a New Screen

1. Read: [Project Structure - Adding a New Feature](./ProjectStructure.md#example-adding-a-new-feature)
2. Reference: [Architecture - Presentation Layer](./Architecture.md#presentation-layer-src)
3. State: [State Management - Provider Types](./StateManagement.md#provider-types)
4. Style: [Theme System - How to Use](./Theme.md#how-to-use)
5. Code: [Conventions - Widget Best Practices](./Conventions.md#widget-best-practices)

### Connecting to an API

1. Read: [API Integration - Overview](./ApiIntegration.md#overview)
2. Setup: [API Integration - Setting Up Services](./ApiIntegration.md#setting-up-services)
3. Integrate: [API Integration - Making Requests](./ApiIntegration.md#making-requests)
4. Handle Errors: [API Integration - Error Handling](./ApiIntegration.md#error-handling)
5. Test: [Conventions - Testing](./Conventions.md#testing)

### Fixing a Bug

1. Read: [Getting Started - Debugging Tips](./GettingStarted.md#debugging-tips)
2. Locate: [Project Structure - Quick Reference](./ProjectStructure.md#quick-reference)
3. Understand: [Architecture - Dependency Flow](./Architecture.md#dependency-flow)
4. Fix: [Conventions - Best Practices](./Conventions.md)
5. Test: [Conventions - Testing](./Conventions.md#testing)

---

## 💡 Key Concepts

### Clean Architecture
The project uses **4-layer architecture**:
- **Core**: Shared utilities, theme, routing
- **Data**: API, database, models, repositories
- **Domain**: Business logic, entities
- **Presentation**: UI, screens, features

[Learn more →](./Architecture.md)

### Riverpod State Management
Type-safe, compile-time checked state management:
- Providers are containers for state
- Watch for changes in widgets
- Read once for one-time access
- Excellent for testing

[Learn more →](./StateManagement.md)

### Theme System
Centralized styling with light/dark mode support:
- `ColorExtension` for colors
- `TextStyleExtension` for fonts
- `Dimensions` for spacing
- Access via `context.color`, `context.textStyle`, etc.

[Learn more →](./Theme.md)

### Repository Pattern
Abstraction layer for data access:
- Repositories fetch and transform data
- Models represent API data
- Entities represent business data
- Providers use repositories for state

[Learn more →](./ApiIntegration.md#architecture)

---

## 🚀 Quick Commands

```bash
# Setup
flutter pub get

# Development
flutter run
flutter run --release
flutter test

# Code Quality
dart format lib/
dart analyze
dart fix --apply

# Build
flutter build apk         # Android
flutter build appbundle   # Google Play
flutter build ios         # iOS
flutter build web         # Web

# Generate Code
flutter pub run build_runner build
flutter pub run build_runner watch
```

[Full command reference →](./GettingStarted.md#common-commands)

---

## 📞 Getting Help

### Documentation
- **Dart**: [dart.dev/guides](https://dart.dev/guides)
- **Flutter**: [flutter.dev/docs](https://flutter.dev/docs)
- **Riverpod**: [riverpod.dev](https://riverpod.dev)
- **Go Router**: [pub.dev/packages/go_router](https://pub.dev/packages/go_router)

### In This Project
- Check the relevant documentation file
- Look for examples in the codebase
- Review similar implementations
- Ask teammates

---

## 📝 Documentation Updates

These docs are living documents. If you find:
- ❌ Outdated information
- ❌ Missing examples
- ❌ Unclear explanations
- ❌ Broken references

Please update the relevant file to help future team members!

---

## 🎓 Learning Path

```
Start Here
    ↓
Getting Started (setup & run)
    ↓
Project Structure (understand organization)
    ↓
Architecture (learn design patterns)
    ↓
State Management (master Riverpod)
    ↓
Theme System (customize UI)
    ↓
API Integration (connect backends)
    ↓
Conventions (write better code)
    ↓
Advanced Topics (specific features)
```

---

## 📊 Documentation Statistics

| Document | Pages | Topics | Examples |
|----------|-------|--------|----------|
| Getting Started | 2 | 8 | 3 |
| Architecture | 5 | 12 | 5 |
| Project Structure | 4 | 10 | 3 |
| State Management | 6 | 15 | 7 |
| Theme System | 7 | 14 | 5 |
| API Integration | 6 | 12 | 4 |
| Conventions | 8 | 20 | 15 |
| **Total** | **38** | **91** | **42** |

---

## 🎯 Next Steps

**First time here?**
1. Start with [Getting Started](./GettingStarted.md)
2. Setup the project
3. Run the app
4. Read [Project Structure](./ProjectStructure.md)

**Assigned a feature?**
1. Read [Architecture](./Architecture.md)
2. Check [Project Structure](./ProjectStructure.md) for similar features
3. Reference [State Management](./StateManagement.md) for provider patterns
4. Use [Theme System](./Theme.md) for UI
5. Follow [Conventions](./Conventions.md) for code quality

**Debugging an issue?**
1. Read [Getting Started - Debugging Tips](./GettingStarted.md#debugging-tips)
2. Check [Architecture - Dependency Flow](./Architecture.md#dependency-flow)
3. Review [Conventions - Error Handling](./Conventions.md#error-handling)

---

**Welcome to the project! 🚀**

Happy coding! If you have questions, refer to the relevant documentation or ask your teammates.

Last updated: 2026
