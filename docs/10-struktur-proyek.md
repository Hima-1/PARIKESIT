# 10. Struktur Proyek

Dokumen ini menjelaskan tempat file berada supaya perubahan baru tidak tersebar sembarangan.

## 1. Layout Root

```text
Parikesit_Git/
  README.md
  docs/
  laravel/
  flutter/
```

## 2. Folder Laravel

```text
laravel/
  app/
  bootstrap/
  config/
  database/
  public/
  resources/
  routes/
  storage/
  tests/
```

| Folder/file | Fungsi |
| --- | --- |
| `routes/api.php` | Route API untuk Flutter |
| `routes/web.php` | Route web dashboard |
| `app/Http/Controllers` | Controller web dan API |
| `app/Models` | Model Eloquent |
| `app/Services` | Logic bisnis yang dipakai controller |
| `app/Http/Requests` | Validasi request |
| `database/migrations` | Perubahan schema database |
| `database/seeders` | Data awal/master data |
| `tests/Feature/Api` | Test API |
| `config/services.php` | Konfigurasi integrasi seperti Firebase |

## 3. Folder Flutter

```text
flutter/
  android/
  assets/
  docs/        <- hanya penunjuk ke root docs
  integration_test/
  lib/
  test/
```

| Folder/file | Fungsi |
| --- | --- |
| `lib/main.dart` | Entry point aplikasi |
| `lib/core` | Router, network, theme, widget umum, storage token |
| `lib/features` | Fitur aplikasi per domain |
| `lib/features/auth` | Login, profil, auth provider |
| `lib/features/assessment` | Formulir dan penilaian |
| `lib/features/home` | Dashboard role |
| `lib/features/admin` | Manajemen admin |
| `lib/features/notifications` | Inbox dan FCM |
| `lib/features/pembinaan` | Dokumentasi dan pembinaan |

## 4. File Generated

Flutter memakai file generated seperti:

- `*.g.dart`
- `*.freezed.dart`

Jika model berubah, jalankan:

```powershell
cd flutter
dart run build_runner build --delete-conflicting-outputs
```

Commit file generated jika repo memang sudah menyimpannya.

## 5. Build Asset Laravel

Untuk local development:

```powershell
cd laravel
npm run dev
```

Untuk production release:

```powershell
cd laravel
npm run build
```

Catatan penting: root `.gitignore` saat ini mengabaikan `laravel/public/build/`. Artinya hasil `npm run build` tidak otomatis ikut commit. Jika deployment cPanel membutuhkan asset Vite, pilih salah satu kebijakan dan ikuti secara konsisten:

- build asset di server saat deploy, atau
- upload artifact build sebagai bagian release di luar Git, atau
- ubah kebijakan `.gitignore` jika tim memutuskan `public/build` harus disimpan di repo.

Jangan menganggap `public/build` ikut deploy tanpa mengecek `git status` dan paket release.
