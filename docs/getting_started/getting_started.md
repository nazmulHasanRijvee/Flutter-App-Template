# Getting Started

## Prerequisites

Install Flutter with a Dart SDK compatible with the constraint in `pubspec.yaml` (`^3.12.2`). Then verify your environment:

```bash
flutter doctor
```

## Installation & Setup

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd flutter_app_template
   ```

2. Fetch Flutter packages:
   ```bash
   flutter pub get
   ```

3. Run the development build:
   ```bash
   flutter run --dart-define-from-file=env/dev.json
   ```

## Environment Configuration

Environment values are provided at compile time using `--dart-define` or `--dart-define-from-file`.

Example `env/dev.json`:
```json
{
  "BASE_URL": "http://10.10.10.3:5000/api",
  "COMMUNITY_URL": "http://api.mercy.kodevio.com"
}
```

> [!NOTE]
> For an Android emulator, replace `localhost` with `10.0.2.2`. For physical devices, use your computer's local LAN IP (e.g. `192.168.x.x`). Do **not** commit runtime secrets to environment JSON files.

## Code Generation (Build Runner)

When updating Retrofit API interfaces or static asset files, regenerate the code using:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch mode for continuous generation during development:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Quality Assurance & Verification

Always run the following commands before committing changes:

```bash
# 1. Format code
dart format lib test

# 2. Analyze code for linting issues
flutter analyze

# 3. Run unit and widget tests
flutter test
```

## Production / Release Builds

Pass production endpoint values when generating release binaries:

```bash
# Android APK
flutter build apk --release --dart-define=BASE_URL=https://api.example.com

# iOS
flutter build ios --release --dart-define=BASE_URL=https://api.example.com

# Web
flutter build web --release --dart-define=BASE_URL=https://api.example.com
```
