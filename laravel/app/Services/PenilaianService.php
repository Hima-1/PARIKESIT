<?php

namespace App\Services;

use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use RuntimeException;

class PenilaianService
{
    public function storePenilaian(Formulir $formulir, Indikator $indikator, array $data, $files): Penilaian
    {
        $savedFileNames = [];
        $disk = Storage::disk('public');
        $normalizedFiles = $this->normalizeFiles($files);
        $existingPenilaian = Penilaian::query()
            ->where('indikator_id', $indikator->id)
            ->where('formulir_id', $formulir->id)
            ->where('user_id', Auth::id())
            ->first();

        if ($normalizedFiles !== []) {
            foreach ($normalizedFiles as $file) {
                $savedFileName = $this->uniqueStoredFileName($file);
                $storedPath = $disk->putFileAs('bukti-dukung', $file, $savedFileName);

                if ($storedPath === false) {
                    throw new RuntimeException('Failed to store bukti dukung file');
                }

                $savedFileNames[] = 'bukti-dukung/'.$savedFileName;
            }
        }

        $existingBuktiDukung = $this->resolveExistingEvidencePaths(
            data: $data,
            existingPenilaian: $existingPenilaian,
        );
        $finalBuktiDukung = $savedFileNames !== [] ? $savedFileNames : $existingBuktiDukung;

        return Penilaian::updateOrCreate(
            [
                'indikator_id' => $indikator->id,
                'formulir_id' => $formulir->id,
                'user_id' => Auth::id(),
            ],
            [
                'nilai' => $data['nilai'],
                'tanggal_penilaian' => now()->format('Y-m-d'),
                'catatan' => $data['catatan'] ?? null,
                'bukti_dukung' => $finalBuktiDukung !== [] ? $finalBuktiDukung : null,
            ]
        );
    }

    /**
     * @return array<int, string>
     */
    private function resolveExistingEvidencePaths(array $data, ?Penilaian $existingPenilaian): array
    {
        if (array_key_exists('existing_bukti_dukung', $data)) {
            return $this->normalizeExistingEvidence($data['existing_bukti_dukung']);
        }

        if (! $existingPenilaian instanceof Penilaian) {
            return [];
        }

        return $existingPenilaian->normalizedBuktiDukung();
    }

    /**
     * @return array<int, string>
     */
    private function normalizeExistingEvidence(mixed $value): array
    {
        if (is_array($value)) {
            return $this->sanitizePaths($value);
        }

        if (is_string($value)) {
            $trimmed = trim($value);

            if ($trimmed === '' || $trimmed === '-') {
                return [];
            }

            $decoded = json_decode($trimmed, true);
            if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
                return $this->sanitizePaths($decoded);
            }

            return $this->sanitizePaths([$trimmed]);
        }

        return [];
    }

    /**
     * @return array<int, UploadedFile>
     */
    private function normalizeFiles(mixed $files): array
    {
        if ($files instanceof UploadedFile) {
            return [$files];
        }

        if (is_array($files)) {
            return array_values(array_filter($files, fn (mixed $file) => $file instanceof UploadedFile));
        }

        return [];
    }

    /**
     * @param  array<int, mixed>  $paths
     * @return array<int, string>
     */
    private function sanitizePaths(array $paths): array
    {
        return array_values(array_filter(
            array_map(
                static fn (mixed $path) => is_string($path) ? trim($path) : null,
                $paths,
            ),
            static fn (?string $path) => $path !== null && $path !== '' && $path !== '-',
        ));
    }

    private function uniqueStoredFileName(UploadedFile $file): string
    {
        $safeOriginalName = $this->safeOriginalName($file);

        if ($safeOriginalName === '') {
            return Str::ulid().'.'.strtolower($file->getClientOriginalExtension());
        }

        return Str::ulid().'-'.$safeOriginalName;
    }

    private function safeOriginalName(UploadedFile $file): string
    {
        $originalName = pathinfo($file->getClientOriginalName(), PATHINFO_FILENAME);
        $extension = strtolower($file->getClientOriginalExtension());
        $safeBaseName = Str::slug($originalName);

        if ($safeBaseName === '' || $extension === '') {
            return '';
        }

        return $safeBaseName.'.'.$extension;
    }
}
