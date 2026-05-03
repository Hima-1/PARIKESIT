<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PenilaianResource extends JsonResource
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
            'indikator_id' => $this->indikator_id,
            'formulir_id' => $this->formulir_id,
            'user_id' => $this->user_id,
            'nilai' => $this->nilai,
            'catatan' => $this->catatan,
            'bukti_dukung' => $this->normalizedBuktiDukung() !== [] ? $this->normalizedBuktiDukung() : null,
            'tanggal_penilaian' => $this->tanggal_penilaian,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
