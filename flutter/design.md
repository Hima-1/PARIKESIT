# Design System: Spacing & Layout

This document defines the spacing system for the Parikesit Flutter application. We prioritize a **lean and mean** approach, focusing on consistency, readability, and speed of implementation for Android.

## 1. Spacing Tokens (The 4-Point Grid)

We use a 4-point incremental grid. All spacing, padding, and margins should ideally be multiples of 4 or 8.

| Token | Size (px/dp) | Use Case |
|-------|--------------|----------|
| `xs`  | 4            | Minimal separation (e.g., icon + text) |
| `sm`  | 8            | Small internal padding, tight groups |
| `md`  | 16           | Standard screen padding, default margins |
| `lg`  | 24           | Significant section breaks |
| `xl`  | 32           | Header spacing, large vertical gaps |
| `xxl` | 48           | Major layout divisions |

## 2. Spacing Widgets (The "Gap" Pattern)

To avoid messy `Padding` nesting, we use standardized constants for `SizedBox`.

### Vertical Gaps (Height)
- `gapH4`: `SizedBox(height: 4)`
- `gapH8`: `SizedBox(height: 8)`
- `gapH16`: `SizedBox(height: 16)`
- `gapH24`: `SizedBox(height: 24)`
- `gapH32`: `SizedBox(height: 32)`
- `gapH48`: `SizedBox(height: 48)`

### Horizontal Gaps (Width)
- `gapW4`: `SizedBox(width: 4)`
- `gapW8`: `SizedBox(width: 8)`
- `gapW16`: `SizedBox(width: 16)`
- `gapW24`: `SizedBox(width: 24)`
- `gapW32`: `SizedBox(width: 32)`
- `gapW48`: `SizedBox(width: 48)`

## 3. Standard Edge Insets

Prefer using these pre-defined constants in `lib/core/theme/app_spacing.dart`:

- `pAll4`, `pAll8`, `pAll16`, `pAll24`, `pAll32`, `pAll48`
- `pH16`: Symmetric horizontal 16
- `pV16`: Symmetric vertical 16
- `pPage`: Standard page padding (16)

## 4. Android Screen Breakpoints

Since we are "Android-only," we optimize for standard handheld and tablet (foldable/large screen) form factors.

| Device Type | Max Width (dp) | Layout Strategy |
|-------------|----------------|-----------------|
| Compact     | < 600          | Single column, bottom navigation |
| Medium/Large| >= 600         | Split-view, side navigation rail |

*Note: Use `LayoutBuilder` or `MediaQuery` to toggle between these strategies.*

---

## Implementation Reference

Create `lib/core/theme/app_spacing.dart`:

```dart
import 'package:flutter/material.dart';


class AppSpacing {
  AppSpacing._();

  // Raw Tokens
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Horizontal Gaps
  static const gapW4 = SizedBox(width: xs);
  static const gapW8 = SizedBox(width: sm);
  static const gapW16 = SizedBox(width: md);
  static const gapW24 = SizedBox(width: lg);
  static const gapW32 = SizedBox(width: xl);
  static const gapW48 = SizedBox(width: xxl);

  // Vertical Gaps
  static const gapH4 = SizedBox(height: xs);
  static const gapH8 = SizedBox(height: sm);
  static const gapH16 = SizedBox(height: md);
  static const gapH24 = SizedBox(height: lg);
  static const gapH32 = SizedBox(height: xl);
  static const gapH48 = SizedBox(height: xxl);

  // Padding Edge Insets
  static const pAll4 = EdgeInsets.all(xs);
  static const pAll8 = EdgeInsets.all(sm);
  static const pAll16 = EdgeInsets.all(md);
  static const pAll24 = EdgeInsets.all(lg);
  static const pAll32 = EdgeInsets.all(xl);
  static const pAll48 = EdgeInsets.all(xxl);

  static const pH16 = EdgeInsets.symmetric(horizontal: md);
  static const pV16 = EdgeInsets.symmetric(vertical: md);

  // Semantic Padding
  static const pPage = EdgeInsets.all(md);
}
```

---

---

# ADR-001: Domain Model & Repository Design for `Penilaian` and `FormulirPenilaianDisposisi`

**Status:** Accepted
**Date:** 2026-03-05
**Context:** Synchronizing Flutter domain models with `basisData.sql`. Two discrepancies were found during schema review and must be resolved with explicit technical decisions before implementation begins.

---

## Decision 1: JSON Key Strategy for `Penilaian`

### Background

The current model (`lib/features/assessment/domain/penilaian.dart`) contains:

```dart
@Default(null) @JsonKey(name: 'evaluasi') String? evaluasi_walidata,
```

This creates a **split-brain** between the Dart field name (`evaluasi_walidata`) and the JSON key (`evaluasi`). The SQL schema confirms the database column is `evaluasi` (migration `2025_08_17_224220_add_evaluasi_walidata_to_penilaians_table` added it as `evaluasi`). The column was *never* renamed to `evaluasi_walidata` in the database — that name only exists in Dart.

The SQL also reveals several **unmapped columns** currently invisible to the model:

| DB Column | DB Type | Dart Model | Status |
|---|---|---|---|
| `evaluasi` | `text` | `evaluasi_walidata` via `@JsonKey(name: 'evaluasi')` | **Misnamed field** |
| `tanggal_penilaian` | `timestamp` | *(missing)* | **Gap** |
| `user_id` | `bigint` | *(missing)* | **Gap** |
| `bukti_dukung` | `text` | *(missing)* | **Gap** (legacy text column) |
| `nilai_diupdate` | `decimal` | *(missing)* | **Gap** |
| `diupdate_by` | `bigint` | *(missing)* | **Gap** |
| `tanggal_diperbarui` | `timestamp` | *(missing)* | **Gap** |
| `tanggal_dikoreksi` | `timestamp` | *(missing)* | **Gap** |

### Decision

**Use exact database column names as both the Dart field name and the JSON key.** Remove the `@JsonKey(name: 'evaluasi')` alias — rename the Dart field from `evaluasi_walidata` to `evaluasi` to match the column.

**Rationale:**

1. **Single source of truth is the SQL schema** (`database-schema-governance/spec.md` is explicit: "the SQL schema SHALL prevail"). The DB column is `evaluasi`; the Dart alias was the mistake.
2. **The existing `@JsonKey` aliasing creates invisible debt.** Any developer reading the model file will expect an `evaluasi_walidata` key in JSON. The API returns `evaluasi`. This mismatch silently breaks payload construction in `submitWalidataCorrection` — confirmed by the mock at line 710 which accesses `data['evaluasi_walidata']` instead of `data['evaluasi']`.
3. **Consistency with all other fields in the codebase.** Every other field in `Penilaian` and all `AssessmentDomain`, `AssessmentAspek`, `AssessmentIndikator` models use verbatim DB names (`formulir_id`, `dikerjakan_by`, `nama_aspek`, etc.). A one-off alias violates this convention.
4. **Dart field naming:** While `snake_case` field names are non-idiomatic Dart, this project has already committed to this convention uniformly. Changing to `camelCase` would require a `@JsonKey` on every field, adding noise. Stay consistent with the existing approach.

### Implementation

```dart
// BEFORE (lib/features/assessment/domain/penilaian.dart)
@Default(null) @JsonKey(name: 'evaluasi') String? evaluasi_walidata,

// AFTER
@Default(null) String? evaluasi,
```

Also update `MockAssessmentRepository` (lines 681, 710) to use `data['evaluasi']`.

**Fields to add in a follow-up model expansion** (not blocking, add when the relevant API surface is consumed):

```dart
@Default(null) DateTime? tanggal_penilaian,
@Default(null) int? user_id,
@Default(null) String? nilai_diupdate,   // keep as String? — legacy decimal stored as text
@Default(null) int? diupdate_by,
@Default(null) DateTime? tanggal_diperbarui,
@Default(null) DateTime? tanggal_dikoreksi,
```

> **Do not add `bukti_dukung` (the legacy `text` column).** It is superseded by the `bukti_dukungs` table (relational, with `BuktiDukung` model). Mapping the legacy column would create two sources for the same data. If the API still returns it, ignore it via `@JsonKey(includeFromJson: false, includeToJson: false)`.

---

## Decision 2: `AssessmentDisposisi` Model Structure

### Background

`formulir_penilaian_disposisis` table schema:

```sql
CREATE TABLE `formulir_penilaian_disposisis` (
  `id`                  bigint UNSIGNED NOT NULL,
  `formulir_id`         bigint UNSIGNED NOT NULL,
  `indikator_id`        bigint UNSIGNED DEFAULT NULL,   -- nullable: may be form-level
  `from_profile_id`     bigint UNSIGNED DEFAULT NULL,   -- sender (users.id)
  `to_profile_id`       bigint UNSIGNED DEFAULT NULL,   -- receiver (users.id)
  `assigned_profile_id` bigint UNSIGNED DEFAULT NULL,   -- currently responsible (users.id)
  `status`              enum('sent','returned','approved','rejected') NOT NULL DEFAULT 'sent',
  `catatan`             text DEFAULT NULL,
  `is_completed`        tinyint(1) NOT NULL DEFAULT 0,
  `deleted_at`          timestamp NULL DEFAULT NULL,
  `created_at`          timestamp NULL DEFAULT NULL,
  `updated_at`          timestamp NULL DEFAULT NULL
)
```

Key observations from the schema:
- Three foreign keys all reference `users.id` (confirmed by `database-schema-governance` spec: "SHALL use the `users` table... MUST NOT use 'Profile' or other aliases").
- `indikator_id` is nullable — a disposisi can apply to an entire formulir or to a single indicator.
- `status` enum is a **strict subset** of `PenilaianStatus`: it excludes `draft` (disposisi cannot be a draft — it is always an action).
- `is_completed` is a boolean flag redundant with `status == approved`, but it exists as a fast aggregate query optimization. Model it, don't ignore it.

### Decision

Create `lib/features/assessment/domain/assessment_disposisi.dart` as a new `freezed` model.

**Enum design:** Define a separate `DisposisiStatus` enum, **not** reusing `PenilaianStatus`. Reusing would couple two independent state machines and would break if either evolves independently.

```dart
@JsonEnum(fieldRename: FieldRename.snake)
enum DisposisiStatus { sent, returned, approved, rejected }
```

**User ID fields:** Name them `from_user_id`, `to_user_id`, and `assigned_user_id`, dropping "profile" — per the governance spec. Use `@JsonKey` to map from the DB column names:

```dart
@JsonKey(name: 'from_profile_id')  int? from_user_id,
@JsonKey(name: 'to_profile_id')    int? to_user_id,
@JsonKey(name: 'assigned_profile_id') int? assigned_user_id,
```

> **Why rename the field but keep the JsonKey?** The DB column uses the misleading "profile" term which the governance spec explicitly bans. The `@JsonKey` bridges the wire format to a correct domain name. This is the legitimate use case for `@JsonKey` — a *governance correction*, not a convenience alias.

**Full model:**

```dart
// lib/features/assessment/domain/assessment_disposisi.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'assessment_disposisi.freezed.dart';
part 'assessment_disposisi.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DisposisiStatus { sent, returned, approved, rejected }

@freezed
class AssessmentDisposisi with _$AssessmentDisposisi {
  const factory AssessmentDisposisi({
    required int id,
    required int formulir_id,
    @Default(null) int? indikator_id,
    @JsonKey(name: 'from_profile_id')     @Default(null) int? from_user_id,
    @JsonKey(name: 'to_profile_id')       @Default(null) int? to_user_id,
    @JsonKey(name: 'assigned_profile_id') @Default(null) int? assigned_user_id,
    required DisposisiStatus status,
    @Default(null) String? catatan,
    @Default(false) bool is_completed,
    @Default(null) DateTime? created_at,
    @Default(null) DateTime? updated_at,
    @Default(null) DateTime? deleted_at,
  }) = _AssessmentDisposisi;

  factory AssessmentDisposisi.fromJson(Map<String, dynamic> json) =>
      _$AssessmentDisposisiFromJson(json);
}
```

**No computed getters needed yet.** If UI needs `isSentByCurrentUser`, add a `const AssessmentDisposisi._()` constructor and a getter later — don't prematurely optimize.

---

## Decision 3: Repository Integration Strategy for Disposisi

### Context

Two viable integration patterns exist:

| Pattern | Description | Tradeoff |
|---|---|---|
| **A: Embedded in assessment response** | API returns disposisi array nested inside the formulir/penilaian payload | One request, but bloats the primary object |
| **B: Separate audit trail endpoint** | Dedicated endpoint `GET /formulir/{id}/disposisis` | Two requests, clean separation of concerns |

### Analysis

The `formulir_penilaian_disposisis` table has two access patterns with fundamentally different consumers:

1. **Workflow gating** — "Can the current user take action on this formulir?" Requires only the *current* disposisi status for a given `(formulir_id, user_id)`. This is a **point query**, not a list.
2. **Audit trail** — "Show the full history of handoffs for this formulir." This is a **list query** rendered in a timeline/log UI.

These two patterns should not share a fetch strategy.

### Decision

**Use a hybrid approach — do not force a binary choice:**

**3a. For workflow gating:** The `Penilaian` object's own `status` field is sufficient for determining UI state (draft/sent/approved/rejected). **Do not embed the disposisi object inside Penilaian.** The Penilaian status is the canonical gate; disposisi is subordinate data.

**3b. For the audit trail:** Implement a **separate endpoint and repository method**. Add to `IAssessmentRepository`:

```dart
Future<List<AssessmentDisposisi>> getDisposisiTrail(int formulirId);
```

Map to a new endpoint: `GET /formulir/{id}/disposisis`

**3c. For disposisi actions** (submit/return/approve/reject): These are write operations that produce a new disposisi record and update `Penilaian.status` atomically on the server. Add:

```dart
Future<AssessmentDisposisi> submitDisposisi({
  required int formulirId,
  int? indikatorId,
  required DisposisiStatus action,
  String? catatan,
});
```

Map to: `POST /formulir/{id}/disposisis`

**Rationale:**

1. **Audit trails are not always needed.** Most screens showing an assessment only need the current `Penilaian.status`. Fetching a potentially large disposisi history on every assessment load is wasteful. Lazy-load it when the user explicitly opens an "Activity Log" or "Riwayat" panel.
2. **Embedding creates coupling.** If disposisi is part of `AssessmentFormModel` or `Penilaian`, every controller that consumes those models inherits the disposisi dependency. The `assessmentRepositoryProvider` is already used by multiple presentation layers — avoid polluting it.
3. **Separate endpoint enables independent caching.** The audit trail is append-only and can be cached aggressively. The penilaian status changes on every action. Mixing them prevents independent cache invalidation strategies.
4. **The `penilaian_client.dart` Retrofit client already has a clean separation** between formulir operations and penilaian operations. The disposisi trail endpoint belongs in the same client alongside a new `getDisposisiTrail` method.

### Caching note

When the disposisi trail is fetched, it should be stored in a **separate Hive box** (`disposisi_trail`) keyed by `formulirId`, not merged into the assessment cache. This allows the trail to be invalidated independently when a `submitDisposisi` action succeeds.

---

## Summary Table

| Concern | Decision |
|---|---|
| `evaluasi_walidata` field | Rename to `evaluasi` (match DB column). Remove `@JsonKey` alias. |
| `PenilaianStatus` reuse for disposisi | **No.** Create separate `DisposisiStatus` enum (excludes `draft`). |
| `from/to_profile_id` naming | Use `from_user_id` / `to_user_id` / `assigned_user_id` in Dart. Bridge via `@JsonKey`. |
| Disposisi fetch strategy | Separate audit trail endpoint. Do **not** embed in Penilaian. |
| Disposisi write strategy | Single `POST /formulir/{id}/disposisis` method in repository. |
| Legacy `bukti_dukung` text column | Ignore. Use `bukti_dukungs` table / `BuktiDukung` model exclusively. |
| Missing DB columns in Penilaian | Add in follow-up; non-blocking for current feature work. |
