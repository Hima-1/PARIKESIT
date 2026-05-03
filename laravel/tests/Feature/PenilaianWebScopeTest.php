<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;

it('scopes isi-domain web page to the active formulir when domain names are duplicated', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulirA = Formulir::create([
        'nama_formulir' => 'Formulir A',
        'created_by_id' => $opd->id,
    ]);
    $formulirB = Formulir::create([
        'nama_formulir' => 'Formulir B',
        'created_by_id' => $opd->id,
    ]);

    $domainA = Domain::create([
        'nama_domain' => 'Domain Prinsip SDI',
        'bobot_domain' => 100,
    ]);
    $domainB = Domain::create([
        'nama_domain' => 'Domain Prinsip SDI',
        'bobot_domain' => 100,
    ]);

    FormulirDomain::create(['formulir_id' => $formulirA->id, 'domain_id' => $domainA->id]);
    FormulirDomain::create(['formulir_id' => $formulirB->id, 'domain_id' => $domainB->id]);

    $aspekA = Aspek::create([
        'domain_id' => $domainA->id,
        'nama_aspek' => 'Aspek Form A',
        'bobot_aspek' => 100,
    ]);
    $aspekB = Aspek::create([
        'domain_id' => $domainB->id,
        'nama_aspek' => 'Aspek Form B',
        'bobot_aspek' => 100,
    ]);

    $indikatorA = Indikator::create([
        'aspek_id' => $aspekA->id,
        'nama_indikator' => 'Indikator Form A',
        'bobot_indikator' => 100,
    ]);
    Indikator::create([
        'aspek_id' => $aspekB->id,
        'nama_indikator' => 'Indikator Form B',
        'bobot_indikator' => 100,
    ]);

    Penilaian::create([
        'indikator_id' => $indikatorA->id,
        'formulir_id' => $formulirA->id,
        'nilai' => 4,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => null,
    ]);

    $response = $this->actingAs($opd)->get(route('formulir.isi-domain', [
        'formulir' => $formulirA,
        'domain' => 'Domain Prinsip SDI',
    ]));

    $response->assertOk();
    $response->assertSeeText('Aspek Form A');
    $response->assertSeeText('Indikator Form A');
    $response->assertDontSeeText('Aspek Form B');
    $response->assertDontSeeText('Indikator Form B');
});

it('scopes indikator detail web page to the active formulir tree when names are duplicated', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulirA = Formulir::create([
        'nama_formulir' => 'Formulir A',
        'created_by_id' => $opd->id,
    ]);
    $formulirB = Formulir::create([
        'nama_formulir' => 'Formulir B',
        'created_by_id' => $opd->id,
    ]);

    $domainA = Domain::create(['nama_domain' => 'Domain Prinsip SDI', 'bobot_domain' => 100]);
    $domainB = Domain::create(['nama_domain' => 'Domain Prinsip SDI', 'bobot_domain' => 100]);
    FormulirDomain::create(['formulir_id' => $formulirA->id, 'domain_id' => $domainA->id]);
    FormulirDomain::create(['formulir_id' => $formulirB->id, 'domain_id' => $domainB->id]);

    $aspekA = Aspek::create(['domain_id' => $domainA->id, 'nama_aspek' => 'Aspek Metadata', 'bobot_aspek' => 100]);
    $aspekB = Aspek::create(['domain_id' => $domainB->id, 'nama_aspek' => 'Aspek Metadata', 'bobot_aspek' => 100]);

    $indikatorA = Indikator::create([
        'aspek_id' => $aspekA->id,
        'kode_indikator' => '30101',
        'nama_indikator' => 'Indikator Konsistensi',
        'bobot_indikator' => 100,
        'level_1_kriteria' => 'Kriteria Form A',
    ]);
    Indikator::create([
        'aspek_id' => $aspekB->id,
        'nama_indikator' => 'Indikator Konsistensi',
        'bobot_indikator' => 100,
        'level_1_kriteria' => 'Kriteria Form B',
    ]);

    Penilaian::create([
        'indikator_id' => $indikatorA->id,
        'formulir_id' => $formulirA->id,
        'nilai' => 3,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => null,
    ]);

    $response = $this->actingAs($opd)->get(route('formulir.penilaianAspek', [
        'formulir' => $formulirA,
        'domain' => 'Domain Prinsip SDI',
        'aspek' => 'Aspek Metadata',
        'indikator' => 'Indikator Konsistensi',
    ]));

    $response->assertOk();
    $response->assertSeeText('Kode Indikator');
    $response->assertSeeText('30101');
    $response->assertSeeText('Tingkat Kriteria');
    $response->assertSeeText('Kriteria Form A');
    $response->assertDontSeeText('Kriteria Form B');
});

it('returns 404 when the requested aspek does not belong to the formulir domain tree', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulirA = Formulir::create([
        'nama_formulir' => 'Formulir A',
        'created_by_id' => $opd->id,
    ]);
    $formulirB = Formulir::create([
        'nama_formulir' => 'Formulir B',
        'created_by_id' => $opd->id,
    ]);

    $domainA = Domain::create(['nama_domain' => 'Domain Prinsip SDI', 'bobot_domain' => 100]);
    $domainB = Domain::create(['nama_domain' => 'Domain Prinsip SDI', 'bobot_domain' => 100]);
    FormulirDomain::create(['formulir_id' => $formulirA->id, 'domain_id' => $domainA->id]);
    FormulirDomain::create(['formulir_id' => $formulirB->id, 'domain_id' => $domainB->id]);

    Aspek::create(['domain_id' => $domainA->id, 'nama_aspek' => 'Aspek Form A', 'bobot_aspek' => 100]);
    $aspekB = Aspek::create(['domain_id' => $domainB->id, 'nama_aspek' => 'Aspek Form B', 'bobot_aspek' => 100]);
    Indikator::create([
        'aspek_id' => $aspekB->id,
        'nama_indikator' => 'Indikator Form B',
        'bobot_indikator' => 100,
    ]);

    $response = $this->actingAs($opd)->get(route('formulir.penilaianAspek', [
        'formulir' => $formulirA,
        'domain' => 'Domain Prinsip SDI',
        'aspek' => 'Aspek Form B',
        'indikator' => 'Indikator Form B',
    ]));

    $response->assertNotFound();
});

it('resolves next indikator only within the current aspek and formulir tree', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulirA = Formulir::create([
        'nama_formulir' => 'Formulir A',
        'created_by_id' => $opd->id,
    ]);
    $formulirB = Formulir::create([
        'nama_formulir' => 'Formulir B',
        'created_by_id' => $opd->id,
    ]);

    $domainA = Domain::create(['nama_domain' => 'Domain Prinsip SDI', 'bobot_domain' => 100]);
    $domainB = Domain::create(['nama_domain' => 'Domain Prinsip SDI', 'bobot_domain' => 100]);
    FormulirDomain::create(['formulir_id' => $formulirA->id, 'domain_id' => $domainA->id]);
    FormulirDomain::create(['formulir_id' => $formulirB->id, 'domain_id' => $domainB->id]);

    $aspekA = Aspek::create(['domain_id' => $domainA->id, 'nama_aspek' => 'Aspek Metadata', 'bobot_aspek' => 100]);
    $aspekB = Aspek::create(['domain_id' => $domainB->id, 'nama_aspek' => 'Aspek Metadata', 'bobot_aspek' => 100]);

    $indikatorPertama = Indikator::create([
        'aspek_id' => $aspekA->id,
        'nama_indikator' => 'Indikator Pertama',
        'bobot_indikator' => 100,
    ]);
    Indikator::create([
        'aspek_id' => $aspekB->id,
        'nama_indikator' => 'Indikator Asing',
        'bobot_indikator' => 100,
    ]);
    $indikatorKedua = Indikator::create([
        'aspek_id' => $aspekA->id,
        'nama_indikator' => 'Indikator Kedua',
        'bobot_indikator' => 100,
    ]);

    $response = $this->actingAs($opd)->get(route('formulir.penilaianAspek', [
        'formulir' => $formulirA,
        'domain' => 'Domain Prinsip SDI',
        'aspek' => 'Aspek Metadata',
        'indikator' => 'Indikator Pertama',
    ]));

    $response->assertOk();
    expect($response->viewData('prev_indikator'))->toBeNull();
    expect($response->viewData('next_indikator'))->not->toBeNull();
    expect($response->viewData('next_indikator')->id)->toBe($indikatorKedua->id);
});

it('renders the assessment detail page with the streamlined progress copy', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Penilaian Statistik',
        'created_by_id' => $opd->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Prinsip SDI',
        'bobot_domain' => 100,
    ]);

    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);

    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Metadata',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Konsistensi',
        'bobot_indikator' => 100,
    ]);

    Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => null,
    ]);

    $response = $this->actingAs($opd)->get(route('formulir.penilaianTersedia', [
        'formulir' => $formulir,
    ]));

    $response->assertOk();
    $response->assertSeeText('Penilaian Kegiatan');
    $response->assertSeeText('Tahap Saat Ini');
    $response->assertSeeText('Progres Pengisian');
    $response->assertSeeText('Ringkasan Progres');
    $response->assertSeeText('LANJUTKAN PENGISIAN');
    $response->assertDontSeeText('PENILAIAN MANDIRI');
    $response->assertDontSeeText('Progres Penilaian Mandiri');
    $response->assertDontSeeText('MULAI PENILAIAN MANDIRI');
});
