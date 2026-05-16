# Integration Testing Standards

This directory contains integration tests for the Parikesit Flutter application. We follow a set of standardized patterns to ensure tests are robust, maintainable, and easy to debug.

## Core Principles

1.  **Shared Helpers**: All common logic (authentication, navigation, form interaction) should be placed in `test_helpers.dart`.
2.  **Robust Waiting**: Use `pumpUntil(tester, finder, label: '...')` instead of arbitrary `pumpAndSettle()` durations. This ensures we wait for specific UI states and provides clear logging when timeouts occur.
3.  **Semantic Selectors**: Prefer `find.byKey` and `find.text` over positional or complex widget-tree based selectors. Ensure critical interactive elements have unique keys.
4.  **Descriptive Logging**: Every `pumpUntil` and `navigateTo` call should include a `label` to help identify the failure point in logs.

## Common Helpers

- `loginAs(tester, email, password)`: Standard login flow.
- `ensureLoggedIn(tester)`: Only logs in if the login screen is visible.
- `navigateTo(tester, finder, targetText: '...')`: Taps a widget and waits for a specific screen title/text.
- `tapButton(tester, key, label: '...')`: Taps a button by key with logging.
- `enterFormText(tester, key, value)`: Enters text into a field by key.
- `selectFromDropdown(tester, key, itemText)`: Handles the specific logic for tapping a dropdown and selecting an item by text.

## Running Tests

Run all integration tests from the project root:
```bash
flutter test integration_test/
```

Run a specific test:
```bash
flutter test integration_test/admin_user_management_test.dart
```

Run a smoke test on Android with explicit API base URL:
```bash
flutter test integration_test/api_journey_test.dart -d <android_device_id> --dart-define-from-file=.env --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

## Guardrails

- Integration tests are environment-dependent and should be run on Android targets.
- Laravel API backend must be running and reachable by the target device.
- Set `API_BASE_URL` in `.env` and use `--dart-define-from-file=.env` for every integration run.
- Use `--dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true` for automated Android runs so the notification permission dialog cannot block the first screen.
- Prefer fresh seed data before smoke suites: `php artisan migrate:fresh --seed --force`.
