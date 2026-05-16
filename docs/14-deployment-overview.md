# 14. Deployment Overview

Dokumen ini memberi gambaran besar deployment. Detail langkah ada di dokumen berikutnya.

## 1. Target Deployment Saat Ini

| Komponen | Target |
| --- | --- |
| Laravel API | Shared hosting/cPanel |
| Database | MySQL/MariaDB dari hosting |
| Android app | APK/AAB Flutter |
| Notifikasi | Firebase Cloud Messaging |
| Scheduler | Cron cPanel menjalankan Laravel scheduler |

Flutter saat ini Android-only. Tidak ada deployment Flutter Web.

## 2. Komponen yang Harus Sinkron

| Komponen | Harus benar karena |
| --- | --- |
| `APP_URL` Laravel | Dipakai URL file publik dan link absolut |
| Domain HTTPS API | Android production harus mengakses HTTPS valid |
| Database production | Login dan seluruh data bergantung pada ini |
| `storage:link` | Upload/download file butuh URL publik |
| Cron scheduler | Reminder dan prune notifikasi bergantung cron |
| Firebase server credential | Laravel butuh ini untuk mengirim push |
| `google-services.json` | Android butuh ini untuk FCM native |
| `firebase_options.dart` | Flutter butuh ini untuk init Firebase |
| `API_BASE_URL` Flutter | APK harus mengarah ke backend production |

## 3. Urutan Baca Deployment

1. [15. Hosting cPanel](15-hosting-cpanel.md)
2. [08. Firebase dan FCM](08-firebase-fcm.md)
3. [16. Build Android Production](16-build-android-production.md)
4. [17. Operasi Postdeploy](17-operasi-postdeploy.md)

## 4. Checklist Backend Production Siap

- Domain API aktif dengan HTTPS.
- Document root mengarah ke folder `laravel/public`.
- `.env` production valid.
- `composer install --no-dev --optimize-autoloader` selesai.
- `php artisan migrate --force` selesai.
- `php artisan storage:link` tersedia atau dibuat manual.
- Cache config/route/view sudah dibuat.
- Cron `schedule:run` aktif.
- Log Laravel tidak berisi error fatal.

## 5. Checklist Android Production Siap

- `API_BASE_URL` memakai domain production.
- `google-services.json` dan `firebase_options.dart` berasal dari project Firebase yang sama.
- Package name Android cocok dengan Firebase.
- Signing release sudah benar.
- Login ke API production berhasil.
- Token FCM tersimpan ke backend.
- Notifikasi foreground/background diterima di device uji.

## 6. Catatan Asset Laravel

`laravel/public/build` diabaikan oleh `.gitignore`. Pastikan strategi deploy asset Vite dipilih:

- build di server,
- upload artifact build,
- atau ubah kebijakan repo jika memang ingin commit `public/build`.

Jangan melewati pengecekan ini saat deploy cPanel.
