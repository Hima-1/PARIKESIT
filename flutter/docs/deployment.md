# Deployment Stack PARIKESIT

## Tujuan

Dokumen ini menjadi pintu masuk dokumentasi hosting dan deployment untuk stack PARIKESIT yang ada saat ini:

- `parikesit_laravel` di-host sebagai backend API Laravel pada shared hosting/cPanel
- `parikesit_flutter` berjalan sebagai aplikasi Android
- Firebase dipakai untuk FCM di sisi Android dan pengiriman push notification dari Laravel

Flutter saat ini **tidak** di-host sebagai web, sehingga tidak ada cakupan Firebase Hosting untuk frontend web.

## Gambaran Sistem

| Komponen | Peran | Lokasi operasional |
| --- | --- | --- |
| Domain API | Endpoint production untuk mobile | Shared hosting/cPanel |
| Laravel API | Auth, data utama, upload file, notifikasi inbox, pengiriman FCM | `parikesit_laravel` |
| Database MySQL/MariaDB | Penyimpanan data aplikasi | Database cPanel |
| Public storage | File dokumentasi/pembinaan yang diakses lewat `/storage/...` | Symlink `public/storage` ke `storage/app/public` |
| Cron scheduler | Menjalankan reminder dan pembersihan notifikasi | Cron cPanel |
| Android app | Client utama untuk user | `parikesit_flutter` |
| Firebase project | FCM client/server | `parikesit-fef3a` saat ini |

## Urutan Baca yang Direkomendasikan

1. [Runbook hosting cPanel](../../parikesit_laravel/docs/hosting-cpanel.md)
2. [Firebase dan FCM end-to-end](firebase-fcm.md)
3. [Mobile production Android](mobile-production.md)
4. [Operasi pascadeploy dan release update](../../parikesit_laravel/docs/operations-postdeploy.md)

## Dependency Antar Komponen

| Dependensi | Dibutuhkan oleh | Dampak jika salah |
| --- | --- | --- |
| `APP_URL` dan HTTPS | Laravel, file URL, origin production | Link file, CORS, dan URL asset bisa rusak |
| Database MySQL/MariaDB | Laravel | Login dan seluruh API gagal |
| `storage:link` | Upload/download dokumentasi | File upload berhasil ke disk tetapi URL publik 404 |
| Cron `schedule:run` | Reminder OPD dan prune notification | Reminder tidak terkirim dan notifikasi lama tidak dibersihkan |
| Kredensial Firebase server | Laravel scheduler dan push notification | Push FCM gagal walau token device tersimpan |
| `google-services.json` | Build Android | FCM client gagal inisialisasi |
| `lib/firebase_options.dart` | Inisialisasi Firebase di Flutter | Aplikasi gagal menghubungkan project Firebase yang benar |
| `--dart-define-from-file=.env` | Flutter production build | APK mengarah ke backend yang salah |

## Source of Truth yang Dipakai Dokumen Ini

| File | Fungsi operasional |
| --- | --- |
| `parikesit_laravel/.env.example` | Daftar env utama yang perlu diisi |
| `parikesit_laravel/config/services.php` | Konfigurasi Firebase server dan jam reminder |
| `parikesit_laravel/config/cors.php` | Origin lintas domain yang diizinkan |
| `parikesit_laravel/config/sanctum.php` | Masa berlaku token dan domain stateful |
| `parikesit_laravel/app/Console/Kernel.php` | Jadwal job harian aktif |
| `parikesit_flutter/lib/core/config/app_config.dart` | `API_BASE_URL` dan `API_PREFIX` mobile |
| `parikesit_flutter/firebase.json` | Mapping project Firebase ke output FlutterFire |
| `parikesit_flutter/lib/firebase_options.dart` | Firebase options yang digunakan aplikasi saat runtime |

## Checklist Tingkat Tinggi

### Backend production siap jika:

- domain API sudah aktif via HTTPS
- `.env` production valid
- `php artisan migrate --force` selesai tanpa error
- `php artisan storage:link` sudah ada
- cron `php artisan schedule:run` berjalan setiap menit
- log awal deploy tidak berisi error fatal

### Android production siap jika:

- build APK/AAB memakai `API_BASE_URL` production
- `google-services.json` dan `firebase_options.dart` sinkron dengan project Firebase
- login berhasil ke API production
- token FCM tersimpan ke endpoint `/api/me/devices/fcm-token`
- notifikasi foreground/background dapat diterima di device uji

## Catatan Penting

- Shared hosting/cPanel adalah target utama dokumen ini. `railway.json` tetap ada di repo, tetapi bukan jalur deployment prioritas.
- Scheduler Laravel aktif untuk dua command saat ini:
  - `reminders:send-opd-form`
  - `notifications:prune-hidden`
- Queue default di template env masih `sync`, jadi dokumen ini tidak mengasumsikan adanya worker queue production terpisah.
