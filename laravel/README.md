## Environment Files

Project ini memakai 4 file env yang jelas:

1. `.env`
   File lokal aktif untuk development. Tidak di-commit.
2. `.env.example`
   Template utama untuk setup project baru.
3. `.env.testing`
   Konfigurasi khusus automated test.
4. `.env.dusk.local`
   Konfigurasi khusus Laravel Dusk / browser test.

File `env` dan `.env.copy` tidak dipakai lagi karena hanya menduplikasi fungsi template atau env aktif.

## Setup Lokal

1. Copy `.env.example` menjadi `.env`
2. Isi kredensial yang dibutuhkan
3. Jalankan `php artisan key:generate`
4. Jalankan migrasi bila perlu

## Browser Testing

Laravel Dusk dipakai untuk smoke test browser di `tests/Browser/AuthAndProfileSmokeTest.php`.

Alur lokal:

1. Pastikan dependency Composer sudah terpasang.
2. Jalankan app untuk environment Dusk:
   `php artisan serve --env=dusk.local --host=127.0.0.1 --port=8000`
3. Di terminal lain, jalankan:
   `php artisan dusk`

Jika Dusk tidak menemukan browser binary di Windows, isi `DUSK_CHROME_BINARY` di `.env.dusk.local` dengan path Chrome, Chromium, atau Edge yang valid.

Environment Dusk memakai `.env.dusk.local` dan database SQLite `database/dusk.sqlite`.

## Seeder

Seed default aplikasi dijalankan melalui `DatabaseSeeder` dan dipakai untuk bootstrap data inti:

1. `UserSeeder`
2. `MasterDataSeeder`
3. `IndikatorKriteriaSeeder`
4. `PembinaanDemoSeeder` hanya untuk demo ringan di environment `local` dan sekarang dibuat idempotent saat `db:seed` dijalankan ulang.

Seeder manual yang tidak ikut `DatabaseSeeder`:

1. `AuditLogSeeder`
   Jalankan dengan `php artisan db:seed --class=AuditLogSeeder`
2. `MassiveDemoSeeder`
   Jalankan dengan `php artisan db:seed --class=MassiveDemoSeeder`

`MassiveDemoSeeder` dipakai khusus untuk stress test lokal dan tidak memengaruhi jalur seed default.

## Dokumentasi Operasional

- Index dokumentasi Laravel: `docs/README.md`
- Runbook hosting cPanel: `docs/hosting-cpanel.md`
- Operasi pascadeploy: `docs/operations-postdeploy.md`
- Deployment stack end-to-end dari sisi Flutter: `../parikesit_flutter/docs/deployment.md`
