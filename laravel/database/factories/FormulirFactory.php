<?php

namespace Database\Factories;

use App\Models\Formulir;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Formulir>
 */
class FormulirFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'nama_formulir' => $this->faker->sentence(3),
            'tanggal_dibuat' => now(),
            'created_by_id' => User::factory(),
            'kind' => Formulir::KIND_ASSESSMENT,
        ];
    }
}
