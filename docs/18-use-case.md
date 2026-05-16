# 18. Use Case

Dokumen ini menjelaskan fitur dari sudut pengguna.

## 1. Login

| Item | Keterangan |
| --- | --- |
| Pengguna | OPD, walidata, admin/BPS |
| Kondisi awal | Pengguna punya akun dan berada di halaman login |
| Aksi | Mengisi email dan password |
| Hasil | Pengguna masuk ke dashboard sesuai role |

Tidak ada registrasi mandiri. Akun dibuat oleh admin/BPS.

## 2. Manajemen Profil

| Item | Keterangan |
| --- | --- |
| Pengguna | Semua role |
| Kondisi awal | Sudah login |
| Aksi | Melihat atau mengubah data profil |
| Hasil | Data profil tersimpan |

## 3. Penilaian Mandiri

| Item | Keterangan |
| --- | --- |
| Pengguna | OPD |
| Kondisi awal | OPD sudah login dan punya akses penilaian |
| Aksi | Membuat formulir, mengisi indikator, memberi catatan, upload bukti dukung |
| Hasil | Penilaian tersimpan dan dapat ditinjau walidata/admin |

## 4. Verifikasi Penilaian

| Item | Keterangan |
| --- | --- |
| Pengguna | Walidata |
| Kondisi awal | Ada penilaian OPD yang selesai |
| Aksi | Melihat hasil OPD dan memberi koreksi |
| Hasil | Koreksi tersimpan untuk ditinjau admin/BPS |

## 5. Evaluasi Penilaian

| Item | Keterangan |
| --- | --- |
| Pengguna | Admin/BPS |
| Kondisi awal | Ada penilaian yang sudah dikoreksi walidata |
| Aksi | Memberi evaluasi akhir dan catatan |
| Hasil | Evaluasi tersimpan dan bisa dilihat OPD |

## 6. Dokumentasi Kegiatan

| Item | Keterangan |
| --- | --- |
| Pengguna | OPD, walidata, admin/BPS |
| Kondisi awal | Sudah login |
| Aksi | Melihat atau mengunggah dokumentasi kegiatan sesuai akses role |
| Hasil | Dokumentasi tersimpan dan dapat diunduh sesuai otorisasi |

## 7. Pembinaan

| Item | Keterangan |
| --- | --- |
| Pengguna | Admin/BPS |
| Kondisi awal | Admin sudah login |
| Aksi | Mengelola data pembinaan dan file terkait |
| Hasil | Data pembinaan tersimpan |

## 8. Manajemen Akun

| Item | Keterangan |
| --- | --- |
| Pengguna | Admin/BPS |
| Kondisi awal | Admin sudah login |
| Aksi | Membuat, mengubah, menghapus, atau reset password akun |
| Hasil | Akun pengguna berubah sesuai aksi |

## 9. Notifikasi dan Reminder

| Item | Keterangan |
| --- | --- |
| Pengguna | Semua role, terutama OPD |
| Kondisi awal | User login dan token FCM tersimpan |
| Aksi | Sistem atau admin mengirim reminder/notifikasi |
| Hasil | Notifikasi masuk ke inbox dan/atau push Android |
