# Parikesit Git

Parikesit Git adalah monorepo untuk backend Laravel Parikesit dan client Flutter Android.

Repositori ini tetap mencatat asal fork untuk atribusi:

- Fork: `https://github.com/Hima-1/PARIKESIT`
- Upstream/pemilik asli: `https://github.com/selicel/PARIKESIT`

## Struktur Repositori

```text
Parikesit_Git/
  laravel/   Aplikasi web Laravel 10 dan API Sanctum
  flutter/   Client Flutter untuk Android
  docs/      Panduan setup dan operasional
```

Source project berada langsung di `laravel` dan `flutter`. Folder dependency lokal, hasil build, file environment privat, upload, log, signing Android, dan file JSON Firebase sengaja diabaikan oleh `.gitignore`.

## Mulai Cepat

1. Ikuti prasyarat di [01. Prasyarat](docs/01-prasyarat.md).
2. Jalankan MySQL dengan XAMPP atau Laragon.
3. Konfigurasi dan jalankan backend:

```powershell
cd laravel
composer install
npm install
Copy-Item .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
```

4. Di terminal kedua, jalankan frontend untuk emulator Android:

```powershell
cd flutter
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Untuk perangkat Android fisik melalui USB:

```powershell
adb reverse tcp:8000 tcp:8000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## Akun Seed Default

Setelah `php artisan migrate:fresh --seed`, gunakan akun development berikut:

| Role | Email | Password |
| --- | --- | --- |
| Admin | `admin@gmail.com` | `password` |
| Walidata | `diskominfo@klaten.go.id` | `password` |
| Contoh OPD | `dpupr@klaten.go.id` | `password` |

## Urutan Dokumentasi

1. [Prasyarat](docs/01-prasyarat.md)
2. [Setup backend dengan XAMPP](docs/02-backend-xampp.md)
3. [Setup backend dengan Laragon](docs/03-backend-laragon.md)
4. [Menjalankan aplikasi mobile](docs/04-menjalankan-aplikasi-mobile.md)
5. [Port forwarding dan jaringan perangkat](docs/05-port-forwarding-dan-jaringan.md)
6. [Struktur proyek dan kebersihan repositori](docs/06-struktur-proyek.md)
7. [Pemecahan masalah](docs/07-pemecahan-masalah.md)

Dokumentasi bawaan framework tetap tersedia di `laravel/docs` dan `flutter/docs`.

## Smoke Test E2E Lokal

Untuk validasi Laragon + emulator Android dari database bersih:

```powershell
cd laravel
php artisan migrate:fresh --seed --force
php artisan test tests/Feature/Api
php artisan serve --host=0.0.0.0 --port=8000
```

Di terminal Flutter:

```powershell
cd flutter
flutter test --dart-define=API_BASE_URL=http://127.0.0.1:8000
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

Gunakan `LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true` hanya untuk automation Android agar dialog permission notifikasi tidak memblokir test.
