# API Mobile

Dokumen ini merangkum endpoint backend yang dipakai aplikasi Flutter.

## Umum

- Prefix API: `/api`
- Autentikasi: `Authorization: Bearer {token}`
- Format umum: JSON
- Upload file: `multipart/form-data`
- Download file: ZIP

## Auth dan Profil

- `POST /api/login`
- `POST /api/logout`
- `GET /api/user`
- `GET /api/profile`
- `PATCH /api/profile`
- `POST /api/profile/update`

Body login:

```json
{
  "email": "user@example.com",
  "password": "secret"
}
```

## Dashboard

- `GET /api/dashboard/stats`
- `GET /api/dashboard/performa-opd`
- `GET /api/dashboard/progress-penilaian`

## Penilaian

### OPD

- `GET /api/formulir`
- `POST /api/formulir`
- `GET /api/formulir/{formulir}`
- `PATCH /api/formulir/{formulir}`
- `DELETE /api/formulir/{formulir}`
- `POST /api/formulir/{formulir}/set-default-children`
- `POST /api/formulir/{formulir}/domains`
- `GET /api/formulir/{formulir}/indicators`
- `POST /api/formulir/{formulir}/indikator/{indikator}/penilaian`

Catatan:

- Submit penilaian bersifat upsert
- Endpoint indikator menerima upload `bukti_dukung[]`

### Review dan Evaluasi

- `GET /api/penilaian-selesai`
- `GET /api/penilaian-selesai/{formulir}/opds`
- `GET /api/penilaian-selesai/{formulir}/summary`
- `GET /api/penilaian-selesai/{formulir}/opd/{user}/stats`
- `GET /api/penilaian-selesai/{formulir}/opd/{user}/domains`
- `POST /api/penilaian-selesai/koreksi`
- `POST /api/penilaian-selesai/evaluasi`

Catatan:

- Koreksi hanya boleh dilakukan `walidata`
- Evaluasi hanya boleh dilakukan `admin`
- `GET /api/formulir/{formulir}/indicators?user_id={opdId}` dipakai Flutter untuk detail OPD, tetapi saat ini guard backend masih belum sepenuhnya cocok untuk walidata lintas OPD

## Dokumentasi dan Pembinaan

### Dokumentasi Kegiatan

- `GET /api/dokumentasi`
- `POST /api/dokumentasi`
- `GET /api/dokumentasi/{dokumentasi}`
- `PATCH /api/dokumentasi/{dokumentasi}`
- `POST /api/dokumentasi/{dokumentasi}`
- `DELETE /api/dokumentasi/{dokumentasi}`
- `GET /api/dokumentasi/{dokumentasi}/download`
- `GET /api/dokumentasi/download-batch`
- `DELETE /api/file-dokumentasi/{fileDok}`

### Pembinaan

- `GET /api/pembinaan`
- `POST /api/pembinaan`
- `GET /api/pembinaan/{pembinaan}`
- `PATCH /api/pembinaan/{pembinaan}`
- `POST /api/pembinaan/{pembinaan}`
- `DELETE /api/pembinaan/{pembinaan}`
- `GET /api/pembinaan/{pembinaan}/download`
- `GET /api/pembinaan/download-batch`
- `DELETE /api/file-pembinaan/{filePemb}`

Catatan:

- Di Flutter, akses pembinaan aktif untuk admin

## Notifikasi

- `POST /api/me/devices/fcm-token`
- `DELETE /api/me/devices/fcm-token`
- `GET /api/notifications`
- `PATCH /api/notifications/read-all`
- `PATCH /api/notifications/{notification}/read`
- `DELETE /api/notifications/{notification}`
- `DELETE /api/notifications/read`

## Admin Only

- `GET /api/users`
- `POST /api/users`
- `GET /api/users/{user}`
- `PATCH /api/users/{user}`
- `DELETE /api/users/{user}`
- `POST /api/users/{user}/reset-password`
- `POST /api/users/{user}/trigger-opd-reminder`

## Referensi Backend Lengkap

Dokumentasi backend yang lebih rinci ada di `../../parikesit_laravel/API_DOCUMENTATION.md`.
