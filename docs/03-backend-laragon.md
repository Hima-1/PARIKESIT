# 03. Setup Backend dengan Laragon

Gunakan Laragon jika ingin environment PHP/MySQL Windows yang ringan, terminal bersih, dan mudah mengganti service.

## 1. Jalankan Laragon

1. Buka Laragon.
2. Klik `Start All`.
3. Pastikan MySQL berjalan.
4. Buka Laragon Terminal dari menu Laragon agar path PHP, Composer, Node, dan MySQL otomatis tersedia.

## 2. Buat Database

Gunakan salah satu opsi berikut:

- Menu Laragon: `Database > Create database`
- HeidiSQL dari Laragon
- MySQL CLI:

```powershell
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS parikesit CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

User MySQL lokal default Laragon biasanya `root` dengan password kosong, kecuali sudah diubah.

## 3. Konfigurasi Laravel

```powershell
cd laravel
composer install
npm install
Copy-Item .env.example .env
php artisan key:generate
```

Jika `npm install` gagal karena konflik peer dependency antara `laravel-vite-plugin` dan `vite`, gunakan:

```powershell
npm install --legacy-peer-deps
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
```

Jika port MySQL Laragon bukan `3306`, sesuaikan `DB_PORT`.

## 4. Build dan Jalankan

```powershell
php artisan migrate:fresh --seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
```

Validasi API sebelum menjalankan mobile:

```powershell
php artisan route:list --path=api --except-vendor
php artisan test tests/Feature/Api
```

Di terminal Laragon kedua:

```powershell
npm run dev
```

Gunakan `php artisan serve` agar jaringan mobile konsisten, walaupun virtual host otomatis Laragon aktif.

## 5. Virtual Host Laragon Opsional

Laragon dapat menyajikan aplikasi Laravel lewat virtual host, tetapi contoh mobile di panduan ini memakai port `8000`. Jika memakai virtual host, jalankan Flutter dengan `API_BASE_URL` eksplisit yang mengarah ke virtual host dan pastikan Android dapat me-resolve hostname tersebut.

Untuk perangkat fisik, IP LAN komputer biasanya lebih sederhana:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8000
```
