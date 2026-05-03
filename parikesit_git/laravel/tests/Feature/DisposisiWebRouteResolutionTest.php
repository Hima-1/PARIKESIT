<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;

it('renders the domain correction overview even when route names have extra whitespace', function () {
    $walidata = User::factory()->create([
        'role' => 'walidata',
        'name' => 'Walidata Uji',
    ]);
    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Dinas Pekerjaan Umum dan Penataan Ruang ',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'aaaasdd ',
        'created_by_id' => $opd->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Prinsip SDI ',
        'bobot_domain' => 100,
    ]);

    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);

    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Uji ',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Uji ',
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

    $response = $this->actingAs($walidata)->get(route('disposisi.koreksi.isi-domain', [
        'opd' => 'Dinas Pekerjaan Umum dan Penataan Ruang',
        'formulir' => 'aaaasdd',
        'domain' => 'Domain Prinsip SDI',
    ]));

    $response->assertOk();
    $response->assertSeeText('KOREKSI PENILAIAN DARI DOMAIN');
    $response->assertSeeText('Domain Prinsip SDI');
    $response->assertSeeText('Aspek Uji');
    $response->assertSeeText('Indikator Uji');
});

it('renders the indikator correction page for walidata using normalized names', function () {
    $walidata = User::factory()->create([
        'role' => 'walidata',
        'name' => 'Walidata Uji',
    ]);
    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Dinas Pekerjaan Umum dan Penataan Ruang ',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'aaaasdd ',
        'created_by_id' => $opd->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Prinsip SDI ',
        'bobot_domain' => 100,
    ]);

    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);

    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Uji ',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'kode_indikator' => '30101',
        'nama_indikator' => 'Indikator Uji ',
        'bobot_indikator' => 100,
        'level_1_kriteria' => 'Level 1',
        'level_2_kriteria' => 'Level 2',
        'level_3_kriteria' => 'Level 3',
        'level_4_kriteria' => 'Level 4',
        'level_5_kriteria' => 'Level 5',
    ]);

    Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => null,
    ]);

    $response = $this->actingAs($walidata)->get(route('disposisi.koreksi.indikator.beri-koreksi', [
        'opd' => 'Dinas Pekerjaan Umum dan Penataan Ruang',
        'formulir' => 'aaaasdd',
        'domain' => 'Domain Prinsip SDI',
        'aspek' => 'Aspek Uji',
        'indikator' => 'Indikator Uji',
    ]));

    $response->assertOk();
    $response->assertSeeText('ASPEK UJI');
    $response->assertSeeText('Kode Indikator');
    $response->assertSeeText('30101');
    $response->assertSeeText('Tingkat Kriteria');
    $response->assertSeeText('Indikator Uji');
    $response->assertSeeText('Simpan Koreksi');
});

it('allows opd to open their own domain review page in read-only mode', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Dinas Pekerjaan Umum dan Penataan Ruang',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'wwwws',
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
        'nama_aspek' => 'Aspek Uji',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Uji',
        'bobot_indikator' => 100,
    ]);

    Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
        'evaluasi' => 'Evaluasi admin',
        'catatan_koreksi' => 'Koreksi walidata',
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => null,
    ]);

    $response = $this->actingAs($opd)->get(route('disposisi.koreksi.isi-domain', [
        'opd' => $opd->name,
        'formulir' => $formulir->nama_formulir,
        'domain' => $domain->nama_domain,
    ]));

    $response->assertOk();
    $response->assertSeeText('TINJAU PENILAIAN DOMAIN');
    $response->assertSeeText('Lihat');
    $response->assertDontSeeText('Koreksi');
});

it('forbids opd from opening another opd review page', function () {
    $owner = User::factory()->create([
        'role' => 'opd',
        'name' => 'OPD Pemilik',
    ]);
    $viewer = User::factory()->create([
        'role' => 'opd',
        'name' => 'OPD Lain',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Form Uji',
        'created_by_id' => $owner->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Prinsip SDI',
        'bobot_domain' => 100,
    ]);

    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);

    $response = $this->actingAs($viewer)->get(route('disposisi.koreksi.isi-domain', [
        'opd' => $owner->name,
        'formulir' => $formulir->nama_formulir,
        'domain' => $domain->nama_domain,
    ]));

    $response->assertForbidden();
});

it('allows opd to open their own completed assessment detail page', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'OPD Pemilik',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Form Detail Saya',
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
        'nama_aspek' => 'Aspek Uji',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Uji',
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

    $response = $this->actingAs($opd)->get(route('disposisi.penilaian.tersedia.detail', [
        'formulir' => $formulir->nama_formulir,
    ]));

    $response->assertOk();
    $response->assertSeeText($formulir->nama_formulir);
});

it('forbids opd from opening another opd completed assessment detail page', function () {
    $owner = User::factory()->create([
        'role' => 'opd',
        'name' => 'OPD Pemilik',
    ]);
    $viewer = User::factory()->create([
        'role' => 'opd',
        'name' => 'OPD Lain',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Form Detail Orang Lain',
        'created_by_id' => $owner->id,
    ]);

    $response = $this->actingAs($viewer)->get(route('disposisi.penilaian.tersedia.detail', [
        'formulir' => $formulir->nama_formulir,
    ]));

    $response->assertForbidden();
});

it('renders indikator review for opd without correction or evaluation actions', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'Dinas Pekerjaan Umum dan Penataan Ruang',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'wwwws',
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
        'nama_aspek' => 'Aspek Uji',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Uji',
        'bobot_indikator' => 100,
    ]);

    Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 5,
        'evaluasi' => 'Evaluasi admin',
        'catatan_koreksi' => 'Koreksi walidata',
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => null,
    ]);

    $response = $this->actingAs($opd)->get(route('disposisi.koreksi.indikator.beri-koreksi', [
        'opd' => $opd->name,
        'formulir' => $formulir->nama_formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
    ]));

    $response->assertOk();
    $response->assertSeeText('Penjelasan Koreksi dari Walidata');
    $response->assertSeeText('Evaluasi Admin');
    $response->assertDontSeeText('Simpan Koreksi');
    $response->assertDontSeeText('Simpan Evaluasi');
});

it('hides completed assessment from admin when assessment has no opd participant', function () {
    $admin = User::factory()->create([
        'role' => 'admin',
    ]);
    $walidata = User::factory()->create([
        'role' => 'walidata',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Form Non OPD',
        'created_by_id' => $walidata->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Non OPD',
        'bobot_domain' => 100,
    ]);
    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Non OPD',
        'bobot_aspek' => 100,
    ]);
    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Non OPD',
        'bobot_indikator' => 100,
    ]);

    Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'tanggal_penilaian' => now(),
        'user_id' => $walidata->id,
    ]);

    $response = $this->actingAs($admin)->get(route('disposisi.penilaian.tersedia'));

    $response->assertOk();
    $response->assertDontSeeText('Form Non OPD');
});

it('rejects web koreksi values outside zero to five', function () {
    [$walidata, $opd, $formulir, $domain, $aspek, $indikator, $penilaian] = createDisposisiValidationFixture();

    $response = $this->actingAs($walidata)->from(route('disposisi.koreksi.indikator.beri-koreksi', [
        'opd' => $opd->name,
        'formulir' => $formulir->nama_formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
    ]))->post(route('disposisi.koreksi.indikator.store-koreksi', [
        'opd' => $opd->name,
        'formulir' => $formulir->nama_formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
    ]), [
        'penilaian_id' => $penilaian->id,
        'nilai' => 6,
        'catatan_koreksi' => 'Nilai di luar rentang',
    ]);

    $response->assertRedirect();
    $response->assertSessionHasErrors(['nilai']);
});

it('rejects web evaluasi values outside zero to five', function () {
    [$walidata, $opd, $formulir, $domain, $aspek, $indikator, $penilaian] = createDisposisiValidationFixture();
    $admin = User::factory()->create([
        'role' => 'admin',
    ]);
    $penilaian->update([
        'nilai_diupdate' => 4,
        'diupdate_by' => $walidata->id,
        'tanggal_diperbarui' => now(),
    ]);

    $response = $this->actingAs($admin)->post(route('disposisi.koreksi.indikator.update-evaluasi', [
        'opd' => $opd->name,
        'formulir' => $formulir->nama_formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
    ]), [
        'penilaian_id' => $penilaian->id,
        'nilai_evaluasi' => 6,
        'evaluasi' => 'Nilai di luar rentang',
    ]);

    $response->assertRedirect();
    $response->assertSessionHasErrors(['nilai_evaluasi']);
});

function createDisposisiValidationFixture(): array
{
    $walidata = User::factory()->create([
        'role' => 'walidata',
        'name' => 'Walidata Validasi',
    ]);
    $opd = User::factory()->create([
        'role' => 'opd',
        'name' => 'OPD Validasi',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Form Validasi',
        'created_by_id' => $opd->id,
    ]);
    $domain = Domain::create([
        'nama_domain' => 'Domain Validasi',
        'bobot_domain' => 100,
    ]);
    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Validasi',
        'bobot_aspek' => 100,
    ]);
    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Validasi',
        'bobot_indikator' => 100,
    ]);
    $penilaian = Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
    ]);

    return [$walidata, $opd, $formulir, $domain, $aspek, $indikator, $penilaian];
}
