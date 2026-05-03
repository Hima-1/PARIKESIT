# Backend Setup with Laragon

Use Laragon when you want a lightweight Windows PHP/MySQL environment with clean terminals and easy service switching.

## 1. Start Laragon

1. Open Laragon.
2. Click `Start All`.
3. Confirm MySQL is running.
4. Open Laragon Terminal from the Laragon menu so PHP, Composer, Node, and MySQL paths are loaded.

## 2. Create the Database

Use one of these options:

- Laragon menu: `Database > Create database`
- HeidiSQL from Laragon
- MySQL CLI:

```powershell
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS parikesit CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

Laragon's default local MySQL user is usually `root` with an empty password unless you changed it.

## 3. Configure Laravel

```powershell
cd parikesit_git\laravel
composer install
npm install
Copy-Item .env.example .env
php artisan key:generate
```

Confirm these `.env` values:

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

If your Laragon MySQL port is not `3306`, update `DB_PORT`.

## 4. Build and Run

```powershell
php artisan migrate:fresh --seed
php artisan storage:link
php artisan serve --host=0.0.0.0 --port=8000
```

In a second Laragon terminal:

```powershell
npm run dev
```

Use `php artisan serve` for consistent mobile networking even if Laragon auto virtual hosts are enabled.

## 5. Optional Laragon Virtual Host

Laragon can serve the Laravel app through a virtual host, but the mobile app examples assume port `8000`. If you use a virtual host, run Flutter with an explicit `API_BASE_URL` that points to the virtual host and make sure Android can resolve that hostname.

For a physical device, using the computer LAN IP is usually simpler:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.25:8000
```
