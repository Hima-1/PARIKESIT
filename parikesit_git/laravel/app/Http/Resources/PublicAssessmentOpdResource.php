<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PublicAssessmentOpdResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this['id'] ?? null,
            'name' => $this['name'] ?? '',
            'opd_score' => $this['opd_score'] ?? null,
            'walidata_score' => $this['walidata_score'] ?? null,
            'admin_score' => $this['admin_score'] ?? null,
        ];
    }
}
