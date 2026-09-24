part of "../crash_reporter.dart";

/// Default reporter that writes crash details to the application logger.
class LoggingCrashReporter implements CrashReporter {
  const LoggingCrashReporter();

  @override
  void recordFlutterError(FlutterErrorDetails details,{ bool fatal = false}) {
    AppLogger.fatal(details.exceptionAsString(),error: details.exception, stackTrace: details.stack);
  }

  @override
  void recordError(dynamic message, Object error, StackTrace? stackTrace, {bool fatal = false}) {
    AppLogger.error('CrashReporter: $message', error: error, stackTrace: stackTrace);
  }
}
