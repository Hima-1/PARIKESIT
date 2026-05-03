# Dokumentasi Parikesit Git

Mulai dari halaman ini saat menyiapkan komputer baru atau onboarding developer lain.

## Urutan Baca

1. Selesaikan [Prasyarat](01-prasyarat.md).
2. Pilih salah satu stack database backend:
   - [Setup backend dengan XAMPP](02-backend-xampp.md)
   - [Setup backend dengan Laragon](03-backend-laragon.md)
3. Jalankan client mobile dengan [panduan emulator Android, USB, atau Wi-Fi](04-menjalankan-aplikasi-mobile.md).
4. Gunakan [port forwarding dan jaringan perangkat](05-port-forwarding-dan-jaringan.md) jika aplikasi tidak bisa menjangkau API.
5. Baca [pemecahan masalah](07-pemecahan-masalah.md) untuk kendala umum Windows, Laravel, MySQL, Flutter, dan Android.
6. Lihat [struktur proyek](06-struktur-proyek.md) sebelum menambah file, dependency, atau konfigurasi baru.

## Default Penting

| Item | Default |
| --- | --- |
| Path Laravel | `laravel` |
| Path Flutter | `flutter` |
| Server API | `http://127.0.0.1:8000/api` |
| API base emulator Android | `http://10.0.2.2:8000` |
| API base USB debugging dengan `adb reverse` | `http://127.0.0.1:8000` |
| Nama database | `parikesit` |
| User MySQL lokal XAMPP/Laragon | `root` |
| Password MySQL lokal XAMPP/Laragon | kosong, kecuali sudah diubah |

## Dokumentasi Source

Dokumentasi framework bawaan tetap berada di masing-masing aplikasi:

- Laravel: `laravel/docs`
- Flutter: `flutter/docs`
