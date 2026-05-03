# Skema Data Ringkas

Ringkasan tabel backend yang relevan untuk Flutter.

## Entitas Inti

- `users`: akun dan role
- `domains`, `aspeks`, `indikators`: master penilaian
- `formulirs`, `formulir_domains`: kegiatan penilaian
- `penilaians`: nilai OPD, koreksi walidata, evaluasi admin
- `bukti_dukungs`: file bukti dukung penilaian
- `formulir_penilaian_disposisis`: status/disposisi
- `dokumentasi_kegiatans`, `file_dokumentasis`: dokumentasi kegiatan
- `pembinaans`, `file_pembinaans`: pembinaan
- `inbox_notifications`: inbox notifikasi
- `device_tokens`: token perangkat untuk FCM

## Kolom Penting

### users

- `id`, `name`, `email`, `password`, `role`, `alamat`, `nomor_telepon`

### formulirs

- `id`, `nama_formulir`, `tanggal_dibuat`, `created_by_id`

### penilaians

- OPD: `nilai`, `catatan`, `tanggal_penilaian`, `dikerjakan_by`
- Walidata: `nilai_diupdate`, `catatan_koreksi`, `diupdate_by`, `tanggal_diperbarui`
- Admin: `nilai_koreksi`, `evaluasi`, `dikoreksi_by`, `tanggal_dikoreksi`

### inbox_notifications

- `id`, `user_id`, `title`, `body`, `type`, `data`, `is_read`, `read_at`, `hidden_at`

### device_tokens

- `id`, `user_id`, `personal_access_token_id`, `token`, `platform`, `device_name`, `app_version`, `is_active`, `last_seen_at`

## Relasi Penting

- `domains` 1..* `aspeks`
- `aspeks` 1..* `indikators`
- `formulirs` 1..* `penilaians`
- `indikators` 1..* `penilaians`
- `users` 1..* `penilaians`
- `penilaians` 1..* `bukti_dukungs`
- `users` 1..* `inbox_notifications`
- `users` 1..* `device_tokens`
