part of '../theme_data.dart';

class _InputDecorationLightTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final BorderRadius borderRadius = BorderRadius.circular(
      dimensions.radius.r10,
    );

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: lightColor.text.secondary),
      filled: true,
      fillColor: lightColor.textFieldFillColor,
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.s12,
        horizontal: dimensions.spacing.s16,
      ),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: lightColor.textFieldBorderColor,
          width: dimensions.spacing.s2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: lightColor.textFieldFocusBorderColor,
          width: dimensions.spacing.s2,
        ),
      ),

      suffixIconColor: lightColor.icon,
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: lightColor.border.withValues(alpha: 0.5),
          width: dimensions.spacing.s2,
        ),
      ),
    );
  }
}

class _InputDecorationDarkTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final BorderRadius borderRadius = BorderRadius.circular(
      dimensions.radius.r6,
    );

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: darkColor.text.secondary),
      filled: true,
      fillColor: darkColor.scaffoldBackground,
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.spacing.s12,
        horizontal: dimensions.spacing.s16,
      ),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: darkColor.border,
          width: dimensions.spacing.s1,
        ),
      ),
      suffixIconColor: darkColor.icon,
      disabledBorder: OutlineInputBorder(borderRadius: borderRadius),
    );
  }
}
