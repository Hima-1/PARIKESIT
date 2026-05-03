# 02. Setup Backend dengan XAMPP

Gunakan XAMPP jika ingin service MySQL lokal yang sederhana dan tersedia phpMyAdmin.

## 1. Jalankan MySQL

1. Buka XAMPP Control Panel.
2. Jalankan `MySQL`.
3. Apache opsional jika Laravel dijalankan dengan `php artisan serve`.
4. Jika MySQL gagal berjalan, kemungkinan service database lain memakai port `3306`.

## 2. Buat Database

Buka [http://localhost/phpmyadmin](http://localhost/phpmyadmin), lalu buat database bernama:

```text
parikesit
```

Pilih collation `utf8mb4_unicode_ci` jika phpMyAdmin menanyakannya.

## 3. Konfigurasi Laravel

```powershell
cd laravel
composer install
npm install
Copy-Item .env.example .env
php artisan key:generate
```

Pastikan nilai `.env` berikut:

```dotenv
APP_NAME=Parikesit
APP_URL=http://127.0.0.1:8000
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=parikesit
DB_USERNAME=root
DB_PASSWORD=
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000
```

Jika password `root` MySQL di XAMPP sudah diubah, isi `DB_PASSWORD` dengan password tersebut.

## 4. Bangun Database

```powershell
php artisan migrate:fresh --seed
php artisan storage:link
```

Perintah ini membuat schema, master data, dan user development.

## 5. Jalankan Laravel

Terminal 1:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

Terminal 2:

```powershell
npm run dev
```

Buka:

- Web app: [http://127.0.0.1:8000](http://127.0.0.1:8000)
- API base: [http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)

## 6. Smoke Test

```powershell
php artisan route:list --path=api --except-vendor
php artisan test
```

Jika test memakai SQLite in-memory, biarkan `.env.testing` sesuai commit.
