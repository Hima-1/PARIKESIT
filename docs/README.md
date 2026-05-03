# Parikesit Git Documentation

Start here when preparing a new machine or onboarding another developer.

## Zero-to-Running Path

1. Complete [Prerequisites](prerequisites.md).
2. Choose one backend database stack:
   - [XAMPP backend setup](backend-xampp.md)
   - [Laragon backend setup](backend-laragon.md)
3. Run the mobile client with [Android emulator, USB, or Wi-Fi instructions](mobile-running.md).
4. Use [Port forwarding and device networking](port-forwarding.md) when the app cannot reach the API.
5. Check [Troubleshooting](troubleshooting.md) for common Windows, Laravel, MySQL, Flutter, and Android issues.

## Important Defaults

| Item | Default |
| --- | --- |
| Laravel path | `parikesit_git/laravel` |
| Flutter path | `parikesit_git/flutter` |
| API server | `http://127.0.0.1:8000/api` |
| Android emulator API base | `http://10.0.2.2:8000` |
| USB debugging API base with `adb reverse` | `http://127.0.0.1:8000` |
| Database name | `parikesit` |
| MySQL user for local XAMPP/Laragon | `root` |
| MySQL password for local XAMPP/Laragon | empty unless you changed it |

## Source Documentation

The original framework documentation was kept with each app:

- Laravel: `parikesit_git/laravel/docs`
- Flutter: `parikesit_git/flutter/docs`
