<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class DomainResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nama_domain' => $this->nama_domain,
            'bobot_domain' => $this->bobot_domain,
            'aspeks' => AspekResource::collection($this->whenLoaded('aspek')),
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
