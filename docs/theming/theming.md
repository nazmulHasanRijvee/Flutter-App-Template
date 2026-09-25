# UI & Theming System

The design and theming system is located in `lib/src/presentation/core/theme/` and uses custom `ThemeExtension` classes, `flutter_screenutil` for responsive scaling, and a reactive `ThemeMode` notifier.

---

## 1. Theme Extensions & Semantic Tokens

Instead of hardcoding color hexes or ad-hoc margins, theme tokens are encapsulated in type-safe theme extensions:

- **AppColorsExtension**: Semantic colors (`primary`, `surface`, `background`, `error`, `textPrimary`, etc.) for light and dark modes.
- **AppTypographyExtension**: Pre-configured text styles conforming to the project typography hierarchy.
- **AppDimensionsExtension**: Spacing tokens (`xs`, `sm`, `md`, `lg`, `xl`), border radii, and icon sizes.

### Usage in Widgets:
```dart
Container(
  color: context.color.primary,
  padding: EdgeInsets.all(context.spacing.md),
  child: Text(
    'Dashboard',
    style: context.textStyle.headlineMedium,
  ),
)
```

---

## 2. Dynamic Theme Mode Switching

- `themeModeProvider` manages `ThemeMode` state (`system`, `light`, `dark`).
- Persisted to disk via `CacheService` (`CacheKey.themeMode`).
- `MaterialApp.router` in `app.dart` listens to `themeModeProvider` to switch themes smoothly at runtime.

---

## 3. Responsive Screen Scaling

`flutter_screenutil` is initialized in `app.dart` with a standard base design viewport:
```dart
ScreenUtilInit(
  designSize: const Size(375, 812),
  minTextAdapt: true,
  splitScreenMode: true,
  ...
)
```

Use `.w`, `.h`, `.r`, and `.sp` extensions where layout elements need proportional scaling across various device sizes.
