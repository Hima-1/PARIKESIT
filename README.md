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
  docs/      Dokumentasi utama proyek
```

Source project berada langsung di `laravel` dan `flutter`. Folder dependency lokal, hasil build, file environment privat, upload, log, signing Android, dan file JSON Firebase sengaja diabaikan oleh `.gitignore`.

## Mulai Cepat Lokal

Untuk penjelasan lengkap dan ramah pemula, mulai dari [docs/README.md](docs/README.md).

1. Ikuti [02. Prasyarat](docs/02-prasyarat.md).
2. Baca [03. Git dan File Rahasia](docs/03-git-dan-file-rahasia.md).
3. Siapkan env sesuai [04. Konfigurasi Environment](docs/04-konfigurasi-env.md).
4. Jalankan MySQL dengan XAMPP atau Laragon.
5. Konfigurasi dan jalankan backend:

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

Pastikan `laravel/.env` sudah memakai nilai local seperti `APP_ENV=local`, `APP_DEBUG=true`, dan database `parikesit`.

6. Di terminal kedua, jalankan Flutter untuk emulator Android:

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

## Dokumentasi

Semua dokumentasi proyek dipusatkan di [docs/](docs/README.md). Folder `laravel/docs` dan `flutter/docs` hanya berisi penunjuk ke root docs.

Urutan awal yang disarankan:

1. [01. Ringkasan Proyek](docs/01-ringkasan-proyek.md)
2. [02. Prasyarat](docs/02-prasyarat.md)
3. [03. Git dan File Rahasia](docs/03-git-dan-file-rahasia.md)
4. [04. Konfigurasi Environment](docs/04-konfigurasi-env.md)
5. [05. Setup Backend Lokal](docs/05-setup-backend-lokal.md)
6. [06. Menjalankan Flutter Android](docs/06-menjalankan-mobile.md)
7. [19. Pemecahan Masalah](docs/19-pemecahan-masalah.md)

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
