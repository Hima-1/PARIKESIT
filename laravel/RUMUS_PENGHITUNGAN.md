# Dokumentasi Rumus Penghitungan Aspek dan Indikator

## Struktur Hierarki
```
Formulir (Indeks Pembangunan Statistik)
  └── Domain (bobot_domain)
      └── Aspek (bobot_aspek)
          └── Indikator (bobot_indikator)
              └── Penilaian (nilai: 1-5)
```

## Rumus Resmi (Berdasarkan Dokumentasi)

### 1. Perhitungan Indeks Aspek
**Rumus:**
```
Indeks Aspek_j = (Σ_{i=1}^{I} Bobot Indikator_{ij} × Nilai Indikator_{ij}) / (Σ_{i=1}^{I} Bobot Indikator_{ij})
```

**Keterangan:**
- `Indeks Aspek_j` = nilai indeks aspek ke-j
- `I` = banyaknya indikator yang ada di aspek-j
- `Bobot Indikator_{ij}` = bobot indikator ke-i pada aspek ke-j
- `Nilai Indikator_{ij}` = nilai indikator ke-i pada aspek ke-j (skala 1-5)

**Penjelasan:**
Rumus ini menghitung **rata-rata tertimbang (weighted average)** dari nilai indikator dalam suatu aspek.

---

### 2. Perhitungan Indeks Domain
**Rumus:**
```
Indeks Domain_k = (Σ_{j=1}^{J} Bobot Aspek_{jk} × Nilai Aspek_{jk}) / (Σ_{j=1}^{J} Bobot Aspek_{jk})
```

**Keterangan:**
- `Indeks Domain_k` = nilai indeks domain ke-k
- `J` = banyaknya aspek yang ada di Domain k
- `Bobot Aspek_{jk}` = nilai bobot aspek ke-j pada domain ke-k
- `Nilai Aspek_{jk}` = nilai indeks aspek ke-j pada domain ke-k

**Penjelasan:**
Rumus ini menghitung **rata-rata tertimbang** dari nilai aspek dalam suatu domain.

**Catatan:** Dalam implementasi saat ini, perhitungan langsung dari Indikator ke Domain (skip Aspek):
```
Indeks Domain_k = (Σ_{i=1}^{I} Bobot Indikator_{ik} × Nilai Indikator_{ik}) / (Σ_{i=1}^{I} Bobot Indikator_{ik})
```

---

### 3. Perhitungan Indeks Pembangunan Statistik
**Rumus:**
```
Indeks Pembangunan Statistik = (Σ_{k=1}^{K} Bobot Domain_k × Nilai Domain_k) / (Σ_{k=1}^{K} Bobot Domain_k)
```

**Keterangan:**
- `K` = banyaknya domain penilaian
- `Bobot Domain_k` = nilai bobot domain ke-k
- `Nilai Domain_k` = nilai indeks domain ke-k

**Penjelasan:**
Rumus ini menghitung **rata-rata tertimbang** dari nilai domain untuk mendapatkan Indeks Pembangunan Statistik secara keseluruhan.

---

## Implementasi dalam Kode

### Rumus yang Ditemukan

### 1. Rumus di PenilaianController.php (Line 109)
**Lokasi:** `app/Http/Controllers/PenilaianController.php`

```php
$totalPersentasePerIndikator += (($penilaian->nilai * $indikator->bobot_indikator) / 100) / $domain->aspek->count();
```

**Rumus:**
```
Persentase Indikator = ((Nilai × Bobot Indikator) / 100) / Jumlah Aspek dalam Domain
```

**Masalah:**
- Membagi dengan jumlah aspek di domain, yang tidak masuk akal secara matematis
- Seharusnya menggunakan weighted average berdasarkan bobot

---

### 2. Rumus di DashboardController.php (calculateRataRataDomain)
**Lokasi:** `app/Http/Controllers/DashboardController.php`

#### A. Perhitungan Nilai Domain (Weighted Average Indikator)
```php
$domainNilai[] = $penilaian->$field * $bobot;
$totalBobot += $bobot;
...
'nilai' => array_sum($domainNilai) / $totalBobot
```

**Rumus:**
```
Nilai Domain = Σ(Nilai Indikator × Bobot Indikator) / Σ(Bobot Indikator)
```

**Contoh:**
- Indikator 1: Nilai = 3, Bobot = 50 → 3 × 50 = 150
- Indikator 2: Nilai = 4, Bobot = 30 → 4 × 30 = 120
- Indikator 3: Nilai = 5, Bobot = 20 → 5 × 20 = 100
- Total: (150 + 120 + 100) / (50 + 30 + 20) = 370 / 100 = 3.7

#### B. Perhitungan Nilai Akhir (Weighted Average Domain)
```php
$totalNilai += $domain['nilai'] * $domain['bobot'];
$totalBobot += $domain['bobot'];
...
return $totalNilai / $totalBobot
```

**Rumus:**
```
Nilai Akhir = Σ(Nilai Domain × Bobot Domain) / Σ(Bobot Domain)
```

**Contoh:**
- Domain 1: Nilai = 3.7, Bobot = 28 → 3.7 × 28 = 103.6
- Domain 2: Nilai = 4.2, Bobot = 24 → 4.2 × 24 = 100.8
- Domain 3: Nilai = 3.5, Bobot = 19 → 3.5 × 19 = 66.5
- Total: (103.6 + 100.8 + 66.5) / (28 + 24 + 19) = 270.9 / 71 = 3.81

---

## Ringkasan Rumus yang Benar

### Perhitungan Nilai Indikator
```
Nilai Indikator = Nilai Penilaian (1-5)
```
Nilai langsung dari input user, skala 1 sampai 5.

---

### Perhitungan Indeks Aspek (Rata-rata Tertimbang Indikator)
```
Indeks Aspek_j = (Σ_{i=1}^{I} Bobot Indikator_{ij} × Nilai Indikator_{ij}) / (Σ_{i=1}^{I} Bobot Indikator_{ij})
```

**Contoh:**
- Indikator 1: Nilai = 3, Bobot = 50 → 3 × 50 = 150
- Indikator 2: Nilai = 4, Bobot = 30 → 4 × 30 = 120
- Indikator 3: Nilai = 5, Bobot = 20 → 5 × 20 = 100
- **Indeks Aspek** = (150 + 120 + 100) / (50 + 30 + 20) = 370 / 100 = **3.7**

---

### Perhitungan Indeks Domain (Rata-rata Tertimbang Aspek atau Indikator)

**Opsi 1: Melalui Aspek (Rumus Resmi)**
```
Indeks Domain_k = (Σ_{j=1}^{J} Bobot Aspek_{jk} × Indeks Aspek_{jk}) / (Σ_{j=1}^{J} Bobot Aspek_{jk})
```

**Opsi 2: Langsung dari Indikator (Implementasi Saat Ini)**
```
Indeks Domain_k = (Σ_{i=1}^{I} Bobot Indikator_{ik} × Nilai Indikator_{ik}) / (Σ_{i=1}^{I} Bobot Indikator_{ik})
```

**Contoh (dari Indikator langsung):**
- Indikator 1: Nilai = 3.7, Bobot = 25 → 3.7 × 25 = 92.5
- Indikator 2: Nilai = 4.2, Bobot = 25 → 4.2 × 25 = 105
- Indikator 3: Nilai = 3.5, Bobot = 25 → 3.5 × 25 = 87.5
- Indikator 4: Nilai = 4.0, Bobot = 25 → 4.0 × 25 = 100
- **Indeks Domain** = (92.5 + 105 + 87.5 + 100) / (25 + 25 + 25 + 25) = 385 / 100 = **3.85**

---

### Perhitungan Indeks Pembangunan Statistik (Rata-rata Tertimbang Domain)
```
Indeks Pembangunan Statistik = (Σ_{k=1}^{K} Bobot Domain_k × Indeks Domain_k) / (Σ_{k=1}^{K} Bobot Domain_k)
```

**Contoh:**
- Domain 1: Indeks = 3.85, Bobot = 28% → 3.85 × 28 = 107.8
- Domain 2: Indeks = 4.20, Bobot = 24% → 4.20 × 24 = 100.8
- Domain 3: Indeks = 3.50, Bobot = 19% → 3.50 × 19 = 66.5
- Domain 4: Indeks = 3.80, Bobot = 17% → 3.80 × 17 = 64.6
- Domain 5: Indeks = 4.00, Bobot = 12% → 4.00 × 12 = 48.0
- **Indeks Pembangunan Statistik** = (107.8 + 100.8 + 66.5 + 64.6 + 48.0) / (28 + 24 + 19 + 17 + 12) = 387.7 / 100 = **3.877**

---

## Perbandingan Rumus

| Lokasi | Rumus | Status |
|--------|-------|--------|
| PenilaianController.php | `((nilai × bobot_indikator) / 100) / jumlah_aspek` | ❌ **SALAH** - Membagi dengan jumlah aspek tidak logis |
| DashboardController.php | `Σ(nilai × bobot) / Σ(bobot)` | ✅ **BENAR** - Weighted average standar |

---

## Rekomendasi Perbaikan

1. **Perbaiki PenilaianController.php** untuk menggunakan rumus weighted average yang benar
2. **Gunakan rumus yang konsisten** di semua controller
3. **Dokumentasikan** rumus yang digunakan di code comments

---

## Contoh Implementasi yang Benar

```php
// Perhitungan Nilai Domain
$domainNilai = [];
$totalBobot = 0;

foreach ($domain->aspek as $aspek) {
    foreach ($aspek->indikator as $indikator) {
        $penilaian = $indikator->penilaian
            ->where('formulir_id', $formulir->id)
            ->where('user_id', $user->id)
            ->first();
        
        if ($penilaian && $penilaian->nilai !== null) {
            $bobot = $indikator->bobot_indikator ?? 1;
            $domainNilai[] = $penilaian->nilai * $bobot;
            $totalBobot += $bobot;
        }
    }
}

$nilaiDomain = ($totalBobot > 0) ? array_sum($domainNilai) / $totalBobot : 0;
```

---

## Catatan Penting

1. **Bobot Indikator** biasanya dalam persentase (0-100) atau proporsi (0-1)
2. **Nilai Penilaian** adalah skala 1-5 (Level 1 sampai Level 5)
3. **Weighted Average** memastikan indikator/aspek/domain dengan bobot lebih besar memiliki pengaruh lebih besar
4. **Pastikan konsistensi** penggunaan bobot (persentase vs proporsi)
5. **Total Bobot** dalam satu level (Aspek/Domain) seharusnya = 100% untuk hasil yang akurat
6. **Rumus di gambar** hanya menunjukkan pembilang (weighted sum), tetapi implementasi yang benar menggunakan **weighted average** dengan membagi total bobot

---

## Bobot Domain (Tabel 7)

| Domain | Bobot |
|--------|-------|
| Prinsip Satu Data Indonesia | 28% |
| Kualitas Data | 24% |
| Proses Bisnis Statistik | 19% |
| Kelembagaan | 17% |
| Statistik Nasional | 12% |
| **Total** | **100%** |

---

## Bobot Aspek (Tabel 8)

### Domain: Prinsip Satu Data Indonesia (Total: 100%)
| Aspek | Bobot |
|-------|-------|
| Standar Data Statistik | 25% |
| Metadata Statistik | 25% |
| Interoperabilitas Data | 25% |
| Kode Referensi dan/atau Data Induk | 25% |

### Domain: Kualitas Data (Total: 100%)
| Aspek | Bobot |
|-------|-------|
| Relevansi | 21% |
| Akurasi | 16% |
| Aktualitas & Ketepatan Waktu | 21% |
| Aksesibilitas | 21% |
| Keterbandingan & Konsistensi | 21% |

### Domain: Proses Bisnis Statistik (Total: 100%)
| Aspek | Bobot |
|-------|-------|
| Perencanaan Data | 32% |
| Pengumpulan Data | 26% |
| Pemeriksaan Data | 21% |
| Penyebarluasan Data | 21% |

### Domain: Kelembagaan (Total: 100%)
| Aspek | Bobot |
|-------|-------|
| Profesionalitas | 35% |
| SDM yang Memadai dan Kapabel | 30% |
| Pengorganisasian Statistik | 35% |

**Catatan:** Total bobot aspek di domain Kelembagaan = 100% (35% + 30% + 35%)

### Domain: Statistik Nasional (Total: 100%)
| Aspek | Bobot |
|-------|-------|
| Pemanfaatan Data Statistik | 34% |
| Pengelolaan Kegiatan Statistik | 33% |
| Penguatan SSN Berkelanjutan | 33% |

**Catatan:** Total bobot aspek di domain Statistik Nasional = 100% (34% + 33% + 33%)

---

## Perbaikan yang Telah Dilakukan

1. ✅ **PenilaianController.php** - Diperbaiki menggunakan weighted average yang benar
2. ✅ **DashboardController.php** - Sudah menggunakan weighted average yang benar
3. ✅ **Dokumentasi** - Diperbarui sesuai rumus resmi dari dokumentasi
4. ✅ **Konsistensi** - Semua perhitungan menggunakan rumus yang sama (weighted average)



