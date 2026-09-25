import 'package:flutter/foundation.dart';
import 'package:flutter_app_template/src/core/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part "reporters/logging_crash_reporter.dart";
part "reporters/firebase_crashlytics_reporter.dart";

/// Reports caught errors through an injected, testable crash service.
///
/// Replace the implementation to connect Crashlytics, Sentry, or another
/// telemetry service.
abstract interface class CrashReporter {
  void recordFlutterError(FlutterErrorDetails details, {bool fatal = false});
  void recordError(dynamic message, Object error, StackTrace? stackTrace);
}

/// Create a Provder of [CrashReporter] for Singleton pattern & centralized crash reporting
/// for the entire app. But Provider for [Api] is needed too for Dependency injection of
/// [crashReporterProvider], then ref.read(apiProvider).call(...) instead of static Api.call())
///
/// NOTE: Make sure autoDispose is disabled if using Riverpod code generation
final crashReporterProvider = Provider<CrashReporter>((ref) {
  return kDebugMode ? LoggingCrashReporter() : FirebaseCrashReporter();
});
