import 'package:flutter/foundation.dart';
import 'package:flutter_app_template/src/core/logger/app_logger.dart';


part "reporters/logging_crash_reporter.dart";
part "reporters/firebase_crashlytics_reporter.dart";

/// Reports caught errors through an injected, testable crash service.
///
/// Replace the implementation to connect Crashlytics, Sentry, or another
/// telemetry service.
abstract interface class CrashReporter {
  void recordFlutterError(FlutterErrorDetails details,{ bool fatal = false});
  void recordError(dynamic message, Object error, StackTrace? stackTrace);
}
