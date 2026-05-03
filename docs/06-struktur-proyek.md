# 06. Struktur Proyek dan Kebersihan Repositori

## 1. Layout

```text
Parikesit_Git/
  README.md
  docs/
  laravel/
  flutter/
```

## 2. Aplikasi Laravel

`laravel` berisi:

- Route web Laravel 10 di `routes/web.php`
- Route API Laravel Sanctum di `routes/api.php`
- Domain model di `app/Models`
- Controller API dan web di `app/Http/Controllers`
- Seeder yang bisa dijalankan ulang di `database/seeders`
- Feature test dan API test di `tests`

Artifact install-time atau runtime yang diabaikan:

- `vendor`
- `node_modules`
- `.env`
- `public/build`
- file upload di bawah `public` dan `storage/app/public`
- cache session, compiled view, log, dan key

## 3. Aplikasi Flutter

`flutter` berisi:

- Project Android di `android`
- Source aplikasi di `lib`
- Unit/widget test di `test`
- Integration test Android di `integration_test`
- Dokumentasi Flutter di `docs`

File generated atau lokal yang diabaikan:

- `.dart_tool`
- `build`
- `.flutter-plugins-dependencies`
- cache Gradle Android
- `android/local.properties`
- `android/app/google-services.json`
- signing key dan artifact release

## 4. Atribusi

Repositori target adalah fork dari repositori Parikesit upstream. Pertahankan remote `origin` dan `upstream` agar maintainer berikutnya dapat melihat dan menyelaraskan histori project asli:

```powershell
git remote -v
```

Gunakan `origin` untuk fork dan `upstream` untuk pemilik asli.

## 5. Strategi Commit

Pisahkan migrasi berikutnya berdasarkan concern:

- relokasi atau sinkronisasi source
- perubahan ignore atau cleanup
- konfigurasi backend
- konfigurasi Flutter
- dokumentasi
- test atau perbaikan verifikasi

Cara ini membuat review dan atribusi lebih mudah dibanding satu commit besar.
