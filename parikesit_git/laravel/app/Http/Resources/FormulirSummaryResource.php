<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class FormulirSummaryResource extends JsonResource
{
    /**
     * Transform the resource into a lightweight array suitable for list views.
     * Only includes the fields needed to render a formulir list item.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id'            => $this->id,
            'nama_formulir' => $this->nama_formulir,
            'created_at'    => $this->created_at,
            'updated_at'    => $this->updated_at,
            'created_by'    => new UserResource($this->whenLoaded('creator')),
        ];
    }
}
