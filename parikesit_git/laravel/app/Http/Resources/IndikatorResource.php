<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class IndikatorResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nama_indikator' => $this->nama_indikator,
            'aspek_id' => $this->aspek_id,
            'bobot_indikator' => $this->bobot_indikator,
            'kode_indikator' => $this->kode_indikator,
            'level_1_kriteria' => $this->level_1_kriteria,
            'level_2_kriteria' => $this->level_2_kriteria,
            'level_3_kriteria' => $this->level_3_kriteria,
            'level_4_kriteria' => $this->level_4_kriteria,
            'level_5_kriteria' => $this->level_5_kriteria,
            'level_1_kriteria_10101' => $this->level_1_kriteria_10101,
            'level_2_kriteria_10101' => $this->level_2_kriteria_10101,
            'level_3_kriteria_10101' => $this->level_3_kriteria_10101,
            'level_4_kriteria_10101' => $this->level_4_kriteria_10101,
            'level_5_kriteria_10101' => $this->level_5_kriteria_10101,
            'level_1_kriteria_10201' => $this->level_1_kriteria_10201,
            'level_2_kriteria_10201' => $this->level_2_kriteria_10201,
            'level_3_kriteria_10201' => $this->level_3_kriteria_10201,
            'level_4_kriteria_10201' => $this->level_4_kriteria_10201,
            'level_5_kriteria_10201' => $this->level_5_kriteria_10201,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
