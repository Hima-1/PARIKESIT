<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AspekResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nama_aspek' => $this->nama_aspek,
            'domain_id' => $this->domain_id,
            'bobot_aspek' => $this->bobot_aspek,
            'indikators' => IndikatorResource::collection($this->whenLoaded('indikator')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
