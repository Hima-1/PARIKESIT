# Audit Seeder vs Proses Bisnis

Audit ini memakai implementasi runtime dan test sebagai sumber kebenaran utama. Fokusnya adalah apakah seed bawaan mendukung alur aktif `OPD -> Walidata -> Admin/BPS`, konsisten dengan hak akses aktual, dan cukup representatif untuk demo/UAT.

## Ringkasan

- Tidak ditemukan `Critical mismatch` yang membuat seed inti langsung bertentangan dengan guard/controller aktif.
- Ditemukan beberapa `Business-representation gap`: seed inti valid untuk bootstrap master data dan akun dasar, tetapi belum merepresentasikan alur transaksi penilaian end-to-end.
- Ditemukan beberapa `Documentation-only mismatch`: seed selaras dengan kode/test, tetapi berbeda dari dokumen lama yang masih menggambarkan proses atau aktor yang sudah bergeser.

## Critical Mismatch

Tidak ada temuan kategori ini dari seed yang diperiksa.

`UserSeeder`, `MasterDataSeeder`, dan `PembinaanDemoSeeder` masih bisa dipakai untuk bootstrap aplikasi tanpa melanggar akses runtime yang aktif. Ini konsisten dengan:

- koreksi hanya oleh `walidata` di [FormulirPenilaianDisposisiController.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/app/Http/Controllers/Api/FormulirPenilaianDisposisiController.php#L56)
- evaluasi akhir hanya oleh `admin` di [FormulirPenilaianDisposisiController.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/app/Http/Controllers/Api/FormulirPenilaianDisposisiController.php#L87)
- pembinaan hanya dapat dibuat/dibaca oleh `admin` di [StorePembinaanRequest.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/app/Http/Requests/StorePembinaanRequest.php#L19) dan [PembinaanController.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/app/Http/Controllers/Api/PembinaanController.php#L22)

## Business-Representation Gap

### 1. Seed inti belum merepresentasikan lifecycle penilaian end-to-end

- `DatabaseSeeder` hanya memanggil `UserSeeder`, `MasterDataSeeder`, `IndikatorKriteriaSeeder`, dan demo pembinaan lokal di [DatabaseSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/DatabaseSeeder.php#L17).
- Tidak ada seed contoh untuk `formulir` operasional milik pengguna aktif, `penilaian`, koreksi walidata (`nilai_diupdate`), atau evaluasi admin/BPS (`nilai_koreksi`).
- Dampak: `migrate:fresh --seed` cukup untuk login dan bootstrap master data, tetapi tidak cukup untuk demo/UAT yang ingin langsung melihat alur penilaian, disposisi, dan perbandingan skor tanpa input manual.
- Rekomendasi: pertahankan seed inti tetap bersih untuk bootstrap, lalu tambahkan seeder demo terpisah khusus lifecycle penilaian.

### 2. `Formulir Master Data` bukan contoh formulir operasional yang representatif

- `MasterDataSeeder` membuat satu formulir global bernama `Formulir Master Data` dan mengaitkan semua domain template di [MasterDataSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/MasterDataSeeder.php#L149).
- Formulir ini dibuat oleh akun `admin@gmail.com`, bukan oleh OPD, sehingga tidak menggambarkan kasus bisnis paling umum untuk input penilaian mandiri.
- Dampak: seed ini valid sebagai template bootstrap, tetapi bisa menimbulkan asumsi keliru bahwa formulir operasional utama berasal dari admin.
- Rekomendasi: biarkan seeder ini sebagai seed master/template, tetapi pisahkan dari contoh formulir bisnis nyata; bila perlu ganti nama menjadi lebih eksplisit, misalnya "Template Master Data".

### 3. `PembinaanDemoSeeder` valid secara runtime, tetapi mencerminkan kebijakan akses saat ini, bukan narasi bisnis lama

- `PembinaanDemoSeeder` selalu mengambil `admin@gmail.com` sebagai pembuat data di [PembinaanDemoSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/PembinaanDemoSeeder.php#L15) dan menyimpan `created_by_id` admin di [PembinaanDemoSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/PembinaanDemoSeeder.php#L50).
- Ini sesuai runtime sekarang karena API pembinaan dibatasi untuk `admin`.
- Dampak: demo pembinaan terlihat seolah domain pembinaan hanya milik admin, padahal dokumen lama masih menggambarkan pembinaan sebagai aktivitas lintas aktor.
- Rekomendasi: biarkan sebagai demo seeder selama pembinaan memang admin-only; jika produk nanti kembali membuka pembinaan untuk OPD/Walidata, seeder demo harus ikut diubah.

### 4. `IndikatorKriteriaSeeder` cukup selaras, tetapi masih rapuh terhadap variasi nama indikator

- Master data menormalkan sebagian nama indikator dengan `trim()` di [MasterDataSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/MasterDataSeeder.php#L136), dan sebagian update kriteria juga memakai helper trim di [IndikatorKriteriaSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/IndikatorKriteriaSeeder.php#L10).
- Namun masih ada beberapa update yang bergantung pada string literal atau `LIKE` karena nama indikator mengandung spasi ganda, misalnya indikator profesionalitas dan literasi statistik di [IndikatorKriteriaSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/IndikatorKriteriaSeeder.php#L32), [IndikatorKriteriaSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/IndikatorKriteriaSeeder.php#L42), [IndikatorKriteriaSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/IndikatorKriteriaSeeder.php#L122), [IndikatorKriteriaSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/IndikatorKriteriaSeeder.php#L132), dan [IndikatorKriteriaSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/IndikatorKriteriaSeeder.php#L224).
- Dampak: saat nama indikator disunting di masa depan, update kriteria bisa diam-diam tidak mengenai target, walau secara bisnis indikatornya masih sama.
- Rekomendasi: standar-kan semua lookup dengan normalisasi yang sama, idealnya berbasis identifier stabil atau minimal `TRIM`/slug yang konsisten.

## Documentation-Only Mismatch

### 1. Dokumen basis data masih menggambarkan pembinaan sebagai aktivitas OPD/Walidata, sedangkan runtime sekarang admin-only

- Dokumen lama menyebut pembinaan sebagai kegiatan oleh OPD dan Walidata/BPS di [basisData.md](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/docs/basisData.md#L36).
- Runtime sekarang membatasi pembinaan ke `admin` melalui request/controller.
- Seeder demo mengikuti runtime saat ini, bukan dokumen lama.
- Rekomendasi: perbarui dokumen agar menjelaskan bahwa pembinaan saat ini adalah modul admin-only, atau ubah implementasi jika dokumen yang dianggap benar.

### 2. Dokumen lama menekankan entitas `formulir_penilaian_disposisis`, tetapi lifecycle aktif API berjalan langsung pada tabel `penilaians`

- Dokumen basis data masih menempatkan `formulir_penilaian_disposisis` sebagai entitas disposisi utama di [basisData.md](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/docs/basisData.md#L47).
- Implementasi dan test lifecycle aktif justru menyimpan koreksi/evaluasi di `penilaians` melalui `nilai_diupdate`, `catatan_koreksi`, `nilai_koreksi`, dan `evaluasi`.
- Seeder tidak mengisi data disposisi terpisah, dan itu selaras dengan runtime yang sedang dipakai.
- Rekomendasi: sinkronkan dokumentasi data model dengan implementasi aktual agar ekspektasi terhadap seeder tidak salah arah.

### 3. Dokumen API/formulir tidak sepenuhnya merefleksikan pembatasan operasional yang tampil di UI web

- API test menunjukkan user terautentikasi dapat membuat formulir di [FormulirApiTest.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/tests/Feature/Api/FormulirApiTest.php#L23), dan service akan menyet `created_by_id` ke user login di [FormulirService.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/app/Services/FormulirService.php#L22).
- Sementara sebagian narasi bisnis lama dan UI web lebih menekankan formulir sebagai domain kerja OPD.
- Seeder `Formulir Master Data` yang dibuat oleh admin tidak melanggar runtime API, tetapi memang tidak mewakili jalur UI bisnis yang paling umum.
- Rekomendasi: tegaskan di dokumentasi apakah formulir adalah resource umum semua role terautentikasi, atau resource OPD-first dengan pengecualian API tertentu.

## Validasi User Seeder

### Selaras dengan runtime

- Akun `walidata` tunggal sudah sesuai peran koreksi runtime di [UserSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/UserSeeder.php#L144).
- Akun BPS yang disimpan sebagai `admin` konsisten dengan evaluasi akhir admin/BPS di [UserSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/UserSeeder.php#L421).
- Akun OPD massal selaras dengan kalkulasi dashboard dan summary yang memang mengambil seluruh user `role = opd`.

### Catatan data kualitas non-bisnis

- Ada email seeded yang tampak typo seperti `disdukcapil@klaten.g.id` di [UserSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/UserSeeder.php#L68) dan `bpkpad@klaten.gi.id` di [UserSeeder.php](/Users/ASUS/Documents/Github/flutter/parikesit_laravel/database/seeders/UserSeeder.php#L128).
- Ini bukan mismatch proses bisnis, tetapi bisa mengganggu login, komunikasi, atau kredibilitas data demo.
- Rekomendasi: koreksi sebagai perbaikan data seed terpisah.

## Verifikasi yang Dijalankan

Test berikut dijalankan dan seluruhnya lulus:

- `php artisan test tests\Feature\Api\AssessmentLifecycleTest.php`
- `php artisan test tests\Feature\Api\DisposisiApiTest.php`
- `php artisan test tests\Feature\Api\PenilaianApiTest.php`

Hasilnya mengonfirmasi bahwa alur `OPD -> Walidata -> Admin` aktif di runtime, walau seed bawaan belum menyediakan data transaksi untuk memamerkan alur tersebut secara langsung.

## Tindak Lanjut yang Disarankan

1. Pertahankan `UserSeeder` dan `MasterDataSeeder` sebagai seed bootstrap inti.
2. Tambahkan seeder demo baru untuk lifecycle penilaian lengkap: formulir contoh, penilaian OPD, koreksi walidata, dan evaluasi admin/BPS.
3. Ubah nama atau dokumentasikan `Formulir Master Data` sebagai template bootstrap agar tidak dibaca sebagai formulir operasional utama.
4. Rapikan lookup pada `IndikatorKriteriaSeeder` agar tidak rapuh terhadap perubahan whitespace/nama indikator.
5. Perbarui dokumentasi lama yang masih menggambarkan model pembinaan dan disposisi versi sebelumnya.
