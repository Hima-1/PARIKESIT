### 4.2.3 Activity Diagram

#### 1. Activity Login
**Gambar 7. Activity Diagram Login**

Pada proses bisnis login pada aplikasi PARIKESIT BPS Kabupaten Klaten, seluruh pengguna (OPD, Walidata, maupun BPS) mengakses sistem melalui halaman login yang tersedia pada web PARIKESIT. Pengguna akan memasukkan alamat email dan password sesuai data akun yang sudah didaftarkan oleh BPS. Tidak ada mekanisme registrasi mandiri pada aplikasi ini karena pembuatan akun sepenuhnya dilakukan oleh BPS. Setelah data diisikan, pengguna menekan tombol login untuk melanjutkan proses. Sistem kemudian melakukan proses validasi dengan memeriksa apakah kombinasi email dan password yang diinputkan cocok dengan data yang tersimpan di basis data. Jika data pengguna teridentifikasi dengan benar, pengguna akan langsung diarahkan ke halaman dashboard utama aplikasi PARIKESIT untuk dapat mengakses fitur-fitur sesuai peran dan otoritasnya. Sebaliknya, apabila data yang diinputkan tidak sesuai atau tidak ditemukan di basis data, maka sistem akan menampilkan pesan kesalahan.

**Tabel 16. Activity Diagram Login**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Login |
| **Aktor** | OPD, Walidata, BPS |
| Membuka halaman login PARIKESIT | Pengguna mengakses link PARIKESIT dan akan masuk ke halaman login |
| Mengisi email dan password pegawai | Pengguna mengisikan email dan password akun yang telah dibuat oleh BPS |
| Menekan tombol login | Pengguna telah mengisi email dan password lalu menekan tombol login |
| Kondisi: apakah ada di database? | Sistem akan memeriksa apakah pengguna sudah terdaftar pada sistem. Jika ya, maka pengguna akan masuk ke halaman dashboard, jika tidak maka tetap berada di halaman login |
| Membuka halaman dashboard PARIKESIT | Pengguna berhasil login dan berada di halaman dashboard PARIKESIT |

#### 2. Activity Edit Profile
**Gambar 8. Activity Diagram Edit Profile**

Pada proses bisnis activity mengedit profil, seluruh pengguna memiliki hak akses untuk melakukan pengubahan data profil masing-masing. Proses ini diawali dengan pengguna membuka halaman Edit My Profile yang dapat diakses melalui ikon profil di pojok atas halaman aplikasi. Setelah halaman terbuka, pengguna dapat mengubah berbagai informasi pribadi seperti nama, alamat email, alamat kantor, password, serta nomor telepon sesuai kebutuhan. Setelah melakukan perubahan pada kolom-kolom yang diinginkan, pengguna harus menekan tombol simpan untuk merekam perubahan ke dalam sistem. Pada tahap ini, sistem secara otomatis akan melakukan validasi terhadap isian yang diberikan. Jika seluruh data telah diisi dengan lengkap dan sesuai format yang ditentukan, maka sistem akan memproses perubahan dan menampilkan notifikasi pop up bahwa update profil berhasil dilakukan. Sebaliknya, jika ada bagian yang belum diisi atau format data tidak sesuai, sistem akan menampilkan notifikasi kesalahan.

**Tabel 17. Activity Diagram Edit Profile**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Edit Profil |
| **Aktor** | OPD, Walidata, BPS |
| Membuka halaman profile | Pengguna membuka halaman Edit My Profile pada icon yang berada di pojok atas. |
| Mengubah isian profile | Pengguna mengubah isian sesuai dengan yang diinginkan |
| Menekan tombol simpan | Pengguna menekan tombol simpan untuk menyimpan perubahan isian |
| Kondisi: apakah isian berhasil disimpan di database? | Sistem akan memeriksa perubahan. Jika berhasil maka akan muncul pop up notifikasi perubahan sukses dilakukan |

#### 3. Activity Penilaian Mandiri
**Gambar 9. Activity Diagram Penilaian Mandiri**

Activity penilaian mandiri dilakukan oleh OPD. OPD membuka halaman kegiatan penilaian di sidebar untuk mengakses halaman formulir penilaian. OPD berada pada halaman tersebut kemudian menekan tombol Tambah Formulir untuk menambahkan kegiatan statistik. Selanjutnya OPD akan menekan tombol untuk menambahkan domain secara otomatis. Apabila telah ada domain, selanjutnya OPD dapat masuk ke halaman Penilaian Mandiri dengan klik pada sidebar. Selanjutnya OPD menekan “Lakukan Penilaian” pada kegiatan yang telah ditambahkan untuk mengisi penilaian. Selanjutnya akan ada rincian penilaian lalu klik pada tombol “Mulai Penilaian Mandiri”. Pada halaman berikutnya yaitu halaman domain. OPD akan memilih domain mana yang akan dilakukan penilaian terlebih dahulu. Selanjutnya akan memilih indikator mana yang akan dinilai. Apabila telah masuk ke halaman penilaian indikator, maka OPD akan mengisikan level kematangan kegiatan statistik sektoral yang telah ditambahkan. Selanjutnya OPD akan memberikan penjelasan dan bukti dukung yang sesuai dengan indikator yang dinilai. OPD akan mengisi seluruh penilaian hingga selesai. Apabila kegiatan penilaian telah selesai dilaksanakan maka akan muncul nilai Indeks Pembangunan Statistik (IPS) pada setiap domain.

**Tabel 18. Activity Diagram Penilaian Mandiri**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Penilaian Mandiri |
| **Aktor** | OPD |
| Membuka halaman Kegiatan Penilaian | Pengguna mengakses nama kegiatan statistik di halaman kegiatan penilaian |
| Mengisi nama kegiatan statistik | Pengguna mengisikan nama kegiatan statistik yang akan dinilai |
| Mengisikan penilaian | Pengguna kembali ke halaman Penilaian Mandiri untuk melakukan penilaian yang dimulai dari mengisikan level penilaian |
| Mengisikan penjelasan | Pengguna mengisikan penjelasan yang memiliki keterkaitan dengan penilaian yang sedang dilakukan |
| Mengisikan bukti dukung | Pengguna mengunggah bukti dukung penilaian berupa pdf |
| Kondisi: telah mengisikan seluruh indikator? | Sistem akan memeriksa apakah penilaian telah dilakukan pada seluruh indikator. |
| Klik simpan penilaian | Pengguna klik tombol simpan untuk menyimpan seluruh penilaian yang telah diisi |

#### 4. Activity Koreksi Penilaian oleh Walidata
**Gambar 10. Activity Diagram Verifikasi Penilaian oleh Walidata**

Activity koreksi penilaian hanya dapat dilakukan oleh walidata. Activity ini dilaksanakan setelah OPD menyelesaikan seluruh indikator penilaian. Walidata akan melaksanakan verifikasi penilaian berdasarkan bukti dukung yang telah diunggah oleh OPD dengan mengisikan Nilai Verifikasi pada setiap indikator. Nilai Verifikasi ini berfungsi sebagai nilai tandingan/pembanding terhadap nilai mandiri yang diinput oleh OPD, sehingga BPS memiliki dasar pembanding saat melanjutkan penilaian dan memberikan umpan balik pada setiap indikator.

**Tabel 19. Activity Diagram Verifikasi Penilaian**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Verifikasi Penilaian |
| **Aktor** | Walidata |
| Membuka halaman Penilaian Selesai | Walidata mengakses aplikasi EPSS dan memilih menu "Penilaian Selesai" yang tersedia di sidebar sistem. Pada tahap ini, aplikasi akan menampilkan daftar seluruh kegiatan statistik yang penilaiannya sudah diselesaikan oleh OPD tetapi masih menunggu proses verifikasi lebih lanjut. |
| Memilih penilaian yang akan diisi | Pengguna memilih kegiatan yang akan dilakukan penilaian |
| Mengisi Nilai Verifikasi berdasarkan penjelasan dan bukti dukung | Walidata memeriksa satu per satu indikator penilaian beserta penjelasan dan bukti dukung yang telah diunggah oleh OPD, lalu mengisikan Nilai Verifikasi sebagai nilai tandingan/pembanding terhadap nilai mandiri OPD agar validitas penilaian tetap objektif. |

#### 5. Activity Penilaian dan Evaluasi BPS
**Gambar 11. Activity Penilaian dan Feedback BPS**

Dalam activity diagram penilaian dan feedback oleh BPS, seluruh tahapan diawali dengan BPS membuka halaman Penilaian Selesai yang tersedia pada sidebar aplikasi. Pada halaman ini, BPS dapat melihat daftar seluruh penilaian mandiri yang telah diselesaikan oleh OPD dan telah dikoreksi oleh Walidata. BPS kemudian memilih salah satu penilaian mandiri yang ingin dinilai dan diberi umpan balik secara lebih lanjut.

Setelah memilih kegiatan, BPS melakukan review detail penjelasan dan seluruh bukti dukung yang diunggah oleh OPD pada setiap indikator. BPS kemudian menentukan nilai pada setiap indikator berdasarkan kelengkapan, relevansi data atau dokumen yang tersedia.

Pada tahap berikutnya, BPS mengisikan feedback secara spesifik pada setiap indikator. Feedback ini berisi masukan, catatan koreksi, saran perbaikan, atau penguatan yang bertujuan meningkatkan kualitas penyelenggaraan statistik sektoral di OPD terkait. Jika berhasil maka penilaian selesai dan sebaliknya.

**Tabel 20. Activity Diagram Penilaian dan Feedback**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Penilaian dan Feedback BPS |
| **Aktor** | BPS |
| Membuka halaman Penilaian | Pengguna membuka halaman penilaian yang ada pada sidebar |
| Memilih penilaian yang akan diisi | Pengguna memilih kegiatan yang akan dilakukan penilaian dan pengisian feedback |
| Mengisi penilaian berdasarkan penjelasan dan bukti dukung | Pengguna melihat penjelasan dan bukti dukung pada setiap indikator dan memilih nilai yang sesuai |
| Mengisikan feedback | Pengguna mengisikan kolom feedback kepada OPD |

#### 6. Activity Dokumentasi dan Pembinaan
**Gambar 12. Activity Diagram Dokumentasi dan Pembinaan**

Activity ini dapat dilakukan oleh seluruh role pengguna. BPS mengakses seluruh modul dokumentasi, sedangkan OPD dan Walidata hanya mengakses halaman Dokumentasi Kegiatan. Setelah berhasil masuk ke halaman yang sesuai, pengguna akan melihat dan menekan tombol “Tambah Dokumentasi” untuk memulai proses pencatatan kegiatan baru.

Setelah tombol tersebut diklik, pengguna diarahkan ke halaman formulir dokumentasi. Pada formulir ini, pengguna diwajibkan mengisi nama atau judul kegiatan pembinaan statistik sektoral yang telah dilakukan. Selain itu, pengguna perlu mengunggah berbagai bukti dukung sebagai kelengkapan dokumentasi, di antaranya surat undangan, daftar hadir peserta, materi yang digunakan, notula rapat atau kegiatan, serta file dokumentasi berupa foto atau video yang menggambarkan jalannya kegiatan pembinaan.

**Tabel 21. Activity Diagram Dokumentasi dan Pembinaan**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Dokumentasi dan Pembinaan |
| **Aktor** | OPD, Walidata, BPS |
| Membuka halaman dokumentasi | Pengguna memilih halaman dokumentasi yang ada pada sidebar |
| Memilih tombol Tambah Dokumentasi | Pengguna klik pada tombol tambah dokumentasi |
| Mengisi nama kegiatan dokumentasi | Pengguna mengisikan nama kegiatan pembinaan statistik sektoral yang telah dilaksanakan |
| Mengunggah bukti dukung | Pengguna memasukkan bukti dukung yaitu undangan, daftar hadir, materi, notula, foto/video |
| Klik tombol simpan | Setelah berhasil disimpan akan masuk ke dalam database. |

#### 7. Activity Menambahkan Akun
**Gambar 13. Activity Diagram Menambahkan Akun**

Activity manajemen akun hanya dapat diakses oleh BPS. Pada halaman tersebut dapat diakses melalui sidebar dengan menekan tombol Manajemen User. Setelah masuk BPS dapat menambahkan akun pengguna dengan menekan tombol Tambah Akun. Selanjutnya BPS dapat memasukkan beberapa isian seperti nama pengguna, password, email, alamat, dan nomor telepon. Selanjutnya BPS juga dapat memilih role pengguna (OPD, Walidata, dan BPS). Apabila berhasil maka akan terlihat akun user baru di dalam tabel. Namun jika tidak berhasil maka akan muncul notifikasi kesalahan.

**Tabel 22. Activity Diagram Membuat akun Pengguna**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Manajemen Akun |
| **Aktor** | BPS |
| Membuka halaman Manajemen User | Pengguna memilih halaman manajemen user yang ada pada sidebar |
| Memilih tombol Tambah Akun | Pengguna klik pada tombol tambah akun |
| Mengisi profil akun baru | Pengguna mengisikan profil akun baru seperti nama pengguna, email, password, alamat, dan nomor telepon pengguna |
| Memilih role akun | Pengguna memilih role untuk akun yang dibuat. |
| Klik tombol simpan | Setelah berhasil disimpan akan masuk ke dalam database. |

#### 8. Menghapus Akun
**Gambar 14. Activity Diagram Menghapus Akun**

Activity manajemen akun hanya dapat diakses oleh BPS. Pada halaman tersebut dapat diakses melalui sidebar dengan menekan tombol Manajemen User. Halaman akan menampilkan tabel yang berisikan informasi terkait user. Tabel tersebut terdapat kolom aksi yang berisikan tombol edit, hapus, dan lihat user. BPS menekan tombol hapus user untuk menghapus akun. Jika berhasil maka akun tersebut terhapus. Jika tidak berhasil akan kembali pada tampilan halaman tabel user.

**Tabel 23. Activity Diagram Menghapus akun Pengguna**

| Nama Proses | Deskripsi |
| :--- | :--- |
| **Nama Proses Bisnis** | Manajemen Akun |
| **Aktor** | BPS |
| Membuka halaman Manajemen User | Pengguna memilih halaman manajemen user yang ada pada sidebar |
| Memilih tombol hapus Akun | Pengguna klik pada tombol hapus akun yang ada pada tabel kolom aksi |
| Konfirmasi akun yang dihapus | Pengguna akan mendapatkan konfirmasi untuk menghapus akun tersebut. |
| Klik tombol hapus | Akun berhasil dihapus |
