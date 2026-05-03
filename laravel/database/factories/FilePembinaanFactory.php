<?php

namespace Database\Factories;

use App\Models\Pembinaan;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\FilePembinaan>
 */
class FilePembinaanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'pembinaan_id' => Pembinaan::factory(),
            'nama_file' => 'file-pembinaan/media/' . $this->faker->word() . '.jpg',
            'tipe_file' => 'jpg',
        ];
    }
}
