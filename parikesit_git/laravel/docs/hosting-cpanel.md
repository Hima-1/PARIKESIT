# Hosting Laravel di Shared Hosting/cPanel

## Tujuan

Runbook ini menjelaskan deployment `parikesit_laravel` sampai hidup di production pada shared hosting/cPanel, lengkap dengan konfigurasi database, storage publik, scheduler, Firebase server, dan validasi akhir.

## Topologi Target

Contoh topologi yang dipakai dokumen ini:

- kode aplikasi berada di `/home/CPANEL_USER/parikesit_laravel`
- domain API production misalnya `https://api.example.com`
- document root domain diarahkan ke folder `public` milik Laravel
- database production berupa MySQL atau MariaDB dari cPanel
- cron cPanel memanggil `php artisan schedule:run` setiap menit

## Baseline Prasyarat

### Hosting

- shared hosting/cPanel dengan PHP CLI tersedia
- akses File Manager
- akses Database Wizard atau phpMyAdmin
- akses Cron Jobs
- idealnya akses SSH atau Terminal cPanel

### Runtime

- PHP 8.2+
- Composer 2.x
- ekstensi PHP yang umum dibutuhkan Laravel 10:
  - `openssl`
  - `pdo_mysql`
  - `mbstring`
  - `tokenizer`
  - `xml`
  - `ctype`
  - `json`
  - `fileinfo`
- MySQL 8+ atau MariaDB 10.4+ sebagai baseline operasional
- Node.js hanya diperlukan jika Anda berniat build asset Vite di server; lebih aman build asset di lokal lalu upload hasilnya

## Source of Truth Repo

| File | Fungsi operasional |
| --- | --- |
| `.env.example` | Template env utama |
| `config/services.php` | Konfigurasi Firebase dan jam reminder |
| `config/cors.php` | Daftar origin yang diizinkan |
| `config/sanctum.php` | Expiration token dan domain stateful |
| `config/filesystems.php` | URL storage publik |
| `app/Console/Kernel.php` | Scheduler aktif |
| `app/Services/FirebasePushNotificationSender.php` | Cara backend mengirim FCM |
| `railway.json` | Alternatif non-prioritas, bukan jalur utama dokumen ini |

## Tabel Dependency Production

| Komponen | Required | Digunakan untuk | Verifikasi |
| --- | --- | --- | --- |
| Domain HTTPS | Ya | API production dan URL file publik | Buka `https://domain/api/...` |
| Database | Ya | Seluruh data aplikasi | Login dan query basic berjalan |
| `APP_URL` | Ya | URL storage dan link absolut | File publik mengarah ke domain benar |
| `storage:link` | Ya | Akses file upload lewat `/storage/...` | URL file tidak 404 |
| Cron scheduler | Ya | Reminder dan prune notification | Command terjadwal jalan otomatis |
| Firebase server credentials | Ya bila notifikasi dipakai | Push FCM dan reminder OPD | Reminder manual berhasil |

## Mode Deployment

### Mode A: Hosting dengan SSH/Terminal tersedia

Mode ini paling aman karena Anda bisa menjalankan command Laravel langsung di server.

### Mode B: Hosting tanpa SSH

Mode ini tetap mungkin, tetapi ada keterbatasan:

- install Composer bisa bergantung pada fitur antarmuka hosting
- `php artisan` mungkin harus dijalankan lewat Terminal cPanel atau kontak support
- `storage:link` bisa perlu dibuat manual jika symlink dilarang
- cache clear atau migrate lebih sulit diulang

Jika provider mendukung Terminal cPanel tetapi bukan SSH penuh, perlakukan sebagai Mode A selama command PHP CLI dapat dijalankan.

## Langkah 1 - Siapkan Domain dan Document Root

### Tujuan

Memastikan request publik hanya masuk ke folder `public` Laravel.

### Panel action

1. Tambahkan domain atau subdomain API di cPanel, misalnya `api.example.com`.
2. Jika hosting mendukung custom document root, arahkan ke:

```text
/home/CPANEL_USER/parikesit_laravel/public
```

### Hasil yang diharapkan

- web root mengarah langsung ke folder `public`
- file sensitif seperti `.env` dan `composer.json` tidak terekspos publik

### Cara cek berhasil

- buka domain API, pastikan request mencapai Laravel
- pastikan root publik bukan folder project penuh

## Langkah 2 - Upload Source Code

### Tujuan

Menempatkan source Laravel lengkap di server.

### Opsi

- upload ZIP lalu extract lewat File Manager
- deploy via cPanel Git Version Control
- `git pull` lewat SSH jika tersedia

### Catatan repo untuk deploy yang mudah

- repo sengaja membawa `public/build` agar aset Vite production ikut deploy ke cPanel
- repo **tidak** membawa `vendor`, sehingga dependency PHP tetap dipasang lewat `composer install`

### Struktur yang direkomendasikan

```text
/home/CPANEL_USER/parikesit_laravel
  app/
  bootstrap/
  config/
  database/
  public/
  resources/
  routes/
  storage/
  vendor/   <- setelah composer install
```

### Hasil yang diharapkan

- seluruh file aplikasi berada di luar `public_html` kecuali folder `public` bila document root sudah diatur benar

### Cara cek berhasil

- file `artisan` ada di root project
- folder `public/index.php` ada

## Langkah 3 - Siapkan Database cPanel

### Tujuan

Menyediakan database production yang akan dipakai `.env`.

### Panel action

1. Buat database MySQL/MariaDB.
2. Buat user database.
3. Assign user ke database dengan privilege yang diperlukan.
4. Catat:
   - nama database
   - username database
   - password database
   - host database dari provider

### Hasil yang diharapkan

- database bisa diakses dari PHP di hosting yang sama

### Cara cek berhasil

- login ke phpMyAdmin
- lihat database kosong atau siap migrasi

## Langkah 4 - Install Dependency

### Tujuan

Menghasilkan folder `vendor/` dan package yang dibutuhkan Laravel production.

### Command jika SSH/Terminal tersedia

```bash
cd /home/CPANEL_USER/parikesit_laravel
composer install --no-dev --optimize-autoloader
```

### Jika tanpa SSH

- gunakan Composer dari panel jika provider menyediakannya
- bila tidak tersedia, siapkan artefak dari mesin lain dengan versi PHP yang kompatibel lalu upload bersama `vendor/`
- aset frontend Laravel tidak perlu dibuild ulang di cPanel selama `public/build` dari release sudah ikut ter-upload

### Hasil yang diharapkan

- folder `vendor/` terbentuk
- autoload Composer tersedia

### Cara cek berhasil

- file `vendor/autoload.php` ada
- membuka aplikasi tidak gagal karena missing autoload

## Langkah 5 - Isi `.env` Production

### Tujuan

Menyediakan konfigurasi runtime production yang aman dan lengkap.

### Tabel env utama

| Variable | Required | Contoh production | Catatan |
| --- | --- | --- | --- |
| `APP_ENV` | Ya | `production` | Jangan biarkan `local` di server |
| `APP_DEBUG` | Ya | `false` | Wajib `false` untuk production |
| `APP_URL` | Ya | `https://api.example.com` | Dipakai untuk URL storage publik |
| `DB_CONNECTION` | Ya | `mysql` | Sesuai template repo |
| `DB_HOST` | Ya | `localhost` atau host provider | Bergantung provider |
| `DB_PORT` | Ya | `3306` | Port database |
| `DB_DATABASE` | Ya | `cpanel_dbname` | Nama database cPanel |
| `DB_USERNAME` | Ya | `cpanel_dbuser` | User database |
| `DB_PASSWORD` | Ya | `strong-password` | Password database |
| `FILESYSTEM_DISK` | Ya | `public` atau `local` sesuai kebijakan | Untuk file publik, pastikan alur storage publik tetap berjalan |
| `QUEUE_CONNECTION` | Ya | `sync` | Default repo saat ini masih `sync` |
| `CORS_ALLOWED_ORIGINS` | Ya | `https://app.example.com` | Jangan biarkan origin dev di production bila tidak perlu |
| `SANCTUM_EXPIRATION` | Ya | `120` | Menit kedaluwarsa token personal access |
| `FIREBASE_PROJECT_ID` | Ya bila tidak pakai `FIREBASE_CREDENTIALS` | `parikesit-fef3a` | Salah satu pola konfigurasi server |
| `FIREBASE_CREDENTIALS` | Ya bila tidak pakai trio env terpisah | `/home/CPANEL_USER/secure/firebase.json` | Disarankan di luar web root |
| `FIREBASE_CLIENT_EMAIL` | Ya bila tidak pakai `FIREBASE_CREDENTIALS` | `firebase-adminsdk-...` | Opsi alternatif |
| `FIREBASE_PRIVATE_KEY` | Ya bila tidak pakai `FIREBASE_CREDENTIALS` | `"-----BEGIN PRIVATE KEY-----\n..."` | Escape newline dengan benar |
| `FIREBASE_REMINDER_TIME` | Ya | `09:00` | Dipakai scheduler reminder |
| `FIREBASE_REMINDER_TIMEZONE` | Ya | `Asia/Bangkok` | Pastikan konsisten dengan operasi tim |

### Contoh `.env` ringkas

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.example.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=cpanel_dbname
DB_USERNAME=cpanel_dbuser
DB_PASSWORD=strong-password

FILESYSTEM_DISK=public
QUEUE_CONNECTION=sync
CORS_ALLOWED_ORIGINS=https://app.example.com
SANCTUM_EXPIRATION=120

FIREBASE_CREDENTIALS=/home/CPANEL_USER/secure/firebase-service-account.json
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Bangkok
```

### Hasil yang diharapkan

- aplikasi punya seluruh env wajib
- tidak ada kredensial rahasia di dalam web root

### Cara cek berhasil

- file `.env` terbaca
- command artisan dapat menggunakan env tanpa error konfigurasi dasar

## Langkah 6 - Generate App Key

### Tujuan

Menghasilkan `APP_KEY` untuk enkripsi Laravel.

### Command

```bash
php artisan key:generate
```

### Hasil yang diharapkan

- `APP_KEY` terisi pada `.env`

### Cara cek berhasil

- `APP_KEY` muncul di `.env`
- tidak ada error `No application encryption key has been specified`

## Langkah 7 - Migrasi Database

### Tujuan

Membuat seluruh tabel yang dibutuhkan aplikasi.

### Command

```bash
php artisan migrate --force
```

### Opsi seed data

Gunakan seed default hanya jika memang diperlukan untuk bootstrap data inti:

```bash
php artisan db:seed --force
```

Catatan:

- `DatabaseSeeder` memasukkan `UserSeeder`, `MasterDataSeeder`, `IndikatorKriteriaSeeder`, dan `PembinaanDemoSeeder` untuk environment `local`
- review isi seeder sebelum dipakai di production

### Hasil yang diharapkan

- tabel aplikasi terbentuk

### Cara cek berhasil

- tabel terlihat di phpMyAdmin
- login atau endpoint dasar dapat mengakses data tanpa error tabel hilang

## Langkah 8 - Siapkan Storage Publik

### Tujuan

Menyediakan URL file upload yang bisa diakses lewat `/storage/...`.

### Kenapa langkah ini wajib

Konfigurasi filesystem repo memakai URL:

```text
APP_URL + /storage
```

Jadi file dokumentasi atau pembinaan tidak akan bisa diunduh publik jika symlink storage tidak ada.

### Command utama

```bash
php artisan storage:link
```

### Hasil yang diharapkan

- `public/storage` menunjuk ke `storage/app/public`

### Cara cek berhasil

- cek adanya `public/storage`
- buka URL file yang valid dengan pola:

```text
https://api.example.com/storage/...
```

### Jika hosting melarang symlink

- gunakan document root yang benar dan cek apakah provider menyediakan symlink
- jika benar-benar tidak didukung, perlu workaround berbasis deploy asset/copy file yang lebih berisiko dan harus diuji khusus
- jangan anggap upload production selesai sebelum file publik bisa diakses

## Langkah 9 - Permission Folder

### Tujuan

Memastikan Laravel dapat menulis cache, session, log, dan file upload.

### Folder penting

- `storage/`
- `bootstrap/cache/`

### Prinsip

- web server harus bisa menulis ke folder tersebut
- hindari permission terlalu longgar tanpa alasan

### Cara cek berhasil

- tidak ada error write permission di log
- upload file berjalan
- cache config/view dapat dibuat

## Langkah 10 - Cache dan Optimasi Dasar

### Tujuan

Menyelaraskan cache Laravel setelah env production terpasang.

### Command

```bash
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Hasil yang diharapkan

- cache runtime terbuat ulang sesuai env production

### Cara cek berhasil

- tidak ada error syntax/config saat command dijalankan

## Langkah 11 - Konfigurasi Cron Scheduler

### Tujuan

Menjalankan job Laravel scheduler secara otomatis di cPanel.

### Job aktif saat ini

- `reminders:send-opd-form`
  - jadwal: setiap hari pada `FIREBASE_REMINDER_TIME`
  - timezone: `FIREBASE_REMINDER_TIMEZONE` atau timezone aplikasi
- `notifications:prune-hidden`
  - jadwal: setiap hari pukul `01:00`

### Command cron cPanel

```bash
* * * * * php /home/CPANEL_USER/parikesit_laravel/artisan schedule:run >> /dev/null 2>&1
```

Jika provider butuh path PHP penuh, gunakan binary PHP yang diberikan hosting, misalnya:

```bash
* * * * * /usr/local/bin/php /home/CPANEL_USER/parikesit_laravel/artisan schedule:run >> /dev/null 2>&1
```

### Hasil yang diharapkan

- scheduler dipanggil setiap menit
- command harian berjalan sesuai jadwal

### Cara cek berhasil

- jalankan `php artisan schedule:list` bila tersedia akses terminal
- pantau log dan hasil reminder pada jam yang dikonfigurasi

## Langkah 12 - Verifikasi Akhir

### Checklist operasional

- domain API sudah HTTPS dan membuka aplikasi dengan benar
- `APP_URL` sesuai domain publik
- login API berhasil
- endpoint profil berhasil
- upload file berhasil
- download file berhasil
- URL `/storage/...` valid
- token FCM dapat tersimpan
- command reminder manual berhasil
- cron scheduler aktif
- log awal deploy bebas dari error fatal

### Endpoint cek cepat

- `POST /api/login`
- `GET /api/profile`
- `GET /api/notifications`

## Jalur Tanpa SSH atau Tanpa Custom Document Root

Gunakan jalur ini hanya jika provider tidak memberi opsi yang lebih baik.

### Opsi manual yang biasa dipakai

1. Taruh source Laravel lengkap di folder non-publik, misalnya `/home/CPANEL_USER/parikesit_laravel`.
2. Salin isi folder `public/` ke `public_html/`.
3. Edit `public_html/index.php` agar path ke `vendor/autoload.php` dan `bootstrap/app.php` menunjuk ke folder project sebenarnya.

### Risiko

- lebih mudah salah path saat update
- deploy ulang lebih rawan drift
- storage link dan asset publik harus dicek lebih teliti

### Rekomendasi

Jika memungkinkan, minta provider mengubah document root ke folder `public` Laravel daripada mempertahankan pola copy manual.

## Hardening Minimum

- set `APP_DEBUG=false`
- wajib pakai HTTPS
- batasi `CORS_ALLOWED_ORIGINS` ke origin yang benar-benar diperlukan
- simpan kredensial Firebase di luar `public_html`
- jangan commit `.env`, service account JSON, atau secret lain ke Git
- review permission file agar tidak terlalu permisif

## Troubleshooting

### Error 500 setelah deploy

- cek `storage/logs/laravel.log`
- cek dependency `vendor/` lengkap
- cek `.env` dan `APP_KEY`
- cek permission `storage/` dan `bootstrap/cache/`

### Migrasi gagal

- cek kredensial `DB_*`
- cek host database dan privilege user
- jalankan ulang setelah koneksi database valid

### Upload file tidak terbaca

- cek `FILESYSTEM_DISK`
- cek permission `storage/`
- cek apakah file masuk ke `storage/app/public`

### `/storage/...` 404

- cek `php artisan storage:link`
- cek `APP_URL`
- cek apakah `public/storage` benar-benar ada dan terbaca web server

### Notifikasi tidak terkirim

- cek env Firebase server
- jalankan `php artisan reminders:send-opd-form`
- cari warning `Firebase sender skipped because configuration is incomplete.`

### Token FCM tidak tersimpan

- cek backend bisa menerima `POST /api/me/devices/fcm-token`
- cek user login adalah role `opd`
- cek konektivitas app ke domain production

### Cron tidak jalan

- cek Cron Jobs cPanel
- cek path binary PHP
- cek path `artisan`
- jalankan command manual untuk memastikan scheduler sendiri tidak error

### `APP_URL` atau origin salah

- file URL bisa mengarah ke domain lama
- CORS bisa menolak origin baru
- perbaiki `.env`, lalu jalankan ulang `php artisan config:cache`

## Referensi

- [Operasi pascadeploy](operations-postdeploy.md)
- [Firebase dan FCM end-to-end](../../parikesit_flutter/docs/firebase-fcm.md)
- [Mobile production Android](../../parikesit_flutter/docs/mobile-production.md)
