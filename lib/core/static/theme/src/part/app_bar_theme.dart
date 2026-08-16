part of '../theme_data.dart';

class _AppBarLightTheme with ThemeExtensions {
  AppBarTheme call() {
    return AppBarTheme(
      elevation: 1,
      titleSpacing: 0,
      centerTitle: true,
      backgroundColor: lightColor.appBar.background,
      surfaceTintColor: lightColor.appBar.surfaceTint,
      titleTextStyle: textStyle.headLineSmall.copyWith(
        color: lightColor.text.primary,
      ),
      iconTheme: IconThemeData(color: lightColor.appBar.icon),
    );
  }
}

class _AppBarDarkTheme with ThemeExtensions {
  AppBarTheme call() {
    return AppBarTheme(
      elevation: 1,
      titleSpacing: 0,
      centerTitle: true,
      backgroundColor: darkColor.appBar.background,
      surfaceTintColor: darkColor.appBar.surfaceTint,
      titleTextStyle: textStyle.headLineSmall.copyWith(
        color: darkColor.text.primary,
      ),
      iconTheme: IconThemeData(color: darkColor.appBar.icon),
    );
  }
}
