# 08. Firebase dan FCM

Firebase dipakai untuk push notification Android melalui Firebase Cloud Messaging atau FCM.

## 1. Ringkasan Alur

1. Flutter menginisialisasi Firebase.
2. Aplikasi meminta izin notifikasi ke user.
3. Android menghasilkan token FCM.
4. Flutter mengirim token ke Laravel melalui `POST /api/me/devices/fcm-token`.
5. Laravel menyimpan token di tabel `device_tokens`.
6. Laravel mengirim push notification ke FCM memakai service account.
7. Jika FCM menandai token tidak valid, Laravel menonaktifkan token tersebut.

## 2. File Firebase di Flutter

| File | Fungsi | Commit? |
| --- | --- | --- |
| `flutter/firebase.json` | Metadata FlutterFire | Ya |
| `flutter/lib/firebase_options.dart` | Options Firebase untuk runtime Flutter | Ya |
| `flutter/android/app/google-services.json` | Konfigurasi native Android | Tidak |

`google-services.json` tidak di-commit karena terkait project Firebase. Ambil dari Firebase Console.

## 3. Setup Client Android

1. Buka Firebase Console.
2. Pilih project Firebase yang benar.
3. Pastikan Android app package name cocok dengan `applicationId` di `flutter/android/app/build.gradle.kts`.
4. Unduh `google-services.json`.
5. Simpan ke:

```text
flutter/android/app/google-services.json
```

6. Jalankan:

```powershell
cd flutter
flutter clean
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

Catatan saat ini: Android masih memakai `applicationId = "com.example.testing"`. Jika package name production diganti, Android app di Firebase juga harus disesuaikan dan `google-services.json` harus diunduh ulang.

## 4. Regenerasi FlutterFire

Lakukan jika project Firebase berubah, package name berubah, atau ingin memisahkan dev dan production.

Output yang harus sinkron:

- `flutter/firebase.json`
- `flutter/lib/firebase_options.dart`
- `flutter/android/app/google-services.json`

Jika salah satu berasal dari project berbeda, inisialisasi Firebase atau FCM token bisa gagal.

## 5. Setup Server Laravel

Laravel mendukung dua pola.

### Opsi A: File service account

```dotenv
FIREBASE_CREDENTIALS=/home/CPANEL_USER/secure/firebase-service-account.json
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Jakarta
```

Simpan file JSON di luar web root, bukan di `public_html`.

### Opsi B: Env terpisah

```dotenv
FIREBASE_PROJECT_ID=parikesit-fef3a
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@parikesit-fef3a.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEv...\n-----END PRIVATE KEY-----\n"
FIREBASE_REMINDER_TIME=09:00
FIREBASE_REMINDER_TIMEZONE=Asia/Jakarta
```

Private key harus memakai `\n` untuk baris baru jika disimpan dalam satu baris `.env`.

## 6. Cek Token Masuk

1. Jalankan backend.
2. Jalankan Flutter di device Android.
3. Login sebagai user `opd`.
4. Cek request ke:

```text
POST /api/me/devices/fcm-token
```

5. Cek tabel `device_tokens`:

- `token` terisi
- `is_active = 1`
- `user_id` sesuai user login

## 7. Cek Pengiriman FCM

Di Laravel:

```powershell
php artisan reminders:send-opd-form
```

Hasil yang diharapkan adalah ringkasan jumlah reminder terkirim atau dilewati. Jika muncul warning `Firebase sender skipped because configuration is incomplete.`, env Firebase server belum lengkap.

## 8. Payload dan Navigasi Notifikasi

Payload FCM memakai field `data` untuk menentukan tujuan navigasi Flutter. Resolver rute berada di:

```text
flutter/lib/features/notifications/data/notification_navigation.dart
```

Kontrak saat ini:

| `data.type` | Field pendukung | Tujuan Flutter |
| --- | --- | --- |
| `incomplete_form_summary` | `formulir_ids`, `incomplete_form_count` | `/penilaian-mandiri` |
| `incomplete_form_reminder` | `formulir_id` atau `target_route=/penilaian-kegiatan?formulirId={id}` | `/penilaian-kegiatan?formulirId={id}` |
| `incomplete_form_reminder` tanpa id valid | - | `/penilaian-mandiri` |

Laravel mengirim reminder per formulir ke detail kegiatan jika ada `formulirId`. Summary manual dari admin diarahkan ke daftar penilaian mandiri agar OPD dapat memilih formulir yang belum lengkap.

## 9. Checklist Production

- `google-services.json` cocok dengan app Firebase production.
- `firebase_options.dart` berasal dari project yang sama.
- Android package name cocok.
- Login Android ke API production berhasil.
- Token FCM tersimpan di backend production.
- Command reminder manual berhasil.
- Tap push notification summary membuka Penilaian Mandiri.
- Tap push notification reminder per formulir membuka detail kegiatan dengan `formulirId`.
- Cron Laravel scheduler aktif.
