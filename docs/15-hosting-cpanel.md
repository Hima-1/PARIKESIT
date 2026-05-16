# 15. Hosting Laravel di Shared Hosting/cPanel

Runbook ini menjelaskan deployment backend Laravel ke shared hosting/cPanel.

## 1. Topologi Contoh

Nama folder server bebas. Contoh ini memakai `parikesit_laravel` agar jelas bahwa yang diupload adalah isi aplikasi Laravel, bukan seluruh monorepo.

```text
/home/CPANEL_USER/parikesit_laravel
  app/
  bootstrap/
  config/
  database/
  public/      <- document root domain API
  resources/
  routes/
  storage/
  vendor/
```

Domain API contoh:

```text
https://api.example.com
```

## 2. Prasyarat Hosting

Hosting idealnya menyediakan:

- PHP 8.2+
- Composer 2.x
- MySQL/MariaDB
- Terminal cPanel atau SSH
- Cron Jobs
- File Manager
- akses untuk mengatur document root subdomain

Ekstensi PHP umum yang dibutuhkan:

- `openssl`
- `pdo_mysql`
- `mbstring`
- `tokenizer`
- `xml`
- `ctype`
- `json`
- `fileinfo`
- `curl`

## 3. Arahkan Document Root

Subdomain API harus mengarah ke:

```text
/home/CPANEL_USER/parikesit_laravel/public
```

Jangan arahkan domain ke root project. File seperti `.env`, `composer.json`, dan folder `storage` tidak boleh terekspos publik.

## 4. Upload Source

Opsi:

- ZIP lalu extract lewat File Manager.
- cPanel Git Version Control.
- `git pull` lewat SSH.

Pastikan file `artisan` ada di root project dan `public/index.php` tersedia.

## 5. Install Dependency

Jika terminal tersedia:

```bash
cd /home/CPANEL_USER/parikesit_laravel
composer install --no-dev --optimize-autoloader
```

Jika tidak ada terminal, gunakan Composer dari panel hosting atau upload folder `vendor` dari environment dengan versi PHP kompatibel.

## 6. Siapkan `.env` Production

Minimal:

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.example.com
APP_TIMEZONE=Asia/Jakarta

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=cpanel_dbname
DB_USERNAME=cpanel_dbuser
DB_PASSWORD=strong-password

FILESYSTEM_DISK=public
QUEUE_CONNECTION=sync
SESSION_SECURE_COOKIE=true
CORS_ALLOWED_ORIGINS=https://api.example.com
SANCTUM_EXPIRATION=120

FIREBASE_CREDENTIALS=/home/CPANEL_USER/secure/firebase-service-account.json
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Jakarta
```

Jika ada frontend browser production di domain lain, tambahkan domain itu ke `CORS_ALLOWED_ORIGINS`.

## 7. Generate Key

Jika `APP_KEY` belum ada:

```bash
php artisan key:generate --force
```

## 8. Migrasi Database

Untuk production:

```bash
php artisan migrate --force
```

Jangan memakai `migrate:fresh` di production karena akan menghapus data.

## 9. Storage Link

```bash
php artisan storage:link
```

Cek file publik dapat diakses lewat URL `/storage/...`.

Jika hosting tidak mendukung symlink, buat mapping manual sesuai fitur File Manager hosting.

## 10. Build Asset Laravel

Jika build di server:

```bash
npm install
npm run build
```

Jika build di lokal, upload hasil `public/build` sebagai artifact release. Ingat: `public/build` tidak ikut commit secara default.

## 11. Cache Production

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Jika env berubah:

```bash
php artisan config:clear
php artisan config:cache
```

## 12. Cron Scheduler

Tambahkan cron cPanel setiap menit:

```text
* * * * * php /home/CPANEL_USER/parikesit_laravel/artisan schedule:run >> /dev/null 2>&1
```

Jika path PHP berbeda:

```text
* * * * * /usr/local/bin/php /home/CPANEL_USER/parikesit_laravel/artisan schedule:run >> /dev/null 2>&1
```

Scheduler menjalankan reminder OPD dan prune notifikasi.

## 13. Validasi Setelah Deploy

```bash
php artisan about
php artisan route:list --path=api --except-vendor
php artisan migrate:status
php artisan reminders:send-opd-form
```

Cek juga:

- domain API bisa dibuka.
- login dari Android production berhasil.
- file upload bisa diakses.
- token FCM tersimpan.
- log `storage/logs` tidak berisi error fatal.
