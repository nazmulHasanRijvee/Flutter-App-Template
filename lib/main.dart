import 'package:flutter_app_template/src/core/bootstrap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_app_template/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/logger/riverpod_log.dart';
import 'src/data/services/cache/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await bootstrap(() {
    runApp(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        observers: [RiverpodObserver()],
        child: const MyApp(),
      ),
    );
  });
}
