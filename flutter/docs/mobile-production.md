# Mobile Production Android

## Tujuan

Dokumen ini menjelaskan input yang wajib tersedia untuk build Android production, cara mengarahkan app ke backend production, dan cara memvalidasi integrasi Firebase/FCM setelah APK atau AAB dibuat.

## Ruang Lingkup

- Flutter saat ini Android-only
- Tidak ada hosting Flutter Web
- Fokus pada build yang terkoneksi ke backend Laravel production

## Input Wajib Sebelum Build

| Input | Required | Contoh | Keterangan |
| --- | --- | --- | --- |
| `API_BASE_URL` | Ya | `https://api.example.com` | Base URL backend production tanpa suffix `/api` bila memakai default prefix |
| `API_PREFIX` | Tidak | `/api` | Default sudah `/api`; ubah hanya jika backend memakai prefix lain |
| `android/app/google-services.json` | Ya bila notifikasi dipakai | file JSON | Konfigurasi native Firebase Android |
| `lib/firebase_options.dart` | Ya | hasil FlutterFire | Dipakai `Firebase.initializeApp()` saat runtime |
| Keystore signing release | Ya untuk distribusi nyata | file keystore | Saat ini repo belum mengatur signing release production |
| Domain HTTPS backend aktif | Ya | `https://api.example.com` | Android production harus memakai HTTPS yang valid |

## Cara Aplikasi Membaca Endpoint API

`lib/core/config/app_config.dart` memakai aturan berikut:

- `API_BASE_URL` dibaca dari `--dart-define-from-file=.env` atau `--dart-define`
- `API_PREFIX` default adalah `/api`
- `fullApiUrl` dibentuk dari `API_BASE_URL + API_PREFIX`

Implikasinya:

- production build **wajib** mengisi `API_BASE_URL` lewat `.env` atau `--dart-define`
- tidak perlu menambahkan `/api` di `API_BASE_URL` jika `API_PREFIX` tetap default

## Contoh Command Build

### APK release

```bash
flutter build apk --release --dart-define-from-file=.env
```

### App Bundle release

```bash
flutter build appbundle --release --dart-define-from-file=.env
```

### Jika prefix API berbeda

Ubah `API_PREFIX` di `.env`, lalu build dengan file env yang sama:

```bash
flutter build apk --release --dart-define-from-file=.env
```

## Device Fisik vs Emulator

### Device fisik

- `127.0.0.1` atau `localhost` hanya masuk akal untuk local debug tertentu, misalnya dengan `adb reverse`
- untuk production, selalu pakai domain publik HTTPS

### Android emulator

- emulator lokal tetap harus memakai `API_BASE_URL` yang dapat dijangkau emulator
- konfigurasi ini hanya relevan untuk development, bukan production

### Production

- gunakan domain publik seperti `https://api.example.com`
- pastikan origin itu juga dimasukkan ke `CORS_ALLOWED_ORIGINS` di backend jika ada client berbasis browser di masa depan

## Checklist Build Production

### Tujuan

Mencegah build production yang secara teknis berhasil tetapi mengarah ke environment yang salah.

### Langkah

1. Pastikan `google-services.json` sesuai project Firebase production.
2. Pastikan `lib/firebase_options.dart` sinkron dengan project yang sama.
3. Tentukan `API_BASE_URL` production di `.env`.
4. Build APK/AAB dengan `--dart-define-from-file=.env`.
5. Install hasil build ke device uji.
6. Login ke backend production.
7. Uji registrasi token FCM dan penerimaan notifikasi.

### Hasil yang diharapkan

- login berhasil
- data utama dapat dimuat dari API production
- token FCM tersimpan di backend production
- notifikasi foreground/background bekerja

### Cara cek berhasil

- buka profil atau dashboard setelah login
- cek database production untuk `device_tokens`
- kirim reminder manual dari backend atau trigger push uji

## Catatan Operasional Saat Ini

- `android/app/build.gradle.kts` masih memakai `applicationId = "com.example.testing"`
- build type `release` masih menggunakan debug signing config

Konsekuensinya:

- sebelum distribusi production nyata, signing release perlu dibereskan
- bila package name diganti, Android app di Firebase harus ikut diganti dan `google-services.json` harus diunduh ulang

Dokumen ini tidak mengubah konfigurasi tersebut; hanya mendokumentasikan kondisi repo saat ini.

## Failure Umum

### APK terpasang tetapi gagal login

- Penyebab umum: `API_BASE_URL` salah, domain belum HTTPS, atau backend belum siap
- Cek: coba buka endpoint `https://domain/api/login` dari perangkat lain

### Build berhasil tetapi notifikasi tidak jalan

- Penyebab umum: `google-services.json` atau `firebase_options.dart` tidak cocok
- Cek: token FCM tidak pernah muncul di backend production

### App mengarah ke server lokal

- Penyebab umum: build dilakukan tanpa `--dart-define-from-file=.env` atau tanpa `API_BASE_URL`
- Cek: log konfigurasi atau perilaku request saat app dibuka

## Acceptance Checklist

- `API_BASE_URL` production sudah dipakai saat build
- `API_PREFIX` sesuai backend
- `google-services.json` terpasang
- `firebase_options.dart` valid
- APK/AAB berhasil dibangun
- login production sukses
- token FCM tersimpan
- notifikasi uji diterima

## Referensi

- [Firebase dan FCM end-to-end](firebase-fcm.md)
- [Deployment stack overview](deployment.md)
- [Runbook hosting cPanel](../../parikesit_laravel/docs/hosting-cpanel.md)
