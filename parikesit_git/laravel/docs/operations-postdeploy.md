# Operasi Pascadeploy dan Release Update

## Tujuan

Dokumen ini menjadi runbook setelah aplikasi production sudah hidup: update release, rollback sederhana, rotasi credential, restart cache, dan smoke test operasional.

## Kapan Dokumen Ini Dipakai

- deploy update rutin
- hotfix production
- pindah domain atau ganti `APP_URL`
- ganti kredensial Firebase
- investigasi setelah deploy

## Prosedur Release Update

### Tujuan

Mengganti kode aplikasi tanpa melewatkan langkah yang berdampak ke runtime.

### Urutan kerja

1. Backup `.env` production dan database bila perubahan berisiko tinggi.
2. Upload perubahan source code baru.
3. Jalankan install dependency jika `composer.lock` berubah:

```bash
composer install --no-dev --optimize-autoloader
```

4. Jalankan migrasi bila ada migration baru:

```bash
php artisan migrate --force
```

5. Clear dan bangun ulang cache:

```bash
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

6. Verifikasi storage link masih valid.
7. Lakukan smoke test operasional.

### Hasil yang diharapkan

- aplikasi memakai kode terbaru
- schema database sesuai kebutuhan release
- cache runtime sesuai env terbaru

## Rollback Sederhana

### Tujuan

Mengembalikan layanan secepat mungkin bila release baru bermasalah.

### Strategi yang direkomendasikan

- rollback source code ke release stabil terakhir
- restore `.env` jika perubahan env ikut menyebabkan masalah
- restore database hanya jika memang ada perubahan schema/data yang tidak kompatibel

### Catatan penting

- rollback database lebih berisiko dibanding rollback kode
- jika migration sudah mengubah data production, rencanakan restore dari backup, bukan sekadar asumsi `migrate:rollback`

## Rotasi Kredensial Firebase

### Kapan perlu dilakukan

- service account diduga bocor
- project Firebase berubah
- organisasi mewajibkan rotasi berkala

### Langkah

1. Buat service account key baru di Firebase/Google Cloud.
2. Upload file JSON baru ke lokasi aman di server atau siapkan nilai env baru.
3. Perbarui `FIREBASE_CREDENTIALS` atau trio env Firebase.
4. Jalankan:

```bash
php artisan optimize:clear
php artisan config:cache
```

5. Uji pengiriman reminder manual:

```bash
php artisan reminders:send-opd-form
```

### Hasil yang diharapkan

- push FCM tetap berhasil dengan kredensial baru

## Rotasi Domain atau `APP_URL`

### Langkah

1. Update DNS dan HTTPS lebih dulu.
2. Perbarui `APP_URL`.
3. Perbarui origin production di `CORS_ALLOWED_ORIGINS` bila perlu.
4. Jalankan:

```bash
php artisan optimize:clear
php artisan config:cache
```

5. Cek URL file `/storage/...` dari data yang sudah ada.

## Restart Cache Operasional

Gunakan saat `.env` atau konfigurasi berubah:

```bash
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Jika hanya ingin membersihkan cache tanpa membangun ulang seluruh cache:

```bash
php artisan optimize:clear
```

## Smoke Test Pascadeploy

### API

- login dengan user valid
- `GET /api/profile` berhasil
- `GET /api/notifications` berhasil

### File

- upload dokumentasi atau pembinaan berhasil
- download file atau ZIP berhasil
- file lama tetap bisa dibuka lewat URL `/storage/...`

### Firebase

- login user `opd` dari Android
- token FCM tersimpan di `device_tokens`
- reminder manual atau push uji terkirim

### Scheduler

- cron cPanel masih aktif
- command scheduled terlihat berjalan sesuai jam yang dikonfigurasi

### Logging

- `storage/logs/laravel.log` tidak berisi error fatal baru setelah deploy

## Checklist Acceptance Pascadeploy

- release baru aktif
- migrasi sukses
- cache sudah direbuild
- login sukses
- endpoint profil sukses
- upload/download file sukses
- storage URL valid
- token FCM aktif
- push notification sukses
- cron tidak rusak

## Failure Umum

### Release baru aktif tetapi route kacau

- jalankan `php artisan optimize:clear`
- bangun ulang route/config cache

### Setelah ganti env, aplikasi masih membaca nilai lama

- cache config belum direfresh
- jalankan `php artisan optimize:clear` lalu `php artisan config:cache`

### Reminder manual berhasil tetapi otomatis tidak jalan

- masalah ada di cron cPanel, bukan di Firebase sender

### Push otomatis gagal setelah rotasi key

- path file JSON baru salah
- JSON tidak dapat dibaca PHP
- `FIREBASE_PRIVATE_KEY` tidak memakai escape newline yang benar

## Referensi

- [Runbook hosting cPanel](hosting-cpanel.md)
- [Deployment stack overview](../../parikesit_flutter/docs/deployment.md)
- [Firebase dan FCM end-to-end](../../parikesit_flutter/docs/firebase-fcm.md)
