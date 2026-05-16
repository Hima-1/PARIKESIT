# 01. Ringkasan Proyek

Parikesit Git adalah monorepo untuk aplikasi PARIKESIT. Di dalam satu repo ini ada dua aplikasi utama:

- `laravel`: backend Laravel 10, web dashboard, API, database, upload file, scheduler, dan pengiriman notifikasi.
- `flutter`: aplikasi Flutter Android yang dipakai oleh OPD, walidata, dan admin/BPS.

## Untuk Apa Aplikasi Ini?

Aplikasi membantu workflow penilaian statistik sektoral:

1. OPD membuat formulir kegiatan statistik.
2. OPD mengisi penilaian mandiri dan mengunggah bukti dukung.
3. Walidata meninjau hasil OPD dan memberi koreksi.
4. Admin/BPS mengevaluasi hasil akhir.
5. Sistem menyimpan notifikasi, dokumentasi kegiatan, pembinaan, dan file pendukung.

## Role Pengguna

| Role | Tugas utama |
| --- | --- |
| `opd` | Mengisi formulir, mengisi nilai, upload bukti dukung, melihat hasil dan notifikasi |
| `walidata` | Melihat penilaian OPD, memberi koreksi, memantau progres |
| `admin` | Evaluasi akhir, manajemen user, dokumentasi, pembinaan, dan reminder OPD |

Di beberapa dokumen lama, role `admin` juga disebut BPS karena admin mewakili fungsi BPS di sistem.

## Komponen Teknis

| Komponen | Teknologi | Fungsi |
| --- | --- | --- |
| Backend | Laravel 10 | API, web dashboard, auth Sanctum, upload, scheduler |
| Database | MySQL/MariaDB | Penyimpanan data utama |
| Mobile | Flutter Android | Client utama untuk pengguna |
| Notifikasi | Firebase Cloud Messaging | Token device dan push notification |
| Build asset web | Vite | Asset dashboard Laravel |

## Alur Komunikasi

```text
Flutter Android
  -> HTTP JSON / multipart
Laravel API
  -> MySQL/MariaDB
  -> Storage file lokal/server
  -> Firebase FCM untuk push notification
```

## Folder Utama

```text
Parikesit_Git/
  README.md
  docs/
  laravel/
  flutter/
```

Gunakan `docs/` sebagai sumber dokumentasi utama. Folder `laravel/docs` dan `flutter/docs` hanya berisi penunjuk ke root docs.
