<?php

namespace Database\Seeders;

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\User;
use App\Support\EpssReference;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MasterDataSeeder extends Seeder
{
    public function run(): void
    {
        DB::transaction(function () {
            $creatorId = User::query()->where('email', 'admin@gmail.com')->value('id');

            $formulir = Formulir::withTrashed()->updateOrCreate(
                ['nama_formulir' => 'Formulir Master Data'],
                [
                    'tanggal_dibuat' => now()->toDateString(),
                    'created_by_id' => $creatorId,
                    'kind' => Formulir::KIND_TEMPLATE,
                    'deleted_at' => null,
                ],
            );

            if (method_exists($formulir, 'restore') && $formulir->trashed()) {
                $formulir->restore();
            }

            $processedDomainIds = [];

            foreach (EpssReference::domains() as $domainData) {
                $domain = $this->syncDomain($domainData);
                $processedDomainIds[] = $domain->id;

                foreach ($domainData['aspeks'] as $aspekData) {
                    $aspek = $this->syncAspek($domain, $aspekData);

                    foreach ($aspekData['indikators'] as $indikatorData) {
                        $this->syncIndikator($aspek, $indikatorData);
                    }
                }
            }

            foreach ($processedDomainIds as $domainId) {
                $pivot = FormulirDomain::withTrashed()->updateOrCreate(
                    ['formulir_id' => $formulir->id, 'domain_id' => $domainId],
                    ['deleted_at' => null],
                );

                if (method_exists($pivot, 'restore') && $pivot->trashed()) {
                    $pivot->restore();
                }
            }

            FormulirDomain::withTrashed()
                ->where('formulir_id', $formulir->id)
                ->whereNotIn('domain_id', $processedDomainIds)
                ->get()
                ->each(function (FormulirDomain $pivot): void {
                    if (! $pivot->trashed()) {
                        $pivot->delete();
                    }
                });
        });
    }

    /**
     * @param  array<string, mixed>  $domainData
     */
    private function syncDomain(array $domainData): Domain
    {
        $domain = Domain::withTrashed()
            ->get()
            ->first(function (Domain $candidate) use ($domainData): bool {
                return $this->isTemplateDomainCandidate($candidate)
                    && $this->labelsMatch($candidate->nama_domain, $domainData['nama_domain']);
            }) ?? new Domain();

        $domain->fill([
            'nama_domain' => $domainData['nama_domain'],
            'bobot_domain' => $domainData['bobot_domain'],
            'deleted_at' => null,
        ]);
        $domain->save();

        if (method_exists($domain, 'restore') && $domain->trashed()) {
            $domain->restore();
        }

        return $domain;
    }

    /**
     * @param  array<string, mixed>  $aspekData
     */
    private function syncAspek(Domain $domain, array $aspekData): Aspek
    {
        $aspek = Aspek::withTrashed()
            ->where('domain_id', $domain->id)
            ->get()
            ->first(fn (Aspek $candidate): bool => $this->labelsMatch($candidate->nama_aspek, $aspekData['nama_aspek']))
            ?? new Aspek();

        $aspek->fill([
            'domain_id' => $domain->id,
            'nama_aspek' => $aspekData['nama_aspek'],
            'bobot_aspek' => $aspekData['bobot_aspek'],
            'deleted_at' => null,
        ]);
        $aspek->save();

        if (method_exists($aspek, 'restore') && $aspek->trashed()) {
            $aspek->restore();
        }

        return $aspek;
    }

    /**
     * @param  array<string, mixed>  $indikatorData
     */
    private function syncIndikator(Aspek $aspek, array $indikatorData): Indikator
    {
        $existingIndicators = Indikator::withTrashed()
            ->where('aspek_id', $aspek->id)
            ->get();

        $indikator = $existingIndicators->first(
            fn (Indikator $candidate): bool => $candidate->kode_indikator === $indikatorData['kode_indikator']
        ) ?? $existingIndicators->first(function (Indikator $candidate) use ($indikatorData): bool {
            return blank($candidate->kode_indikator)
                && $this->labelsMatch($candidate->nama_indikator, $indikatorData['nama_indikator']);
        }) ?? new Indikator();

        $indikator->fill([
            'aspek_id' => $aspek->id,
            'nama_indikator' => $indikatorData['nama_indikator'],
            'kode_indikator' => $indikatorData['kode_indikator'],
            'bobot_indikator' => $indikatorData['bobot_indikator'],
            'level_1_kriteria' => $indikatorData['kriteria'][1] ?? null,
            'level_2_kriteria' => $indikatorData['kriteria'][2] ?? null,
            'level_3_kriteria' => $indikatorData['kriteria'][3] ?? null,
            'level_4_kriteria' => $indikatorData['kriteria'][4] ?? null,
            'level_5_kriteria' => $indikatorData['kriteria'][5] ?? null,
            'deleted_at' => null,
        ]);
        $indikator->save();

        if (method_exists($indikator, 'restore') && $indikator->trashed()) {
            $indikator->restore();
        }

        return $indikator;
    }

    private function isTemplateDomainCandidate(Domain $domain): bool
    {
        return ! $domain->formulirs()
            ->where('kind', Formulir::KIND_ASSESSMENT)
            ->exists();
    }

    private function labelsMatch(?string $existing, string $canonical): bool
    {
        if ($existing === null) {
            return false;
        }

        return $this->normalizeLabel($existing) === $this->normalizeLabel($canonical);
    }

    private function normalizeLabel(string $value): string
    {
        $normalized = preg_replace('/\s+/u', ' ', trim($value)) ?? trim($value);
        $normalized = preg_replace('/\s*\/\s*/u', '/', $normalized) ?? $normalized;
        $normalized = ' '.mb_strtolower($normalized).' ';

        $normalized = str_replace(
            [' dan atau ', ' dan / atau ', ' dan /atau ', ' dan/ atau '],
            ' dan/atau ',
            $normalized,
        );

        return trim($normalized);
    }
}
