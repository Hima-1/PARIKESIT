<?php

namespace Database\Factories;

use App\Models\Aspek;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Indikator>
 */
class IndikatorFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'aspek_id' => Aspek::factory(),
            'kode_indikator' => $this->faker->unique()->numerify('#####'),
            'nama_indikator' => $this->faker->sentence(5),
            'bobot_indikator' => $this->faker->numberBetween(30, 100),
            'level_1_kriteria' => $this->faker->sentence(),
            'level_2_kriteria' => $this->faker->sentence(),
            'level_3_kriteria' => $this->faker->sentence(),
            'level_4_kriteria' => $this->faker->sentence(),
            'level_5_kriteria' => $this->faker->sentence(),
        ];
    }
}
