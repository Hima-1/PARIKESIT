# Firebase dan FCM End-to-End

## Tujuan

Dokumen ini menjelaskan konfigurasi Firebase/FCM dari sisi Android client sampai Laravel server agar notifikasi production dapat berjalan dan mudah dipulihkan saat pindah hosting atau ganti project Firebase.

## Kondisi Saat Ini

- Firebase project aktif di repo: `parikesit-fef3a`
- Output FlutterFire saat ini disimpan di:
  - `firebase.json`
  - `lib/firebase_options.dart`
- Android membaca konfigurasi native dari:
  - `android/app/google-services.json`
- Laravel mengirim FCM melalui HTTP v1 API menggunakan service account

## Arsitektur Singkat

1. Flutter menginisialisasi Firebase lewat `DefaultFirebaseOptions.currentPlatform`.
2. `NotificationService` meminta permission notifikasi, mengambil token FCM, lalu sinkron ke backend.
3. Flutter mengirim token ke `POST /api/me/devices/fcm-token`.
4. Laravel menyimpan token aktif pada tabel `device_tokens`.
5. Saat reminder atau push lain dijalankan, Laravel membuat access token Google OAuth dari service account dan mengirim pesan ke FCM.
6. Jika Firebase mengembalikan error `NotRegistered`, backend menonaktifkan token terkait.

## Source of Truth Repo

| File | Fungsi |
| --- | --- |
| `firebase.json` | Metadata FlutterFire project dan app mapping |
| `lib/firebase_options.dart` | Firebase options yang dipakai Flutter saat runtime |
| `lib/main.dart` | Inisialisasi Firebase di awal aplikasi |
| `lib/features/notifications/data/notification_service.dart` | Registrasi token, foreground/background handling, local notification |
| `lib/features/notifications/data/notification_device_repository.dart` | Payload sinkron token ke API |
| `parikesit_laravel/config/services.php` | Mapping env Firebase server |
| `parikesit_laravel/app/Services/FirebasePushNotificationSender.php` | Implementasi pengiriman FCM server-side |

## Setup Firebase Client Android

### Tujuan

Menjamin APK Android mengarah ke project Firebase yang benar dan FCM dapat diinisialisasi pada startup.

### Prasyarat

- Akses ke Firebase Console
- Android package name yang valid untuk aplikasi production
- File `google-services.json` terbaru

### Langkah konfigurasi

1. Buka Firebase Console dan pilih project yang dipakai untuk production.
2. Pastikan Android app yang terdaftar cocok dengan `applicationId` Android.
3. Unduh `google-services.json` dari Firebase Console.
4. Simpan file tersebut ke `android/app/google-services.json`.
5. Pastikan `lib/firebase_options.dart` juga berasal dari project yang sama.

### Hasil yang diharapkan

- Build Android dapat dijalankan tanpa error konfigurasi Firebase.
- `Firebase.initializeApp()` berhasil saat startup.

### Cara cek berhasil

- Jalankan app di device Android.
- Pastikan tidak ada error inisialisasi Firebase pada startup.
- Login sebagai user `opd`, lalu cek token FCM berhasil dikirim ke backend.

## Regenerasi Konfigurasi FlutterFire

### Kapan perlu dilakukan

- project Firebase berubah
- package name Android berubah
- ingin memisahkan Firebase dev dan production

### Langkah

1. Install FlutterFire CLI jika belum ada.
2. Dari root `parikesit_flutter`, jalankan konfigurasi ulang untuk Android.
3. Pastikan output menulis ulang:
   - `firebase.json`
   - `lib/firebase_options.dart`
4. Ganti `google-services.json` dengan file dari app Firebase yang sama.
5. Ulangi pengujian token FCM.

### Catatan penting

- Saat ini `android/app/build.gradle.kts` masih memakai `applicationId = "com.example.testing"`.
- Jika package name production diubah, Android app di Firebase juga harus dibuat ulang atau diperbarui.
- `lib/firebase_options.dart` dan `google-services.json` harus selalu berasal dari project dan app yang sama.

## Konfigurasi Firebase Server di Laravel

### Tujuan

Menjamin backend dapat mengirim push notification dan reminder FCM tanpa bergantung pada mesin lokal developer.

### Opsi konfigurasi yang didukung

Backend menerima dua pola konfigurasi:

1. `FIREBASE_CREDENTIALS`
   - Bisa berisi path file JSON service account di server
   - Bisa berisi JSON string service account lengkap
2. Trio env terpisah:
   - `FIREBASE_PROJECT_ID`
   - `FIREBASE_CLIENT_EMAIL`
   - `FIREBASE_PRIVATE_KEY`

### Rekomendasi untuk shared hosting/cPanel

Gunakan salah satu pendekatan berikut:

- Simpan file service account JSON di luar `public_html`, lalu isi `FIREBASE_CREDENTIALS=/home/CPANEL_USER/secure/firebase-service-account.json`
- Jika hosting tidak nyaman memakai file terpisah, isi trio env terpisah dan simpan private key dengan escape newline

### Contoh env berbasis path file

```env
FIREBASE_CREDENTIALS=/home/CPANEL_USER/secure/firebase-service-account.json
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Bangkok
```

### Contoh env berbasis field terpisah

```env
FIREBASE_PROJECT_ID=parikesit-fef3a
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@parikesit-fef3a.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEv...\n-----END PRIVATE KEY-----\n"
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Bangkok
```

### Penjelasan private key multi-line

- Laravel mengganti `\n` menjadi baris baru saat membuat JWT ke Google.
- Jika key di-copy sebagai multi-line mentah tanpa escape yang benar, proses `openssl_pkey_get_private()` bisa gagal.
- Simpan private key dalam satu baris dengan `\n` antar baris jika memakai `.env`.

### Hasil yang diharapkan

- Backend bisa memperoleh access token OAuth dari Google.
- Pengiriman FCM dari Laravel berhasil.

### Cara cek berhasil

- Jalankan command reminder secara manual pada server:

```bash
php artisan reminders:send-opd-form
```

- Cek apakah command menghasilkan ringkasan `Reminder sent: X, skipped: Y`.
- Cek log jika ada warning `Firebase sender skipped because configuration is incomplete.` atau error access token.

## Alur Registrasi Token Device

### Payload yang dikirim Flutter

Flutter mengirim data berikut ke `/api/me/devices/fcm-token`:

```json
{
  "token": "<fcm-token>",
  "platform": "android",
  "device_name": "android",
  "app_version": "1.0.0+1"
}
```

### Kondisi agar token tersinkron

- user sudah login
- role user adalah `opd`
- Firebase berhasil diinisialisasi
- device memberikan izin notifikasi
- backend API dapat diakses oleh aplikasi

### Cara cek berhasil

1. Login sebagai user `opd` di device Android.
2. Pastikan request ke `POST /api/me/devices/fcm-token` berstatus sukses.
3. Cek tabel `device_tokens` di database:
   - `token` terisi
   - `is_active = 1`
   - `user_id` sesuai user login

## Dependensi Scheduler terhadap Firebase

Job `reminders:send-opd-form` dijadwalkan di Laravel scheduler dan bergantung langsung pada kredensial Firebase server.

Artinya:

- cron cPanel aktif tetapi kredensial Firebase salah: scheduler jalan, reminder tetap gagal
- kredensial Firebase benar tetapi cron tidak aktif: push reminder tidak pernah dikirim otomatis

Keduanya harus lolos verifikasi sebelum sistem dianggap production-ready.

## Checklist Verifikasi FCM Production

- `google-services.json` cocok dengan app Firebase production
- `lib/firebase_options.dart` cocok dengan project Firebase production
- login Android berhasil
- token FCM masuk ke endpoint `/api/me/devices/fcm-token`
- record `device_tokens` tersimpan aktif
- notifikasi foreground tampil sebagai local notification
- tap notifikasi membuka route yang sesuai jika payload `target_route` ada
- command manual reminder di server berhasil

## Failure Umum dan Recovery

### `Firebase not initialized`

- Penyebab: `firebase_options.dart` tidak sinkron atau konfigurasi native Android hilang
- Recovery: generate ulang FlutterFire config dan pasang `google-services.json` yang benar

### Token FCM tidak tersimpan

- Penyebab: user bukan role `opd`, permission notifikasi ditolak, atau API tidak reachable
- Recovery: login dengan akun OPD, cek izin notifikasi, cek `API_BASE_URL`

### Push server gagal

- Penyebab: env Firebase server kosong atau private key tidak valid
- Recovery: periksa `FIREBASE_CREDENTIALS` atau trio env terpisah, lalu ulangi tes command manual

### Token banyak tetapi tidak aktif

- Penyebab: Firebase menandai token sudah tidak terdaftar
- Recovery: login ulang pada device aktif untuk menghasilkan token baru

## Referensi Tindak Lanjut

- [Deployment stack overview](deployment.md)
- [Mobile production Android](mobile-production.md)
- [Hosting backend cPanel](../../parikesit_laravel/docs/hosting-cpanel.md)
