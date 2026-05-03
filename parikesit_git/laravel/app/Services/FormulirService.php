<?php

namespace App\Services;

use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class FormulirService
{
    public function __construct(
        private readonly FormulirSetupService $setupService,
    ) {}

    public function createFormulir(array $data)
    {
        $useTemplate = $data['use_template'] ?? true;

        return DB::transaction(function () use ($data, $useTemplate) {
            $formulir = Formulir::create([
                'nama_formulir' => $data['nama_formulir'],
                'created_by_id' => Auth::id(),
                'kind' => Formulir::KIND_ASSESSMENT,
            ]);

            if ($useTemplate) {
                $this->setupService->setup($formulir);
            }

            return $formulir;
        });
    }

    public function updateFormulir(Formulir $formulir, array $data): Formulir
    {
        return DB::transaction(function () use ($formulir, $data) {
            $formulir->update([
                'nama_formulir' => trim($data['nama_formulir']),
            ]);

            return $formulir->refresh();
        });
    }

    public function deleteFormulir(Formulir $formulir): void
    {
        DB::transaction(function () use ($formulir) {
            $formulir->domains()->detach();
            $formulir->penilaians()->delete();
            $formulir->formulir_domains()->delete();
            $formulir->delete();
        });
    }

    public function storeDomain(Formulir $formulir, array $data)
    {
        $namaDomain = trim($data['nama_domain']);

        if ($this->formulirHasDomainNamed($formulir, $namaDomain)) {
            throw ValidationException::withMessages([
                'nama_domain' => 'Domain dengan nama yang sama sudah ada pada formulir ini.',
            ]);
        }

        return DB::transaction(function () use ($formulir, $data, $namaDomain) {
            $domain = Domain::create([
                'nama_domain' => $namaDomain,
            ]);

            FormulirDomain::create([
                'formulir_id' => $formulir->id,
                'domain_id' => $domain->id,
            ]);

            foreach ($data['nama_aspek'] as $namaAspek) {
                $domain->aspek()->create([
                    'domain_id' => $domain->id,
                    'nama_aspek' => trim($namaAspek),
                ]);
            }

            return $domain->load('aspek');
        });
    }

    protected function formulirHasDomainNamed(Formulir $formulir, string $namaDomain): bool
    {
        return FormulirDomain::query()
            ->where('formulir_id', $formulir->id)
            ->whereNull('deleted_at')
            ->whereHas('domain', function ($query) use ($namaDomain) {
                $query->whereNull('deleted_at')
                    ->whereRaw('LOWER(nama_domain) = ?', [mb_strtolower($namaDomain)]);
            })
            ->exists();
    }
}
