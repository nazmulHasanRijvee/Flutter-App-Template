# Getting started

## Prerequisites

Install Flutter with a Dart SDK compatible with the constraint in `pubspec.yaml` (`^3.12.2`). Then verify the installation:

```bash
flutter doctor
```

## Install and run

```bash
flutter pub get
flutter run --dart-define-from-file=env/dev.json
```

`env/dev.json` contains the development values used by `Endpoints`:

```json
{
  "BASE_URL": "http://10.10.10.3:5000/api",
  "COMMUNITY_URL": "http://api.mercy.kodevio.com"
}
```

Replace these values with hosts reachable from the selected device. For an Android emulator, a host machine may need an emulator-specific address such as `10.0.2.2`; use the address appropriate for your setup.

Do not commit secrets to an environment JSON file. These values are compile-time defines, not secure storage.

## Generated files

After changing Retrofit annotations or asset configuration, regenerate code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

The project currently uses generated Retrofit code in `lib/src/data/services/network/rest_client.g.dart` and generated asset references in `lib/src/core/gen/assets.gen.dart`.

## Verify a change

```bash
dart format lib test
flutter analyze
flutter test
```

The default widget test is still a starter smoke test. Replace it with tests for the real application behavior as features are implemented.

## Release builds

Pass production values explicitly when building:

```bash
flutter build apk --release --dart-define=BASE_URL=https://api.example.com
flutter build ios --release --dart-define=BASE_URL=https://api.example.com
flutter build web --release --dart-define=BASE_URL=https://api.example.com
```

Add any additional defines required by your backend. Firebase Crashlytics is not enabled in the current dependency graph.
