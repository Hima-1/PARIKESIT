<?php

namespace App\Services;

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Support\EpssReference;
use Illuminate\Support\Facades\DB;

class FormulirSetupService
{
    public function setup(Formulir $formulir)
    {
        return DB::transaction(function () use ($formulir) {
            foreach (EpssReference::domains() as $domainData) {
                $domain = Domain::create([
                    'nama_domain' => $domainData['nama_domain'],
                    'bobot_domain' => $domainData['bobot_domain'],
                ]);

                FormulirDomain::create([
                    'formulir_id' => $formulir->id,
                    'domain_id' => $domain->id,
                ]);

                foreach ($domainData['aspeks'] as $aspekData) {
                    $aspek = Aspek::create([
                        'domain_id' => $domain->id,
                        'nama_aspek' => $aspekData['nama_aspek'],
                        'bobot_aspek' => $aspekData['bobot_aspek'],
                    ]);

                    foreach ($aspekData['indikators'] as $indikatorData) {
                        Indikator::create([
                            'aspek_id' => $aspek->id,
                            'kode_indikator' => $indikatorData['kode_indikator'],
                            'nama_indikator' => $indikatorData['nama_indikator'],
                            'bobot_indikator' => $indikatorData['bobot_indikator'],
                            'level_1_kriteria' => $indikatorData['kriteria'][1] ?? null,
                            'level_2_kriteria' => $indikatorData['kriteria'][2] ?? null,
                            'level_3_kriteria' => $indikatorData['kriteria'][3] ?? null,
                            'level_4_kriteria' => $indikatorData['kriteria'][4] ?? null,
                            'level_5_kriteria' => $indikatorData['kriteria'][5] ?? null,
                        ]);
                    }
                }
            }

            return true;
        });
    }
}
