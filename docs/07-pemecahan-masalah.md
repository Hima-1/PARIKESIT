# 07. Pemecahan Masalah

## 1. `php` Tidak Dikenali

Tambahkan folder PHP ke PATH:

- XAMPP: `C:\xampp\php`
- Laragon: `C:\laragon\bin\php\php-8.x.x`

Buka terminal PowerShell baru, lalu jalankan `php -v`.

## 2. `composer install` Gagal

Jalankan:

```powershell
composer diagnose
composer install
```

Jika ekstensi PHP belum aktif, aktifkan di `php.ini`. Kebutuhan umum Laravel mencakup `openssl`, `pdo_mysql`, `mbstring`, `tokenizer`, `xml`, `ctype`, `json`, `bcmath`, `fileinfo`, dan `curl`.

## 3. Koneksi MySQL Ditolak

Cek:

- MySQL XAMPP atau Laragon sedang berjalan.
- `.env` memakai `DB_PORT` yang benar.
- Database `parikesit` sudah ada.
- `DB_USERNAME` dan `DB_PASSWORD` sesuai MySQL lokal.

Lalu jalankan:

```powershell
php artisan config:clear
php artisan migrate:fresh --seed
```

## 4. Port `8000` Sudah Dipakai

Gunakan port lain:

```powershell
php artisan serve --host=0.0.0.0 --port=8001
```

Lalu update Flutter:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8001
```

Untuk USB debugging:

```powershell
adb reverse tcp:8001 tcp:8001
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8001
```

## 5. Aplikasi Android Tidak Bisa Menjangkau API

Gunakan host yang sesuai:

- Emulator: `http://10.0.2.2:8000`
- USB dengan reverse: `http://127.0.0.1:8000`
- Perangkat Wi-Fi: `http://<ip-komputer>:8000`

Pastikan juga Laravel berjalan dengan:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

## 6. `CLEARTEXT communication not permitted`

Manifest Android mengizinkan traffic cleartext lokal. Jika error ini muncul, rebuild aplikasi dan pastikan project Android yang dijalankan berada di `flutter/android`.

## 7. Error Firebase atau Google Services Saat Build

Aplikasi bisa build tanpa `android/app/google-services.json`. Jika butuh FCM:

1. Unduh file dari Firebase.
2. Letakkan di `flutter/android/app/google-services.json`.
3. Jangan commit file tersebut.

Jika Gradle masih error, jalankan:

```powershell
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## 8. File Dart Generated Sudah Usang

Jalankan:

```powershell
dart run build_runner build --delete-conflicting-outputs
```

Commit perubahan `*.g.dart` dan `*.freezed.dart` ketika source model berubah.

## 9. Login Gagal Setelah Seeding

Gunakan akun seed:

```text
admin@gmail.com / password
diskominfo@klaten.go.id / password
dpupr@klaten.go.id / password
```

Jika database pernah diubah manual, bangun ulang data lokal:

```powershell
php artisan migrate:fresh --seed
```

## 10. `npm install` Konflik Peer Dependency Vite

Jika Laragon/Node menampilkan konflik `laravel-vite-plugin` dengan versi `vite`, gunakan:

```powershell
npm install --legacy-peer-deps
```

Catatan `npm audit` tidak otomatis berarti aplikasi gagal dijalankan, tetapi tetap perlu ditinjau sebelum production release.

## 11. Integration Test Android Berhenti di Dialog Notifikasi

Android 13 atau lebih baru bisa menampilkan permission dialog notifikasi saat app start. Untuk automation integration test, jalankan dengan flag:

```powershell
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

Flag tersebut hanya mematikan inisialisasi notifikasi selama test. Jangan pakai flag ini untuk uji manual fitur notifikasi.

## 12. Install APK Emulator Gagal Karena Storage

Jika muncul error seperti `Requested internal only, but not enough space`, bersihkan data emulator dari Android Studio Device Manager atau jalankan cold boot/wipe data, lalu ulangi:

```powershell
adb devices
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```
