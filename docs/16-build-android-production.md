# 16. Build Android Production

Dokumen ini untuk membuat APK/AAB Flutter yang mengarah ke backend production.

## 1. Input Wajib

| Input | Wajib | Keterangan |
| --- | --- | --- |
| `API_BASE_URL` | Ya | Domain API production, contoh `https://api.example.com` |
| `API_PREFIX` | Tidak | Default `/api` |
| `google-services.json` | Ya jika notifikasi dipakai | File Firebase Android |
| `firebase_options.dart` | Ya | Output FlutterFire |
| Keystore release | Ya untuk distribusi nyata | Signing APK/AAB |
| Domain HTTPS valid | Ya | Android production harus memakai HTTPS |

## 2. `.env` Flutter Production

Di `flutter/.env`:

```dotenv
API_BASE_URL=https://api.example.com
API_PREFIX=/api
LOGIN_STARTUP_PROBE=false
LOGIN_PROBE_BYPASS_AUTH_INIT=false
LOGIN_PROBE_DISABLE_CUSTOM_PAINT=false
LOGIN_PROBE_DISABLE_DIO_LOGGER=false
LOGIN_PROBE_DISABLE_PROVIDER_OBSERVER=false
LOGIN_PROBE_SKIP_SECURE_STORAGE_READ=false
LOGIN_PROBE_SKIP_NOTIFICATION_INIT=false
```

Jangan tambahkan `/api` ke `API_BASE_URL` jika `API_PREFIX=/api`.

## 3. Build APK

```powershell
cd flutter
flutter build apk --release --dart-define-from-file=.env
```

## 4. Build App Bundle

```powershell
cd flutter
flutter build appbundle --release --dart-define-from-file=.env
```

## 5. Signing Release

Repo saat ini masih perlu validasi signing release sebelum distribusi nyata. Jangan mengandalkan debug signing untuk production.

File yang tidak boleh di-commit:

- `android/key.properties`
- `android/app/*.keystore`
- `android/app/*.jks`

## 6. Firebase Production

Pastikan:

- `flutter/android/app/google-services.json` dari Firebase production.
- `flutter/lib/firebase_options.dart` dari project yang sama.
- Android `applicationId` cocok dengan app Firebase.

Catatan saat ini: `flutter/android/app/build.gradle.kts` masih memakai `applicationId = "com.example.testing"`. Jika package name diganti, Firebase app Android juga harus diganti atau ditambah ulang.

## 7. Validasi APK/AAB

Install hasil build ke device uji, lalu cek:

1. Aplikasi terbuka.
2. Login ke API production berhasil.
3. Dashboard memuat data.
4. Upload file kecil berhasil.
5. Token FCM tersimpan di backend.
6. Notifikasi foreground/background diterima.

## 8. Error Umum

| Gejala | Kemungkinan penyebab |
| --- | --- |
| APK terpasang tapi gagal login | `API_BASE_URL` salah, domain belum HTTPS, backend belum siap |
| App masih mengarah ke server lokal | Build tanpa `--dart-define-from-file=.env` |
| Notifikasi tidak jalan | `google-services.json` dan `firebase_options.dart` tidak sinkron |
| Token FCM tidak masuk backend | User bukan OPD, izin notifikasi ditolak, API tidak reachable |
