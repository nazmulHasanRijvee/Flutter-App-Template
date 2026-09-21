import 'package:flutter/foundation.dart';
import 'package:flutter_app_template/src/core/base/crash_reporter.dart';

Future<void> initializeCrashReporting(CrashReporter reporter) async {

  /// Handles errors raised by Flutter during build, layout, or painting.
  FlutterError.onError = (details) {
    reporter.recordFlutterError(details, fatal: true);
  };

  /// Handles uncaught asynchronous and platform errors.
  PlatformDispatcher.instance.onError = (error, stack) {
    
    reporter.recordError('Uncaught async error', error, stack);

    return true; // Mark the error as handled to prevent duplicate logging.
  };
}
