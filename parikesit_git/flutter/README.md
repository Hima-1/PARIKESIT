# Parikesit Flutter

Aplikasi Flutter Android-only untuk workflow penilaian statistik sektoral PARIKESIT.

## Modul Utama

- `auth`: login, profil, ganti profil, ganti password
- `home`: dashboard berbasis role `opd`, `walidata`, `admin`
- `assessment`: formulir penilaian, penilaian mandiri OPD, koreksi walidata, evaluasi admin
- `notifications`: inbox notifikasi dan integrasi FCM
- `pembinaan`: dokumentasi kegiatan dan dokumentasi pembinaan
- `admin`: dashboard admin, manajemen user, dokumentasi terpusat

## Struktur Singkat

- `lib/core/`: routing, networking, auth, widget dasar, tema
- `lib/features/`: fitur per domain bisnis
- `docs/`: dokumentasi proses, UI, basis data, dan API
- `test/`, `integration_test/`: automated test

## Menjalankan Proyek

1. `flutter pub get`
2. Siapkan backend Laravel dan base URL API sesuai environment
3. Pastikan konfigurasi Firebase Android tersedia di `android/app/google-services.json`
4. Jika notifikasi dipakai, verifikasi `lib/firebase_options.dart` sesuai project Firebase Android
5. Jalankan: `flutter run`

## Testing

- Default lane (unit/widget): `flutter test`
- Satu file: `flutter test test/path/to/file_test.dart`
- Filter nama test: `flutter test --plain-name "name pattern"`
- Integration test: `flutter test integration_test`
- Integration test (single file + Android device):
  `flutter test integration_test/api_journey_test.dart --dart-define=API_BASE_URL=http://127.0.0.1:8000 -d <android_device_id>`

### Guardrails Integration Test

- Jalankan di perangkat Android (emulator/fisik), bukan desktop/web.
- Backend Laravel harus aktif dan akun seed test harus tersedia.
- Selalu set `--dart-define=API_BASE_URL=...` ke host backend yang dapat diakses device.

## Dokumentasi

- Dokumentasi utama: `docs/README.md`
- Ringkasan arsitektur: `docs/architecture.md`
- Kontrak API mobile: `docs/api.md`
- Peta screen: `docs/ui.md`
- Overview deployment stack: `docs/deployment.md`
- Setup Firebase/FCM: `docs/firebase-fcm.md`
- Panduan mobile production Android: `docs/mobile-production.md`
