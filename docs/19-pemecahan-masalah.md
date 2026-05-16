# 19. Pemecahan Masalah

Cari gejala yang paling mirip, lalu ikuti langkahnya dari atas.

## 1. `php` Tidak Dikenali

Tambahkan folder PHP ke PATH:

- XAMPP: `C:\xampp\php`
- Laragon: `C:\laragon\bin\php\php-8.x.x`

Buka PowerShell baru, lalu:

```powershell
php -v
```

## 2. `composer install` Gagal

```powershell
cd laravel
composer diagnose
composer install
```

Pastikan ekstensi PHP umum aktif: `openssl`, `pdo_mysql`, `mbstring`, `xml`, `fileinfo`, dan `curl`.

## 3. Koneksi MySQL Ditolak

Cek:

- MySQL XAMPP/Laragon berjalan.
- Database `parikesit` sudah dibuat.
- `.env` memakai `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, dan `DB_PASSWORD` yang benar.

Lalu:

```powershell
cd laravel
php artisan config:clear
php artisan migrate:fresh --seed
```

## 4. Port `8000` Sudah Dipakai

Gunakan port lain:

```powershell
cd laravel
php artisan serve --host=0.0.0.0 --port=8001
```

Emulator:

```powershell
cd flutter
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8001
```

HP USB:

```powershell
adb reverse tcp:8001 tcp:8001
cd flutter
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8001
```

## 5. Android Tidak Bisa Login ke API

Gunakan URL sesuai target:

- Emulator Android Studio: `http://10.0.2.2:8000`
- HP USB dengan reverse: `http://127.0.0.1:8000`
- HP Wi-Fi: `http://<ip-komputer>:8000`

Pastikan Laravel berjalan:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

## 6. `CLEARTEXT communication not permitted`

Project Android mengizinkan cleartext lokal. Jika error muncul:

```powershell
cd flutter
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Pastikan yang dijalankan adalah project `flutter/android`.

## 7. Error Firebase atau Google Services

Clone baru bisa build tanpa `google-services.json`. Jika butuh FCM:

1. Unduh `google-services.json` dari Firebase Console.
2. Simpan ke `flutter/android/app/google-services.json`.
3. Pastikan `firebase_options.dart` dari project yang sama.
4. Jalankan:

```powershell
cd flutter
flutter clean
flutter pub get
```

## 8. File Dart Generated Usang

```powershell
cd flutter
dart run build_runner build --delete-conflicting-outputs
```

Commit perubahan `*.g.dart` dan `*.freezed.dart` jika source model berubah.

## 9. Login Gagal Setelah Seeding

Gunakan akun:

```text
admin@gmail.com / password
diskominfo@klaten.go.id / password
dpupr@klaten.go.id / password
```

Jika database lokal sudah berantakan:

```powershell
cd laravel
php artisan migrate:fresh --seed
```

## 10. `npm install` Konflik Vite

```powershell
cd laravel
npm install --legacy-peer-deps
```

Catatan `npm audit` tidak otomatis membuat aplikasi gagal jalan, tetapi perlu ditinjau sebelum release production.

## 11. Integration Test Berhenti di Dialog Notifikasi

Gunakan flag automation:

```powershell
cd flutter
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

Jangan pakai flag itu untuk uji manual notifikasi.

## 12. Install APK Emulator Gagal Karena Storage

Jika muncul error storage tidak cukup:

1. Buka Android Studio Device Manager.
2. Wipe Data atau Cold Boot emulator.
3. Jalankan ulang test/build.

## 13. Production Masih Membaca Env Lama

```bash
php artisan config:clear
php artisan config:cache
```

Laravel production sering membaca cache config, bukan `.env` langsung.
