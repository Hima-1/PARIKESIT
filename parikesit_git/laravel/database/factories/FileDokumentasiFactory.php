<?php

namespace Database\Factories;

use App\Models\DokumentasiKegiatan;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\FileDokumentasi>
 */
class FileDokumentasiFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'dokumentasi_kegiatan_id' => DokumentasiKegiatan::factory(),
            'nama_file' => 'file-dokumentasi/media/' . $this->faker->word() . '.jpg',
            'tipe_file' => 'jpg',
        ];
    }
}
