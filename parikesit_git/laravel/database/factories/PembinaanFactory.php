<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Pembinaan>
 */
class PembinaanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $judul = $this->faker->sentence();
        $slug = Str::slug($judul . '-' . time());
        
        return [
            'created_by_id' => User::factory(),
            'judul_pembinaan' => $judul,
            'directory_pembinaan' => $slug,
            'bukti_dukung_undangan_pembinaan' => 'file-pembinaan/' . $slug . '/undangan.pdf',
            'daftar_hadir_pembinaan' => 'file-pembinaan/' . $slug . '/hadir.pdf',
            'materi_pembinaan' => 'file-pembinaan/' . $slug . '/materi.pdf',
            'notula_pembinaan' => 'file-pembinaan/' . $slug . '/notula.pdf',
        ];
    }
}
