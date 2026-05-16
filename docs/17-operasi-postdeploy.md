# 17. Operasi Postdeploy

Gunakan dokumen ini setelah production sudah hidup.

## 1. Update Release

Sebelum update:

1. Backup database.
2. Backup `.env` production.
3. Catat versi commit yang sedang live.
4. Cek apakah release membawa migration.

Langkah umum:

```bash
cd /home/CPANEL_USER/parikesit_laravel
git pull origin <branch>
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Ganti path tersebut dengan lokasi Laravel di server Anda.

Jika asset Vite berubah, jalankan atau upload hasil:

```bash
npm install
npm run build
```

## 2. Rollback Sederhana

Rollback source:

```bash
git log --oneline -5
git checkout <commit-sebelum-release>
composer install --no-dev --optimize-autoloader
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Jika migration sudah mengubah data production, rollback tidak selalu aman. Gunakan backup database jika perubahan bersifat destruktif.

## 3. Setelah Mengubah `.env`

```bash
php artisan config:clear
php artisan config:cache
```

Jika route/view ikut berubah:

```bash
php artisan route:clear
php artisan route:cache
php artisan view:clear
php artisan view:cache
```

## 4. Rotasi Credential Firebase

Lakukan jika service account bocor, project Firebase berubah, atau credential lama dicabut.

1. Buat service account key baru di Firebase/Google Cloud.
2. Upload file JSON baru ke lokasi aman di server.
3. Perbarui `FIREBASE_CREDENTIALS` atau trio env Firebase.
4. Jalankan:

```bash
php artisan config:clear
php artisan config:cache
php artisan reminders:send-opd-form
```

5. Cek log Laravel.

## 5. Smoke Test Production

Backend:

```bash
php artisan about
php artisan migrate:status
php artisan route:list --path=api --except-vendor
php artisan reminders:send-opd-form
```

Android:

1. Login sebagai user uji.
2. Buka dashboard.
3. Buka profil.
4. Buka notifikasi.
5. Upload file kecil.
6. Cek token FCM.

## 6. Saat Ada Masalah

| Gejala | Cek pertama |
| --- | --- |
| 500 setelah deploy | log Laravel, `.env`, `APP_KEY`, cache config |
| Login gagal | database, Sanctum token, API URL |
| File upload 404 | `storage:link`, `APP_URL`, permission folder |
| Reminder tidak jalan | cron cPanel dan env Firebase |
| Setelah env diganti tetap nilai lama | `config:clear` lalu `config:cache` |
