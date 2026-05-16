# Agent Instructions for Parikesit Flutter

You are an AI coding agent working on the **Parikesit** Flutter project. This is a "Lean and Mean" Android-only application focused on statistics (inspired by BPS).

## 1. Development Commands

| Task | Command |
|------|---------|
| Get Dependencies | `flutter pub get` |
| Static Analysis | `flutter analyze` |
| Run All Tests | `flutter test --dart-define-from-file=.env` |
| Run Single Test | `flutter test test/path/to/file_test.dart --dart-define-from-file=.env` |
| Run Single Test by Name | `flutter test --dart-define-from-file=.env --plain-name "test name pattern"` |
| Run Integration Tests | `flutter test integration_test --dart-define-from-file=.env` |
| Build Android APK | `flutter build apk --split-per-abi --dart-define-from-file=.env` |

**Integration test guardrails:**
- Run on Android device/emulator (`-d <android_device_id>`), not desktop/web.
- Ensure Laravel backend is up and reachable by the selected device.
- Provide API target explicitly with `--dart-define-from-file=.env`.

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

## 4. UI Design (Material 3 — Javanese Modern Heritage)
The visual system is "Javanese-Shadcn": Sogan brown brand + cream/white surfaces + 1px hairline borders, no thick shadows. See [docs/design-system.md](docs/design-system.md) for the full reference.

### Tokens — single source of truth
All design values live in `lib/core/theme/tokens/`:
- `colors.dart` — `AppColors.soganBrown`, `.terracotta`, `.cream`, semantic (`.success`/`.error`/`.warning`/`.info`), text grades.
- `typography.dart` — `AppTypography.display(...)` (Philosopher) + `.body(...)` (Plus Jakarta Sans).
- `radii.dart` — `AppRadii.sm/md/lg/rPill` + ready-to-use `BorderRadius` (`.rrSm/.rrMd/...`).
- `spacing.dart` — `AppSpacing.xs/sm/md/lg/xl` + `gapH*/gapW*` + `pAll*/pH*/pV*`.
- `elevation.dart` — `AppElevation.e0/e1/e2/e3` shadow lists.
- `motion.dart` — `AppMotion.fast/base/slow` durations + curves.
- `breakpoints.dart` — `AppBreakpoint.compact/medium/expanded` + `AppBreakpoints.of(context)`.

`AppTheme.lightTheme` / `AppTheme.darkTheme` assemble these tokens into Material's `ThemeData`. `lib/core/theme/app_theme.dart` keeps backward-compat aliases (`AppTheme.sogan`, `AppTheme.gold`, etc.) — they delegate to tokens, so old call sites still compile, but **new code must consume tokens or `Theme.of(context)`**.

### Component conventions
- **Read first, build second.** Run the gallery before adding a new widget: `flutter run -t lib/widgetbook.dart`. If a similar component already exists, extend it.
- Pull from `lib/core/widgets/` (general) before reaching into a feature. When you do build, place domain-coupled widgets under `features/<x>/presentation/widgets/`, never in `core/`.
- Wrap `AsyncValue<T>` rendering in `asyncView<T>(...)` from `core/helpers/async_view.dart` so loading/error visuals stay consistent.
- For paginated lists, use `PagedListView<T>` instead of rebuilding the loading + empty + error + footer stack.
- For form modals, use `AppFormDialog`. Pass `isSubmitting: true` to disable actions while saving.
- For filter rows, compose `AppFilterBar` with the `search` / `filters` / `trailing` slots — don't reimplement the responsive collapse.

### Spacing & gaps
- Prefer `Gap(x)` (from `package:gap`) over `SizedBox(height/width: x)` — works in any flex direction.
- For semantic edges, `AppSpacing.gapH*/gapW*` and `AppSpacing.pAll*` are still acceptable (and what most existing code uses).
- Never write `Color(0xFF...)`, `EdgeInsets.all(<n>)`, or `BorderRadius.circular(<n>)` literal in screens — pull from tokens.

### Typography
- Always read text styles from `Theme.of(context).textTheme.*`. The two-font system (Philosopher for display, Plus Jakarta Sans for body) is wired via `AppTheme`.
- The `EthnoTextTheme` extension exposes `labelTiny` for eyebrow labels — `EthnoTextTheme.of(context).labelTiny`.

### Icons
- Use `lucide_icons` for non-system icons (filter, sort, export). System Material icons (`Icons.*`) remain fine for navigation and AppBar actions.
- Use `flutter_svg` for SVG assets.
