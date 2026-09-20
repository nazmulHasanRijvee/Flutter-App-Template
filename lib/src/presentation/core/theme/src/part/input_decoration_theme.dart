part of '../theme_data.dart';

class _InputDecorationLightTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final BorderRadius borderRadius = BorderRadius.circular(
      dimensions.radius.md,
    );

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: lightColor.text.secondary),
      filled: true,
      fillColor: lightColor.textFieldFillColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.md,
        horizontal: dimensions.spacing.lg,
      ),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: lightColor.textFieldBorderColor,
          width: dimensions.spacing.xxs,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: lightColor.textFieldFocusBorderColor,
          width: dimensions.spacing.xxs,
        ),
      ),

      suffixIconColor: lightColor.icon,
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: lightColor.border.withValues(alpha: 0.5),
          width: dimensions.spacing.xxs,
        ),
      ),
    );
  }
}

class _InputDecorationDarkTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final BorderRadius borderRadius = BorderRadius.circular(
      dimensions.radius.xs,
    );

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: darkColor.text.secondary),
      filled: true,
      fillColor: darkColor.scaffoldBackground,
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.md,
        horizontal: dimensions.spacing.lg,
      ),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: darkColor.border,
          width: dimensions.spacing.xxs,
        ),
      ),
      suffixIconColor: darkColor.icon,
      disabledBorder: OutlineInputBorder(borderRadius: borderRadius),
    );
  }
}
