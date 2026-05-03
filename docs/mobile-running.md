# Running the Flutter Android App

The Flutter app reads its backend target from `API_BASE_URL`. The default in code is `http://127.0.0.1:8000`, which is useful for USB debugging with `adb reverse`.

## 1. Prepare Flutter

```powershell
cd parikesit_git\flutter
flutter pub get
flutter doctor
```

If generated model files need to be refreshed:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## 2. Run on Android Emulator

Start the Laravel backend first:

```powershell
cd parikesit_git\laravel
php artisan serve --host=0.0.0.0 --port=8000
```

Then run Flutter:

```powershell
cd parikesit_git\flutter
flutter emulators
flutter emulators --launch <emulator_id>
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Android Studio's emulator maps `10.0.2.2` to the host machine.

## 3. Run on Physical Device with USB Debugging

1. Enable Developer Options on the phone.
2. Enable USB debugging.
3. Connect the phone by USB and accept the authorization prompt.
4. Confirm the device is visible:

```powershell
adb devices
```

Forward the device's port `8000` to the computer's Laravel port:

```powershell
adb reverse tcp:8000 tcp:8000
adb reverse --list
```

Run:

```powershell
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## 4. Run on Physical Device over Wi-Fi

Use this when USB reverse is unavailable.

1. Make sure the computer and phone are on the same network.
2. Run Laravel on all interfaces:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

3. Find the computer IPv4 address:

```powershell
ipconfig
```

4. Allow Windows Firewall access to PHP if prompted.
5. Run Flutter with the LAN IP:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8000
```

Replace `192.168.1.25` with your computer's actual IPv4 address.

## 5. Firebase and Notifications

`android/app/google-services.json` is ignored so Firebase project credentials are not committed. A fresh clone can build without that file because the Google Services plugin is applied only when the file exists.

For FCM testing:

1. Download `google-services.json` from the Firebase console.
2. Place it at `parikesit_git/flutter/android/app/google-services.json`.
3. Confirm the Laravel `.env` Firebase variables are configured if backend push delivery is needed.
4. Re-run `flutter pub get` and `flutter run`.

## 6. Integration Tests

Run integration tests only against an Android target with an explicit API URL:

```powershell
flutter test integration_test -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

For USB debugging with reverse:

```powershell
adb reverse tcp:8000 tcp:8000
flutter test integration_test -d <device_id> --dart-define=API_BASE_URL=http://127.0.0.1:8000
```
