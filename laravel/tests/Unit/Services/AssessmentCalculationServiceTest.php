<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use App\Services\AssessmentCalculationService;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(Tests\TestCase::class, RefreshDatabase::class);

test('it resolves layer scores from one unique assessment record', function () {
    $service = new AssessmentCalculationService;

    $formulir = Formulir::factory()->create();
    $domain = Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
        'bobot_aspek' => 100,
    ]);
    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'bobot_indikator' => 100,
    ]);
    $opd = User::factory()->create(['role' => 'opd']);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
    ]);

    expect($service->calculateScore($formulir, $opd, 'opd'))->toBe(3.0)
        ->and($service->calculateScore($formulir, $opd, 'walidata'))->toBe(4.0)
        ->and($service->calculateScore($formulir, $opd, 'admin'))->toBe(5.0);
});
