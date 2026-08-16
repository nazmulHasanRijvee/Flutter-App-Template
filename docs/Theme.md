# Theme System Guide

This guide explains how the theme system works in this project and how to use it effectively. The theme system is built on Flutter's `ThemeExtension<T>` and custom Dart extensions for easy access.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Components](#components)
- [How to Use](#how-to-use)
- [Adding Custom Themes](#adding-custom-themes)
- [Examples](#examples)
- [Best Practices](#best-practices)

## Overview

The theme system provides:
- ✅ **Light & Dark Theme Support**: Automatic theme switching
- ✅ **Type-Safe Access**: No magic strings, fully typed
- ✅ **Centralized Styling**: Single source of truth for all styles
- ✅ **Easy Customization**: Simple to modify or extend
- ✅ **Performance**: Optimized with extensions and const classes
- ✅ **Theme Persistence**: Theme preference saved to device

## Architecture

### How It Works

```
ThemeData
  ├── extensions: [
  │   ├── ColorExtension (LightColorExtension or DarkColorExtension)
  │   ├── TextStyleExtension
  │   └── Dimensions
  └── ...other theme properties
```

The theme system uses Flutter's `ThemeExtension<T>` mechanism to add custom theme data to the standard `ThemeData`. This allows accessing theme values through a clean, type-safe API.

### The Connection Flow

```
BuildContext
    │
    ├──→ Theme.of(context) ──→ ThemeData
    │                             │
    │                             ├──→ extension<ColorExtension>()
    │                             ├──→ extension<TextStyleExtension>()
    │                             └──→ extension<Dimensions>()
    │
    └──→ context.color ──→ ThemeExtension on BuildContext
        context.textStyle     (Direct access via getters)
        context.dimensions
```

## Components

### 1. ThemeExtension<T>

The base class that all custom theme extensions inherit from:

```dart
abstract class ThemeExtension<T extends ThemeExtension<T>> {
  /// Create a copy of the extension with optional new values
  T copyWith();
  
  /// Interpolate between two extensions (for animations)
  T lerp(T? other, double t);
}
```

### 2. ColorExtension

Defines all colors used in the app:

```dart
class LightColorExtension extends ColorExtension {
  const LightColorExtension();
  
  // Primary colors
  final Color primary = const Color(0xFF6200EE);
  final Color secondary = const Color(0xFF03DAC6);
  
  // Status colors
  final Color error = const Color(0xFFB3261E);
  final Color warning = const Color(0xFFF9A825);
  final Color success = const Color(0xFF2E7D32);
  
  // Surface colors
  final Color background = const Color(0xFFFFFFFF);
  final Color surface = const Color(0xFFF5F5F5);
  
  // Other colors
  final Color border = const Color(0xFFE0E0E0);
  final Color icon = const Color(0xFF424242);
}

class DarkColorExtension extends ColorExtension {
  const DarkColorExtension();
  
  final Color primary = const Color(0xFFBB86FC);
  final Color secondary = const Color(0xFF03DAC6);
  // ... rest of dark colors
}
```

**Access in widgets:**
```dart
context.color.primary      // Color based on current theme
context.color.error        // Error color
context.color.background   // Background color
```

### 3. TextStyleExtension

Defines all text styles used in the app (using Google Fonts):

```dart
class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();
  
  // Heading styles
  TextStyle get headLineLarge => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.40,
  );
  
  TextStyle get headLineMedium => GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  // Body styles
  TextStyle get bodyLarge => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  
  TextStyle get bodyMedium => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  
  // Label styles (with letter spacing)
  TextStyle get labelLarge => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
  );
}
```

**Text style hierarchy:**
- `headLine*` - For titles and headers
- `body*` - For main content and paragraphs
- `label*` - For labels and small text with emphasis

**Access in widgets:**
```dart
Text('Hello', style: context.textStyle.headLineLarge)
Text('Description', style: context.textStyle.bodyMedium)
Button(text: 'Click Me', style: context.textStyle.labelMedium)
```

### 4. Dimensions

Defines all spacing, padding, margin, and border radius:

```dart
class Dimensions extends ThemeExtension<Dimensions> {
  const Dimensions();
  
  final spacing = const AppSpacing();   // s1, s2, s4, s8, s16, s24, ...
  final padding = const AppPadding();   // p4, p8, p12, p16, p20, p24
  final margin = const AppMargin();     // m6
  final radius = const AppRadius();     // r4, r6, r10, r12, r16, ...
}

class AppSpacing {
  const AppSpacing();
  
  final double s1 = 1;
  final double s2 = 2;
  final double s4 = 4;
  final double s8 = 8;
  final double s12 = 12;
  final double s16 = 16;
  final double s24 = 24;
  final double s32 = 32;
  // ... more spacing values
}

class AppPadding {
  const AppPadding();
  
  final double p4 = 4;
  final double p8 = 8;
  final double p12 = 12;
  final double p16 = 16;
  final double p20 = 20;
  final double p24 = 24;
}

class AppRadius {
  const AppRadius();
  
  final double r4 = 4;
  final double r6 = 6;
  final double r8 = 8;
  final double r12 = 12;
  final double r16 = 16;
}
```

**Access spacing:**
```dart
SizedBox(
  height: context.spacing.s16,    // 16px height
  width: context.spacing.s32,     // 32px width
)

Padding(
  padding: EdgeInsets.all(context.padding.p16),  // 16px padding
)

BorderRadius.circular(context.radius.r12)  // 12px radius
```

### 5. BuildContextExtension

Custom extension on `BuildContext` for convenient theme access:

```dart
extension ThemeDataExtension on BuildContext {
  /// Get the current color extension (light or dark)
  ColorExtension get color { ... }
  
  /// Get the text style extension
  TextStyleExtension get textStyle { ... }
  
  /// Get the dimensions extension
  Dimensions get dimensions { ... }
  
  /// Shortcut to spacing
  AppSpacing get spacing => dimensions.spacing;
}
```

This extension makes it easy to access theme properties without verbose code.

## How to Use

### 1. Accessing Colors

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.primary,
      child: Text(
        'Hello',
        style: TextStyle(color: context.color.onPrimary),
      ),
    );
  }
}
```

### 2. Accessing Text Styles

```dart
class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Welcome',
      style: context.textStyle.headingLarge,
    );
  }
}
```

### 3. Using Dimensions for Spacing

```dart
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.s16),
      margin: EdgeInsets.all(context.spacing.s8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius.r12),
        color: context.color.surface,
      ),
      child: Column(
        children: [
          SizedBox(height: context.spacing.s12),
          Text('Card Content', style: context.textStyle.bodyMedium),
        ],
      ),
    );
  }
}
```

### 4. Combined Theme Usage

```dart
class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.s16),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(context.radius.r12),
        border: Border.all(color: context.color.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'John Doe',
            style: context.textStyle.headingSmall
                .copyWith(color: context.color.primary),
          ),
          SizedBox(height: context.spacing.s8),
          Text(
            'john@example.com',
            style: context.textStyle.bodyMedium
                .copyWith(color: context.color.secondary),
          ),
        ],
      ),
    );
  }
}
```

## Adding Custom Themes

### Step 1: Define Your Colors

Edit `lib/core/static/theme/src/theme_extensions/src/colors/colors.dart`:

```dart
class LightColorExtension extends ColorExtension {
  const LightColorExtension();
  
  // ... existing colors ...
  
  // Add your custom color
  final Color customColor = const Color(0xFF123456);
}

class DarkColorExtension extends ColorExtension {
  const DarkColorExtension();
  
  // ... existing colors ...
  
  // Add your custom color for dark theme
  final Color customColor = const Color(0xFFABCDEF);
}
```

### Step 2: Define Your Text Styles

Edit `lib/core/static/theme/src/theme_extensions/src/text_style.dart`:

```dart
class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();
  
  // ... existing styles ...
  
  // Add your custom text style
  TextStyle get customStyle => GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
```

### Step 3: Add Dimensions

Edit `lib/core/static/theme/src/theme_extensions/src/dimensions.dart`:

```dart
class Dimensions extends ThemeExtension<Dimensions> {
  const Dimensions();
  
  static const double _v48 = 48;  // Add constant
  
  // Access via context.spacing.s48
}
```

### Step 4: Use in Your Widget

```dart
Text(
  'Custom Text',
  style: context.textStyle.customStyle.copyWith(
    color: context.color.customColor,
  ),
)
```

## Examples

### Example 1: Complete Button Widget

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.s16,
        vertical: context.spacing.s12,
      ),
      decoration: BoxDecoration(
        color: context.color.primary,
        borderRadius: BorderRadius.circular(context.radius.r8),
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(context.color.onPrimary),
              )
            : Text(
                label,
                style: context.textStyle.labelLarge.copyWith(
                  color: context.color.onPrimary,
                ),
              ),
      ),
    );
  }
}
```

### Example 2: Dialog Widget

```dart
showDialog(
  context: context,
  builder: (context) => Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.radius.r16),
    ),
    child: Padding(
      padding: EdgeInsets.all(context.spacing.s24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Title',
            style: context.textStyle.headingMedium
                .copyWith(color: context.color.primary),
          ),
          SizedBox(height: context.spacing.s16),
          Text(
            'Message',
            style: context.textStyle.bodyMedium
                .copyWith(color: context.color.secondary),
          ),
          SizedBox(height: context.spacing.s24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    ),
  ),
);
```

### Example 3: Responsive Card

```dart
class ResponsiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final isTablet = context.isTablet;  // From ContextEx extension
    
    return Container(
      padding: EdgeInsets.all(isTablet ? spacing.s24 : spacing.s16),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: BorderRadius.circular(context.radius.r12),
        boxShadow: [
          BoxShadow(
            color: context.color.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Responsive Card',
            style: context.textStyle.headingSmall,
          ),
          SizedBox(height: spacing.s16),
          Text(
            'This card adapts to tablet and mobile sizes',
            style: context.textStyle.bodyMedium,
          ),
        ],
      ),
    );
  }
}
```

## Best Practices

### ✅ DO:

1. **Always use theme values**, never hardcode colors or spacing
   ```dart
   // ✅ Good
   Container(color: context.color.primary)
   
   // ❌ Bad
   Container(color: Color(0xFF6200EE))
   ```

2. **Use appropriate text styles** for hierarchy
   ```dart
   // ✅ Good
   Text('Title', style: context.textStyle.headingLarge)
   Text('Body', style: context.textStyle.bodyMedium)
   
   // ❌ Bad
   Text('Title', style: TextStyle(fontSize: 24))
   ```

3. **Leverage dimensions for consistency**
   ```dart
   // ✅ Good
   Padding(
     padding: EdgeInsets.all(context.spacing.s16),
     child: child,
   )
   
   // ❌ Bad
   Padding(
     padding: EdgeInsets.all(16),
     child: child,
   )
   ```

4. **Compose text styles** when you need variations using **`.copyWith()`**
   ```dart
   // ✅ Good
   Text(
     'Hello',
     style: context.textStyle.headingLarge.copyWith(
       color: context.color.error,
     ),
   )
   ```

5. **Test with both themes** (light and dark)
   ```dart
   // Test appearance in both themes during development
   ```

### ❌ DON'T:

1. **Hardcode dimensions**
   ```dart
   // ❌ Avoid
   SizedBox(height: 16, width: 32)
   ```

2. **Create duplicate colors**
   ```dart
   // ❌ Avoid
   Color myColor = Color(0xFF123456);  // Not in theme
   ```

3. **Mix theme and non-theme values**
   ```dart
   // ❌ Avoid
   Column(
     children: [
       Text('Title', style: context.textStyle.headingLarge),
       SizedBox(height: 16),  // Should use context.spacing.s16
     ],
   )
   ```

4. **Access theme inside const constructors**
   ```dart
   // ❌ Bad - Can't use context in const constructor
   const MyWidget(color: context.color.primary)
   
   // ✅ Good
   MyWidget(color: context.color.primary)
   ```

## Theme Persistence

The theme preference is saved to the device and restored on app launch:

```dart
// Changing theme (saved automatically)
ref.read(themeProvider.notifier).changeTheme(ThemeMode.dark);

// Theme is persisted via SharedPreferences
// On app restart, the saved theme will be restored
```

## Troubleshooting

### Issue: "Ensure ColorExtension is added to ThemeData.extensions"

**Cause**: The theme extension is not registered in `ThemeData`.

**Solution**: Check `lib/core/static/theme/src/theme_data.dart` and ensure extensions are added:
```dart
ThemeData(
  extensions: <ThemeExtension<dynamic>>[
    lightColor,      // ← Must be included
    textStyle,       // ← Must be included
    dimensions,      // ← Must be included
  ],
)
```

### Issue: Colors don't change when switching themes

**Cause**: Widget is not rebuilding when theme changes.

**Solution**: Use `ConsumerWidget` if using Riverpod:
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeProvider);  // Watch theme changes
    return Container(
      color: context.color.primary,
    );
  }
}
```

---

**Need help?** Check the [Architecture Guide](./Architecture.md) or [Riverpod Documentation](https://riverpod.dev)
