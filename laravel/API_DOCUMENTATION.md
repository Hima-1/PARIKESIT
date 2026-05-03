# Parikesit API Documentation

Dokumen ini merangkum endpoint API backend yang aktif pada tanggal 29 Maret 2026 berdasarkan `routes/api.php`, controller API, dan feature test.

## Autentikasi

API memakai bearer token Sanctum.

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `POST` | `/api/login` | Login memakai `email` dan `password` | No | `tests/Feature/Api/AuthApiTest.php` |
| `POST` | `/api/logout` | Logout current token dan nonaktifkan device token terkait | Yes | `tests/Feature/Api/AuthApiTest.php` |
| `GET` | `/api/user` | Data user yang sedang login | Yes | `tests/Feature/Api/AuthApiTest.php` |
| `GET` | `/api/profile` | Detail profil user login | Yes | `tests/Feature/Api/AuthApiTest.php` |
| `PATCH` | `/api/profile` | Update profil via JSON | Yes | `tests/Feature/Api/AuthApiTest.php` |
| `POST` | `/api/profile/update` | Fallback update profil via multipart | Yes | Belum ada test khusus |

## Notifikasi dan Device Token

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `POST` | `/api/me/devices/fcm-token` | Registrasi atau update FCM token aktif | Yes | `tests/Feature/Api/DeviceTokenApiTest.php` |
| `DELETE` | `/api/me/devices/fcm-token` | Nonaktifkan FCM token milik user login | Yes | `tests/Feature/Api/DeviceTokenApiTest.php` |
| `GET` | `/api/notifications` | List inbox notification milik user | Yes | `tests/Feature/Api/NotificationApiTest.php` |
| `PATCH` | `/api/notifications/read-all` | Tandai semua notifikasi sebagai dibaca | Yes | `tests/Feature/Api/NotificationApiTest.php` |
| `PATCH` | `/api/notifications/{notification}/read` | Tandai satu notifikasi sebagai dibaca | Yes | `tests/Feature/Api/NotificationApiTest.php` |
| `DELETE` | `/api/notifications/{notification}` | Sembunyikan satu notifikasi | Yes | `tests/Feature/Api/NotificationApiTest.php` |
| `DELETE` | `/api/notifications/read` | Sembunyikan semua notifikasi yang sudah dibaca | Yes | `tests/Feature/Api/NotificationApiTest.php` |

## Formulir dan Penilaian

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `GET` | `/api/formulir` | List formulir | Yes | `tests/Feature/Api/FormulirApiTest.php` |
| `POST` | `/api/formulir` | Buat formulir | Yes | `tests/Feature/Api/FormulirApiTest.php` |
| `GET` | `/api/formulir/{formulir}` | Detail formulir | Yes | `tests/Feature/Api/FormulirApiTest.php` |
| `PATCH` | `/api/formulir/{formulir}` | Ubah nama formulir | Yes | `tests/Feature/Api/FormulirApiTest.php` |
| `DELETE` | `/api/formulir/{formulir}` | Hapus formulir | Yes | `tests/Feature/Api/FormulirApiTest.php` |
| `POST` | `/api/formulir/{formulir}/set-default-children` | Inisialisasi default domain/aspek/indikator | Yes | `tests/Feature/Api/FormulirApiTest.php` |
| `POST` | `/api/formulir/{formulir}/domains` | Tambah domain ke formulir | Yes | Belum ada test khusus |
| `GET` | `/api/formulir/{formulir}/indicators` | Ambil struktur domain/aspek/indikator dan penilaian | Yes | `tests/Feature/Api/PenilaianApiTest.php`, `tests/Feature/Api/AssessmentLifecycleTest.php` |
| `POST` | `/api/formulir/{formulir}/indikator/{indikator}/penilaian` | Simpan atau update penilaian OPD | Yes | `tests/Feature/Api/PenilaianApiTest.php`, `tests/Feature/Api/AssessmentLifecycleTest.php` |

Catatan:

- Endpoint ini menerima query `user_id`.
- Implementasi otorisasi saat ini mengizinkan admin atau owner formulir; walidata lintas OPD belum lolos guard endpoint ini.

## Penilaian Selesai, Koreksi, dan Evaluasi

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `GET` | `/api/penilaian-selesai` | List formulir yang memiliki penilaian | Yes | `tests/Feature/Api/DisposisiApiTest.php` |
| `GET` | `/api/penilaian-selesai/{formulir}/opds` | List OPD peserta untuk formulir | Yes | `tests/Feature/Api/DisposisiApiTest.php` |
| `GET` | `/api/penilaian-selesai/{formulir}/summary` | Ringkasan perbandingan skor semua OPD | Yes | `tests/Feature/Api/DisposisiApiTest.php` |
| `GET` | `/api/penilaian-selesai/{formulir}/opd/{user}/stats` | Ringkasan skor dan progress satu OPD | Yes | `tests/Feature/Api/DisposisiApiTest.php`, `tests/Feature/Api/AssessmentLifecycleTest.php` |
| `GET` | `/api/penilaian-selesai/{formulir}/opd/{user}/domains` | Ringkasan skor per domain untuk satu OPD | Yes | `tests/Feature/Api/DisposisiApiTest.php` |
| `POST` | `/api/penilaian-selesai/koreksi` | Simpan koreksi walidata | Yes | `tests/Feature/Api/DisposisiApiTest.php`, `tests/Feature/Api/AssessmentLifecycleTest.php` |
| `POST` | `/api/penilaian-selesai/evaluasi` | Simpan evaluasi final admin | Yes | `tests/Feature/Api/DisposisiApiTest.php`, `tests/Feature/Api/AssessmentLifecycleTest.php` |

## Dokumentasi dan Pembinaan

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `GET` | `/api/pembinaan` | List pembinaan | Admin | `tests/Feature/Api/ActivityApiTest.php` |
| `POST` | `/api/pembinaan` | Buat pembinaan | Yes | `tests/Feature/Api/ActivityApiTest.php` |
| `GET` | `/api/pembinaan/{pembinaan}` | Detail pembinaan | Admin | `tests/Feature/Api/ActivityApiTest.php` |
| `PUT/PATCH` | `/api/pembinaan/{pembinaan}` | Update pembinaan | Yes | `tests/Feature/Api/ActivityApiTest.php` |
| `POST` | `/api/pembinaan/{pembinaan}` | Fallback update multipart | Yes | Belum ada test khusus |
| `DELETE` | `/api/pembinaan/{pembinaan}` | Hapus pembinaan | Yes | `tests/Feature/Api/ActivityApiTest.php` |
| `GET` | `/api/pembinaan/download-batch` | Download ZIP banyak pembinaan | Admin | `tests/Feature/Api/ActivityApiTest.php` |
| `GET` | `/api/pembinaan/{pembinaan}/download` | Download ZIP satu pembinaan | Admin | `tests/Feature/Api/ActivityApiTest.php` |
| `DELETE` | `/api/file-pembinaan/{filePemb}` | Hapus file pembinaan tertentu | Yes | `tests/Feature/Api/FileCleanupApiTest.php` |
| `GET` | `/api/dokumentasi` | List dokumentasi | Admin/OPD/Walidata | `tests/Feature/Api/DokumentasiApiTest.php` |
| `POST` | `/api/dokumentasi` | Buat dokumentasi | Yes | `tests/Feature/Api/DokumentasiApiTest.php` |
| `GET` | `/api/dokumentasi/{dokumentasi}` | Detail dokumentasi | Admin/OPD/Walidata | `tests/Feature/Api/DokumentasiApiTest.php` |
| `PUT/PATCH` | `/api/dokumentasi/{dokumentasi}` | Update dokumentasi | Yes | `tests/Feature/Api/DokumentasiApiTest.php` |
| `POST` | `/api/dokumentasi/{dokumentasi}` | Fallback update multipart | Yes | Belum ada test khusus |
| `DELETE` | `/api/dokumentasi/{dokumentasi}` | Hapus dokumentasi | Yes | `tests/Feature/Api/DokumentasiApiTest.php` |
| `GET` | `/api/dokumentasi/download-batch` | Download ZIP banyak dokumentasi | Admin/OPD/Walidata | `tests/Feature/Api/DokumentasiApiTest.php` |
| `GET` | `/api/dokumentasi/{dokumentasi}/download` | Download ZIP satu dokumentasi | Admin/OPD/Walidata | `tests/Feature/Api/DokumentasiApiTest.php` |
| `DELETE` | `/api/file-dokumentasi/{fileDok}` | Hapus file dokumentasi tertentu | Yes | `tests/Feature/Api/FileCleanupApiTest.php` |

## Dashboard

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `GET` | `/api/dashboard/stats` | Statistik dashboard sesuai role | Yes | `tests/Feature/Api/DashboardApiTest.php`, `tests/Feature/Api/AssessmentDashboardIntegrationTest.php` |
| `GET` | `/api/dashboard/performa-opd` | Data performa OPD | Yes | `tests/Feature/Api/DashboardApiTest.php` |
| `GET` | `/api/dashboard/progress-penilaian` | Data progress penilaian | Yes | `tests/Feature/Api/DashboardApiTest.php` |

## User Management

Semua endpoint berikut berada di grup `can:admin`.

| Method | Endpoint | Deskripsi | Auth | Tests |
| :--- | :--- | :--- | :---: | :--- |
| `GET` | `/api/users` | List user | Admin | `tests/Feature/Api/UserManagementApiTest.php` |
| `POST` | `/api/users` | Buat user | Admin | `tests/Feature/Api/UserManagementApiTest.php` |
| `GET` | `/api/users/{user}` | Detail user | Admin | `tests/Feature/Api/UserManagementApiTest.php` |
| `PATCH` | `/api/users/{user}` | Update user | Admin | `tests/Feature/Api/UserManagementApiTest.php` |
| `DELETE` | `/api/users/{user}` | Hapus user | Admin | `tests/Feature/Api/UserManagementApiTest.php` |
| `POST` | `/api/users/{user}/reset-password` | Reset password sementara dan cabut token aktif | Admin | `tests/Feature/Api/UserManagementApiTest.php` |
| `POST` | `/api/users/{user}/trigger-opd-reminder` | Kirim reminder manual ke OPD | Admin | `tests/Feature/Api/UserManagementApiTest.php` |

## Catatan Perubahan Terkini

- Login API saat ini memakai `email`, bukan `username`
- Notifikasi inbox dan FCM device token sudah menjadi bagian kontrak API aktif
- Password plaintext tidak lagi menjadi bagian model user; reset password mengembalikan password sementara lewat response admin
- Endpoint debug `GET /api/test-500` hanya aktif pada environment `testing`
