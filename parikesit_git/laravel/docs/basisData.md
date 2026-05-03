### 4.2.4 Rancangan Basis Data
Perancangan basis data memiliki tujuan dalam mempermudah proses penyimpanan data dalam sistem yang dibangun. Terdapat tiga tahap dalam merancang basis data yaitu tahapan konseptual, tahapan logical, dan tahapan fisikal.

#### 1. Rancangan Basis Data Konseptual
Pada tahap perancangan basis data konseptual dilakukan penentuan jenis entitas, penentuan hubungan antar entitas, dan penjelasan terkait entitas yang digunakan pada sistem yang dibangun. Basis data konseptual yang digunakan terdiri dari 4 tabel. Rancangan ini belum melalui normalisasi basis data.

**Tabel 24. Rancangan Basis Data Konseptual**

| No. | Nama Entitas | Penjelasan |
| :--- | :--- | :--- |
| 1 | Users | Entitas yang berisikan informasi pengguna yang dapat mengakses situs web |
| 2 | Penilaians | Entitas yang menyimpan data penilaian |
| 3 | Pembinaans | Entitas yang berisikan kegiatan pembinaan yang dilakukan oleh OPD dan Walidata |
| 4 | Dokumentasi | Entitas yang berisikan dokumentasi kegiatan pembinaan yang dilakukan oleh BPS |

**Gambar 15. Rancangan Basis Data Konseptual**

**Tabel 25. Hubungan Kardinalitas Basis Data Logikal**

| Nama Entitas | Multiplicity | Relasi | Multiplicity | Nama Entitas |
| :--- | :--- | :--- | :--- | :--- |
| Users | 1..* | Menilai | 1..* | Penilaian |
| Users | 1..* | Memiliki | 1..* | Dokumentasi |
| Users | 1..* | Memiliki | 1..* | Pembinaan |

#### 2. Rancangan Basis Data Logikal
Setelah selesai dengan tahap konseptual, langkah berikutnya adalah perancangan logika. Tahap ini lebih mendetail daripada tahap konseptual dan berfokus pada pemodelan data yang lebih spesifik. Pada perancangan ini, skema basis data yang telah ditentukan pada tahap konseptual diubah menjadi model data yang lebih teknis, seperti model relasional. Aktivitas pada tahap ini mencakup normalisasi data, yang bertujuan untuk mengurangi redundansi dan meningkatkan integritas data.

Proses normalisasi database merupakan tahapan penting dalam perancangan struktur basis data agar menjadi efisien, bebas dari redundansi data, dan memudahkan pengelolaan. Berdasarkan perubahan yang terjadi pada rancangan basis data konseptual, proses yang dilaksanakan menggunakan bentuk Normalisasi Ketiga (Third Normal Form/3NF). Proses tersebut dilaksanakan dengan memisahkan atribut-atribut yang masih redundan pada entitas pembinaan, penilaian, dan dokumentasi. Sehingga didapatkan 13 tabel yang telah dinormalisasi.

**Tabel 26. Rancangan Basis Data Logical**

| No. | Nama Entitas | Penjelasan |
| :--- | :--- | :--- |
| 1 | Users | Entitas yang berisikan informasi pengguna yang dapat mengakses situs web |
| 2 | Domains | Entitas yang berisikan domain-domain penilaian |
| 3 | Aspeks | Entitas yang berisikan kumpulan aspek penilaian |
| 4 | Indikators | Entitas yang berisikan kumpulan indikator penilaian |
| 5 | Formulirs | Entitas yang berisikan nama kegiatan statistik sektoral |
| 6 | Penilaians | Entitas yang menyimpan data penilaian pada setiap indikator |
| 7 | File_dokumentasis | Entitas yang menyimpan bukti dukung foto/video pada kegiatan dokumentasi |
| 8 | File_pembinaans | Entitas yang menyimpan bukti dukung foto/video pada kegiatan pembinaan |
| 9 | Pembinaans | Entitas yang berisikan bukti dukung pdf dari kegiatan pembinaan OPD dan Walidata |
| 10 | Dokumentasi_kegiatans | Entitas yang berisikan bukti dukung pdf dari kegiatan dokumentasi BPS |
| 11 | Bukti_dukungs | Entitas yang menyimpan bukti dukung file (PDF/Image) untuk penilaian |
| 12 | Formulir_domains | Entitas junction yang menghubungkan formulir dengan domain |
| 13 | Formulir_penilaian_disposisis | Entitas yang menyimpan riwayat disposisi dan status penilaian |

**Gambar 16. Rancangan basis Data Logikal**

**Tabel 27. Hubungan Kardinalitas antar Entitas**

| Nama Entitas | Multiplicity | Relasi | Multiplicity | Nama Entitas |
| :--- | :--- | :--- | :--- | :--- |
| Users | 1..1 | Menilai | 1..* | Penilaian |
| Users | 1..1 | Memiliki | 1..* | Dokumentasi |
| Users | 1..1 | Memiliki | 1..* | Pembinaan |
| Formulir | 1..1 | Memiliki | 1..* | Penilaian |
| Domain | 1..1 | Memiliki | 1..* | Aspek |
| Aspek | 1..1 | Memiliki | 1..* | Indikator |
| Indikator | 1..1 | Memiliki | 1..* | Penilaian |
| Dokumentasi | 1..1 | Memiliki | 1..* | File_dokumentasi |
| Pembinaan | 1..1 | Memiliki | 1..* | File_pembinaan |
| Penilaian | 1..1 | Memiliki | 0..* | Bukti_dukung |
| Formulir | 1..* | Mencakup | 1..* | Domain (via formulir_domains) |
| Formulir | 1..1 | Memiliki | 0..* | Disposisi |

**Tabel 28. Entitas beserta Atribut**

| No. | Nama Entitas | Atribut |
| :--- | :--- | :--- |
| 1 | Users | Id, name, email, password, role, alamat, nomor_telepon |
| 2 | Domains | Id, nama_domain, bobot_domain |
| 3 | Aspeks | Id, nama_aspek, bobot_aspek, domain_id |
| 4 | Indikators | Id, nama_indikator, bobot_indikator, aspek_id |
| 5 | Formulirs | Id, nama_formulir, tanggal_dibuat |
| 6 | Penilaians | Id, indikator_id, nilai, catatan, tanggal_penilaian, user_id, formulir_id, bukti_dukung, dikerjakan_by, dikoreksi_by, koreksi, nilai_koreksi |
| 7 | File_dokumentasis | Id, dokumentasi_kegiatan_id, nama_file, tipe_file |
| 8 | File_pembinaans | Id, pembinaan_id, nama_file, tipe_file |
| 9 | Pembinaans | Id, created_by_id, judul_pembinaan, bukti_dukung_undangan_pembinaan, daftar_hadir_pembinaan, materi_pembinaan, notula_pembinaan |
| 10 | Dokumentasi_kegiatans | Id, created_by_id, judul_dokumentasi, bukti_dukung_undangan_dokumentasi, daftar_hadir_dokumentasi, materi_dokumentasi, notula_dokumentasi |
| 11 | Bukti_dukungs | Id, penilaian_id, path, nama_file, ukuran_file |
| 12 | Formulir_domains | Id, formulir_id, domain_id |
| 13 | Formulir_penilaian_disposisis | Id, formulir_id, indikator_id, from_profile_id, to_profile_id, assigned_profile_id, status, catatan, is_completed |

64
#### 3. Rancangan Basis Data Fisikal
Tahap terakhir adalah perancangan fisik, di mana struktur data konkret yang akan digunakan oleh sistem basis data diimplementasikan. Pada tahap ini, keputusan teknis seperti tipe data, indeks, dan struktur penyimpanan data diambil. Perhatian juga diberikan pada kinerja sistem, dengan tujuan untuk memastikan efisiensi operasional dan ketersediaan data yang cepat. Tahap ini mencakup pembuatan tabel, indeks, dan pemilihan teknologi database yang sesuai.

**Gambar 17. Rancangan Basis Data Fisikal**

**Tabel 29. Rancangan Fisikal Entitas Users**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | id | Int | 20 | NO | PK |
| 2 | Email | Varchar | 255 | NO | |
| 3 | Username | Varchar | 255 | NO | |
| 4 | Password | Varchar | 255 | NO | |
| 5 | Role | Varchar | 255 | NO | |
| 6 | Alamat | Varchar | 255 | NO | |
| 7 | Nomor_telepon | Varchar | 255 | NO | |

**Tabel 30. Rancangan Fisikal Entitas Formulir**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | Judul_formulir | Varchar | 255 | NO | |
| 3 | Tanggal_pengisian | Date | | NO | |

**Tabel 31. Rancangan Fisikal Entitas Domain**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | Nama_domain | Varchar | 255 | NO | |
| 3 | Bobot_domain | Decimal | 5,2 | YES | |

**Tabel 32. Rancangan Fisikal Entitas Aspek**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | Domain_id | Int | 20 | NO | FK |
| 3 | Nama_aspek | Varchar | 255 | NO | |
| 4 | Bobot_aspek | Decimal | 5,2 | YES | |

**Tabel 33. Rancangan Fisikal Entitas Indikator**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | Aspek_id | Int | 20 | NO | FK |
| 3 | Nama_indikator | Varchar | 255 | NO | |
| 4 | Bobot_indikator | Decimal | 5,2 | YES | |

> *Catatan: Tabel Indikator juga memiliki kolom override kriteria `level_N_kriteria_XXXXX` (di mana XXXXX adalah kode formulir) untuk mendukung kriteria spesifik per formulir. Arsitektur ini disarankan untuk dimigrasikan ke kolom JSON pada pengembangan selanjutnya.*

**Tabel 34. Rancangan Fisikal Entitas Penilaian**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Bigint | 20 | NO | PK |
| 2 | Indikator_id | Bigint | 20 | NO | FK |
| 3 | User_id | Bigint | 20 | NO | FK |
| 4 | Formulir_id | Bigint | 20 | NO | FK |
| 5 | Nilai | Decimal | 5,2 | NO | |
| 6 | Catatan | Text | | YES | |
| 7 | Bukti_dukung | Text | | YES | |
| 8 | Status | Enum | 'sent', 'returned', 'approved', 'rejected' | NO | |
| 9 | Dikerjakan_by | Bigint | 20 | YES | FK |
| 10 | Dikoreksi_by | Bigint | 20 | YES | FK |
| 11 | Catatan_koreksi | Text | | YES | |
| 12 | Nilai_koreksi | Decimal | 5,2 | YES | |
| 13 | Evaluasi_walidata | Text | | YES | |
| 14 | Created_at | Timestamp | | YES | |
| 15 | Updated_at | Timestamp | | YES | |
| 16 | Deleted_at | Timestamp | | YES | |

**Tabel 35. Rancangan Fisikal Entitas Dokumentasi**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | user_id | Int | 20 | NO | FK |
| 3 | Judul_dokumentasi | Varchar | 255 | NO | |
| 4 | Undangan_dokumentasi | Varchar | 255 | NO | |
| 5 | Materi_dokumentasi | Varchar | 255 | NO | |
| 6 | Notula_dokumentasi | Varchar | 255 | NO | |
| 7 | Daftar_hadir_dokumentasi | Varchar | 255 | NO | |

**Tabel 36. Rancangan Fisikal Entitas Pembinaan**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | user_id | Int | 20 | NO | FK |
| 3 | Judul_pembinaan | Varchar | 255 | NO | |
| 4 | Undangan_pembinaan | Varchar | 255 | NO | |
| 5 | Daftar_hadir_pembinaan | Varchar | 255 | NO | |
| 6 | Materi_pembinaan | Varchar | 255 | NO | |
| 7 | Notula_pembinaan | Varchar | 255 | NO | |

**Tabel 37. Rancangan Fisikal Entitas File_dokumentasi**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | Dokumentasi_id | Int | 20 | NO | FK |
| 3 | Nama_file | Text | | NO | |
| 4 | Tipe_file | Enum | 'png', 'jpg', 'jpeg', 'mp4', 'pdf', 'docx', 'xlsx', 'pptx', 'zip', 'rar' | NO | |

**Tabel 38. Rancangan Fisikal Entitas file_pembinaan**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Int | 20 | NO | PK |
| 2 | Pembinaan_id | Int | 20 | NO | FK |
| 3 | Nama_file | Text | | NO | |
| 4 | Tipe_file | Enum | 'png', 'jpg', 'jpeg', 'mp4', 'pdf', 'docx', 'xlsx', 'pptx', 'zip', 'rar' | NO | |

NO
Tabel 38. Rancangan Fisikal Entitas file_pembinaan
No Nama Atribut Tipe Data Panjang
Karakter
Null Keterangan
(1) (2) (3) (4) (5) (6)
1 Id Int 20 NO PK
2 pembinaan_id Int 20 NO FK
3 Nama_file Text NO
4 Tipe_file Enum
(‘png’,
NO
69
No Nama Atribut Tipe Data Panjang
Karakter
Null Keterangan
(1) (2) (3) (4) (5) (6)
‘jpg’,
‘jpeg’,
‘mp4’,
‘docx’,
‘xlsx’,
‘pptx’,
‘zip’, ‘rar’)

**Tabel 39. Rancangan Fisikal Entitas Bukti_dukungs**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Bigint | 20 | NO | PK |
| 2 | Penilaian_id | Bigint | 20 | NO | FK |
| 3 | Path | Varchar | 255 | NO | |
| 4 | Nama_file | Varchar | 255 | NO | |
| 5 | Ukuran_file | Int | 11 | NO | |

**Tabel 40. Rancangan Fisikal Entitas Formulir_domains**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Bigint | 20 | NO | PK |
| 2 | Formulir_id | Bigint | 20 | NO | FK |
| 3 | Domain_id | Bigint | 20 | NO | FK |

**Tabel 41. Rancangan Fisikal Entitas Formulir_penilaian_disposisis**

| No | Nama Atribut | Tipe Data | Panjang | Null | Keterangan |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Id | Bigint | 20 | NO | PK |
| 2 | Formulir_id | Bigint | 20 | NO | FK |
| 3 | Indikator_id | Bigint | 20 | YES | FK |
| 4 | From_profile_id | Bigint | 20 | YES | FK |
| 5 | To_profile_id | Bigint | 20 | YES | FK |
| 6 | Assigned_profile_id | Bigint | 20 | YES | FK |
| 7 | Status | Enum | 'sent', 'returned', 'approved', 'rejected' | NO | |
| 8 | Catatan | Text | | YES | |
| 9 | Is_completed | Tinyint | 1 | NO | |
