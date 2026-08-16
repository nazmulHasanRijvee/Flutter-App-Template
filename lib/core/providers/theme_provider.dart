import 'package:flutter/material.dart';
import 'package:flutter_app_template/data/services/cache/cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    return await _loadTheme();
  }

  ThemeMode get themeMode => state.value ?? ThemeMode.system;

  List<ThemeMode> get supportedThemes => ThemeMode.values;

  Future<void> changeTheme(ThemeMode newTheme) async {
    state = AsyncValue.data(newTheme);
    await _saveTheme(newTheme);
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    final cacheService = ref.read(cacheServiceProvider);
    await cacheService.save<String>(CacheKey.themeMode, themeMode.name);
  }

  Future<ThemeMode> _loadTheme() async {
    final cacheService = ref.read(cacheServiceProvider);
    final String? themeMode = cacheService.get<String>(CacheKey.themeMode);
    if (themeMode != null) {
      return ThemeMode.values.firstWhere(
        (element) => element.name == themeMode,
        orElse: () => ThemeMode.system,
      );
    }
    return ThemeMode.system;
  }
}

final themeProvider = AsyncNotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
