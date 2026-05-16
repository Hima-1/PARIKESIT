<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Support\Facades\DB;

test('admin can paginate dashboard progress data with explicit meta payload', function () {
    Formulir::factory()->count(12)->create();
    Formulir::factory()->create(['kind' => Formulir::KIND_TEMPLATE]);

    $response = loginAsAdmin()->getJson('/api/dashboard/progress-penilaian?page=2&per_page=5');

    $response->assertOk()
        ->assertJsonPath('meta.current_page', 2)
        ->assertJsonPath('meta.per_page', 5)
        ->assertJsonPath('meta.total', 12)
        ->assertJsonCount(5, 'data');
});

test('admin can search dashboard progress by formulir name', function () {
    Formulir::factory()->create(['nama_formulir' => 'Dinas Kesehatan 2026']);
    Formulir::factory()->create(['nama_formulir' => 'Bappeda 2026']);

    $response = loginAsAdmin()->getJson(
        '/api/dashboard/progress-penilaian?search=kesehatan',
    );

    $response->assertOk()
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.nama', 'Dinas Kesehatan 2026');
});

test('admin can sort dashboard progress by name ascending', function () {
    Formulir::factory()->create(['nama_formulir' => 'Zulu']);
    Formulir::factory()->create(['nama_formulir' => 'Alpha']);

    $response = loginAsAdmin()->getJson(
        '/api/dashboard/progress-penilaian?sort_by=nama&sort_direction=asc',
    );

    $response->assertOk()
        ->assertJsonPath('data.0.nama', 'Alpha')
        ->assertJsonPath('data.1.nama', 'Zulu');
});

test('dashboard progress falls back to default sort when sort params are invalid', function () {
    Formulir::factory()->create([
        'nama_formulir' => 'Oldest',
        'tanggal_dibuat' => now()->subDays(5),
    ]);
    Formulir::factory()->create([
        'nama_formulir' => 'Newest',
        'tanggal_dibuat' => now(),
    ]);

    $response = loginAsAdmin()->getJson(
        '/api/dashboard/progress-penilaian?sort_by=invalid&sort_direction=sideways',
    );

    $response->assertOk()
        ->assertJsonPath('data.0.nama', 'Newest')
        ->assertJsonPath('data.1.nama', 'Oldest');
});

test('admin can sort dashboard progress by opd and walidata progress', function () {
    Formulir::factory()->create([
        'nama_formulir' => 'B Progress',
        'tanggal_dibuat' => now()->subDay(),
    ]);
    Formulir::factory()->create([
        'nama_formulir' => 'A Progress',
        'tanggal_dibuat' => now(),
    ]);

    $opdResponse = loginAsAdmin()->getJson(
        '/api/dashboard/progress-penilaian?sort_by=progress_opd&sort_direction=asc',
    );
    $walidataResponse = loginAsAdmin()->getJson(
        '/api/dashboard/progress-penilaian?sort_by=progress_walidata&sort_direction=asc',
    );

    $opdResponse->assertOk()
        ->assertJsonStructure([
            'data' => [
                '*' => [
                    'id',
                    'nama',
                    'tanggal',
                    'opd_filled_count',
                    'opd_total_count',
                    'walidata_corrected_count',
                    'walidata_total_count',
                ],
            ],
            'meta' => ['current_page', 'last_page', 'per_page', 'total'],
        ]);
    $walidataResponse->assertOk()
        ->assertJsonStructure([
            'data' => [
                '*' => [
                    'id',
                    'nama',
                    'tanggal',
                    'opd_filled_count',
                    'opd_total_count',
                    'walidata_corrected_count',
                    'walidata_total_count',
                ],
            ],
            'meta' => ['current_page', 'last_page', 'per_page', 'total'],
        ]);
});

test('admin dashboard counts walidata progress from nilai_diupdate without waiting for admin evaluation', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'nama_formulir' => 'Dinas Kominfo 2026',
    ]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain->id);

    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
    ]);

    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => null,
        'evaluasi' => null,
    ]);

    $response = loginAsAdmin()->getJson('/api/dashboard/progress-penilaian');

    $response->assertOk()
        ->assertJsonPath('data.0.nama', 'Dinas Kominfo 2026')
        ->assertJsonPath('data.0.walidata_corrected_count', 1)
        ->assertJsonPath('data.0.walidata_total_count', 1);
});

test('admin dashboard progress query count stays bounded for paginated data', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);

    foreach (range(1, 8) as $index) {
        $formulir = Formulir::factory()->create([
            'nama_formulir' => "Formulir {$index}",
        ]);
        $domain = Domain::factory()->create();
        $formulir->domains()->attach($domain->id);
        $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);

        foreach (range(1, 2) as $indicatorIndex) {
            $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

            Penilaian::factory()->create([
                'formulir_id' => $formulir->id,
                'indikator_id' => $indikator->id,
                'user_id' => $opd->id,
                'nilai' => $indicatorIndex,
                'nilai_diupdate' => $indicatorIndex === 1 ? 4 : null,
            ]);
        }
    }

    DB::flushQueryLog();
    DB::enableQueryLog();

    $response = loginAsAdmin($admin)->getJson('/api/dashboard/progress-penilaian?page=1&per_page=5');

    $queryCount = count(DB::getQueryLog());
    DB::disableQueryLog();

    $response->assertOk()->assertJsonCount(5, 'data');
    expect($queryCount)->toBeLessThanOrEqual(18);
});
