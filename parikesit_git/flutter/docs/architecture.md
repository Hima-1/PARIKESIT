# Arsitektur dan Alur

## Ringkasan

Parikesit Flutter adalah aplikasi Android-first untuk workflow penilaian statistik sektoral. Frontend dibangun dengan Flutter, Riverpod, Dio, dan GoRouter. Backend utama berada di Laravel API dengan autentikasi Sanctum.

## Role

- `opd`: membuat formulir, mengisi penilaian mandiri, mengunggah bukti dukung, melihat hasil
- `walidata`: meninjau hasil OPD, melakukan koreksi, memonitor progres review
- `admin`: mengevaluasi hasil akhir, mengelola user, mengelola dokumentasi dan pembinaan, mengirim reminder OPD

## Modul Flutter

- `auth`: login, profil, ganti password
- `home`: dashboard berbasis role
- `assessment`: formulir, penilaian mandiri, koreksi, evaluasi
- `notifications`: inbox notifikasi dan integrasi FCM
- `pembinaan`: dokumentasi kegiatan dan pembinaan
- `admin`: dashboard admin, manajemen user, dokumentasi terpusat

## Alur Bisnis

### Penilaian

1. OPD membuat formulir.
2. OPD mengisi nilai, catatan, dan bukti dukung per indikator.
3. Walidata meninjau dan mengisi koreksi.
4. Admin melakukan evaluasi akhir.
5. OPD melihat hasil perbandingan dan progres.

### Dokumentasi

- Semua role di Flutter dapat mengakses dokumentasi kegiatan.
- Admin memiliki akses tambahan ke pembinaan dan dokumentasi terpusat.

### Notifikasi

- Backend menyimpan inbox notification per user.
- Mobile mendaftarkan FCM token per perangkat.
- Tap notifikasi dapat mengarahkan user ke route tertentu jika `target_route` tersedia.

## Akses Route Flutter

- `opd`: formulir, penilaian mandiri, dokumentasi kegiatan, notifikasi, profil
- `walidata`: review penilaian selesai, dokumentasi kegiatan, notifikasi, profil
- `admin`: dashboard admin, evaluasi, user management, dokumentasi kegiatan, pembinaan, notifikasi, profil

## Catatan Implementasi Penting

- Login API saat ini memakai `email`, bukan `username`
- Reminder OPD dipicu admin dari endpoint user management
- Password plaintext tidak lagi menjadi bagian model user
- Ada mismatch yang masih perlu diperhatikan:
  - Flutter sudah punya flow review indikator lintas OPD untuk walidata
  - Guard backend `GET /api/formulir/{formulir}/indicators?user_id=...` saat ini masih membatasi admin atau owner formulir
