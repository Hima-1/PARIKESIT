# 12. Arsitektur dan UI

Dokumen ini menjelaskan cara Flutter disusun dan aturan UI yang harus diikuti saat menambah fitur.

## 1. Arsitektur Flutter

Flutter memakai pendekatan feature-first:

```text
lib/
  core/
  features/
    auth/
    home/
    assessment/
    notifications/
    pembinaan/
    admin/
```

## 2. Fungsi Modul

| Modul | Fungsi |
| --- | --- |
| `auth` | Login, profil, ganti password, auth provider |
| `home` | Dashboard per role |
| `assessment` | Formulir, penilaian mandiri, koreksi, evaluasi |
| `notifications` | Inbox notifikasi, FCM, dan resolver rute payload notifikasi |
| `pembinaan` | Dokumentasi kegiatan dan pembinaan |
| `admin` | Dashboard admin, user management, dokumentasi terpusat |

## 3. Alur Penilaian

1. OPD membuat formulir.
2. OPD mengisi nilai, catatan, dan bukti dukung per indikator.
3. Walidata meninjau dan mengisi koreksi.
4. Admin melakukan evaluasi akhir.
5. OPD melihat hasil dan progres.

## 4. Route Berdasarkan Role

| Role | Akses utama |
| --- | --- |
| `opd` | Formulir, penilaian mandiri, dokumentasi kegiatan, notifikasi, profil |
| `walidata` | Review penilaian selesai, dokumentasi kegiatan, notifikasi, profil |
| `admin` | Dashboard admin, evaluasi, user management, dokumentasi, pembinaan, notifikasi, profil |

## 5. Design System

Style visual aplikasi adalah Javanese Modern Heritage:

- warna utama sogan brown
- surface white dengan aksen cream seperlunya
- border 1px
- shadow minimal
- komponen konsisten melalui token theme

Token visual berada di:

```text
flutter/lib/core/theme/tokens/
```

Gunakan token atau `Theme.of(context)`. Jangan menulis warna mentah seperti `Color(0xFF...)` di screen baru.

Background light theme aplikasi memakai `AppTheme.background` agar halaman publik dan scaffold utama konsisten. Jika mengubah warna dasar, ubah token/theme, bukan screen satu per satu.

## 6. Komponen UI yang Disarankan

| Kebutuhan | Komponen |
| --- | --- |
| Button | `EthnoButton` |
| Card | `EthnoCard` |
| Text input | `AppTextField` |
| Dropdown | `AppDropdownField`, `AppSortDropdownField` |
| Upload file | `FileUploadField` |
| Loading | `AppLoadingState`, `SkeletonLoader` |
| Empty state | `AppEmptyState` |
| Error state | `AppErrorState` |
| Form modal | `AppFormDialog` |
| Filter/search | `AppFilterBar` |
| Pagination | `AppPaginationFooter`, `PagedListView<T>` |
| Layout utama | `MainLayout`, `AppHeader`, `AppSidebar`, `AppBottomNav` |

## 7. Checklist Saat Menambah UI

- Tidak ada warna mentah di screen.
- Tidak ada radius/spacing angka acak jika token sudah tersedia.
- Loading, empty, dan error state tersedia.
- Form menampilkan validasi yang jelas.
- Layout mobile tidak overflow.
- Widget umum hanya masuk `core/widgets` jika dipakai lebih dari satu fitur.
- Widget khusus fitur tetap berada di `features/<nama>/presentation/widgets`.

## 8. Catatan Arsitektur

Catatan audit arsitektur sebelumnya menemukan beberapa area yang perlu disederhanakan:

- beberapa repository memakai pola layer yang tidak seragam
- ada helper parsing Laravel yang sempat berulang
- beberapa abstraksi tidak dipakai
- beberapa widget core belum diadopsi luas

Jangan menambah layer baru hanya karena terlihat rapi. Tambahkan abstraksi hanya jika mengurangi duplikasi nyata atau dipakai lintas fitur.

Helper lintas fitur yang sudah ada:

| Helper | Fungsi |
| --- | --- |
| `features/notifications/data/notification_navigation.dart` | Menentukan rute internal dari payload FCM sebelum dipakai `NotificationService` |
