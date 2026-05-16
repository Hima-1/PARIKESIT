# Dokumentasi Parikesit Git

Semua dokumentasi proyek dipusatkan di folder `docs` ini. Mulai dari halaman ini jika Anda baru clone repo, menyiapkan komputer baru, menjalankan aplikasi, atau menyiapkan release.

## Jalur Cepat Untuk Pemula

Ikuti urutan ini tanpa melompat:

1. [01. Ringkasan Proyek](01-ringkasan-proyek.md)
2. [02. Prasyarat Komputer](02-prasyarat.md)
3. [03. Git dan File Rahasia](03-git-dan-file-rahasia.md)
4. [04. Konfigurasi Environment](04-konfigurasi-env.md)
5. [05. Setup Backend Lokal](05-setup-backend-lokal.md)
6. [06. Menjalankan Flutter Android](06-menjalankan-mobile.md)
7. [07. Jaringan Android dan Port Forwarding](07-jaringan-android.md)
8. [08. Firebase dan FCM](08-firebase-fcm.md) jika ingin menguji notifikasi
9. [09. Testing dan Verifikasi](09-testing-dan-verifikasi.md)
10. [19. Pemecahan Masalah](19-pemecahan-masalah.md)

## Dokumentasi Teknis

| No | Dokumen | Isi utama |
| --- | --- | --- |
| 01 | [Ringkasan Proyek](01-ringkasan-proyek.md) | Fungsi aplikasi, role, komponen Laravel dan Flutter |
| 02 | [Prasyarat](02-prasyarat.md) | Tool yang harus terpasang di Windows |
| 03 | [Git dan File Rahasia](03-git-dan-file-rahasia.md) | Remote, branch, `.gitignore`, file yang boleh/tidak boleh commit |
| 04 | [Konfigurasi Environment](04-konfigurasi-env.md) | `.env` Laravel, `.env` Flutter, local/testing/production |
| 05 | [Setup Backend Lokal](05-setup-backend-lokal.md) | XAMPP, Laragon, database, Laravel serve |
| 06 | [Menjalankan Mobile](06-menjalankan-mobile.md) | Emulator, HP USB, HP Wi-Fi, Firebase optional |
| 07 | [Jaringan Android](07-jaringan-android.md) | `127.0.0.1`, `10.0.2.2`, `adb reverse`, firewall |
| 08 | [Firebase dan FCM](08-firebase-fcm.md) | Client Android, Laravel service account, notifikasi |
| 09 | [Testing](09-testing-dan-verifikasi.md) | Laravel test, Flutter test, integration test |
| 10 | [Struktur Proyek](10-struktur-proyek.md) | Folder penting dan aturan penempatan file |
| 11 | [API Mobile](11-api-mobile.md) | Endpoint yang dipakai Flutter |
| 12 | [Arsitektur dan UI](12-arsitektur-dan-ui.md) | Modul Flutter, flow role, design system |
| 13 | [Basis Data](13-basis-data.md) | Entitas, relasi, lampiran SQL |
| 14 | [Deployment Overview](14-deployment-overview.md) | Gambaran deployment Laravel, Android, Firebase |
| 15 | [Hosting cPanel](15-hosting-cpanel.md) | Runbook backend production |
| 16 | [Build Android Production](16-build-android-production.md) | APK/AAB, signing, API production |
| 17 | [Operasi Postdeploy](17-operasi-postdeploy.md) | Update, rollback, cache, rotasi credential |
| 18 | [Use Case](18-use-case.md) | Alur bisnis dari sudut pengguna |
| 19 | [Pemecahan Masalah](19-pemecahan-masalah.md) | Error umum dan cara memperbaiki |
| 20 | [Catatan Audit](20-catatan-audit.md) | Security, seeder, dan catatan arsitektur |

## Default Lokal

| Item | Nilai |
| --- | --- |
| Folder Laravel | `laravel` |
| Folder Flutter | `flutter` |
| Database lokal | `parikesit` |
| User MySQL lokal | `root` |
| Password MySQL lokal | kosong, kecuali Anda mengubahnya |
| Laravel lokal | `http://127.0.0.1:8000` |
| API Laravel lokal | `http://127.0.0.1:8000/api` |
| API untuk emulator Android Studio | `http://10.0.2.2:8000` |
| API untuk HP USB dengan `adb reverse` | `http://127.0.0.1:8000` |

## Lampiran

- SQL basis data: [reference/01-basis-data.sql](reference/01-basis-data.sql)
- Snapshot schema mobile: [reference/02-schema-snapshot.sql](reference/02-schema-snapshot.sql)
- Catatan internal: [internal/](internal/)
