part of '../crash_reporter.dart';

/// Reporter for sending errors to Firebase Crashlytics.
///
/// Add the Firebase packages and run `flutterfire configure` to enable it.
class FirebaseCrashReporter implements CrashReporter {
  const FirebaseCrashReporter();

  // final _crashlytics = FirebaseCrashlytics.instance;

  @override
  void recordFlutterError(FlutterErrorDetails details, {bool fatal = false}) {
    // _crashlytics.recordFlutterError(
    //  details,
    //  fatal: fatal
    // );
  }

  @override
  void recordError(dynamic message, Object error, StackTrace? stackTrace) {
    // _crashlytics.recordError(
    //   error,
    //   stackTrace,
    //   reason: message,
    // );
  }
}
