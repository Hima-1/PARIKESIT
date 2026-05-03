# Agent Instructions for Parikesit Flutter

You are an AI coding agent working on the **Parikesit** Flutter project. This is a "Lean and Mean" Android-only application focused on statistics (inspired by BPS).

## 1. Development Commands

| Task | Command |
|------|---------|
| Get Dependencies | `flutter pub get` |
| Static Analysis | `flutter analyze` |
| Run All Tests | `flutter test` |
| Run Single Test | `flutter test test/path/to/file_test.dart` |
| Run Single Test by Name | `flutter test --plain-name "test name pattern"` |
| Run Integration Tests | `flutter test integration_test` |
| Build Android APK | `flutter build apk --split-per-abi` |

**Integration test guardrails:**
- Run on Android device/emulator (`-d <android_device_id>`), not desktop/web.
- Ensure Laravel backend is up and reachable by the selected device.
- Provide API target explicitly with `--dart-define=API_BASE_URL=...`.

**Note:** This project uses an optimized `build_runner` for data models. Always ensure `build.yaml` is configured to only scan `domain` or `models` directories to maintain fast build times.

## 2. Code Style & Conventions

### Architecture: Feature-First
Follow the established directory structure:
- `lib/core/`: Cross-cutting concerns (api, local storage, router, theme).
- `lib/features/`: Domain-specific features (auth, home). Each feature contains:
  - `data/`: Repositories and data sources.
  - `domain/`: Entities and models (using `freezed` and `json_serializable`).
  - `presentation/`: Controllers (Riverpod) and UI widgets.

### State Management: Riverpod
- Use `AsyncNotifier` or `Notifier` for logic.
- Access providers via `ConsumerWidget` or `ConsumerStatefulWidget`.
- Avoid `setState` for logic that should be shared or persisted.

### Networking: Dio
- Use the central `apiClientProvider` in `lib/core/api/`.
- Authenticated requests are handled via `AuthInterceptor`.

### Local Storage: Hive & Secure Storage
- Use `hive` for general data caching.
- Use `flutter_secure_storage` exclusively for sensitive tokens.

### JSON Parsing
- Use `freezed` and `json_serializable` for data models in `domain` folders.
- Run `dart run build_runner build --delete-conflicting-outputs` when models change.
- Keep the build scope restricted via `build.yaml`.

### Testing
- Use **Mocktail** for mocking. Do NOT use `mockito` (it requires code-gen).
- Reuse helpers in `test/helpers/`:
  - `mocks.dart`: Common mock classes.
  - `test_wrapper.dart`: `TestWrapper` widget to inject provider overrides.

## 3. General Rules
- **Platform:** Target Android only. Delete any auto-generated iOS/Web/Desktop folders.
- **Formatting:** Run `dart format .` before committing.
- **Lints:** Follow `package:flutter_lints/flutter.yaml`. Do not ignore lints unless critical.
- **Error Handling:** Use `AsyncValue.guard` in Notifiers to handle errors gracefully in the UI.
- **Naming:**
  - Classes: `PascalCase`
  - Files/Variables: `snake_case`
  - Providers: `<feature><Type>Provider` (e.g., `authControllerProvider`).

## 4. UI Design (Material 3)
- Use the BPS palette defined in `lib/core/theme/app_theme.dart`:
  - **Primary:** Navy (`0xFF0B5C9E`)
  - **Secondary:** Orange (`0xFFF28C28`)
  - **Tertiary:** Cyan (`0xFF00A2E8`)
- Use **Google Fonts (Montserrat)** for typography.
- Use `flutter_svg` for vector icons.
