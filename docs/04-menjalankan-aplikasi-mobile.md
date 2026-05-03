# 04. Menjalankan Aplikasi Flutter Android

Aplikasi Flutter membaca target backend dari `API_BASE_URL`. Default di kode adalah `http://127.0.0.1:8000`, yang cocok untuk USB debugging dengan `adb reverse`.

## 1. Siapkan Flutter

```powershell
cd flutter
flutter pub get
flutter doctor
```

Jika file model hasil generate perlu diperbarui:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

## 2. Jalankan di Emulator Android

Jalankan backend Laravel terlebih dahulu:

```powershell
cd laravel
php artisan serve --host=0.0.0.0 --port=8000
```

Lalu jalankan Flutter:

```powershell
cd flutter
flutter emulators
flutter emulators --launch <emulator_id>
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Emulator Android Studio memetakan `10.0.2.2` ke komputer host.

## 3. Jalankan di Perangkat Fisik dengan USB Debugging

1. Aktifkan Developer Options di ponsel.
2. Aktifkan USB debugging.
3. Hubungkan ponsel dengan USB dan setujui prompt otorisasi.
4. Pastikan perangkat terbaca:

```powershell
adb devices
```

Teruskan port `8000` perangkat ke port Laravel di komputer:

```powershell
adb reverse tcp:8000 tcp:8000
adb reverse --list
```

Jalankan:

```powershell
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## 4. Jalankan di Perangkat Fisik lewat Wi-Fi

Gunakan cara ini jika USB reverse tidak tersedia.

1. Pastikan komputer dan ponsel berada di jaringan yang sama.
2. Jalankan Laravel di semua interface:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

3. Cari alamat IPv4 komputer:

```powershell
ipconfig
```

4. Izinkan akses Windows Firewall untuk PHP jika muncul prompt.
5. Jalankan Flutter dengan IP LAN:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8000
```

Ganti `192.168.1.25` dengan alamat IPv4 komputer yang sebenarnya.

## 5. Firebase dan Notifikasi

`android/app/google-services.json` diabaikan agar credential Firebase project tidak masuk commit. Clone baru tetap bisa build tanpa file tersebut karena Google Services plugin hanya diterapkan ketika file tersedia.

Untuk testing FCM:

1. Unduh `google-services.json` dari Firebase Console.
2. Letakkan di `flutter/android/app/google-services.json`.
3. Pastikan variable Firebase di `.env` Laravel sudah dikonfigurasi jika backend perlu mengirim push notification.
4. Jalankan ulang `flutter pub get` dan `flutter run`.

## 6. Integration Test

Jalankan integration test hanya pada target Android dengan URL API eksplisit:

```powershell
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

Untuk USB debugging dengan reverse:

```powershell
adb reverse tcp:8000 tcp:8000
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://127.0.0.1:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

Run smoke suite utama satu per satu dari database seed bersih:

```powershell
$tests = @(
  'integration_test/api_journey_test.dart',
  'integration_test/admin_user_management_test.dart',
  'integration_test/walidata_journey_test.dart',
  'integration_test/walidata_navigation_test.dart',
  'integration_test/opd_journey_test.dart',
  'integration_test/profile_view_test.dart'
)

foreach ($test in $tests) {
  flutter test $test -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
```

`LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true` hanya dipakai untuk automation. Run manual tetap boleh tanpa flag itu agar alur notifikasi diuji oleh pengguna.
