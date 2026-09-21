import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template/src/core/base/crash_reporter.dart';
import 'package:flutter_app_template/src/core/base/initialize_crash_reporting.dart';

Future<void> bootstrap(VoidCallback onRun) async {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );

  // In debug mode: log to console. In release/profile mode: report to Firebase Crashlytics.
  // late final CrashReporter reporter;
  // if (kDebugMode) {
  //   reporter = const LoggingCrashReporter();
  // } else {
  //   reporter = const FirebaseCrashReporter();
  // }

  await initializeCrashReporting(const LoggingCrashReporter());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  onRun();
}
