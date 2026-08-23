part of '../theme_data.dart';

class _CheckboxTheme with ThemeExtensions {
  CheckboxThemeData call() {
    return CheckboxThemeData(
      side: BorderSide(width: dimensions.spacing.xxs, color: lightColor.border),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimensions.radius.xs),
      ),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColor.primary;
        }
        return lightColor.scaffoldBackground;
      }),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return lightColor.onPrimary;
        }
        return lightColor.border;
      }),
    );
  }
}
