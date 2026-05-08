<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;

test('full assessment lifecycle flow: opd -> walidata -> admin', function () {
    // 1. Setup
    $opd = User::factory()->create(['role' => 'opd', 'name' => 'OPD Test']);
    $walidata = User::factory()->create(['role' => 'walidata', 'name' => 'Walidata Test']);
    $admin = User::factory()->create(['role' => 'admin', 'name' => 'Admin Test']);

    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $domain = Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    // 2. OPD Step: Submit Penilaian
    $responseOPD = loginAs($opd)->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 3,
        'catatan' => 'Original OPD response',
    ]);
    $responseOPD->assertStatus(201);
    $penilaianId = $responseOPD->json('data.id');

    // 3. Walidata Step: Correction
    $responseWalidata = loginAs($walidata)->postJson('/api/penilaian-selesai/koreksi', [
        'penilaian_id' => $penilaianId,
        'nilai' => 4,
        'catatan_koreksi' => 'Walidata recommendation',
    ]);
    $responseWalidata->assertStatus(200);

    // 4. Admin Step: Final Evaluation
    $responseAdmin = loginAs($admin)->postJson('/api/penilaian-selesai/evaluasi', [
        'penilaian_id' => $penilaianId,
        'nilai_evaluasi' => 5,
        'evaluasi' => 'Final BPS decision',
    ]);
    $responseAdmin->assertStatus(200);

    // 5. Verify Final State and Stats
    $finalPenilaian = Penilaian::find($penilaianId);
    expect($finalPenilaian->nilai)->toEqual(3);
    expect($finalPenilaian->nilai_diupdate)->toEqual(4);
    expect($finalPenilaian->nilai_koreksi)->toEqual(5);

    // Check comparative stats API
    $responseStats = loginAs($admin)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/stats");
    $responseStats->assertStatus(200)
        ->assertJsonPath('comparison.opd_score', 3)
        ->assertJsonPath('comparison.walidata_score', 4)
        ->assertJsonPath('comparison.admin_score', 5);
});

test('indicators endpoint returns persisted walidata and admin review fields', function () {
    $opd = User::factory()->create(['role' => 'opd', 'name' => 'OPD Test']);
    $walidata = User::factory()->create(['role' => 'walidata', 'name' => 'Walidata Test']);
    $admin = User::factory()->create(['role' => 'admin', 'name' => 'Admin Test']);

    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $domain = Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $responseOPD = loginAs($opd)->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 3,
        'catatan' => 'Original OPD response',
    ]);
    $responseOPD->assertStatus(201);
    $penilaianId = $responseOPD->json('data.id');

    $responseWalidata = loginAs($walidata)->postJson('/api/penilaian-selesai/koreksi', [
        'penilaian_id' => $penilaianId,
        'nilai' => 4,
        'catatan_koreksi' => 'Walidata recommendation',
    ]);
    $responseWalidata->assertStatus(200);

    $responseAdmin = loginAs($admin)->postJson('/api/penilaian-selesai/evaluasi', [
        'penilaian_id' => $penilaianId,
        'nilai_evaluasi' => 5,
        'evaluasi' => 'Final BPS decision',
    ]);
    $responseAdmin->assertStatus(200);

    loginAs($walidata)
        ->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$opd->id}")
        ->assertStatus(200)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.id', $penilaianId)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai', '3.00')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai_diupdate', 4)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.catatan_koreksi', 'Walidata recommendation')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.diupdate_by', $walidata->id)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai_koreksi', 5)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.evaluasi', 'Final BPS decision')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.dikoreksi_by', $admin->id);
});
