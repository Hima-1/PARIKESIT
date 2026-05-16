# 05. Setup Backend Lokal

Backend Laravel harus berjalan dulu sebelum aplikasi Flutter bisa login atau mengambil data.

## 1. Pilih XAMPP atau Laragon

Gunakan salah satu saja:

| Pilihan | Cocok untuk |
| --- | --- |
| XAMPP | Pemula yang ingin MySQL dan phpMyAdmin sederhana |
| Laragon | Developer Windows yang ingin terminal dan service lebih ringan |

Panduan command Laravel sama untuk keduanya. Perbedaannya hanya cara menjalankan MySQL dan membuat database.

## 2. Jalankan MySQL

### XAMPP

1. Buka XAMPP Control Panel.
2. Klik `Start` pada `MySQL`.
3. Apache tidak wajib jika Laravel dijalankan dengan `php artisan serve`.

### Laragon

1. Buka Laragon.
2. Klik `Start All`.
3. Buka Laragon Terminal agar PATH PHP, Composer, Node, dan MySQL otomatis tersedia.

## 3. Buat Database

Nama database lokal:

```text
parikesit
```

### Lewat phpMyAdmin XAMPP

1. Buka `http://localhost/phpmyadmin`.
2. Buat database `parikesit`.
3. Pilih collation `utf8mb4_unicode_ci` jika diminta.

### Lewat MySQL CLI

```powershell
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS parikesit CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

Jika MySQL Anda punya password:

```powershell
mysql -uroot -p -e "CREATE DATABASE IF NOT EXISTS parikesit CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

## 4. Install Dependency Laravel

```powershell
cd laravel
composer install
npm install
```

Jika `npm install` gagal karena konflik peer dependency Vite:

```powershell
npm install --legacy-peer-deps
```

## 5. Buat `.env`

```powershell
Copy-Item .env.example .env
php artisan key:generate
```

Ubah `.env` mengikuti [04. Konfigurasi Environment](04-konfigurasi-env.md), terutama:

```dotenv
APP_ENV=local
APP_DEBUG=true
APP_URL=http://127.0.0.1:8000
DB_DATABASE=parikesit
DB_USERNAME=root
DB_PASSWORD=
SESSION_SECURE_COOKIE=false
```

## 6. Bangun Database

```powershell
php artisan migrate:fresh --seed
php artisan storage:link
```

Perintah ini membuat schema, master data, dan akun development.

## 7. Jalankan Backend

Terminal 1:

```powershell
cd laravel
php artisan serve --host=0.0.0.0 --port=8000
```

Terminal 2:

```powershell
cd laravel
npm run dev
```

Buka:

- Web app: `http://127.0.0.1:8000`
- API base: `http://127.0.0.1:8000/api`

## 8. Akun Seed Default

| Role | Email | Password |
| --- | --- | --- |
| Admin | `admin@gmail.com` | `password` |
| Walidata | `diskominfo@klaten.go.id` | `password` |
| Contoh OPD | `dpupr@klaten.go.id` | `password` |

## 9. Cek Backend Berhasil

```powershell
php artisan route:list --path=api --except-vendor
php artisan test tests/Feature/Api
```

Jika test gagal karena database belum siap, ulangi:

```powershell
php artisan migrate:fresh --seed
```
