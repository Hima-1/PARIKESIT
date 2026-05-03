<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PenilaianIndicatorResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id'               => $this->id,
            'indikator_id'     => $this->indikator_id,
            'formulir_id'      => $this->formulir_id,
            'user_id'          => $this->user_id,
            'nilai'            => $this->nilai !== null ? number_format((float) $this->nilai, 2, '.', '') : null,
            'catatan'          => $this->catatan,
            'tanggal_penilaian' => $this->tanggal_penilaian,
            'evaluasi'         => $this->evaluasi,
            'catatan_koreksi'  => $this->catatan_koreksi,
            'dikerjakan_by'    => $this->dikerjakan_by,
            'diupdate_by'      => $this->diupdate_by,
            'dikoreksi_by'     => $this->dikoreksi_by,
            'nilai_diupdate'   => $this->nilai_diupdate,
            'nilai_koreksi'    => $this->nilai_koreksi,
            'tanggal_diperbarui' => $this->tanggal_diperbarui,
            'tanggal_dikoreksi' => $this->tanggal_dikoreksi,
            'status'           => $this->status,
            'bukti_dukung'     => $this->normalizedBuktiDukung() !== [] ? $this->normalizedBuktiDukung() : null,
            'created_at'       => $this->created_at,
            'updated_at'       => $this->updated_at,
        ];
    }
}
