<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;

test('guest can list public completed assessments', function () {
    $publicFormulir = Formulir::factory()->create([
        'nama_formulir' => 'Evaluasi Publik 2026',
    ]);
    $hiddenTemplate = Formulir::factory()->create([
        'kind' => Formulir::KIND_TEMPLATE,
        'nama_formulir' => 'Template Internal',
    ]);
    $withoutOpdParticipant = Formulir::factory()->create([
        'nama_formulir' => 'Tanpa OPD',
    ]);

    $opd = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    Penilaian::factory()->create([
        'formulir_id' => $publicFormulir->id,
        'user_id' => $opd->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $hiddenTemplate->id,
        'user_id' => $opd->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $withoutOpdParticipant->id,
        'user_id' => $walidata->id,
    ]);

    $this->getJson('/api/public/penilaian-selesai')
        ->assertOk()
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.id', $publicFormulir->id)
        ->assertJsonPath('data.0.nama_formulir', 'Evaluasi Publik 2026')
        ->assertJsonMissingPath('data.0.created_by_id')
        ->assertJsonMissingPath('data.0.created_by')
        ->assertJsonMissingPath('data.0.review_progress')
        ->assertJsonMissingPath('data.0.pending_indicator_preview');
});

test('public completed assessments apply search sort and pagination', function () {
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

    $this->getJson('/api/public/penilaian-selesai?search=Formulir&sort=nama_formulir&direction=asc&page=2&per_page=1')
        ->assertOk()
        ->assertJsonPath('meta.current_page', 2)
        ->assertJsonPath('meta.last_page', 3)
        ->assertJsonPath('meta.per_page', 1)
        ->assertJsonPath('meta.total', 3)
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.nama_formulir', 'Formulir Beta');
});

test('guest can list public OPD scores for a formulir without exposing internal fields', function () {
    $formulir = Formulir::factory()->create([
        'nama_formulir' => 'Publik OPD',
    ]);
    $domain = Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Bappeda',
        'email' => 'bappeda@example.com',
    ]);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
    ]);

    $this->getJson("/api/public/penilaian-selesai/{$formulir->id}/opds?per_page=1")
        ->assertOk()
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('meta.current_page', 1)
        ->assertJsonPath('meta.per_page', 1)
        ->assertJsonPath('meta.total', 1)
        ->assertJsonPath('data.0.id', $opd->id)
        ->assertJsonPath('data.0.name', 'Bappeda')
        ->assertJsonPath('data.0.email', 'bappeda@example.com')
        ->assertJsonPath('data.0.opd_score', 3)
        ->assertJsonPath('data.0.walidata_score', 4)
        ->assertJsonPath('data.0.admin_score', 5)
        ->assertJsonMissingPath('data.0.stats');
});

test('public OPD list returns 404 for template formulir', function () {
    $formulir = Formulir::factory()->create([
        'kind' => Formulir::KIND_TEMPLATE,
    ]);

    $this->getJson("/api/public/penilaian-selesai/{$formulir->id}/opds")
        ->assertNotFound();
});

test('guest can get public detail for one opd without exposing internal fields', function () {
    $formulir = Formulir::factory()->create([
        'nama_formulir' => 'Publik Detail OPD',
    ]);
    $domain = Domain::factory()->create([
        'nama_domain' => 'Kelembagaan',
        'bobot_domain' => 100,
    ]);
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Penguatan Statistik',
        'bobot_aspek' => 100,
    ]);
    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Ketersediaan Metadata',
        'bobot_indikator' => 100,
    ]);

    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Bappeda',
        'email' => 'bappeda@example.com',
    ]);
    $otherOpd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Dinkes',
    ]);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
        'catatan' => 'Catatan OPD',
        'catatan_koreksi' => 'Catatan Walidata',
        'evaluasi' => 'Catatan Admin',
    ]);

    Penilaian::factory()->create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'user_id' => $otherOpd->id,
        'nilai' => 1,
        'nilai_diupdate' => 2,
        'nilai_koreksi' => 3,
    ]);

    $this->getJson("/api/public/penilaian-selesai/{$formulir->id}/opd/{$opd->id}")
        ->assertOk()
        ->assertJsonPath('data.id', $formulir->id)
        ->assertJsonPath('data.opd_id', $opd->id)
        ->assertJsonPath('data.opd_name', 'Bappeda')
        ->assertJsonPath('data.scores.opd', 3)
        ->assertJsonPath('data.scores.walidata', 4)
        ->assertJsonPath('data.scores.admin', 5)
        ->assertJsonPath('data.domains.0.id', $domain->id)
        ->assertJsonPath('data.domains.0.nama_domain', 'Kelembagaan')
        ->assertJsonPath('data.domains.0.scores.opd', 3)
        ->assertJsonPath('data.domains.0.aspek.0.id', $aspek->id)
        ->assertJsonPath('data.domains.0.aspek.0.nama_aspek', 'Penguatan Statistik')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.id', $indikator->id)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.nama_indikator', 'Ketersediaan Metadata')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.scores.opd', 3)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.user_id', $opd->id)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai', '3.00')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai_diupdate', 4)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai_koreksi', 5)
        ->assertJsonMissingPath('data.email')
        ->assertJsonMissingPath('data.review_progress')
        ->assertJsonMissingPath('data.domains.0.aspek.0.indikator.0.penilaian.dikerjakan_by')
        ->assertJsonMissingPath('data.domains.0.aspek.0.indikator.0.penilaian.diupdate_by')
        ->assertJsonMissingPath('data.domains.0.aspek.0.indikator.0.penilaian.dikoreksi_by');
});

test('public opd detail returns 404 for template formulir or unrelated opd', function () {
    $template = Formulir::factory()->create([
        'kind' => Formulir::KIND_TEMPLATE,
    ]);
    $formulir = Formulir::factory()->create();
    $opd = User::factory()->create(['role' => 'opd']);

    $this->getJson("/api/public/penilaian-selesai/{$template->id}/opd/{$opd->id}")
        ->assertNotFound();

    $this->getJson("/api/public/penilaian-selesai/{$formulir->id}/opd/{$opd->id}")
        ->assertNotFound();
});
