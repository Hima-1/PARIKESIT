# 13. Basis Data

Database utama memakai MySQL/MariaDB. Untuk development lokal, nama database yang dipakai adalah `parikesit`.

## 1. Entitas Inti

| Tabel | Fungsi |
| --- | --- |
| `users` | Akun dan role pengguna |
| `domains` | Domain penilaian |
| `aspeks` | Aspek dalam domain |
| `indikators` | Indikator penilaian |
| `formulirs` | Kegiatan/formulir penilaian |
| `formulir_domains` | Relasi formulir dengan domain |
| `penilaians` | Nilai OPD, koreksi walidata, evaluasi admin |
| `bukti_dukungs` | File bukti dukung penilaian |
| `formulir_penilaian_disposisis` | Status/disposisi penilaian |
| `dokumentasi_kegiatans` | Dokumentasi kegiatan |
| `file_dokumentasis` | File dokumentasi |
| `pembinaans` | Data pembinaan |
| `file_pembinaans` | File pembinaan |
| `inbox_notifications` | Notifikasi dalam aplikasi |
| `device_tokens` | Token perangkat untuk FCM |

## 2. Relasi Penting

```text
domains 1..* aspeks
aspeks 1..* indikators
formulirs 1..* penilaians
indikators 1..* penilaians
users 1..* penilaians
penilaians 1..* bukti_dukungs
users 1..* inbox_notifications
users 1..* device_tokens
```

## 3. Kolom Penting

### `users`

- `id`
- `name`
- `email`
- `password`
- `role`
- `alamat`
- `nomor_telepon`

### `formulirs`

- `id`
- `nama_formulir`
- `tanggal_dibuat`
- `created_by_id`

### `penilaians`

Untuk OPD:

- `nilai`
- `catatan`
- `tanggal_penilaian`
- `dikerjakan_by`

Untuk walidata:

- `nilai_diupdate`
- `catatan_koreksi`
- `diupdate_by`
- `tanggal_diperbarui`

Untuk admin:

- `nilai_koreksi`
- `evaluasi`
- `dikoreksi_by`
- `tanggal_dikoreksi`

### `device_tokens`

- `user_id`
- `personal_access_token_id`
- `token`
- `platform`
- `device_name`
- `app_version`
- `is_active`
- `last_seen_at`

## 4. Migration dan Seeder

Untuk reset database lokal:

```powershell
cd laravel
php artisan migrate:fresh --seed
```

Seeder utama membuat:

- akun development
- master data domain/aspek/indikator
- data demo yang dibutuhkan untuk development lokal

Review isi seeder sebelum dipakai di production. Jangan menjalankan `migrate:fresh --seed` di production karena perintah itu menghapus data lama.

## 5. Lampiran SQL

Lampiran tersedia di:

- [reference/01-basis-data.sql](reference/01-basis-data.sql)
- [reference/02-schema-snapshot.sql](reference/02-schema-snapshot.sql)
