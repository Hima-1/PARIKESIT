# Peta UI

Dokumen ini merangkum screen yang benar-benar tersedia di aplikasi Flutter.

## OPD

- Login: `POST /api/login`
- Dashboard: `GET /api/dashboard/stats`
- Profil: `GET /api/profile`, `PATCH /api/profile`
- List formulir: `GET /api/formulir`
- Buat formulir: `POST /api/formulir`
- Detail formulir: `GET /api/formulir/{formulir}` atau `GET /api/formulir/{formulir}/indicators`
- Isi penilaian indikator: `POST /api/formulir/{formulir}/indikator/{indikator}/penilaian`
- Riwayat penilaian selesai: `GET /api/penilaian-selesai`
- Detail skor sendiri: `GET /api/penilaian-selesai/{formulir}/opd/{user}/stats`
- Ringkasan domain sendiri: `GET /api/penilaian-selesai/{formulir}/opd/{user}/domains`
- Notifikasi: `/api/notifications*`
- Dokumentasi kegiatan: `/api/dokumentasi*`

## Walidata

- Login, dashboard, profil
- List formulir selesai: `GET /api/penilaian-selesai`
- List OPD per formulir: `GET /api/penilaian-selesai/{formulir}/opds`
- Statistik OPD: `GET /api/penilaian-selesai/{formulir}/opd/{user}/stats`
- Review domain: `GET /api/penilaian-selesai/{formulir}/opd/{user}/domains`
- Detail indikator OPD: `GET /api/formulir/{formulir}/indicators?user_id={opdId}`
- Submit koreksi: `POST /api/penilaian-selesai/koreksi`
- Notifikasi: `/api/notifications*`
- Dokumentasi kegiatan: `/api/dokumentasi*`

Catatan:

- Flutter sudah punya flow review indikator lintas OPD
- Detail indikator lintas OPD didukung lewat endpoint `GET /api/formulir/{formulir}/indicators?user_id=...` untuk `walidata` dan `admin`

## Admin

- Login, dashboard, profil
- List formulir selesai: `GET /api/penilaian-selesai`
- List OPD per formulir: `GET /api/penilaian-selesai/{formulir}/opds`
- Detail OPD: `GET /api/formulir/{formulir}/indicators?user_id={opdId}`
- Ringkasan domain OPD: `GET /api/penilaian-selesai/{formulir}/opd/{user}/domains`
- Submit evaluasi: `POST /api/penilaian-selesai/evaluasi`
- User management: `/api/users*`
- Reminder OPD: `POST /api/users/{user}/trigger-opd-reminder`
- Dokumentasi kegiatan: `/api/dokumentasi*`
- Pembinaan: `/api/pembinaan*`
- Notifikasi: `/api/notifications*`
