import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template/src/core/initialize_crash_reporting.dart';
import 'package:flutter_app_template/src/core/logger/app_logger.dart';

Future<void> bootstrap(VoidCallback onRun) async {
  await initializeCrashReporting();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runZonedGuarded(onRun, (error, stackTrace) {
    AppLogger.error(
      'Uncaught zone error: $error',
      error: error,
      stackTrace: stackTrace,
    );
  });
}
