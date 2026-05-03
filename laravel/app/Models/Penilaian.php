<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Penilaian extends Model
{
    use HasFactory;

    protected $fillable = [
        'indikator_id',
        'formulir_id',
        'nilai',
        'catatan',
        'tanggal_penilaian',
        'user_id',
        'bukti_dukung',
        'dikerjakan_by',
        'nilai_diupdate',
        'catatan_koreksi',
        'diupdate_by',
        'tanggal_diperbarui',
        'nilai_koreksi',
        'dikoreksi_by',
        'evaluasi',
        'tanggal_dikoreksi',
    ];

    public function indikator()
    {
        return $this->belongsTo(Indikator::class, 'indikator_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function formulir()
    {
        return $this->belongsTo(Formulir::class);
    }

    public function dikerjakan_by()
    {
        return $this->belongsTo(User::class, 'dikerjakan_by');
    }

    public function diupdate_by()
    {
        return $this->belongsTo(User::class, 'diupdate_by');
    }

    public function dikoreksi_by()
    {
        return $this->belongsTo(User::class, 'dikoreksi_by');
    }

    protected $casts = [
        'user_id' => 'integer',
        'bukti_dukung' => 'array',
    ];

    /**
     * @return array<int, string>
     */
    public function normalizedBuktiDukung(): array
    {
        $value = $this->getAttribute('bukti_dukung');

        if (is_array($value)) {
            return $this->sanitizeEvidencePaths($value);
        }

        if (is_string($value)) {
            $trimmed = trim($value);

            if ($trimmed === '' || $trimmed === '-') {
                return [];
            }

            $decoded = json_decode($trimmed, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                return $this->sanitizeEvidencePaths($decoded);
            }

            return $this->sanitizeEvidencePaths([$trimmed]);
        }

        return [];
    }

    public function hasBuktiDukung(): bool
    {
        return $this->normalizedBuktiDukung() !== [];
    }

    public function resolveBuktiDukungUrl(string $path): string
    {
        if (Storage::disk('public')->exists($path)) {
            return Storage::url($path);
        }

        return asset($path);
    }

    /**
     * @param  array<int, mixed>  $paths
     * @return array<int, string>
     */
    private function sanitizeEvidencePaths(array $paths): array
    {
        return array_values(array_filter(
            array_map(
                static fn (mixed $path) => is_string($path) ? trim($path) : null,
                $paths,
            ),
            static fn (?string $path) => $path !== null && $path !== '' && $path !== '-',
        ));
    }
}
