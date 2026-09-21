# Theming

Theme configuration lives under `lib/src/presentation/core/theme/`.

## Theme data

The template builds separate light and dark `ThemeData` objects. Each theme registers extensions for:

- colors
- text styles
- dimensions, including spacing, sizes, and radii

Use the `BuildContext` extensions from `theme.dart` in widgets:

```dart
Container(
  color: context.color.primary,
  padding: EdgeInsets.all(context.spacing.md),
  child: Text('Example', style: context.textStyle.bodyMedium),
)
```

The exact extension properties are defined in `theme_extensions/`. Add new shared tokens there rather than scattering raw values through feature widgets.

## Theme mode

`themeModeProvider` loads the saved mode from `CacheService` and defaults to `ThemeMode.system`. Calling `changeTheme` updates the provider immediately and persists the selected mode.

`MyApp` passes the mode to `MaterialApp.router` together with `lightTheme` and `darkTheme`.

## Responsive sizing

`ScreenUtilInit` uses a design size of `375 x 812` and enables text adaptation. Use the project’s existing ScreenUtil conventions when a dimension should respond to screen size, and use theme dimensions for semantic spacing and component sizes.

## Adding theme tokens

1. Add the primitive or semantic value to the relevant theme extension.
2. Register it in both light and dark theme data when necessary.
3. Expose it through the context extension if that improves readability.
4. Use it in widgets instead of duplicating a literal value.
5. Check both theme modes on a representative screen.
