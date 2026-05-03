# Parikesit Git

Parikesit Git is a monorepo wrapper for the Parikesit Laravel backend and Android-first Flutter client.

This repository keeps the fork lineage intact for attribution:

- Fork: `https://github.com/Hima-1/PARIKESIT`
- Upstream/original owner: `https://github.com/selicel/PARIKESIT`

## Repository Layout

```text
parikesit_git/
  laravel/   Laravel 10 web app and Sanctum API
  flutter/   Flutter Android client
docs/        Zero-to-running setup and operating guides
```

The source projects were copied into `parikesit_git/laravel` and `parikesit_git/flutter`. Local dependency folders, generated builds, private environment files, uploads, logs, Android signing files, and Firebase JSON files are intentionally ignored.

## Fast Start

1. Install the prerequisites in [docs/prerequisites.md](docs/prerequisites.md).
2. Start MySQL with either XAMPP or Laragon.
3. Configure and run the backend:

```powershell
cd parikesit_git\laravel
composer install
npm install
Copy-Item .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
```

4. In a second terminal, run the frontend for an Android emulator:

```powershell
cd parikesit_git\flutter
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

For a physical Android device over USB, run:

```powershell
adb reverse tcp:8000 tcp:8000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

## Default Seed Accounts

After `php artisan migrate:fresh --seed`, use these development accounts:

| Role | Email | Password |
| --- | --- | --- |
| Admin | `admin@gmail.com` | `password` |
| Walidata | `diskominfo@klaten.go.id` | `password` |
| OPD example | `inspektorat@klaten.go.id` | `password` |

## Documentation

- [Prerequisites](docs/prerequisites.md)
- [XAMPP backend setup](docs/backend-xampp.md)
- [Laragon backend setup](docs/backend-laragon.md)
- [Android emulator, USB, and Wi-Fi running guide](docs/mobile-running.md)
- [Port forwarding and device networking](docs/port-forwarding.md)
- [Project structure and repository hygiene](docs/project-structure.md)
- [Troubleshooting](docs/troubleshooting.md)

Existing framework-specific documentation remains under `parikesit_git/laravel/docs` and `parikesit_git/flutter/docs`.
