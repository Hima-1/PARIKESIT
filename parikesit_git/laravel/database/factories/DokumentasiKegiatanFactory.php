<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\DokumentasiKegiatan>
 */
class DokumentasiKegiatanFactory extends Factory
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
            'judul_dokumentasi' => $judul,
            'directory_dokumentasi' => $slug,
            'bukti_dukung_undangan_dokumentasi' => 'file-dokumentasi/' . $slug . '/undangan.pdf',
            'daftar_hadir_dokumentasi' => 'file-dokumentasi/' . $slug . '/hadir.pdf',
            'materi_dokumentasi' => 'file-dokumentasi/' . $slug . '/materi.pdf',
            'notula_dokumentasi' => 'file-dokumentasi/' . $slug . '/notula.pdf',
        ];
    }
}
