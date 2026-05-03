<?php

namespace Database\Factories;

use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Penilaian>
 */
class PenilaianFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'indikator_id' => Indikator::factory(),
            'formulir_id' => Formulir::factory(),
            'user_id' => User::factory(),
            'nilai' => $this->faker->numberBetween(1, 5),
            'catatan' => $this->faker->sentence(),
            'tanggal_penilaian' => now()->format('Y-m-d'),
            'bukti_dukung' => '-',
            'dikerjakan_by' => null,
            'nilai_diupdate' => null,
            'catatan_koreksi' => null,
            'diupdate_by' => null,
            'tanggal_diperbarui' => null,
            'nilai_koreksi' => null,
            'dikoreksi_by' => null,
            'evaluasi' => null,
            'tanggal_dikoreksi' => null,
        ];
    }
}
