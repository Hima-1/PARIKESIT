<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FormulirResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nama_formulir' => $this->nama_formulir,
            'created_by_id' => $this->created_by_id,
            'created_by' => new UserResource($this->whenLoaded('creator')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
            'scores' => $this->scores ?? null,
            'domains' => $this->whenLoaded('domains', function () {
                return $this->domains->map(function ($domain) {
                    return [
                        'id' => $domain->id,
                        'nama_domain' => $domain->nama_domain,
                        'bobot_domain' => $domain->bobot_domain,
                        'scores' => $domain->scores ?? null,
                        'aspek' => $domain->aspek->map(function ($aspek) {
                            return [
                                'id' => $aspek->id,
                                'nama_aspek' => $aspek->nama_aspek,
                                'bobot_aspek' => $aspek->bobot_aspek,
                                'scores' => $aspek->scores ?? null,
                                'indikator' => $aspek->indikator->map(function ($indikator) {
                                    return [
                                        'id' => $indikator->id,
                                        'kode_indikator' => $indikator->kode_indikator,
                                        'nama_indikator' => $indikator->nama_indikator,
                                        'bobot_indikator' => $indikator->bobot_indikator,
                                        'level_1_kriteria' => $indikator->level_1_kriteria,
                                        'level_2_kriteria' => $indikator->level_2_kriteria,
                                        'level_3_kriteria' => $indikator->level_3_kriteria,
                                        'level_4_kriteria' => $indikator->level_4_kriteria,
                                        'level_5_kriteria' => $indikator->level_5_kriteria,
                                        'level_1_kriteria_10101' => $indikator->level_1_kriteria_10101,
                                        'level_2_kriteria_10101' => $indikator->level_2_kriteria_10101,
                                        'level_3_kriteria_10101' => $indikator->level_3_kriteria_10101,
                                        'level_4_kriteria_10101' => $indikator->level_4_kriteria_10101,
                                        'level_5_kriteria_10101' => $indikator->level_5_kriteria_10101,
                                        'level_1_kriteria_10201' => $indikator->level_1_kriteria_10201,
                                        'level_2_kriteria_10201' => $indikator->level_2_kriteria_10201,
                                        'level_3_kriteria_10201' => $indikator->level_3_kriteria_10201,
                                        'level_4_kriteria_10201' => $indikator->level_4_kriteria_10201,
                                        'level_5_kriteria_10201' => $indikator->level_5_kriteria_10201,
                                        'scores' => $indikator->scores ?? null,
                                        'penilaian' => $indikator->penilaian->where('formulir_id', $this->id)->first(),
                                    ];
                                }),
                            ];
                        }),
                    ];
                });
            }),
        ];
    }
}
