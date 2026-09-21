# Error handling and reporting

The template separates error capture from error delivery through the `CrashReporter` interface.

## Global handlers

`initializeCrashReporting` installs:

- `FlutterError.onError` for framework errors during build, layout, and paint
- `PlatformDispatcher.instance.onError` for uncaught asynchronous and platform errors

The active reporter is registered in `bootstrap.dart` before the app starts.

## Current reporter

The active implementation is `LoggingCrashReporter`. It writes errors to `AppLogger`. The logger is verbose in debug mode and restricts production logs to error-level output.

This means the current project has local error logging, not a remote crash dashboard.

## Firebase readiness

`FirebaseCrashReporter` contains a placeholder implementation for a future Crashlytics integration. Firebase dependencies, generated Firebase options, initialization, and reporter selection are not enabled in the current project.

When enabling it, complete all of these steps together:

1. Add the Firebase packages to `pubspec.yaml`.
2. Run `flutterfire configure` and add the generated options.
3. Initialize Firebase before crash reporting in `bootstrap.dart`.
4. Select the Firebase reporter for the intended build modes.
5. Verify non-fatal, fatal, Flutter, and uncaught async errors in a controlled environment.

## API errors

Network failures are handled at the `Api.call` boundary. Transport errors are logged with request and response context, then reduced to a user-facing message through the `onError` callback. Feature code should present that message without exposing raw tokens or sensitive request data.

## Reporting guidelines

- Include the original error and stack trace when logging.
- Avoid logging access tokens, passwords, or personal data.
- Convert backend errors into clear user-facing messages at the feature boundary.
- Add tests for expected failures instead of relying only on global handlers.
