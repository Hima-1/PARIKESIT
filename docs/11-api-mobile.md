# 11. API Mobile

Dokumen ini merangkum endpoint Laravel yang dipakai aplikasi Flutter.

## 1. Aturan Umum

| Item | Nilai |
| --- | --- |
| Prefix API | `/api` |
| Auth | `Authorization: Bearer {token}` |
| Format umum | JSON |
| Upload file | `multipart/form-data` |
| Download batch | ZIP |

Jika Flutter memakai `API_BASE_URL=http://10.0.2.2:8000` dan `API_PREFIX=/api`, maka URL penuh API adalah:

```text
http://10.0.2.2:8000/api
```

## 2. Auth dan Profil

| Method | Endpoint | Fungsi |
| --- | --- | --- |
| `POST` | `/api/login` | Login |
| `POST` | `/api/logout` | Logout |
| `GET` | `/api/user` | User login |
| `GET` | `/api/profile` | Profil |
| `PATCH` | `/api/profile` | Update profil |
| `POST` | `/api/profile/update` | Update profil alternatif |

Body login:

```json
{
  "email": "user@example.com",
  "password": "secret"
}
```

## 3. Dashboard

| Method | Endpoint |
| --- | --- |
| `GET` | `/api/dashboard/stats` |
| `GET` | `/api/dashboard/performa-opd` |
| `GET` | `/api/dashboard/progress-penilaian` |

## 4. Penilaian OPD

| Method | Endpoint | Fungsi |
| --- | --- | --- |
| `GET` | `/api/formulir` | List formulir |
| `POST` | `/api/formulir` | Buat formulir |
| `GET` | `/api/formulir/{formulir}` | Detail formulir |
| `PATCH` | `/api/formulir/{formulir}` | Update formulir |
| `DELETE` | `/api/formulir/{formulir}` | Hapus formulir |
| `POST` | `/api/formulir/{formulir}/set-default-children` | Isi domain/aspek/indikator default |
| `POST` | `/api/formulir/{formulir}/domains` | Tambah domain ke formulir |
| `GET` | `/api/formulir/{formulir}/indicators` | Ambil indikator |
| `POST` | `/api/formulir/{formulir}/indikator/{indikator}/penilaian` | Submit nilai indikator |

Submit penilaian bersifat upsert. Endpoint penilaian menerima upload `bukti_dukung[]`.

## 5. Review Walidata dan Evaluasi Admin

| Method | Endpoint | Fungsi |
| --- | --- | --- |
| `GET` | `/api/penilaian-selesai` | List formulir selesai |
| `GET` | `/api/penilaian-selesai/{formulir}/opds` | List OPD per formulir |
| `GET` | `/api/penilaian-selesai/{formulir}/summary` | Ringkasan formulir |
| `GET` | `/api/penilaian-selesai/{formulir}/opd/{user}/stats` | Statistik OPD |
| `GET` | `/api/penilaian-selesai/{formulir}/opd/{user}/domains` | Ringkasan domain OPD |
| `POST` | `/api/penilaian-selesai/koreksi` | Koreksi walidata |
| `POST` | `/api/penilaian-selesai/evaluasi` | Evaluasi admin |

Catatan:

- Koreksi hanya untuk role `walidata`.
- Evaluasi hanya untuk role `admin`.
- Detail indikator lintas OPD memakai `GET /api/formulir/{formulir}/indicators?user_id={opdId}`.

## 6. Dokumentasi dan Pembinaan

### Dokumentasi Kegiatan

| Method | Endpoint |
| --- | --- |
| `GET` | `/api/dokumentasi` |
| `POST` | `/api/dokumentasi` |
| `GET` | `/api/dokumentasi/{dokumentasi}` |
| `PATCH` | `/api/dokumentasi/{dokumentasi}` |
| `POST` | `/api/dokumentasi/{dokumentasi}` |
| `DELETE` | `/api/dokumentasi/{dokumentasi}` |
| `GET` | `/api/dokumentasi/{dokumentasi}/download` |
| `GET` | `/api/dokumentasi/download-batch` |
| `DELETE` | `/api/file-dokumentasi/{fileDok}` |

### Pembinaan

| Method | Endpoint |
| --- | --- |
| `GET` | `/api/pembinaan` |
| `POST` | `/api/pembinaan` |
| `GET` | `/api/pembinaan/{pembinaan}` |
| `PATCH` | `/api/pembinaan/{pembinaan}` |
| `POST` | `/api/pembinaan/{pembinaan}` |
| `DELETE` | `/api/pembinaan/{pembinaan}` |
| `GET` | `/api/pembinaan/{pembinaan}/download` |
| `GET` | `/api/pembinaan/download-batch` |
| `DELETE` | `/api/file-pembinaan/{filePemb}` |

Di Flutter, pembinaan aktif untuk admin.

## 7. Notifikasi

| Method | Endpoint |
| --- | --- |
| `POST` | `/api/me/devices/fcm-token` |
| `DELETE` | `/api/me/devices/fcm-token` |
| `GET` | `/api/notifications` |
| `PATCH` | `/api/notifications/read-all` |
| `PATCH` | `/api/notifications/{notification}/read` |
| `DELETE` | `/api/notifications/{notification}` |
| `DELETE` | `/api/notifications/read` |

## 8. Admin Only

| Method | Endpoint |
| --- | --- |
| `GET` | `/api/users` |
| `POST` | `/api/users` |
| `GET` | `/api/users/{user}` |
| `PATCH` | `/api/users/{user}` |
| `DELETE` | `/api/users/{user}` |
| `POST` | `/api/users/{user}/reset-password` |
| `POST` | `/api/users/{user}/trigger-opd-reminder` |

Referensi endpoint backend yang lebih lengkap ada di `laravel/API_DOCUMENTATION.md`.
