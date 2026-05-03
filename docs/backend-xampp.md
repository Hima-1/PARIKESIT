# Backend Setup with XAMPP

Use XAMPP when you want a simple local MySQL service and phpMyAdmin.

## 1. Start MySQL

1. Open the XAMPP Control Panel.
2. Start `MySQL`.
3. Apache is optional if you run Laravel with `php artisan serve`.
4. If MySQL fails to start, another database service is probably using port `3306`.

## 2. Create the Database

Open [http://localhost/phpmyadmin](http://localhost/phpmyadmin), create a database named:

```text
parikesit
```

Use `utf8mb4_unicode_ci` when phpMyAdmin asks for collation.

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
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000
```

If you changed the MySQL root password in XAMPP, set `DB_PASSWORD` to that value.

## 4. Build the Database

```powershell
php artisan migrate:fresh --seed
php artisan storage:link
```

This creates the schema, master data, and development users.

## 5. Run Laravel

Terminal 1:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

Terminal 2:

```powershell
npm run dev
```

Open:

- Web app: [http://127.0.0.1:8000](http://127.0.0.1:8000)
- API base: [http://127.0.0.1:8000/api](http://127.0.0.1:8000/api)

## 6. Smoke Test

```powershell
php artisan route:list --path=api --except-vendor
php artisan test
```

If tests use SQLite in memory, keep `.env.testing` as committed.
