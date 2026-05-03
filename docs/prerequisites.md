# Prerequisites

This project is easiest to run on Windows with either XAMPP or Laragon for MySQL, plus Android Studio for the emulator and SDK tooling.

## Required Tools

| Tool | Recommended Version | Check Command |
| --- | --- | --- |
| Git | Current stable | `git --version` |
| PHP | 8.2 or newer | `php -v` |
| Composer | 2.x | `composer --version` |
| Node.js | 18 LTS or newer | `node -v` |
| npm | Bundled with Node | `npm -v` |
| MySQL or MariaDB | XAMPP/Laragon bundled version is fine | `mysql --version` |
| Flutter SDK | Version that includes Dart 3.11 or newer | `flutter --version` |
| Android Studio | Current stable | `flutter doctor` |
| Android SDK Platform Tools | Current stable | `adb version` |

## Windows PATH

Make sure these are available in a new PowerShell terminal:

- PHP from XAMPP: `C:\xampp\php`
- PHP from Laragon: usually `C:\laragon\bin\php\php-8.x.x`
- Composer: usually `C:\ProgramData\ComposerSetup\bin`
- Node.js: usually `C:\Program Files\nodejs`
- Flutter: the `bin` folder inside your Flutter SDK
- Android platform tools: usually `%LOCALAPPDATA%\Android\Sdk\platform-tools`

After changing PATH, close and reopen PowerShell.

## Validation

Run:

```powershell
php -v
composer --version
node -v
npm -v
flutter doctor
adb version
```

Resolve any `flutter doctor` Android toolchain errors before running the mobile app.

## Repository Clone

```powershell
git clone https://github.com/Hima-1/PARIKESIT.git Parikesit_Git
cd Parikesit_Git
git remote -v
```

Expected remotes for attribution:

```text
origin    https://github.com/Hima-1/PARIKESIT.git
upstream  https://github.com/selicel/PARIKESIT.git
```
