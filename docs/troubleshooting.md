# Troubleshooting

## `php` is not recognized

Add your PHP folder to PATH:

- XAMPP: `C:\xampp\php`
- Laragon: `C:\laragon\bin\php\php-8.x.x`

Open a new PowerShell terminal and run `php -v`.

## Composer install fails

Run:

```powershell
composer diagnose
composer install
```

If PHP extensions are missing, enable them in `php.ini`. Common Laravel needs include `openssl`, `pdo_mysql`, `mbstring`, `tokenizer`, `xml`, `ctype`, `json`, `bcmath`, `fileinfo`, and `curl`.

## MySQL connection refused

Check:

- XAMPP or Laragon MySQL is running.
- `.env` uses the right `DB_PORT`.
- Database `parikesit` exists.
- `DB_USERNAME` and `DB_PASSWORD` match your local MySQL.

Then run:

```powershell
php artisan config:clear
php artisan migrate:fresh --seed
```

## Port 8000 is already in use

Use another port:

```powershell
php artisan serve --host=0.0.0.0 --port=8001
```

Then update Flutter:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8001
```

For USB debugging:

```powershell
adb reverse tcp:8001 tcp:8001
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8001
```

## Android app cannot reach the API

Use the correct host:

- Emulator: `http://10.0.2.2:8000`
- USB with reverse: `http://127.0.0.1:8000`
- Wi-Fi device: `http://<computer-ip>:8000`

Also confirm Laravel is running with:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

## `CLEARTEXT communication not permitted`

The Android manifest enables local cleartext traffic. If this error appears, rebuild the app and confirm you are running the Android project under `parikesit_git/flutter/android`.

## Firebase or Google Services build errors

The app can build without `android/app/google-services.json`. If you need FCM:

1. Download the file from Firebase.
2. Put it at `parikesit_git/flutter/android/app/google-services.json`.
3. Do not commit it.

If Gradle still complains, run:

```powershell
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Generated Dart files are stale

Run:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Commit generated `*.g.dart` and `*.freezed.dart` changes when model source changes.

## Login fails after seeding

Use a seeded account:

```text
admin@gmail.com / password
diskominfo@klaten.go.id / password
inspektorat@klaten.go.id / password
```

If the database was changed manually, rebuild local data:

```powershell
php artisan migrate:fresh --seed
```
