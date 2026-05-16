# 09. Testing dan Verifikasi

Jalankan test setelah setup awal, setelah mengubah fitur, dan sebelum release.

## 1. Test Laravel

```powershell
cd laravel
php artisan test
```

Untuk fokus API:

```powershell
php artisan test tests/Feature/Api
```

Untuk melihat route API:

```powershell
php artisan route:list --path=api --except-vendor
```

## 2. Test Flutter Unit dan Widget

```powershell
cd flutter
flutter test
```

Jika test butuh API lokal:

```powershell
flutter test --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

Untuk fokus navigasi payload notifikasi:

```powershell
flutter test test/features/notifications/data/notification_navigation_test.dart
```

## 3. Integration Test Android

Jalankan backend dulu:

```powershell
cd laravel
php artisan migrate:fresh --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Untuk emulator Android Studio:

```powershell
cd flutter
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

Untuk HP USB:

```powershell
adb reverse tcp:8000 tcp:8000
cd flutter
flutter test integration_test/api_journey_test.dart -d <device_id> --dart-define=API_BASE_URL=http://127.0.0.1:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
```

`LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true` dipakai agar dialog permission notifikasi tidak memblokir automation. Jangan pakai flag itu saat uji manual fitur notifikasi.

## 4. Smoke Suite Mobile

Jalankan dari database seed bersih:

```powershell
$tests = @(
  'integration_test/api_journey_test.dart',
  'integration_test/admin_user_management_test.dart',
  'integration_test/walidata_journey_test.dart',
  'integration_test/walidata_navigation_test.dart',
  'integration_test/opd_journey_test.dart',
  'integration_test/profile_view_test.dart'
)

foreach ($test in $tests) {
  flutter test $test -d <device_id> --dart-define=API_BASE_URL=http://10.0.2.2:8000 --dart-define=LOGIN_PROBE_SKIP_NOTIFICATION_INIT=true
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
```

## 5. Verifikasi Manual Minimal

Setelah aplikasi berjalan:

1. Login sebagai admin.
2. Login sebagai walidata.
3. Login sebagai OPD.
4. Buka dashboard masing-masing role.
5. OPD membuat formulir dan isi satu indikator.
6. Walidata membuka penilaian selesai dan memberi koreksi.
7. Admin membuka hasil dan memberi evaluasi.
8. Upload satu file bukti dukung kecil.
9. Buka notifikasi.
10. Tap notifikasi summary reminder dan pastikan masuk ke Penilaian Mandiri.
11. Tap notifikasi reminder per formulir dan pastikan masuk ke detail kegiatan sesuai `formulirId`.

Jika alur ini lolos, setup lokal sudah cukup sehat untuk development.

## 6. Test Terarah Reminder OPD

Setelah mengubah payload atau rute reminder:

```powershell
cd laravel
php artisan test --filter=OpdFormReminderServiceTest
php artisan test --filter=UserManagementApiTest
```

Kedua test ini mengunci payload reminder Laravel dan endpoint admin untuk trigger reminder OPD.
