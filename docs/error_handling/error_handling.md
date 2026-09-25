# Error Handling & Crash Reporting

The template decouples error capturing from delivery mechanisms using a modular `CrashReporter` interface.

---

## 1. Global Error Handlers

In `lib/src/core/base/initialize_crash_reporting.dart`, top-level hooks catch unhandled errors:

- **`FlutterError.onError`**: Captures UI framework errors occurring during widget build, layout, and render phases.
- **`PlatformDispatcher.instance.onError`**: Captures uncaught asynchronous errors and native platform dispatcher faults.

---

## 2. Active Crash Reporters

- **`LoggingCrashReporter` (Active)**: Formats and forwards all crashes to `AppLogger.error()`. Verbose in debug builds; strictly error-level in release builds.
- **`FirebaseCrashReporter` (Integration Ready)**: Prepared stub for Firebase Crashlytics. Can be activated once Firebase CLI configuration is executed.

---

## 3. Network Error Boundary (`Api.call`)

Network transport exceptions are caught and sanitized by `Api.call`:
- Decodes `DioException` error responses.
- Extracts user-friendly backend messages if returned by the server.
- Sanitizes payload to ensure authorization tokens or passwords are never logged.
- Passes clean error strings to the UI callback (`onError`).
