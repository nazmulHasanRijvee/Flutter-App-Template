import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template/src/data/services/cache/cache_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base/crash_reporter.dart';
import 'base/initialize_crash_reporting.dart';
import 'logger/riverpod_log.dart';

Future<ProviderContainer> bootstrap() async {
  /// 1. initialize Firebase
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();

  /// 2. Build container with overrides
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    retry: (retryCount, error) => null,
    observers: [RiverpodObserver()],
  );

  /// 3. Update crash reporting to the fully resolved provider
  /// In debug mode: log to console. In release/profile mode: report to Firebase Crashlytics.
  ///
  ///  Avoid autoDispose on Providers Read Only During Startup
  initializeCrashReporting(container.read(crashReporterProvider));

  return container;
}
