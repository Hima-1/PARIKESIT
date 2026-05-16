# 20. Catatan Audit

Dokumen ini merangkum catatan audit teknis yang sebelumnya tersebar.

## 1. Security

Prioritas security production:

- `APP_DEBUG=false`.
- `SESSION_SECURE_COOKIE=true`.
- Domain API memakai HTTPS.
- `CORS_ALLOWED_ORIGINS` dibatasi ke origin yang benar-benar diperlukan.
- `.env`, Firebase service account, keystore, dan secret lain tidak masuk Git.
- File upload divalidasi tipe dan ukurannya.
- Route debug/test tidak aktif di production.
- Token Sanctum punya expiration yang jelas.

### Temuan audit keamanan lama

| Prioritas | Area | Risiko | Tindak lanjut |
| --- | --- | --- | --- |
| Critical | Password plaintext | Password mentah pernah disimpan di database melalui kolom `plain_password` | Pastikan tidak ada flow yang menulis password plaintext dan rencanakan drop column jika masih ada |
| High | Reset password admin | Password reset statis atau dikembalikan di response API dapat bocor ke log/tooling | Pakai token reset atau password sementara acak dengan display aman, jangan kembalikan password di response |
| High | Endpoint debug | Endpoint seperti `/api/test-500` tidak boleh hidup di production | Hapus route atau guard ke environment `local`/`testing` |
| High | Dokumentasi file | Baca/download lintas owner dapat menjadi IDOR | Terapkan policy `view`, `viewAny`, dan `download` |
| Medium | Route destruktif GET | Penghapusan lewat `GET` rawan terpicu link/crawler/CSRF-style | Ganti ke `POST`/`DELETE` dengan CSRF untuk web |
| Medium | Sort/pagination | `sort`, `direction`, `per_page` tanpa whitelist dapat membuat query error atau berat | Whitelist kolom, batasi direction, clamp `per_page` |
| Medium | CORS | Origin wildcard memperluas permukaan browser call | Batasi `CORS_ALLOWED_ORIGINS` per environment |
| Medium | Sanctum token | Token tanpa expiration tetap valid sampai revoke manual | Set `SANCTUM_EXPIRATION` dan kebijakan revoke |
| Low | Security headers | Header browser bergantung pada hosting/proxy | Tambahkan HSTS/CSP/X-Frame-Options bila dibutuhkan |

## 2. Seeder

Seeder development boleh membuat akun dan data demo. Untuk production:

- review data sebelum seeding,
- jangan menjalankan `migrate:fresh --seed`,
- gunakan migration normal dengan `php artisan migrate --force`,
- pastikan akun default tidak dibiarkan dengan password lemah.

Catatan lama menemukan beberapa email seed yang tampak typo. Jika data OPD dipakai untuk production, validasi ulang daftar OPD dan email.

### Temuan audit seeder lama

| Area | Status | Catatan |
| --- | --- | --- |
| User, master data, pembinaan demo | Tidak ada critical mismatch | Seed masih bisa dipakai untuk bootstrap aplikasi |
| Lifecycle penilaian | Belum representatif | Seed belum menyediakan contoh formulir operasional, penilaian OPD, koreksi walidata, dan evaluasi admin |
| `Formulir Master Data` | Valid sebagai template | Jangan dibaca sebagai formulir operasional OPD |
| Pembinaan demo | Selaras dengan runtime admin-only | Jika pembinaan nanti dibuka untuk OPD/walidata, seeder harus ikut berubah |
| Kriteria indikator | Masih rapuh | Sebagian lookup bergantung pada nama/whitespace indikator |
| Email OPD seed | Perlu validasi | Ada beberapa email yang tampak typo dan harus dicek sebelum demo resmi |

Tindak lanjut yang disarankan:

1. Pertahankan seeder inti untuk bootstrap.
2. Tambahkan seeder demo terpisah untuk alur lengkap `OPD -> Walidata -> Admin`.
3. Gunakan identifier stabil untuk lookup indikator jika memungkinkan.
4. Validasi data OPD sebelum dipakai UAT atau production.

## 3. Arsitektur Flutter

Rekomendasi audit arsitektur:

- Pertahankan feature-first.
- Hindari interface repository jika hanya ada satu implementasi.
- Simpan parsing response Laravel di satu helper.
- Hapus abstraction mati jika tidak dipakai.
- Jangan memindahkan widget ke `core/widgets` sebelum benar-benar dipakai lintas fitur.
- Gunakan Riverpod provider override untuk testability.

### Target pola arsitektur

```text
lib/
  core/
    network/
    auth/
    router/
    storage/
    theme/
    helpers/
    utils/
    widgets/
  features/<fitur>/
    data/
    domain/
    presentation/
```

Aturan praktis:

- Repository cukup kelas konkret + provider di `data/` jika hanya ada satu implementasi.
- Domain berisi model dan invariant bisnis, bukan interface repository dekoratif.
- Mapping JSON Laravel tetap di `data/` atau helper `core/network` jika dipakai lintas fitur.
- Shared component masuk `core/widgets` hanya jika dipakai lebih dari satu fitur.
- State kompleks sebaiknya memakai `freezed` agar `copyWith` tidak ditulis manual.

## 4. Design System

Aturan penting:

- Gunakan token dari `flutter/lib/core/theme/tokens`.
- Hindari warna mentah di screen.
- Gunakan komponen umum yang sudah ada.
- Tambahkan Widgetbook use-case jika membuat shared component baru.

## 5. Lampiran Internal

Catatan kerja internal yang masih disimpan:

- [internal/01-login-error-handling.md](internal/01-login-error-handling.md)

Lampiran SQL:

- [reference/01-basis-data.sql](reference/01-basis-data.sql)
- [reference/02-schema-snapshot.sql](reference/02-schema-snapshot.sql)
