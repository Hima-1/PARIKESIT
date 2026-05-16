<?php

namespace App\Services;

use App\Models\Formulir;
use App\Models\Domain;
use App\Models\Indikator;
use App\Models\Penilaian;
use Illuminate\Support\Collection;

class PenilaianSelectionService
{
    /**
     * Resolve the most relevant penilaian for a single indicator.
     *
     * Preference:
     * - match the requested formulir and user
     * - among filled records, pick the newest one
     * - if no filled record exists, pick the newest matching record
     */
    public function resolveForIndicator(
        Indikator $indikator,
        Formulir $formulir,
        ?int $userId = null,
        string $field = 'nilai',
    ): ?Penilaian {
        if ($indikator->relationLoaded('penilaian')) {
            return $this->resolveFromCollection($indikator->penilaian, $formulir->id, $userId, $field);
        }

        return $this->resolveFromCollection($indikator->penilaian()->get(), $formulir->id, $userId, $field);
    }

    /**
     * Resolve the most relevant penilaian from a preloaded collection.
     *
     * @param Collection<int, Penilaian> $penilaians
     */
    public function resolveFromCollection(
        Collection $penilaians,
        int $formulirId,
        ?int $userId = null,
        string $field = 'nilai',
    ): ?Penilaian {
        $matching = $penilaians->filter(function (Penilaian $penilaian) use ($formulirId, $userId) {
            if ((int) $penilaian->formulir_id !== $formulirId) {
                return false;
            }

            if ($userId !== null && (int) $penilaian->user_id !== $userId) {
                return false;
            }

            return true;
        });

        if ($matching->isEmpty()) {
            return null;
        }

        $filled = $matching->filter(fn (Penilaian $penilaian) => $this->isFieldFilled($penilaian, $field));
        $pool = $filled->isNotEmpty() ? $filled : $matching;

        return $pool
            ->sortByDesc(fn (Penilaian $penilaian) => $this->sortKey($penilaian))
            ->first();
    }

    /**
     * Resolve only when the requested field is actually filled.
     *
     * @param Collection<int, Penilaian> $penilaians
     */
    public function resolveFilledFromCollection(
        Collection $penilaians,
        int $formulirId,
        ?int $userId = null,
        string $field = 'nilai',
    ): ?Penilaian {
        $matching = $penilaians->filter(function (Penilaian $penilaian) use ($formulirId, $userId) {
            if ((int) $penilaian->formulir_id !== $formulirId) {
                return false;
            }

            if ($userId !== null && (int) $penilaian->user_id !== $userId) {
                return false;
            }

            return true;
        });

        $filled = $matching->filter(fn (Penilaian $penilaian) => $this->isFieldFilled($penilaian, $field));

        if ($filled->isEmpty()) {
            return null;
        }

        return $filled
            ->sortByDesc(fn (Penilaian $penilaian) => $this->sortKey($penilaian))
            ->first();
    }

    /**
     * Mark all indicators in a formulir with the active penilaian for the supplied user.
     */
    public function annotateIndicators(Formulir $formulir, ?int $userId, string $field = 'nilai', string $attribute = 'penilaian_aktif'): void
    {
        $formulir->loadMissing([
            'domains.aspek.indikator.penilaian' => function ($query) use ($formulir, $userId) {
                $query->where('formulir_id', $formulir->id);

                if ($userId !== null) {
                    $query->where('user_id', $userId);
                }
            },
        ]);

        foreach ($formulir->domains as $domain) {
            foreach ($domain->aspek as $aspek) {
                foreach ($aspek->indikator as $indikator) {
                    $penilaian = $field === 'nilai'
                        ? $this->resolveFilledFromCollection(
                            $indikator->relationLoaded('penilaian')
                                ? $indikator->penilaian
                                : $indikator->penilaian()->get(),
                            $formulir->id,
                            $userId,
                            $field,
                        )
                        : $this->resolveForIndicator($indikator, $formulir, $userId, $field);

                    $indikator->setAttribute(
                        $attribute,
                        $penilaian,
                    );
                }
            }
        }
    }

    /**
     * Mark all indicators in a domain with the active penilaian for the supplied user.
     */
    public function annotateDomainIndicators(Domain $domain, Formulir $formulir, ?int $userId, string $field = 'nilai', string $attribute = 'penilaian_aktif'): void
    {
        $domain->loadMissing([
            'aspek.indikator.penilaian' => function ($query) use ($formulir, $userId) {
                $query->where('formulir_id', $formulir->id);

                if ($userId !== null) {
                    $query->where('user_id', $userId);
                }
            },
        ]);

        foreach ($domain->aspek as $aspek) {
            foreach ($aspek->indikator as $indikator) {
                $penilaian = $field === 'nilai'
                    ? $this->resolveFilledFromCollection(
                        $indikator->relationLoaded('penilaian')
                            ? $indikator->penilaian
                            : $indikator->penilaian()->get(),
                        $formulir->id,
                        $userId,
                        $field,
                    )
                    : $this->resolveForIndicator($indikator, $formulir, $userId, $field);

                $indikator->setAttribute(
                    $attribute,
                    $penilaian,
                );
            }
        }
    }

    private function isFieldFilled(Penilaian $penilaian, string $field): bool
    {
        $value = $penilaian->{$field} ?? null;

        if ($field === 'evaluasi' || $field === 'catatan' || $field === 'catatan_koreksi') {
            return filled($value);
        }

        if ($field === 'bukti_dukung') {
            return $penilaian->hasBuktiDukung();
        }

        return $value !== null && $value !== '';
    }

    private function sortKey(Penilaian $penilaian): string
    {
        $updatedAt = $penilaian->updated_at?->getTimestamp() ?? 0;
        $createdAt = $penilaian->created_at?->getTimestamp() ?? 0;
        $id = (int) $penilaian->id;

        return sprintf('%020d%020d%020d', $updatedAt, $createdAt, $id);
    }
}
