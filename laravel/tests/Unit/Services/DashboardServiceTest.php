<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\Formulir;
use App\Models\User;
use App\Services\DashboardService;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(Tests\TestCase::class, RefreshDatabase::class);

beforeEach(function () {
    $this->service = new DashboardService();
});

test('it returns correct aggregate statistics', function () {
    $users = User::factory()->count(10)->create();

    Formulir::factory()->count(5)->create([
        'created_by_id' => $users->first()->id,
    ]);

    $stats = $this->service->getStats();

    expect($stats['jumlahKegiatanPenilaian'])->toBe(5);
    expect($stats['userTerdaftar'])->toBe(10);
});


test('it returns progress data for opd role', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create();

    // Simulate assessment
    $ind = \App\Models\Indikator::factory()->create();
    \App\Models\Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $ind->id,
        'nilai' => 4
    ]);

    $progress = $this->service->getOPDProgress($user);

    expect($progress)->toBeArray()
        ->and(count($progress))->toBeGreaterThan(0)
        ->and($progress[0]['nama'])->toBe($formulir->nama_formulir);
});

test('it returns walidata progress with uncorrected indicator detail', function () {
    $walidata = User::factory()->create(['role' => 'walidata']);
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'created_by_id' => $walidata->id,
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
        'nilai' => 4,
        'nilai_diupdate' => null,
        'nilai_koreksi' => null,
        'catatan_koreksi' => null,
        'evaluasi' => null,
    ]);

    $progress = $this->service->getWalidataProgress();

    expect($progress)->toBeArray()
        ->and($progress)->not->toBeEmpty()
        ->and($progress[0]['id'])->toBe($formulir->id)
        ->and($progress[0]['statistik_walidata']['total_indikator'])->toBe(1)
        ->and($progress[0]['statistik_walidata']['terkoreksi'])->toBe(0)
        ->and($progress[0]['indikator_belum_dikoreksi'])->toHaveCount(1)
        ->and($progress[0]['indikator_belum_dikoreksi'][0]['id'])->toBe($indikator->id)
        ->and($progress[0]['indikator_belum_dikoreksi'][0]['user_id'])->toBe($opd->id);
});

test('it counts walidata correction stats from nilai_diupdate before admin evaluation', function () {
    $walidata = User::factory()->create(['role' => 'walidata']);
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'created_by_id' => $walidata->id,
    ]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain->id);

    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
    ]);

    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'bobot_indikator' => 100,
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => null,
        'catatan_koreksi' => 'Perlu disesuaikan',
        'evaluasi' => null,
    ]);

    $progress = $this->service->getWalidataProgress();
    $adminProgress = $this->service->getAdminProgress();

    expect($progress[0]['nilai_koreksi_akhir'])->toBe(4.0)
        ->and($progress[0]['statistik_walidata']['terkoreksi'])->toBe(1)
        ->and($progress[0]['statistik_walidata']['persentase'])->toBe(100.0)
        ->and($progress[0]['indikator_belum_dikoreksi'])->toBeEmpty()
        ->and($adminProgress[0]['walidata_corrected_count'])->toBe(1)
        ->and($adminProgress[0]['walidata_total_count'])->toBe(1);
});

test('it keeps walidata and admin progress separated after evaluation', function () {
    $walidata = User::factory()->create(['role' => 'walidata']);
    $opd = User::factory()->create(['role' => 'opd']);
    $admin = User::factory()->create(['role' => 'admin']);
    $formulir = Formulir::factory()->create([
        'created_by_id' => $walidata->id,
    ]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain->id);

    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
    ]);

    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'bobot_indikator' => 100,
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $opd->id,
        'nilai' => 2,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
        'dikoreksi_by' => $admin->id,
        'catatan_koreksi' => 'Sudah dikoreksi walidata',
        'evaluasi' => '5',
    ]);

    $walidataProgress = $this->service->getWalidataProgress();
    $opdProgress = $this->service->getOPDProgress($opd);
    $adminProgress = $this->service->getAdminProgress();

    expect($walidataProgress[0]['nilai_koreksi_akhir'])->toBe(4.0)
        ->and($walidataProgress[0]['statistik_walidata']['terkoreksi'])->toBe(1)
        ->and($opdProgress[0]['progress_koreksi_walidata']['sudah_dikoreksi'])->toBe(1)
        ->and($opdProgress[0]['progress_koreksi_walidata']['persentase'])->toBe(100.0)
        ->and($opdProgress[0]['progress_evaluasi_admin']['sudah_dievaluasi'])->toBe(1)
        ->and($opdProgress[0]['progress_evaluasi_admin']['persentase'])->toBe(100.0)
        ->and($adminProgress[0]['walidata_corrected_count'])->toBe(1);
});
