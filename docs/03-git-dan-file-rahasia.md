# 03. Git dan File Rahasia

Tujuan dokumen ini adalah mencegah file lokal, credential, upload, dan hasil build masuk commit.

## 1. Remote Git

Repo ini mempertahankan asal fork:

```text
origin    https://github.com/Hima-1/PARIKESIT.git
upstream  https://github.com/selicel/PARIKESIT.git
```

Cek remote:

```powershell
git remote -v
```

Gunakan `origin` untuk push ke fork. Gunakan `upstream` hanya untuk mengambil perubahan dari repo asli jika diperlukan.

## 2. File yang Tidak Boleh Di-commit

Jangan commit file berikut:

| File/folder | Alasan |
| --- | --- |
| `laravel/.env` | Berisi credential database, app key, secret |
| `flutter/.env` | Berisi URL backend per environment |
| `flutter/android/app/google-services.json` | Berisi konfigurasi Firebase project |
| Firebase service account JSON | Credential server untuk FCM |
| `vendor/` | Dependency PHP hasil `composer install` |
| `node_modules/` | Dependency Node hasil `npm install` |
| `.dart_tool/`, `build/` | Cache dan hasil build Flutter |
| `laravel/public/storage/` | Symlink atau output storage |
| `laravel/storage/logs/` | Log runtime |
| `laravel/storage/app/public/...` | File upload user |
| Android keystore, `.jks`, `.keystore`, `key.properties` | Credential signing APK/AAB |

`.gitignore` root sudah mengabaikan file-file tersebut. Jika ada file rahasia muncul di `git status`, jangan langsung commit.

## 3. File yang Boleh Di-commit

| File | Kapan commit |
| --- | --- |
| `laravel/.env.example` | Jika ada variable env baru yang perlu diketahui semua developer |
| `flutter/.env.example` | Jika ada dart-define baru |
| Migration Laravel | Setiap ada perubahan schema database |
| Seeder Laravel | Jika data awal/master data berubah |
| `*.g.dart` dan `*.freezed.dart` | Jika model Flutter hasil generate berubah dan repo memang menyimpan generated file |
| Dokumentasi di `docs/` | Setiap ada perubahan setup, env, deploy, atau workflow |

## 4. Sebelum Commit

Jalankan:

```powershell
git status --short
```

Pastikan perubahan yang akan di-commit sesuai tujuan. Worktree repo ini bisa berisi perubahan orang lain, jadi jangan melakukan `git reset --hard` atau checkout file tanpa alasan jelas.

## 5. Strategi Commit

Pisahkan commit berdasarkan concern:

- dokumentasi
- konfigurasi env/example
- migrasi database
- perubahan backend
- perubahan Flutter
- test
- cleanup file ignore

Commit kecil lebih mudah direview dan lebih aman dikembalikan jika ada masalah.
