# 04. Konfigurasi Environment

Environment adalah nilai konfigurasi yang berbeda antara komputer lokal, test, dan production. Contohnya URL aplikasi, nama database, credential Firebase, dan domain API.

## 1. Prinsip Penting

- File `.env` adalah file lokal dan rahasia.
- File `.env.example` adalah template yang boleh di-commit.
- Jika `.env.example` berubah, dokumentasi ini harus ikut diperbarui.
- Jangan memakai credential production di komputer developer kecuali memang sedang melakukan operasi production.

## 2. Laravel Local

Buat file env:

```powershell
cd laravel
Copy-Item .env.example .env
php artisan key:generate
```

Untuk development lokal, ubah nilai penting menjadi:

```dotenv
APP_NAME=Parikesit
APP_ENV=local
APP_DEBUG=true
APP_URL=http://127.0.0.1:8000
APP_TIMEZONE=Asia/Jakarta

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=parikesit
DB_USERNAME=root
DB_PASSWORD=

SESSION_SECURE_COOKIE=false
CORS_ALLOWED_ORIGINS=http://localhost,http://127.0.0.1:8000,http://10.0.2.2:8000
SANCTUM_EXPIRATION=120
```

Jika MySQL Anda memakai password, isi `DB_PASSWORD`.

## 3. Laravel Testing

Repo membawa `laravel/.env.testing`. Jangan ubah sembarangan. Test Laravel memakai konfigurasi ini saat menjalankan:

```powershell
php artisan test
```

Jika test gagal karena database, cek dulu isi `.env.testing` dan `phpunit.xml`.

## 4. Laravel Production

Production harus lebih ketat:

```dotenv
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.example.com
SESSION_SECURE_COOKIE=true

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=cpanel_dbname
DB_USERNAME=cpanel_dbuser
DB_PASSWORD=strong-password

CORS_ALLOWED_ORIGINS=https://api.example.com
SANCTUM_EXPIRATION=120
```

Jangan biarkan `APP_DEBUG=true` di production.

## 5. Flutter Local

Flutter bisa menerima konfigurasi dengan dua cara:

```powershell
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Atau pakai file:

```powershell
cd flutter
Copy-Item .env.example .env
flutter run --dart-define-from-file=.env
```

Contoh `flutter/.env` untuk emulator Android Studio:

```dotenv
API_BASE_URL=http://10.0.2.2:8000
API_PREFIX=/api
LOGIN_STARTUP_PROBE=false
LOGIN_PROBE_SKIP_NOTIFICATION_INIT=false
```

Contoh untuk HP fisik USB dengan `adb reverse`:

```dotenv
API_BASE_URL=http://127.0.0.1:8000
API_PREFIX=/api
```

Contoh untuk HP fisik lewat Wi-Fi:

```dotenv
API_BASE_URL=http://192.168.1.25:8000
API_PREFIX=/api
```

Ganti `192.168.1.25` dengan IPv4 komputer Anda.

## 6. Firebase Env Laravel

Backend Laravel bisa mengirim FCM jika salah satu konfigurasi ini tersedia:

```dotenv
FIREBASE_CREDENTIALS=/path/aman/firebase-service-account.json
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Jakarta
```

Atau:

```dotenv
FIREBASE_PROJECT_ID=parikesit-fef3a
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@parikesit-fef3a.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEv...\n-----END PRIVATE KEY-----\n"
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Jakarta
```

Simpan service account di luar folder public. Jangan commit JSON service account.

## 7. Setelah Mengubah Env Laravel

Jika Laravel masih membaca nilai lama:

```powershell
php artisan config:clear
php artisan cache:clear
```

Di production, setelah env benar:

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```
