<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;

test('walidata and admin can list available assessments for review', function () {
    $formulir = Formulir::factory()->create();
    $opd = User::factory()->create(['role' => 'opd']);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
    ]);

    $walidata = User::factory()->create(['role' => 'walidata']);
    $response = loginAs($walidata)->getJson('/api/penilaian-selesai');

    $response->assertStatus(200)
        ->assertJsonCount(1, 'data');
});

test('completed assessments include unique participating opd count', function () {
    $formulir = Formulir::factory()->create();
    $opdA = User::factory()->create(['role' => 'opd']);
    $opdB = User::factory()->create(['role' => 'opd']);
    $walidataReviewer = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->count(2)->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opdA->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opdB->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $walidataReviewer->id,
    ]);

    $walidata = User::factory()->create(['role' => 'walidata']);

    loginAs($walidata)->getJson('/api/penilaian-selesai')
        ->assertOk()
        ->assertJsonPath('data.0.id', $formulir->id)
        ->assertJsonPath('data.0.participating_opd_count', 2);
});

test('opd only sees completed assessments related to self', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $otherOpd = User::factory()->create(['role' => 'opd']);

    $ownedFormulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $assessedFormulir = Formulir::factory()->create();
    $foreignFormulir = Formulir::factory()->create(['created_by_id' => $otherOpd->id]);

    Penilaian::factory()->create([
        'formulir_id' => $assessedFormulir->id,
        'user_id' => $opd->id,
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $foreignFormulir->id,
        'user_id' => $otherOpd->id,
    ]);

    $response = loginAs($opd)->getJson('/api/penilaian-selesai');

    $response->assertStatus(200)
        ->assertJsonCount(2, 'data');

    expect(collect($response->json('data'))->pluck('id')->sort()->values()->all())
        ->toBe([$ownedFormulir->id, $assessedFormulir->id]);
});

test('completed assessments exclude formulir without opd participant', function () {
    $formulirDenganOpd = Formulir::factory()->create();
    $formulirTanpaOpd = Formulir::factory()->create();

    $opd = User::factory()->create(['role' => 'opd']);
    $walidataReviewer = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'formulir_id' => $formulirDenganOpd->id,
        'user_id' => $opd->id,
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $formulirTanpaOpd->id,
        'user_id' => $walidataReviewer->id,
    ]);

    $walidata = User::factory()->create(['role' => 'walidata']);
    $response = loginAs($walidata)->getJson('/api/penilaian-selesai');

    $response->assertStatus(200)
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.id', $formulirDenganOpd->id);
});

test('completed assessments exclude template formulirs even when they have opd penilaian', function () {
    $templateFormulir = Formulir::factory()->create([
        'kind' => Formulir::KIND_TEMPLATE,
        'nama_formulir' => 'Formulir Master Data',
    ]);
    $operationalFormulir = Formulir::factory()->create();

    $opd = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'formulir_id' => $templateFormulir->id,
        'user_id' => $opd->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $operationalFormulir->id,
        'user_id' => $opd->id,
    ]);

    $response = loginAs($walidata)->getJson('/api/penilaian-selesai');

    $response->assertOk()
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.id', $operationalFormulir->id);
});

test('completed assessments apply search sort direction and pagination query params', function () {
    $walidata = User::factory()->create(['role' => 'walidata']);
    $opd = User::factory()->create(['role' => 'opd']);

    $older = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Zeta',
        'created_at' => now()->subDays(3),
    ]);
    $middle = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Alpha',
        'created_at' => now()->subDays(2),
    ]);
    $newest = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Beta',
        'created_at' => now()->subDay(),
    ]);

    foreach ([$older, $middle, $newest] as $formulir) {
        Penilaian::factory()->create([
            'formulir_id' => $formulir->id,
            'user_id' => $opd->id,
        ]);
    }

    $response = loginAs($walidata)->getJson(
        '/api/penilaian-selesai?search=Formulir&sort=nama_formulir&direction=asc&page=2&per_page=1'
    );

    $response->assertOk()
        ->assertJsonPath('current_page', 2)
        ->assertJsonPath('last_page', 3)
        ->assertJsonPath('per_page', 1)
        ->assertJsonPath('total', 3)
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.nama_formulir', 'Formulir Beta');
});

test('completed assessments default to newest first ordering', function () {
    $walidata = User::factory()->create(['role' => 'walidata']);
    $opd = User::factory()->create(['role' => 'opd']);

    $older = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Lama',
        'created_at' => now()->subDays(5),
    ]);
    $newer = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Baru',
        'created_at' => now()->subDay(),
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $older->id,
        'user_id' => $opd->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $newer->id,
        'user_id' => $opd->id,
    ]);

    $response = loginAs($walidata)->getJson('/api/penilaian-selesai');

    $response->assertOk()
        ->assertJsonPath('data.0.id', $newer->id)
        ->assertJsonPath('data.1.id', $older->id);
});

test('completed assessments include walidata review progress summary for walidata and admin', function () {
    $formulir = Formulir::factory()->create([
        'nama_formulir' => 'Evaluasi SPBE 2026',
    ]);
    $domain = Domain::factory()->create([
        'nama_domain' => 'Kebijakan',
        'bobot_domain' => 100,
    ]);
    $formulir->domains()->attach($domain);

    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Perencanaan',
        'bobot_aspek' => 100,
    ]);

    $indikatorTerkoreksi = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Terkoreksi',
        'bobot_indikator' => 100,
    ]);
    $indikatorPending = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Pending',
        'bobot_indikator' => 100,
    ]);

    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Dinas Kominfo',
    ]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorTerkoreksi->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorPending->id,
        'user_id' => $opd->id,
        'nilai' => 2,
        'nilai_diupdate' => null,
    ]);

    $walidata = User::factory()->create(['role' => 'walidata']);

    loginAs($walidata)->getJson('/api/penilaian-selesai')
        ->assertOk()
        ->assertJsonPath('data.0.review_progress.total_indicators', 2)
        ->assertJsonPath('data.0.review_progress.corrected_count', 1)
        ->assertJsonPath('data.0.review_progress.percentage', 50)
        ->assertJsonPath('data.0.review_progress.final_correction_score', 4)
        ->assertJsonPath('data.0.review_progress.pending_indicator_preview.0.id', $indikatorPending->id)
        ->assertJsonPath('data.0.review_progress.pending_indicator_preview.0.nama', 'Indikator Pending')
        ->assertJsonPath('data.0.review_progress.pending_indicator_preview.0.domain', 'Kebijakan')
        ->assertJsonPath('data.0.review_progress.pending_indicator_preview.0.aspek', 'Perencanaan')
        ->assertJsonPath('data.0.review_progress.pending_indicator_preview.0.user_id', $opd->id)
        ->assertJsonPath('data.0.review_progress.pending_indicator_preview.0.user_name', 'Dinas Kominfo');

    loginAs(User::factory()->create(['role' => 'admin']))->getJson('/api/penilaian-selesai')
        ->assertOk()
        ->assertJsonPath('data.0.review_progress.corrected_count', 1);
});

test('completed assessments omit walidata review progress for opd responses', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
    ]);

    loginAs($opd)->getJson('/api/penilaian-selesai')
        ->assertOk()
        ->assertJsonMissingPath('data.0.review_progress');
});

test('walidata can store a correction', function () {
    $penilaian = Penilaian::factory()->create();
    $walidata = User::factory()->create(['role' => 'walidata']);

    $response = loginAs($walidata)->postJson('/api/penilaian-selesai/koreksi', [
        'penilaian_id' => $penilaian->id,
        'nilai' => 4,
        'catatan_koreksi' => 'Koreksi Walidata',
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('penilaians', [
        'id' => $penilaian->id,
        'nilai_diupdate' => 4,
        'catatan_koreksi' => 'Koreksi Walidata',
        'diupdate_by' => $walidata->id,
    ]);
});

test('walidata can store a correction without catatan koreksi', function () {
    $penilaian = Penilaian::factory()->create();
    $walidata = User::factory()->create(['role' => 'walidata']);

    $response = loginAs($walidata)->postJson('/api/penilaian-selesai/koreksi', [
        'penilaian_id' => $penilaian->id,
        'nilai' => 4,
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('penilaians', [
        'id' => $penilaian->id,
        'nilai_diupdate' => 4,
        'catatan_koreksi' => null,
        'diupdate_by' => $walidata->id,
    ]);
});

test('admin can store an evaluation after walidata correction', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    $penilaian = Penilaian::factory()->create([
        'nilai_diupdate' => 4,
        'diupdate_by' => $walidata->id,
    ]);

    $response = loginAs($admin)->postJson('/api/penilaian-selesai/evaluasi', [
        'penilaian_id' => $penilaian->id,
        'nilai_evaluasi' => 5,
        'evaluasi' => 'Evaluasi Admin Akhir',
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('penilaians', [
        'id' => $penilaian->id,
        'nilai_koreksi' => 5,
        'evaluasi' => 'Evaluasi Admin Akhir',
        'dikoreksi_by' => $admin->id,
    ]);
});

test('admin can store an evaluation without evaluasi text', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    $penilaian = Penilaian::factory()->create([
        'nilai_diupdate' => 4,
        'diupdate_by' => $walidata->id,
    ]);

    $response = loginAs($admin)->postJson('/api/penilaian-selesai/evaluasi', [
        'penilaian_id' => $penilaian->id,
        'nilai_evaluasi' => 5,
    ]);

    $response->assertStatus(200);
    $this->assertDatabaseHas('penilaians', [
        'id' => $penilaian->id,
        'nilai_koreksi' => 5,
        'evaluasi' => null,
        'dikoreksi_by' => $admin->id,
    ]);
});

test('admin cannot evaluate before walidata correction', function () {
    $penilaian = Penilaian::factory()->create(['nilai_diupdate' => null]);
    $admin = User::factory()->create(['role' => 'admin']);

    $response = loginAs($admin)->postJson('/api/penilaian-selesai/evaluasi', [
        'penilaian_id' => $penilaian->id,
        'nilai_evaluasi' => 5,
        'evaluasi' => 'Evaluasi Prematur',
    ]);

    $response->assertStatus(422)
        ->assertJson(['message' => 'Walidata belum mengisi penilaian. Anda tidak dapat melakukan evaluasi.']);
});

test('non-walidata cannot store correction', function () {
    $penilaian = Penilaian::factory()->create();
    $opd = User::factory()->create(['role' => 'opd']);

    $response = loginAs($opd)->postJson('/api/penilaian-selesai/koreksi', [
        'penilaian_id' => $penilaian->id,
        'nilai' => 4,
        'catatan_koreksi' => 'Bypass Attempt',
    ]);

    $response->assertStatus(403);
});

test('admin and walidata can get participating opds for a formulir', function () {
    $formulir = Formulir::factory()->create();
    $opd = User::factory()->create([
        'role' => 'opd',
        'nomor_telepon' => '08123456789',
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
    ]);

    $walidata = User::factory()->create(['role' => 'walidata']);
    $response = loginAs($walidata)->getJson("/api/penilaian-selesai/{$formulir->id}/opds?per_page=1");

    $response->assertStatus(200)
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('current_page', 1)
        ->assertJsonPath('per_page', 1)
        ->assertJsonPath('total', 1)
        ->assertJsonPath('data.0.id', $opd->id)
        ->assertJsonPath('data.0.name', $opd->name)
        ->assertJsonPath('data.0.role', 'opd')
        ->assertJsonPath('data.0.nomor_telepon', '08123456789')
        ->assertJsonStructure([
            'data' => [[
                'id',
                'name',
                'role',
                'nomor_telepon',
                'stats',
            ]],
        ]);
});

test('opd cannot get participating opds or summary for a formulir', function () {
    $formulir = Formulir::factory()->create();
    $opd = User::factory()->create(['role' => 'opd']);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
    ]);

    loginAs($opd)->getJson("/api/penilaian-selesai/{$formulir->id}/opds")
        ->assertStatus(403);

    loginAs($opd)->getJson("/api/penilaian-selesai/{$formulir->id}/summary")
        ->assertStatus(403);
});

test('walidata can get comparison summary for each opd with real scores', function () {
    $formulir = Formulir::factory()->create();
    $domain = \App\Models\Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = \App\Models\Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $opd = User::factory()->create(['role' => 'opd', 'name' => 'Bappeda']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
    ]);

    $response = loginAs($walidata)->getJson("/api/penilaian-selesai/{$formulir->id}/summary");

    $response->assertStatus(200)
        ->assertJsonPath('0.opd_id', $opd->id)
        ->assertJsonPath('0.nama_opd', 'Bappeda')
        ->assertJsonPath('0.skor_mandiri', 3)
        ->assertJsonPath('0.skor_walidata', 4)
        ->assertJsonPath('0.skor_bps', 5);
});

test('summary prefers walidata score from the most relevant correction record', function () {
    $formulir = Formulir::factory()->create();
    $domain = \App\Models\Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = \App\Models\Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $opd = User::factory()->create(['role' => 'opd', 'name' => 'Bappeda']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 2,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
        'updated_at' => now()->subMinute(),
    ]);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => null,
        'nilai_koreksi' => null,
        'updated_at' => now(),
    ]);

    $response = loginAs($walidata)->getJson("/api/penilaian-selesai/{$formulir->id}/summary");

    $response->assertStatus(200)
        ->assertJsonPath('0.skor_mandiri', 3)
        ->assertJsonPath('0.skor_walidata', 4)
        ->assertJsonPath('0.skor_bps', 5);
});

test('walidata can get review domain summary for an opd with real scores', function () {
    $formulir = Formulir::factory()->create();
    $domain = \App\Models\Domain::factory()->create(['nama_domain' => 'Kelembagaan', 'bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = \App\Models\Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $opd = User::factory()->create(['role' => 'opd', 'name' => 'Bappeda']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 2,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
    ]);

    $response = loginAs($walidata)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/domains");

    $response->assertStatus(200)
        ->assertJsonPath('0.domain_id', $domain->id)
        ->assertJsonPath('0.nama_domain', 'Kelembagaan')
        ->assertJsonPath('0.opd_score', 2)
        ->assertJsonPath('0.walidata_score', 4)
        ->assertJsonPath('0.admin_score', 5);
});

test('opd stats prefer walidata score from the most relevant correction record', function () {
    $formulir = Formulir::factory()->create();
    $domain = \App\Models\Domain::factory()->create(['nama_domain' => 'Kelembagaan', 'bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = \App\Models\Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $opd = User::factory()->create(['role' => 'opd', 'name' => 'Bappeda']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 2,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
        'updated_at' => now()->subMinute(),
    ]);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => null,
        'nilai_koreksi' => null,
        'updated_at' => now(),
    ]);

    $response = loginAs($walidata)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/stats");

    $response->assertStatus(200)
        ->assertJsonPath('comparison.opd_score', 3)
        ->assertJsonPath('comparison.walidata_score', 4)
        ->assertJsonPath('comparison.admin_score', 5);
});

test('opd can get own stats and domain summary for related formulir only', function () {
    $formulir = Formulir::factory()->create(['created_by_id' => null]);
    $domain = \App\Models\Domain::factory()->create(['nama_domain' => 'Kelembagaan', 'bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = \App\Models\Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $opd = User::factory()->create(['role' => 'opd', 'name' => 'Bappeda']);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 2,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
    ]);

    loginAs($opd)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/stats")
        ->assertStatus(200)
        ->assertJsonPath('opd', 'Bappeda');

    loginAs($opd)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/domains")
        ->assertStatus(200)
        ->assertJsonPath('0.nama_domain', 'Kelembagaan');
});

test('opd cannot get stats or domain summary for another opd', function () {
    $formulir = Formulir::factory()->create();
    $owner = User::factory()->create(['role' => 'opd']);
    $viewer = User::factory()->create(['role' => 'opd']);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $owner->id,
    ]);

    loginAs($viewer)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$owner->id}/stats")
        ->assertStatus(403);

    loginAs($viewer)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$owner->id}/domains")
        ->assertStatus(403);
});

test('opd cannot get own stats or domain summary for unrelated formulir', function () {
    $formulir = Formulir::factory()->create();
    $opd = User::factory()->create(['role' => 'opd']);

    loginAs($opd)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/stats")
        ->assertStatus(403);

    loginAs($opd)->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$opd->id}/domains")
        ->assertStatus(403);
});

test('disposisi endpoints return 401 when unauthenticated', function () {
    $formulir = Formulir::factory()->create();
    $user = User::factory()->create();

    $this->getJson('/api/penilaian-selesai')->assertStatus(401);
    $this->getJson("/api/penilaian-selesai/{$formulir->id}/opds")->assertStatus(401);
    $this->getJson("/api/penilaian-selesai/{$formulir->id}/opd/{$user->id}/stats")->assertStatus(401);
    $this->postJson('/api/penilaian-selesai/koreksi', [])->assertStatus(401);
    $this->postJson('/api/penilaian-selesai/evaluasi', [])->assertStatus(401);
});

test('non-admin cannot store evaluation', function () {
    $penilaian = Penilaian::factory()->create([
        'nilai_diupdate' => 4,
        'diupdate_by' => User::factory()->create(['role' => 'walidata'])->id,
    ]);

    $response = loginAs()->postJson('/api/penilaian-selesai/evaluasi', [
        'penilaian_id' => $penilaian->id,
        'nilai_evaluasi' => 5,
        'evaluasi' => 'Bypass Attempt',
    ]);

    $response->assertStatus(403);
});

test('koreksi returns 422 when payload missing', function () {
    $walidata = User::factory()->create(['role' => 'walidata']);

    $response = loginAs($walidata)->postJson('/api/penilaian-selesai/koreksi', []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['penilaian_id', 'nilai']);
});

test('evaluasi returns 422 when payload missing', function () {
    $admin = User::factory()->create(['role' => 'admin']);

    $response = loginAs($admin)->postJson('/api/penilaian-selesai/evaluasi', []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['penilaian_id', 'nilai_evaluasi']);
});
