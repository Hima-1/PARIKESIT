# Analisis Clean Architecture — Parikesit Flutter

> Tujuan: arsitektur tetap **Feature-First + Riverpod** seperti yang dideklarasikan di [AGENTS.md](../AGENTS.md), tapi **tanpa lapisan dekoratif**, **tanpa duplikasi**, dan **konsisten antar fitur**. Filosofi: *lean & mean* — hanya layer yang membayar dirinya sendiri.

---

## 1. Ringkasan Eksekutif

Proyek sudah konsisten di permukaan (semua fitur punya `data/ domain/ presentation/`), tapi di dalam terdapat tiga jenis utang arsitektur:

1. **Layering tidak seragam** — fitur `home` memakai pola `data_sources/ + repositories/ + domain/repositories/` ala "DDD textbook", sedangkan 5 fitur lain menaruh repo langsung di `data/`. Tidak ada keputusan yang jelas dipilih dan diikuti.
2. **Duplikasi infrastruktur** — `core/api/` dan `core/network/` hidup berdampingan; helper parsing JSON Laravel (`_extractMapData`, `_extractListData`, `_parseNullableDouble`) di-copy-paste di 3+ repository.
3. **Abstraksi mati** — `BaseRepository`, `ApiResponse`, `ConnectivityInterceptor`, `StorageService`, beberapa widget di `core/widgets/` ada tapi tidak (atau hampir tidak) dipakai. Mereka membayar biaya kognitif tanpa memberi nilai.

Tindakan yang direkomendasikan dapat dilakukan **inkremental**, tanpa refactor "big bang", dan secara total **mengurangi LoC** alih-alih menambahnya.

---

## 2. Prinsip yang Diadopsi (untuk dipakai sebagai pemandu keputusan)

1. **Satu layer = satu alasan untuk ada.** Jika file hanya meneruskan panggilan ke layer lain, hapus.
2. **Riverpod adalah seam testabilitas.** Kita **tidak butuh interface `IXxxRepository`** hanya untuk mocking — `ProviderContainer.overrideWith(...)` sudah cukup.
3. **Domain = data + invariant bisnis.** Bukan tempat untuk *repository interface* yang impl-nya di-bind di `data/`. Repository bukan konsep domain di app CRUD biasa.
4. **Mapping JSON tinggal di `data/`.** Domain tidak boleh tahu bentuk respons Laravel.
5. **Helper hidup di `core/` jika digunakan ≥2 fitur.** Jika tidak, biarkan inline di fitur. Premature abstraction lebih buruk dari pengulangan terbatas.
6. **State class pakai `freezed`.** `copyWith` manual seperti di `AssessmentFormState` adalah biaya yang bisa dihilangkan dengan satu anotasi.

---

## 3. Target Struktur (sederhana, satu pola untuk semua fitur)

```
lib/
├── core/
│   ├── network/              # SATU rumah untuk Dio, interceptor, response wrappers
│   │   ├── dio_provider.dart
│   │   ├── auth_interceptor.dart
│   │   ├── laravel_response.dart    # parseLaravelPaginatedResponse + extractData/extractList + parseNullableDouble
│   │   ├── laravel_exceptions.dart
│   │   └── paginated_response.dart
│   ├── auth/                 # AppUser, role, role-access (lintas fitur, jadi di core OK)
│   ├── router/
│   ├── storage/              # token_storage saja
│   ├── theme/                # tokens/ + app_theme.dart (sudah baik)
│   ├── helpers/
│   │   └── async_view.dart
│   ├── utils/                # SISAKAN: logger, app_dialogs, app_snackbar, app_error_mapper,
│   │                         #          json_converters, file_saver, file_type, image_to_pdf,
│   │                         #          assets.gen, app_date_formatter, maturity_level,
│   │                         #          provider_observer, startup_probe, error_boundary
│   └── widgets/              # widget umum lintas fitur
│
└── features/<x>/
    ├── data/
    │   ├── <x>_repository.dart           # 1 file: provider + class konkret + mapping
    │   └── <x>_api.dart                  # OPSIONAL: hanya jika pakai retrofit (@RestApi)
    ├── domain/
    │   └── <model>.dart (+ .freezed/.g)  # entitas saja — tidak ada interface repository
    └── presentation/
        ├── controller/
        │   └── <x>_controller.dart       # AsyncNotifier<State> + state freezed
        ├── <screen>.dart
        └── widgets/
```

**Aturan keputusan tunggal**: repository = **kelas konkret + provider** di `data/`. Tidak ada `domain/repositories/`. Tidak ada `data/repositories/<x>_repository_impl.dart`.

---

## 4. Temuan Detail dan Aksi

### 4.1 Layering tidak seragam (PRIORITAS TINGGI)

| Fitur       | Pola yang dipakai                                           | Status         |
|-------------|-------------------------------------------------------------|----------------|
| `auth`      | `data/auth_repository.dart` + `auth_api_client.dart` (retrofit) | ✅ pola target |
| `assessment`| `data/assessment_repository.dart` (interface + impl 975 LoC) | ⚠️ interface + raw Dio |
| `admin`     | `data/admin_*_repository.dart` (interface + impl)            | ⚠️ interface |
| `pembinaan` | `data/{pembinaan,dokumentasi}_repository.dart` (interface + impl) | ⚠️ interface |
| `home`      | `data/data_sources/` + `data/repositories/` + `domain/repositories/` | ❌ over-layered |
| `notifications` | `data/<x>.dart` (kelas konkret langsung)                  | ✅ pola target |

**Aksi:**
1. **`home`** — kolaps `data_sources/dashboard_remote_data_source.dart` (16 LoC retrofit) ke `data/dashboard_repository.dart`, hapus `domain/repositories/`. Setelah kolaps, file repo ~140 LoC.
2. **`assessment`, `admin`, `pembinaan`** — hapus `abstract class IXxxRepository`. Riverpod sudah memberi seam testabilitas yang sama dengan `overrideWith`. Bukti: `notifications/data/notification_repository.dart` sudah pakai pola ini dan testable.
3. Ini **bukan** perubahan perilaku — hanya menghapus indirection. Tes mocktail tetap jalan karena `mockProvider(repositoryProvider, MockRepo())` tidak bergantung pada interface.

> **Pengecualian sah untuk interface**: jika ada **dua implementasi nyata** (mis. fake offline + remote). Saat ini tidak ada.

### 4.2 `core/api/` vs `core/network/` (PRIORITAS TINGGI)

`core/api/` berisi:
- `api_response.dart` — **0 pemakai** di luar dirinya sendiri.
- `connectivity_interceptor.dart` — **0 pemakai**.

`core/network/` adalah satu-satunya jalur yang aktif dipakai.

**Aksi:** hapus seluruh direktori `core/api/`. Jika nanti butuh wrapper response, taruh di `core/network/`.

### 4.3 Duplikasi mapping JSON Laravel (PRIORITAS TINGGI)

Tiga helper privat yang identik di-copy ke beberapa repo:
- `_extractMapData(dynamic) → Map<String,dynamic>`
- `_extractListData(dynamic) → List<dynamic>`
- `_parseNullableDouble(dynamic) → double?`

Plus pola `if (data is Map && data['data'] is Map) ...` muncul di [`dashboard_repository_impl.dart:22-38`](../lib/features/home/data/repositories/dashboard_repository_impl.dart) dan beberapa tempat lain.

**Aksi:** pindahkan ke `core/network/laravel_response.dart` sebagai top-level functions:
```dart
Map<String, dynamic> extractMap(dynamic raw, {String? label});
List<dynamic> extractList(dynamic raw, {String? label});
double? parseNullableDouble(dynamic v);
```
Hapus duplikat dari semua repo. Hemat ~60–80 LoC + bug-shape konsisten.

### 4.4 `BaseRepository` (PRIORITAS MENENGAH)

`lib/core/utils/base_repository.dart` punya dua method:
- `safeRequest` — hanya wrapper `try/catch + log + rethrow`. Gantikan dengan satu helper: `runLogged('label', () => ...)` di `logger.dart`, atau hapus dan biarkan log di interceptor (Talker sudah aktif).
- `toAsyncValue` — **tidak dipakai** di mana pun. `AsyncNotifier` + `AsyncValue.guard` sudah memberi ini.

**Aksi:** hapus class `BaseRepository`. Repo cukup kelas biasa. Logging yang masih dibutuhkan diserap interceptor; jika ada hot-spot, panggil `AppLogger.error` langsung.

### 4.5 `presentation/models/` di `assessment` (PRIORITAS RENDAH)

Ada `presentation/models/evidence_attachment.dart` dan `indicator_review_models.dart` — view-model yang hanya dipakai layar.

**Aksi:** ini sebetulnya OK, tapi konsistenkan namanya jadi `presentation/state/` atau gabung ke file controller. Saat ini bingung dengan `domain/`. Tidak mendesak — tunda sampai layer lain beres.

### 4.6 State class tanpa freezed

[`AssessmentFormState`](../lib/features/assessment/presentation/controller/assessment_controller.dart#L8-L57) menulis `copyWith` manual dengan flag `clearSelectedDomain` / `clearSelectedAspek`.

**Aksi:** jadikan `@freezed`. `copyWith` yang dihasilkan menerima `Value<T?>` untuk membedakan "tidak set" vs "set null". Hilangkan ~30 LoC boilerplate dan menghilangkan kelas bug "lupa update copyWith".

### 4.7 Domain `assessment` terlalu pecah (PRIORITAS RENDAH)

`lib/features/assessment/domain/` punya 13+ file `.dart` (ditambah `.freezed`/`.g`), beberapa hanya 1 class kecil. Plus `assessment_models.dart` adalah catch-all multi-class.

**Aksi:** kelompokkan logis:
- `assessment_form.dart` — `AssessmentFormModel`, `RoleScore`, `PendingIndicatorPreview` (yang sekarang di `assessment_models.dart`)
- `indikator.dart` — `AssessmentIndikator`, `AssessmentAspek`, `AssessmentDomain` (struktur formulir)
- `penilaian.dart` — `Penilaian`, `BuktiDukung`, `AssessmentDisposisi`
- `opd.dart`, `comparison_summary.dart` (sudah OK)

Ini menyentuh banyak import; lakukan saat layer 4.1–4.4 sudah beres.

### 4.8 Mati / belum diadopsi di `core/widgets/`

Tidak dirujuk dari mana pun:
- `app_shortcut_grid.dart`
- `ethno_divider.dart`
- `ethno_radar_chart.dart`
- `paged_list_view.dart` *(diwajibkan AGENTS.md tapi belum ada konsumen — adopsi di `assessment/opd_selection_screen.dart` & `admin/user_management_screen.dart` dulu sebelum disebut "core")*

Belum diadopsi luas:
- `app_form_dialog.dart`, `app_filter_bar.dart`, `asyncView<T>` — baru dipakai 1–3 layar walau diwajibkan.

**Aksi:**
1. Hapus `app_shortcut_grid`, `ethno_divider`, `ethno_radar_chart` jika tidak ada rencana 1 sprint ke depan.
2. Buat satu PR "adopsi paged-list/form-dialog/filter-bar" untuk migrasi semua layar yang masih custom.
3. `core/utils/storage_service.dart` (53 LoC, 0 pemakai) — hapus.

### 4.9 Provider didefinisikan di file repo

Saat ini setiap repo file mengakhiri dirinya dengan `final xxxRepositoryProvider = Provider(...)`. Ini OK dan **lebih ringkas** dari memindah ke `<x>_providers.dart`. Pertahankan; jangan ikuti tren "satu file providers per fitur" — itu menambah indirection tanpa nilai.

### 4.10 `assessment_repository.dart` — 975 LoC

Ini bukan masalah arsitektur, tapi masalah **ukuran**. Setelah 4.3 (mapping helpers ke core), file akan turun ke ~850 LoC. Pertimbangan tambahan: mapping per-entitas (`_mapFormulir`, `_mapComparisonSummary`, ...) adalah **mappers**, bukan repository concern.

**Aksi opsional:** ekstrak satu file `data/assessment_mappers.dart` (private top-level functions). Repo turun jadi ~500 LoC orchestrasi murni. Tunda kecuali file ini menjadi titik konflik merge.

---

## 5. Roadmap Inkremental (urutan eksekusi yang aman)

Setiap langkah berdiri sendiri, hijau-tes, dan bisa di-merge sebelum langkah berikutnya.

| # | Langkah | Sentuh file | Risiko |
|---|---|---|---|
| 1 | Hapus `core/api/` (`api_response`, `connectivity_interceptor`) + `core/utils/storage_service.dart` | hapus 6 file | nol — 0 pemakai |
| 2 | Pindahkan `extractMap/extractList/parseNullableDouble` ke `core/network/laravel_response.dart`; ganti pemakaian privat di `assessment_repository.dart`, `dashboard_repository_impl.dart`, dst. | 4–5 file | rendah |
| 3 | Hapus `BaseRepository`; repo yang `extends BaseRepository` jadi class biasa, panggil `AppLogger` di tempat yang masih perlu | 5 file | rendah |
| 4 | Kolaps fitur `home`: gabung `data_sources/` + `data/repositories/` + `domain/repositories/` jadi satu `data/dashboard_repository.dart`; pindahkan `IDashboardRepository` ke kelas konkret | 4 file dihapus, 1 disederhanakan | rendah (tes provider) |
| 5 | Hapus `abstract class IAssessmentRepository / IAdmin* / IPembinaan* / IDokumentasi*`; ubah provider jadi `Provider<XxxRepository>` (kelas konkret) | 4 file | rendah — pastikan test override pakai class konkret |
| 6 | `AssessmentFormState` → `@freezed` | 1 file + `.freezed`/`.g` | rendah |
| 7 | Adopsi `PagedListView` / `AppFormDialog` / `AppFilterBar` / `asyncView` di layar yang masih custom (1 PR per kategori) | banyak layar | medium — visual regress test |
| 8 | (Opsional) Pisah `assessment_mappers.dart`; reorganisasi `assessment/domain/` per cluster | banyak | medium |

Total LoC yang dipangkas pada langkah 1–6 saja: estimasi **−400 hingga −600 LoC** dengan **0 perubahan perilaku**.

---

## 6. Kapan TIDAK Mengikuti Saran Ini

- **Jika muncul kebutuhan offline-first** (cache lokal Hive serius), interface repository **berhak hidup kembali** karena akan ada dua implementasi (remote + cache). Saat itu tiba, tambahkan interface — tidak sebelumnya.
- **Jika `assessment_repository.dart` mulai sering konflik merge**, dahulukan langkah 8 dari roadmap.
- **Jika tim memutuskan adopsi `riverpod_generator`** (codegen `@riverpod`), revisi konvensi penamaan provider; tapi itu adalah keputusan terpisah dari pembersihan ini.

---

## 7. Ringkasan untuk PR Tunggal Pertama

Jika hanya ingin satu PR pembuka yang aman dan mengirim sinyal "kita serius lean":

> **PR: prune dead infra & dedupe Laravel mappers**
> 1. Hapus `core/api/`, `core/utils/storage_service.dart`, `core/utils/base_repository.dart`.
> 2. Promosikan `_extractMapData` / `_extractListData` / `_parseNullableDouble` ke `core/network/laravel_response.dart`.
> 3. Update 3 repo yang memakainya.
>
> **Hasil:** −250 LoC, satu sumber kebenaran untuk parsing Laravel, tidak ada fitur yang berubah.

Setelahnya, eksekusi langkah 4–6 secara berurutan.
