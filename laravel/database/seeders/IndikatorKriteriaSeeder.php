<?php

namespace Database\Seeders;

use App\Models\Indikator;
use App\Support\EpssReference;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class IndikatorKriteriaSeeder extends Seeder
{
    /**
     * @var array<int, array<string, mixed>>
     */
    private array $references = [];

    public function run(): void
    {
        $this->references = $this->buildReferences();

        Indikator::withTrashed()
            ->with('aspek.domain')
            ->orderBy('id')
            ->chunkById(100, function (Collection $indikators): void {
                foreach ($indikators as $indikator) {
                    $reference = $this->findReferenceFor($indikator);

                    if ($reference === null) {
                        continue;
                    }

                    $indikator->forceFill($this->criteriaPayload($reference))->save();
                }
            });
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    private function buildReferences(): array
    {
        $references = [];

        foreach (EpssReference::indicatorsByCode() as $reference) {
            $references[] = [
                ...$reference,
                'domain_key' => $this->normalizeLabel($reference['nama_domain']),
                'aspek_key' => $this->normalizeLabel($reference['nama_aspek']),
                'indicator_key' => $this->normalizeLabel($reference['nama_indikator']),
                'indicator_simple_key' => $this->simplifyLabel($reference['nama_indikator']),
                'legacy_indicator_keys' => $this->legacyIndicatorKeys($reference['kode_indikator']),
            ];
        }

        return $references;
    }

    /**
     * @return array<string, mixed>|null
     */
    private function findReferenceFor(Indikator $indikator): ?array
    {
        $code = trim((string) $indikator->kode_indikator);

        if ($code !== '') {
            foreach ($this->references as $reference) {
                if ($reference['kode_indikator'] === $code) {
                    return $reference;
                }
            }
        }

        $domainKey = $this->normalizeLabel($indikator->aspek?->domain?->nama_domain);
        $aspekKey = $this->normalizeLabel($indikator->aspek?->nama_aspek);
        $indicatorKey = $this->normalizeLabel($indikator->nama_indikator);
        $indicatorSimpleKey = $this->simplifyLabel($indikator->nama_indikator);

        foreach ($this->references as $reference) {
            if (
                $reference['domain_key'] === $domainKey
                && $reference['aspek_key'] === $aspekKey
                && (
                    $reference['indicator_key'] === $indicatorKey
                    || $reference['indicator_simple_key'] === $indicatorSimpleKey
                    || in_array($indicatorKey, $reference['legacy_indicator_keys'], true)
                    || in_array($indicatorSimpleKey, $reference['legacy_indicator_keys'], true)
                )
            ) {
                return $reference;
            }
        }

        return null;
    }

    /**
     * @param  array<string, mixed>  $reference
     * @return array<string, mixed>
     */
    private function criteriaPayload(array $reference): array
    {
        return [
            'kode_indikator' => $reference['kode_indikator'],
            'nama_indikator' => $reference['nama_indikator'],
            'bobot_indikator' => $reference['bobot_indikator'],
            'level_1_kriteria' => $reference['kriteria'][1] ?? null,
            'level_2_kriteria' => $reference['kriteria'][2] ?? null,
            'level_3_kriteria' => $reference['kriteria'][3] ?? null,
            'level_4_kriteria' => $reference['kriteria'][4] ?? null,
            'level_5_kriteria' => $reference['kriteria'][5] ?? null,
        ];
    }

    private function normalizeLabel(?string $label): string
    {
        return trim((string) Str::of($label ?? '')
            ->lower()
            ->replaceMatches('/[^a-z0-9]+/', ' ')
            ->replaceMatches('/\s+/', ' '));
    }

    private function simplifyLabel(?string $label): string
    {
        return trim((string) Str::of($this->normalizeLabel($label))
            ->replaceMatches('/\b(dan|atau)\b/', ' ')
            ->replaceMatches('/\s+/', ' '));
    }

    /**
     * @return array<int, string>
     */
    private function legacyIndicatorKeys(string $kodeIndikator): array
    {
        $aliases = [
            '40102' => [
                'Tingkat Kematangan Penjaminan Netralitas dan Objektivitas terhadap Penggunaan Sumber Data Metodologi',
            ],
            '40304' => [
                'Tingkat Kematangan Penyelenggaraan Pelaksanaan Tugas Sebagai Walidata',
            ],
        ];

        return array_values(array_unique(array_merge(
            array_map(fn (string $alias): string => $this->normalizeLabel($alias), $aliases[$kodeIndikator] ?? []),
            array_map(fn (string $alias): string => $this->simplifyLabel($alias), $aliases[$kodeIndikator] ?? []),
        )));
    }
}
