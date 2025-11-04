# Repository Guidelines

## Project Structure & Module Organization
Flutter code lives in `lib/` with feature layers: `model/` (data classes + generated `*.g.dart`), `network/` (Firebase + REST clients), `viewmodel/` (state), `view/` (widgets), and `util/` (shared helpers). `lib/main.dart` is the entry point and `firebase_options.dart` stores environment config. Tests sit in `test/`; add peers using `<feature>_test.dart`. Platform folders (`android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/`) and assets (`AppIcon.appiconset/`, `font/`, `bib_json/`) stay checked in for tooling.

## Build, Test, and Development Commands
Run `flutter pub get` after dependency changes. Regenerate JSON serializers with `dart run build_runner build --delete-conflicting-outputs`. Use `flutter analyze` to surface lints, `flutter test` for unit/widget suites, and `flutter run -d <device_id>` when iterating on a target. Ship builds via `flutter build apk --release` or the matching platform command.

## Coding Style & Naming Conventions
Keep Dart’s two-space indentation and prefer single quotes unless interpolation is cleaner. Follow the active `flutter_lints`; resolve warnings instead of sprinkling `ignore`. Continue the existing PascalCase file names for widgets (`MainView.dart`) and lowerCamelCase for members. Extract reusable UI into widgets and keep secrets out of source control.

## Testing Guidelines
Add focused tests for any new view, provider, or service: name files `<feature>_test.dart` and group cases with `group()` for readability. Use `testWidgets` for UI contracts and prefer fakes or `mockito` when isolating Firebase and HTTP layers. Check coverage with `flutter test --coverage` before opening a review.

## Commit & Pull Request Guidelines
Recent history favors short, present-tense commits (for example, "폰트 재설정"). Stay under ~60 characters, lead with a verb, and include an English gloss when changes affect shared flows. Pull requests must describe scope, testing performed, links to tasks or issues, and UI screenshots when visuals shift. Call out migrations (Firebase, assets, generated code) so reviewers can re-run `flutter pub get`, `build_runner`, or `flutterfire configure`.

## Assets & Configuration Tips
Declare new fonts or scripture JSON files in `pubspec.yaml` and mirror directory casing. After tweaking splash or icons, rerun `flutter pub run flutter_native_splash:create` and commit the regenerated assets. Keep Firebase credentials in the console; rely on `lib/firebase_options.dart` and environment-specific secret management rather than committing `.env` files.
