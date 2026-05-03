# Audit Keamanan Laravel Web/API

Tanggal audit: 2026-03-28  
Lingkup: `parikesit_laravel`  
Metode: white-box static review + verifikasi dengan test yang sudah ada

## Ringkasan

Audit ini menemukan beberapa risiko nyata pada area auth, admin/user management, route safety, input handling, dan file access. Dua temuan paling serius adalah penyimpanan password plaintext di database dan alur reset password admin yang menggunakan password statis lalu mengembalikan password baru di response API. Selain itu ada endpoint debug 500 yang masih terekspos, kontrol akses baca yang longgar pada API dokumentasi, route destruktif via `GET`, dan parameter sorting/pagination yang belum di-whitelist.

Beberapa perilaku berisiko juga sudah dikunci oleh test saat ini, sehingga perbaikan nanti perlu dibarengi pembaruan test.

## Temuan Prioritas

### 1. Critical: Password plaintext disimpan di database

- Lokasi:
  - `database/migrations/2025_10_31_234800_add_plain_password_to_users_table.php:17`
  - `app/Models/User.php:24`
  - `app/Services/UserService.php:37`
  - `app/Services/UserService.php:51`
  - `app/Services/UserService.php:75`
  - `app/Http/Controllers/Api/ProfileController.php:46`
- Endpoint/flow terkait:
  - `POST /api/users`
  - `PATCH /api/users/{user}`
  - `POST /api/users/{user}/reset-password`
  - `PATCH /api/profile`
- Bukti:
  - Migrasi menambahkan kolom `plain_password`.
  - Model `User` menjadikan `plain_password` sebagai `fillable`.
  - Service user menyalin password mentah ke `plain_password` saat create, update, dan reset.
  - Update profil API juga menyimpan password baru ke `plain_password`.
- Dampak:
  - Kompromi database, backup, dump, query log, atau akses admin internal langsung mengungkap kredensial pengguna.
  - Pelanggaran kontrol dasar password handling dan meningkatkan blast radius insiden secara drastis.
- Skenario eksploitasi:
  - Penyerang dengan akses read-only ke database atau backup dapat langsung mengambil password seluruh user tanpa perlu cracking hash.
- Mitigasi minimum:
  - Hapus seluruh penulisan ke `plain_password`.
  - Rencanakan migrasi penghapusan kolom `plain_password`.
  - Audit seeders, factories, test, dan alur admin yang masih mengandalkan password plaintext.

### 2. High: Reset password admin memakai password statis dan mengembalikan password baru di API response

- Lokasi:
  - `app/Services/UserService.php:71`
  - `app/Http/Controllers/Api/UserManagementController.php:63`
  - `tests/Feature/Api/UserManagementApiTest.php:181`
- Endpoint terkait:
  - `POST /api/users/{user}/reset-password`
- Bukti:
  - `resetPassword()` default ke nilai tetap `password123`.
  - Controller mengembalikan `new_password` ke caller.
  - Test saat ini secara eksplisit mengharapkan field `new_password` ada di response.
- Dampak:
  - Reset password menjadi dapat diprediksi.
  - Password baru terekspos di response API, tooling client, proxy log, browser devtools, observability, dan pihak internal yang tidak perlu tahu.
- Skenario eksploitasi:
  - Akun admin yang kompromi dapat mereset user mana pun ke password yang diketahui.
  - Password hasil reset dapat tertinggal di log aplikasi/API gateway.
- Mitigasi minimum:
  - Jangan gunakan password statis.
  - Ganti alur menjadi token reset sekali pakai atau paksa admin membuat password sementara acak yang tidak pernah dikembalikan lagi setelah display awal yang aman.
  - Hentikan pengembalian `new_password` di response API.

### 3. High: Endpoint debug `/api/test-500` masih terekspos

- Lokasi:
  - `routes/api.php:33`
  - `tests/Feature/Api/ErrorHandlingTest.php:21`
- Endpoint terkait:
  - `GET /api/test-500`
- Bukti:
  - Route publik melempar exception sengaja.
  - Test memastikan endpoint ini tetap mengembalikan 500 JSON.
- Dampak:
  - Menyediakan endpoint denial-of-service trivial.
  - Mempermudah fingerprinting environment error handling.
  - Berisiko membocorkan detail tambahan bila konfigurasi runtime berubah atau debug aktif.
- Skenario eksploitasi:
  - Bot atau user anonim dapat memukul endpoint ini terus-menerus untuk menghasilkan error rate tinggi dan noise monitoring.
- Mitigasi minimum:
  - Hapus route ini dari production code.
  - Jika tetap dibutuhkan untuk test, pindahkan ke test-only route registration atau guard `app()->environment('local', 'testing')`.

### 4. High: API dokumentasi membuka baca dan download lintas pemilik tanpa object-level authorization

- Lokasi:
  - `app/Http/Controllers/Api/DokumentasiKegiatanController.php:23`
  - `app/Http/Controllers/Api/DokumentasiKegiatanController.php:69`
  - `app/Http/Controllers/Api/DokumentasiKegiatanController.php:141`
  - `app/Http/Controllers/Api/DokumentasiKegiatanController.php:162`
  - Bandingkan dengan proteksi update/destroy di `app/Http/Controllers/Api/DokumentasiKegiatanController.php:78` dan `:133`
  - `tests/Feature/Api/DokumentasiApiTest.php:12`
  - `tests/Feature/Api/DokumentasiApiTest.php:29`
  - `tests/Feature/Api/DokumentasiApiTest.php:116`
  - `tests/Feature/Api/DokumentasiApiTest.php:141`
- Endpoint terkait:
  - `GET /api/dokumentasi`
  - `GET /api/dokumentasi/{dokumentasi}`
  - `GET /api/dokumentasi/{dokumentasi}/download`
  - `GET /api/dokumentasi/download-batch`
- Bukti:
  - `index()`, `show()`, `download()`, dan `downloadBatch()` tidak membatasi resource ke owner/admin.
  - Hanya `update()` dan `destroy()` yang memeriksa `created_by_id`.
  - Test saat ini justru menganggap user biasa boleh list/show/download dokumentasi.
- Dampak:
  - User terautentikasi dapat mengakses metadata dan paket file dokumentasi milik user lain.
  - Ini adalah IDOR / broken object-level authorization untuk operasi baca.
- Skenario eksploitasi:
  - User biasa mengiterasi ID dokumentasi atau memakai `download-batch` untuk mengekspor dokumen milik pihak lain.
- Mitigasi minimum:
  - Terapkan policy/gate object-level untuk `view`, `viewAny`, dan `download`.
  - Batasi query non-admin ke resource yang mereka miliki atau yang memang sengaja dibagikan.
  - Tambahkan test negatif: non-owner tidak bisa show/download/download-batch resource orang lain.

### 5. Medium: Route destruktif web masih memakai `GET`

- Lokasi:
  - `routes/web.php:67`
  - `routes/web.php:89`
- Endpoint terkait:
  - `GET /file-pembinaan/{filePemb}`
  - `GET /file-dokumentasi/{fileDok}`
- Bukti:
  - Route delete file pada web memakai `GET`, bukan `DELETE` atau `POST` dengan CSRF protection yang sesuai.
- Dampak:
  - Memperbesar risiko CSRF-style triggering, link prefetch, crawler-triggered deletion, dan aksi destruktif tidak idempoten lewat URL biasa.
- Skenario eksploitasi:
  - User yang sedang login bisa dipancing mengunjungi URL atau memuat resource yang memicu penghapusan.
- Mitigasi minimum:
  - Ubah ke `DELETE` atau `POST` dengan CSRF token.
  - Pastikan tombol UI memakai form submit, bukan tautan `href` destruktif.

### 6. Medium: Parameter `sort`, `direction`, dan `per_page` belum di-whitelist sebelum dipakai di query

- Lokasi:
  - `app/Services/UserService.php:25`
  - `app/Http/Controllers/Api/DokumentasiKegiatanController.php:31`
  - `app/Http/Controllers/Api/PembinaanController.php:35`
- Endpoint terkait:
  - `GET /api/users`
  - `GET /api/dokumentasi`
  - `GET /api/pembinaan`
- Bukti:
  - Nilai request langsung dipakai di `orderBy($sortBy, $sortDirection)` dan `paginate($perPage)`.
  - Tidak terlihat whitelist kolom/sort direction pada jalur ini.
- Dampak:
  - User dapat memicu error query, pagination sangat besar, atau manipulasi sorting di luar intent API.
  - Risiko utamanya adalah reliability/DoS kecil dan query behavior abuse; bukan bukti SQL injection langsung dari audit ini.
- Skenario eksploitasi:
  - Penyerang mengirim `per_page` sangat besar atau `sort` tidak valid berulang untuk meningkatkan beban dan error rate.
- Mitigasi minimum:
  - Whitelist kolom yang boleh dipakai untuk sort.
  - Batasi `direction` ke `asc|desc`.
  - Clamp `per_page` ke batas aman.

## Temuan Konfigurasi / Hardening

### 7. Medium: CORS terlalu permisif untuk API bearer-token

- Lokasi:
  - `config/cors.php:22`
  - `config/cors.php:32`
- Bukti:
  - `allowed_origins` diset ke `['*']`.
  - `supports_credentials` diset ke `false`.
- Dampak:
  - Untuk API bearer-token, wildcard origin tidak langsung membuka cookie cross-site, tetapi tetap memperluas permukaan pemanggilan browser dari origin mana pun.
  - Ini meningkatkan risiko integrasi liar, pemakaian origin tak terkontrol, dan memperlemah pembatasan asal request di browser.
- Mitigasi minimum:
  - Restrict origin ke daftar frontend resmi per environment.
  - Dokumentasikan jika API memang public-cross-origin dan lindungi dengan mekanisme lain yang eksplisit.

### 8. Medium: Sanctum personal access token tidak punya expiration

- Lokasi:
  - `config/sanctum.php:49`
  - `app/Http/Controllers/Api/AuthController.php:30`
- Bukti:
  - `expiration => null`.
  - Login membuat token baru tanpa TTL tambahan.
- Dampak:
  - Token yang bocor tetap valid sampai direvoke manual.
  - Meningkatkan dwell time penyerang setelah token compromise.
- Mitigasi minimum:
  - Tetapkan TTL yang sesuai risiko.
  - Tambahkan rotasi/revocation policy dan device/session management yang eksplisit.

### 9. Low: Cookie secure dan security headers belum dipaksa dari aplikasi

- Lokasi:
  - `config/session.php:171`
- Bukti:
  - `secure` bergantung pada `SESSION_SECURE_COOKIE` environment.
  - Tidak ditemukan middleware/header config aplikasi untuk `Strict-Transport-Security`, `Content-Security-Policy`, `X-Frame-Options`, `Referrer-Policy`, atau `X-Content-Type-Options`.
- Dampak:
  - Hardening browser sangat bergantung pada konfigurasi proxy/runtime.
  - Jika environment salah set, sesi web bisa terkirim tanpa atribut secure.
- Mitigasi minimum:
  - Pastikan production memaksa HTTPS dan `SESSION_SECURE_COOKIE=true`.
  - Terapkan security headers di app middleware atau reverse proxy secara eksplisit.

## Cakupan Test Saat Ini

Test yang dijalankan:

- `tests/Feature/Api/UserManagementApiTest.php`
- `tests/Feature/Api/ErrorHandlingTest.php`
- `tests/Feature/Api/FileCleanupApiTest.php`
- `tests/Feature/Api/AuthApiTest.php`

Hasil:

- `41` test lulus, `128` assertion.

Catatan penting:

- Test saat ini mengunci perilaku yang tidak aman pada:
  - `tests/Feature/Api/UserManagementApiTest.php:181` mengharapkan `new_password` ada di response reset password.
  - `tests/Feature/Api/ErrorHandlingTest.php:21` mengharapkan `/api/test-500` tetap tersedia.
  - `tests/Feature/Api/DokumentasiApiTest.php:12`, `:29`, `:116`, `:141` menganggap user biasa boleh list/show/download/download-batch dokumentasi.
- Test auth hanya memverifikasi `plain_password` tidak bocor ke JSON, tetapi tidak menangkap masalah utama bahwa nilai tersebut tetap disimpan di database.

## Prioritas Remediasi

1. Hapus penyimpanan `plain_password` di semua flow dan rencanakan drop column.
2. Ubah total alur reset password admin: tanpa password statis dan tanpa mengembalikan password di API.
3. Hapus `/api/test-500` dari runtime non-test.
4. Terapkan policy object-level untuk baca/download dokumentasi.
5. Ubah route destruktif web dari `GET` ke method yang aman.
6. Whitelist semua parameter sort/direction/per_page.
7. Restrict CORS, aktifkan token expiration, dan pastikan hardening HTTPS/header di production.
