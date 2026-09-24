import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/src/data/services/cache/cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  ThemeMode get themeMode => state;

  List<ThemeMode> get supportedThemes => ThemeMode.values;

  Future<void> changeTheme(ThemeMode newTheme) async {
    state = newTheme;
    await _saveTheme(newTheme);
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.save<String>(CacheKey.themeMode, themeMode.name);
  }

  Future<void> setCurrentThemeMode() async {
    final cacheService = ref.read(cacheServiceProvider);
    final String? themeMode = cacheService.get<String>(CacheKey.themeMode);
    if (themeMode != null) {
      state = ThemeMode.values.firstWhere(
        (element) => element.name == themeMode,
        orElse: () => ThemeMode.system,
      );
    }
    state = ThemeMode.system;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
