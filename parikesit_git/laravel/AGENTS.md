# AGENTS.md

## Project Overview
This is a Laravel 10 project using Vite, Tailwind CSS, and Alpine.js. It's a management system (PARIKESIT) for evaluations, likely related to government or organizational performance (Aspek, Domain, Indikator).

## Build & Run Commands

### Development
- **Backend:** `php artisan serve`
- **Frontend (Vite):** `npm run dev`
- **Full Setup:** `composer install && npm install && npm run dev`

### Production Build
- **Frontend:** `npm run build`
- **Backend Optimization:** `php artisan optimize`

### Database
- **Migrate:** `php artisan migrate`
- **Seed:** `php artisan db:seed`
- **Refresh & Seed:** `php artisan migrate:fresh --seed`

#### Seeding Notes
- `DatabaseSeeder` menjalankan `UserSeeder` -> `MasterDataSeeder` -> `IndikatorKriteriaSeeder`.
- Master data yang terisi: `domains`, `aspeks`, `indikators`, `formulirs`, `formulir_domains`.
- Seeder dibuat repeatable (aman dijalankan berulang) dengan strategi upsert (`updateOrCreate`).

### Testing
- **Run all tests:** `php artisan test` or `./vendor/bin/pest`
- **Run a single test file:** `php artisan test tests/Unit/ExampleTest.php`
- **Run specific test method:** `php artisan test --filter test_example`
- **Static Analysis (Pint):** `./vendor/bin/pint`

## Code Style & Guidelines

### PHP / Laravel
- **Framework:** Laravel 10.x
- **Testing:** Pest PHP
- **Linting:** Laravel Pint (standard Laravel preset)
- **Naming Conventions:**
  - Controllers: `PascalCaseController` (e.g., `AspekController`)
  - Models: `PascalCase` (e.g., `BuktiDukung`)
  - Migrations: `snake_case` with timestamps
  - Variables/Methods: `camelCase`
- **Imports:**
  - Group imports by type (Internal vs External)
  - Use absolute namespaces in `use` statements.
- **Models:**
  - Always define `$fillable` or `$guarded`.
  - Use Eloquent relationships (belongsTo, hasMany) consistently.
- **Controllers:**
  - Use Resource controllers where possible.
  - Keep logic in Services or Models if it exceeds 10-15 lines.
  - Use `FormRequest` for validation logic.

### Frontend
- **Stack:** Tailwind CSS, Alpine.js, Vite.
- **Components:** Laravel Blade components (found in `app/View/Components` and `resources/views/components`).
- **Styling:** Use Tailwind utility classes directly in Blade files. Avoid custom CSS unless absolutely necessary (add to `resources/css/app.css`).

### Error Handling
- Use Laravel's `Try-Catch` blocks for database transactions or external API calls.
- Return consistent JSON responses for AJAX/API requests.
- Use `abort(404)` or `abort(403)` for unauthorized/not-found access.

## Directories of Interest
- `app/Models`: Database entities.
- `app/Http/Controllers`: Request handling.
- `database/migrations`: Schema definitions.
- `resources/views`: Blade templates.
- `routes/web.php`: Primary routing file.
