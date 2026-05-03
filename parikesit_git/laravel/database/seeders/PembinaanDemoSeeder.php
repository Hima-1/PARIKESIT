<?php

namespace Database\Seeders;

use App\Models\Pembinaan;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class PembinaanDemoSeeder extends Seeder
{
    /**
     * Demo pembinaan ringan untuk local seed default.
     * Seeder ini sengaja idempotent agar aman saat `db:seed` dijalankan ulang.
     */
    public function run(): void
    {
        $userId = User::query()->where('email', 'admin@gmail.com')->value('id')
            ?? User::query()->value('id');

        if (!$userId) {
            return;
        }

        $disk = Storage::disk('public');

        $templates = [
            'undangan' => base_path('database/seeders/assets/pembinaan-undangan-template.pdf'),
            'daftar_hadir' => base_path('database/seeders/assets/pembinaan-daftar-hadir-template.pdf'),
            'materi' => base_path('database/seeders/assets/pembinaan-materi-template.pdf'),
            'notula' => base_path('database/seeders/assets/pembinaan-notula-template.pdf'),
        ];

        $items = [
            [
                'slug' => 'demo-pembinaan-statistik-sektoral',
                'judul' => 'Pembinaan Statistik Sektoral (Demo)',
            ],
            [
                'slug' => 'demo-koordinasi-standar-data',
                'judul' => 'Koordinasi Standar Data (Demo)',
            ],
        ];

        foreach ($items as $item) {
            $slug = $item['slug'];
            $folder = 'file-pembinaan/' . $slug;

            $files = [
                'bukti_dukung_undangan_pembinaan' => $this->copyTemplate($disk, $templates['undangan'], $folder, 'bukti_dukung_undangan'),
                'daftar_hadir_pembinaan' => $this->copyTemplate($disk, $templates['daftar_hadir'], $folder, 'daftar_hadir'),
                'materi_pembinaan' => $this->copyTemplate($disk, $templates['materi'], $folder, 'materi'),
                'notula_pembinaan' => $this->copyTemplate($disk, $templates['notula'], $folder, 'notula'),
            ];

            Pembinaan::updateOrCreate(
                ['directory_pembinaan' => $slug],
                [
                    'created_by_id' => $userId,
                    'judul_pembinaan' => $item['judul'],
                    'bukti_dukung_undangan_pembinaan' => $files['bukti_dukung_undangan_pembinaan'],
                    'daftar_hadir_pembinaan' => $files['daftar_hadir_pembinaan'],
                    'materi_pembinaan' => $files['materi_pembinaan'],
                    'notula_pembinaan' => $files['notula_pembinaan'],
                ]
            );
        }
    }

    private function copyTemplate($disk, string $templatePath, string $folder, string $prefix): string
    {
        $target = $folder . '/' . $prefix . '.pdf';

        $content = @file_get_contents($templatePath);
        if ($content === false) {
            $content = "%PDF-1.4\n%\n%%EOF\n";
        }

        $disk->put($target, $content);

        // Return path that works with `asset()` (public_path has symlink `file-pembinaan` -> storage/app/public)
        return 'storage/' . $target;
    }
}
