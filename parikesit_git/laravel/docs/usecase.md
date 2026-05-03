### 4.2.2 Usecase Diagram
Berdasarkan use case tersebut, dapat dijelaskan seperti pada tabel-tabel berikut:

**Tabel 9. Usecase Diagram Login**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Login |
| **Pengguna** | OPD, walidata, BPS |
| **Deskripsi** | Pengguna masuk ke dalam sistem menggunakan akun yang telah dibuatkan dengan email dan password yang diberikan kepada seluruh pengguna |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi internet<br>2. Pengguna berada di halaman login |
| **Kondisi Akhir** | Pengguna berada di halaman dashboard |

**Tabel 10. Usecase Diagram Manajemen Profil**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Manajemen Profil |
| **Pengguna** | OPD, walidata, BPS |
| **Deskripsi** | Pengguna dapat melihat profil akun dan mengedit akun |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi dengan internet<br>2. Pengguna sudah melakukan login<br>3. Pengguna berada di halaman profil |
| **Kondisi Akhir** | Pengguna dapat melihat dan mengedit akun |

**Tabel 11. Usecase Diagram Penilaian Mandiri**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Penilaian Mandiri |
| **Pengguna** | OPD |
| **Deskripsi** | Pengguna menggunakan halaman untuk mengisi nama kegiatan statistik dan melakukan penilaian |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi dengan internet<br>2. Pengguna sudah melakukan login<br>3. Pengguna berada di halaman Penilaian Mandiri<br>4. Pengguna memiliki wewenang untuk mengakses halaman Penilaian Mandiri |
| **Kondisi Akhir** | Pengguna dapat mengisi penilaian mandiri dengan memasukkan level penilaian, penjelasan, dan bukti dukung |

**Tabel 12. Usecase Diagram Verifikasi Penilaian**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Verifikasi penilaian mandiri OPD |
| **Pengguna** | Walidata |
| **Deskripsi** | Pengguna dapat melihat dan mengoreksi penilaian yang telah dilakukan oleh OPD |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi dengan internet<br>2. Pengguna sudah melakukan login<br>3. Pengguna berada di halaman Penilaian Selesai<br>4. Pengguna memiliki wewenang untuk mengakses halaman |
| **Kondisi Akhir** | Pengguna dapat mengoreksi penilaian yang telah dilaksanakan oleh OPD |

**Tabel 13. Usecase Diagram Penilaian dan Feedback BPS**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Penilaian oleh BPS |
| **Pengguna** | BPS |
| **Deskripsi** | Pengguna menggunakan fitur ini untuk melakukan penilaian dan evaluasi kegiatan yang telah dikoreksi oleh walidata |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi dengan internet<br>2. Pengguna sudah melakukan login<br>3. Pengguna berada di halaman penilaian selesai<br>4. Pengguna memiliki wewenang untuk mengakses halaman |
| **Kondisi Akhir** | Pengguna dapat mengisi penilaian berdasarkan penjelasan dan bukti dukung yang telah diunggah OPD. Pengguna juga dapat memberikan evaluasi pada setiap penilaian |

**Tabel 14. Usecase Diagram Dokumentasi**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Dokumentasi kegiatan pembinaan |
| **Pengguna** | OPD, walidata, BPS |
| **Deskripsi** | Digunakan oleh pengguna untuk mengunggah dokumentasi kegiatan pembinaan statistik sektoral ke dalam global pool dokumentasi. BPS dapat mengakses seluruh modul dokumentasi, sedangkan OPD dan walidata hanya mengakses halaman Dokumentasi Kegiatan. Pengguna wajib memasukkan beberapa bukti seperti undangan, foto/video, dan lain-lain |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi dengan internet<br>2. Pengguna sudah melakukan login<br>3. Pengguna berada di halaman dokumentasi |
| **Kondisi Akhir** | Dokumentasi kegiatan pembinaan statistik sektoral tersimpan pada global pool dan dapat dilihat sesuai otorisasi role |

**Tabel 15. Usecase Diagram Manajemen Akun**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Menambahkan akun OPD dan Walidata |
| **Pengguna** | BPS |
| **Deskripsi** | BPS menggunakan fitur ini untuk mendaftarkan akun OPD dan walidata. BPS akan memasukkan username, password, role, dan lainnya untuk membuat akun OPD dan walidata |
| **Kondisi Awal** | 1. Pengguna harus terkoneksi dengan internet<br>2. Pengguna sudah melakukan login<br>3. Pengguna berada di halaman manajemen user<br>4. Pengguna memiliki wewenang untuk mengakses halaman tersebut |
| **Kondisi Akhir** | Pengguna dapat menambahkan akun untuk OPD dan Walidata |

**Tabel 16. Usecase Diagram Unggah Bukti Dukung**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Unggah Bukti Dukung |
| **Pengguna** | OPD, Walidata, BPS |
| **Deskripsi** | Use case tambahan (extend) untuk mengunggah dokumen atau file sebagai bukti pendukung kegiatan |
| **Kondisi Awal** | 1. Pengguna berada di halaman Penilaian Mandiri atau Dokumentasi Kegiatan<br>2. Pengguna memilih opsi untuk mengunggah file |
| **Kondisi Akhir** | File berhasil terunggah dan tersimpan di dalam sistem sebagai referensi penilaian atau dokumentasi |

**Tabel 17. Usecase Diagram Evaluasi Penilaian**

| Komponen | Deskripsi |
| :--- | :--- |
| **Nama use case** | Evaluasi Penilaian |
| **Pengguna** | BPS |
| **Deskripsi** | Use case tambahan (extend) yang digunakan oleh BPS untuk memberikan catatan evaluasi mendalam pada setiap butir penilaian |
| **Kondisi Awal** | 1. Pengguna sedang melakukan proses "Penilaian oleh BPS"<br>2. Pengguna merasa perlu memberikan feedback tambahan |
| **Kondisi Akhir** | Catatan evaluasi tersimpan dan dapat dilihat oleh OPD sebagai bahan perbaikan |
