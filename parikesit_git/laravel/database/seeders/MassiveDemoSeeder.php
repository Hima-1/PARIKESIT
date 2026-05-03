<?php

namespace Database\Seeders;

use App\Models\DokumentasiKegiatan;
use App\Models\Domain;
use App\Models\FileDokumentasi;
use App\Models\FilePembinaan;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\InboxNotification;
use App\Models\Pembinaan;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class MassiveDemoSeeder extends Seeder
{
    private const FORM_COUNT = 50;

    private const PEMBINAAN_COUNT = 12;

    private const DOKUMENTASI_COUNT = 15;

    private const NOTIFICATION_COUNT = 3;

    private const FORM_PREFIX = 'Massive Demo Formulir';

    private const PEMBINAAN_PREFIX = 'Massive Demo Pembinaan';

    private const DOKUMENTASI_PREFIX = 'Massive Demo Dokumentasi';

    /**
     * Seeder manual untuk stress test lokal.
     * Jalankan eksplisit: `php artisan db:seed --class=MassiveDemoSeeder`
     */
    public function run(): void
    {
        $this->call([
            UserSeeder::class,
            MasterDataSeeder::class,
            IndikatorKriteriaSeeder::class,
        ]);

        $opdUsers = User::query()
            ->where('role', 'opd')
            ->orderBy('id')
            ->get(['id', 'name', 'email']);

        $walidataUser = User::query()->where('role', 'walidata')->orderBy('id')->first(['id', 'name']);
        $adminUsers = User::query()->where('role', 'admin')->orderBy('id')->get(['id', 'name']);

        if ($opdUsers->isEmpty() || !$walidataUser || $adminUsers->isEmpty()) {
            $this->command?->warn('MassiveDemoSeeder dibatalkan: user OPD, walidata, atau admin belum tersedia.');

            return;
        }

        $domains = Domain::query()
            ->whereNull('deleted_at')
            ->with([
                'aspek' => fn ($aspekQuery) => $aspekQuery
                    ->whereNull('deleted_at')
                    ->orderBy('id')
                    ->with([
                        'indikator' => fn ($indikatorQuery) => $indikatorQuery
                            ->whereNull('deleted_at')
                            ->orderBy('id'),
                    ]),
            ])
            ->orderBy('id')
            ->get();

        if ($domains->isEmpty()) {
            $this->command?->warn('MassiveDemoSeeder dibatalkan: master domain/aspek/indikator belum tersedia.');

            return;
        }

        $indikators = $domains
            ->flatMap(fn ($domain) => $domain->aspek->flatMap->indikator)
            ->values();

        if ($indikators->isEmpty()) {
            $this->command?->warn('MassiveDemoSeeder dibatalkan: indikator aktif tidak ditemukan.');

            return;
        }

        $this->cleanupExistingDemoData();
        $this->seedFormulirsAndPenilaians($opdUsers, $walidataUser, $adminUsers, $domains, $indikators);
        $this->seedPembinaans($adminUsers);
        $this->seedDokumentasi($adminUsers);
        $this->seedInboxNotifications($opdUsers, $walidataUser, $adminUsers);
    }

    private function cleanupExistingDemoData(): void
    {
        $formulirIds = Formulir::withTrashed()
            ->where('nama_formulir', 'like', self::FORM_PREFIX . '%')
            ->pluck('id');

        if ($formulirIds->isNotEmpty()) {
            Penilaian::query()->whereIn('formulir_id', $formulirIds)->delete();
            FormulirDomain::withTrashed()->whereIn('formulir_id', $formulirIds)->forceDelete();
            Formulir::withTrashed()->whereIn('id', $formulirIds)->forceDelete();
        }

        $pembinaans = Pembinaan::query()
            ->where('judul_pembinaan', 'like', self::PEMBINAAN_PREFIX . '%')
            ->get();

        foreach ($pembinaans as $pembinaan) {
            FilePembinaan::query()->where('pembinaan_id', $pembinaan->id)->delete();
            $this->deleteDirectoryFromStorage($pembinaan->directory_pembinaan);
            $pembinaan->delete();
        }

        $dokumentasis = DokumentasiKegiatan::query()
            ->where('judul_dokumentasi', 'like', self::DOKUMENTASI_PREFIX . '%')
            ->get();

        foreach ($dokumentasis as $dokumentasi) {
            FileDokumentasi::query()->where('dokumentasi_kegiatan_id', $dokumentasi->id)->delete();
            $this->deleteDirectoryFromStorage($dokumentasi->directory_dokumentasi);
            $dokumentasi->delete();
        }

        InboxNotification::query()
            ->where('type', 'massive_demo')
            ->delete();
    }

    private function seedFormulirsAndPenilaians(
        Collection $opdUsers,
        User $walidataUser,
        Collection $adminUsers,
        Collection $domains,
        Collection $indikators
    ): void {
        DB::transaction(function () use ($opdUsers, $walidataUser, $adminUsers, $domains, $indikators) {
            for ($formIndex = 0; $formIndex < self::FORM_COUNT; $formIndex++) {
                /** @var User $opdUser */
                $opdUser = $opdUsers[$formIndex % $opdUsers->count()];
                $createdAt = now()->subDays(self::FORM_COUNT - $formIndex)->startOfDay()->addHours($formIndex % 8);

                $formulir = Formulir::create([
                    'nama_formulir' => sprintf(
                        '%s %02d - %s',
                        self::FORM_PREFIX,
                        $formIndex + 1,
                        Str::limit($opdUser->name, 40, '')
                    ),
                    'tanggal_dibuat' => $createdAt->toDateString(),
                    'created_by_id' => $opdUser->id,
                ]);

                foreach ($domains as $domain) {
                    FormulirDomain::create([
                        'formulir_id' => $formulir->id,
                        'domain_id' => $domain->id,
                    ]);
                }

                foreach ($indikators as $indikatorIndex => $indikator) {
                    $baseValue = (($formIndex + $indikatorIndex) % 5) + 1;
                    $statusBucket = ($formIndex + $indikatorIndex) % 10;
                    $tanggalPenilaian = (clone $createdAt)->addDays($indikatorIndex % 5);

                    $attributes = [
                        'indikator_id' => $indikator->id,
                        'formulir_id' => $formulir->id,
                        'user_id' => $opdUser->id,
                        'nilai' => $baseValue,
                        'catatan' => sprintf(
                            'Penilaian massive demo %02d untuk %s pada indikator %s.',
                            $formIndex + 1,
                            $opdUser->name,
                            Str::limit($indikator->nama_indikator, 80, '...')
                        ),
                        'tanggal_penilaian' => $tanggalPenilaian,
                        'bukti_dukung' => [
                            sprintf('massive-demo/evidence/form-%02d/indikator-%d-ringkasan.pdf', $formIndex + 1, $indikator->id),
                        ],
                        'dikerjakan_by' => $opdUser->id,
                        'created_at' => $tanggalPenilaian,
                        'updated_at' => $tanggalPenilaian,
                    ];

                    if ($statusBucket >= 4) {
                        $tanggalDiperbarui = (clone $tanggalPenilaian)->addDays(2);

                        $attributes['nilai_diupdate'] = min(5, $baseValue + 1);
                        $attributes['catatan_koreksi'] = sprintf(
                            'Koreksi walidata untuk formulir massive demo %02d pada indikator %d.',
                            $formIndex + 1,
                            $indikator->id
                        );
                        $attributes['diupdate_by'] = $walidataUser->id;
                        $attributes['tanggal_diperbarui'] = $tanggalDiperbarui;
                        $attributes['updated_at'] = $tanggalDiperbarui;
                    }

                    if ($statusBucket >= 8) {
                        /** @var User $adminUser */
                        $adminUser = $adminUsers[($formIndex + $indikatorIndex) % $adminUsers->count()];
                        $tanggalDikoreksi = (clone $tanggalPenilaian)->addDays(4);

                        $attributes['nilai_koreksi'] = max(
                            1,
                            min(5, ($attributes['nilai_diupdate'] ?? $baseValue) + (($indikatorIndex % 3) - 1))
                        );
                        $attributes['dikoreksi_by'] = $adminUser->id;
                        $attributes['evaluasi'] = sprintf(
                            'Evaluasi final massive demo oleh %s untuk indikator %d.',
                            $adminUser->name,
                            $indikator->id
                        );
                        $attributes['tanggal_dikoreksi'] = $tanggalDikoreksi;
                        $attributes['updated_at'] = $tanggalDikoreksi;
                    }

                    Penilaian::query()->create($attributes);
                }
            }
        });
    }

    private function seedPembinaans(Collection $adminUsers): void
    {
        $disk = Storage::disk('public');

        for ($index = 0; $index < self::PEMBINAAN_COUNT; $index++) {
            /** @var User $adminUser */
            $adminUser = $adminUsers[$index % $adminUsers->count()];
            $slug = Str::slug(sprintf('massive-demo-pembinaan-%02d-%s', $index + 1, Str::random(6)));
            $folder = 'file-pembinaan/' . $slug;

            $pembinaan = Pembinaan::query()->create([
                'created_by_id' => $adminUser->id,
                'directory_pembinaan' => $folder,
                'judul_pembinaan' => sprintf('%s %02d', self::PEMBINAAN_PREFIX, $index + 1),
                'bukti_dukung_undangan_pembinaan' => $this->storePdf($disk, $folder, 'undangan', "Undangan pembinaan massive demo {$index}"),
                'daftar_hadir_pembinaan' => $this->storePdf($disk, $folder, 'daftar-hadir', "Daftar hadir pembinaan massive demo {$index}"),
                'materi_pembinaan' => $this->storePdf($disk, $folder, 'materi', "Materi pembinaan massive demo {$index}"),
                'notula_pembinaan' => $this->storePdf($disk, $folder, 'notula', "Notula pembinaan massive demo {$index}"),
                'created_at' => now()->subDays(20 - ($index % 20)),
                'updated_at' => now()->subDays(20 - ($index % 20)),
            ]);

            for ($fileIndex = 0; $fileIndex < 2; $fileIndex++) {
                FilePembinaan::query()->create([
                    'pembinaan_id' => $pembinaan->id,
                    'nama_file' => $this->storeBinaryFile(
                        $disk,
                        $folder,
                        sprintf('lampiran-%02d', $fileIndex + 1),
                        'pdf',
                        "Lampiran pembinaan {$index} - {$fileIndex}"
                    ),
                    'tipe_file' => 'pdf',
                ]);
            }
        }
    }

    private function seedDokumentasi(Collection $adminUsers): void
    {
        $disk = Storage::disk('public');

        for ($index = 0; $index < self::DOKUMENTASI_COUNT; $index++) {
            /** @var User $adminUser */
            $adminUser = $adminUsers[$index % $adminUsers->count()];
            $slug = Str::slug(sprintf('massive-demo-dokumentasi-%02d-%s', $index + 1, Str::random(6)));
            $folder = 'dokumentasi-kegiatan/' . $slug;

            $dokumentasi = DokumentasiKegiatan::query()->create([
                'created_by_id' => $adminUser->id,
                'directory_dokumentasi' => $folder,
                'judul_dokumentasi' => sprintf('%s %02d', self::DOKUMENTASI_PREFIX, $index + 1),
                'bukti_dukung_undangan_dokumentasi' => $this->storePdf($disk, $folder, 'undangan', "Undangan dokumentasi massive demo {$index}"),
                'daftar_hadir_dokumentasi' => $this->storePdf($disk, $folder, 'daftar-hadir', "Daftar hadir dokumentasi massive demo {$index}"),
                'materi_dokumentasi' => $this->storePdf($disk, $folder, 'materi', "Materi dokumentasi massive demo {$index}"),
                'notula_dokumentasi' => $this->storePdf($disk, $folder, 'notula', "Notula dokumentasi massive demo {$index}"),
                'created_at' => now()->subDays(30 - ($index % 25)),
                'updated_at' => now()->subDays(30 - ($index % 25)),
            ]);

            $fileTypes = ['pdf', 'jpg', 'png'];
            foreach ($fileTypes as $fileIndex => $fileType) {
                FileDokumentasi::query()->create([
                    'dokumentasi_kegiatan_id' => $dokumentasi->id,
                    'nama_file' => $this->storeBinaryFile(
                        $disk,
                        $folder,
                        sprintf('dokumentasi-%02d', $fileIndex + 1),
                        $fileType,
                        "Dokumentasi {$index} - {$fileType}"
                    ),
                    'tipe_file' => $fileType,
                ]);
            }
        }
    }

    private function seedInboxNotifications(Collection $opdUsers, User $walidataUser, Collection $adminUsers): void
    {
        $notificationUsers = $opdUsers
            ->take(min(20, $opdUsers->count()))
            ->push($walidataUser)
            ->merge($adminUsers->take(min(5, $adminUsers->count())))
            ->unique('id')
            ->values();

        foreach ($notificationUsers as $userIndex => $user) {
            for ($notificationIndex = 0; $notificationIndex < self::NOTIFICATION_COUNT; $notificationIndex++) {
                $createdAt = Carbon::now()->subDays($userIndex + $notificationIndex)->subHours($notificationIndex * 3);
                $isRead = (($userIndex + $notificationIndex) % 3) === 0;

                InboxNotification::query()->create([
                    'user_id' => $user->id,
                    'title' => sprintf('Massive Demo Notification %02d', $notificationIndex + 1),
                    'body' => sprintf(
                        'Notifikasi demo untuk %s terkait pengujian volume data pada dashboard dan inbox.',
                        $user->name
                    ),
                    'type' => 'massive_demo',
                    'data' => [
                        'source' => 'MassiveDemoSeeder',
                        'sequence' => $notificationIndex + 1,
                        'user_role' => $user->role,
                    ],
                    'is_read' => $isRead,
                    'read_at' => $isRead ? (clone $createdAt)->addHours(4) : null,
                    'hidden_at' => (($userIndex + $notificationIndex) % 7) === 0 ? (clone $createdAt)->addDays(3) : null,
                    'created_at' => $createdAt,
                    'updated_at' => $isRead ? (clone $createdAt)->addHours(4) : $createdAt,
                ]);
            }
        }
    }

    private function storePdf($disk, string $folder, string $prefix, string $content): string
    {
        return $this->storeBinaryFile($disk, $folder, $prefix, 'pdf', $content);
    }

    private function storeBinaryFile($disk, string $folder, string $prefix, string $extension, string $content): string
    {
        $path = sprintf('%s/%s.%s', $folder, $prefix, $extension);

        $payload = match ($extension) {
            'png' => base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9sot0kQAAAAASUVORK5CYII=', true),
            'jpg' => base64_decode('/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxAQEBAQEBAPEA8QDw8QDw8PDxAQEA8QFREWFhURFRUYHSggGBolHRUVITEhJSkrLi4uFx8zODMsNygtLisBCgoKDg0OGxAQGi0lHyUtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAAEAAgMBIgACEQEDEQH/xAAXAAEBAQEAAAAAAAAAAAAAAAAAAQID/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEAMQAAAB6gD/xAAXEAEBAQEAAAAAAAAAAAAAAAABABEh/9oACAEBAAEFApC5v//EABQRAQAAAAAAAAAAAAAAAAAAABD/2gAIAQMBAT8BP//EABQRAQAAAAAAAAAAAAAAAAAAABD/2gAIAQIBAT8BP//Z', true),
            default => "%PDF-1.4\n{$content}\n%%EOF\n",
        };

        $disk->put($path, $payload ?: $content);

        return 'storage/' . $path;
    }

    private function deleteDirectoryFromStorage(string $directory): void
    {
        $normalized = Str::replaceStart('storage/', '', $directory);

        if ($normalized === '') {
            return;
        }

        Storage::disk('public')->deleteDirectory($normalized);
    }
}
