<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Support\Carbon;

it('allows walidata to update koreksi for an existing penilaian via the web route', function () {
    Carbon::setTestNow('2026-03-28 10:00:00');

    $walidata = User::factory()->create([
        'role' => 'walidata',
    ]);
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Penilaian',
        'created_by_id' => $opd->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Statistik',
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

    $penilaian = Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'catatan' => 'Catatan awal',
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => ['bukti-dukung/lampiran.pdf'],
    ]);

    $response = $this->actingAs($walidata)
        ->from('/penilaian/sebelumnya')
        ->post(route('formulir.update-penilaian', [
            'formulir' => $formulir,
            'domain' => $domain->nama_domain,
            'aspek' => $aspek->nama_aspek,
            'indikator' => $indikator->nama_indikator,
            'penilaian' => $penilaian,
        ]), [
            'nilai_update' => 4,
            'koreksi' => 'Perlu penyesuaian pada level kematangan.',
        ]);

    $response->assertRedirect('/penilaian/sebelumnya');
    $response->assertSessionHas('success', 'Berhasil mengoreksi penilaian');

    $penilaian->refresh();

    expect($penilaian->nilai)->toBe(3)
        ->and($penilaian->bukti_dukung)->toBe(['bukti-dukung/lampiran.pdf'])
        ->and($penilaian->nilai_koreksi)->toBeNull()
        ->and($penilaian->evaluasi)->toBeNull()
        ->and($penilaian->nilai_diupdate)->toBe(4)
        ->and($penilaian->catatan_koreksi)->toBe('Perlu penyesuaian pada level kematangan.')
        ->and($penilaian->diupdate_by)->toBe($walidata->id)
        ->and($penilaian->tanggal_diperbarui)->not->toBeNull();

    Carbon::setTestNow();
});

it('rejects non walidata users from updating penilaian koreksi via the web route', function () {
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);
    $admin = User::factory()->create([
        'role' => 'admin',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Penilaian',
        'created_by_id' => $opd->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Statistik',
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

    $penilaian = Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 2,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => ['bukti-dukung/lampiran.pdf'],
    ]);

    $response = $this->actingAs($admin)
        ->from('/penilaian/sebelumnya')
        ->post(route('formulir.update-penilaian', [
            'formulir' => $formulir,
            'domain' => $domain->nama_domain,
            'aspek' => $aspek->nama_aspek,
            'indikator' => $indikator->nama_indikator,
            'penilaian' => $penilaian,
        ]), [
            'nilai_update' => 5,
            'koreksi' => 'Admin mencoba mengubah koreksi.',
        ]);

    $response->assertRedirect('/penilaian/sebelumnya');
    $response->assertSessionHas('error', 'Anda tidak memiliki izin untuk melakukan koreksi');

    $penilaian->refresh();

    expect($penilaian->nilai_diupdate)->toBeNull()
        ->and($penilaian->catatan_koreksi)->toBeNull()
        ->and($penilaian->diupdate_by)->toBeNull()
        ->and($penilaian->tanggal_diperbarui)->toBeNull();
});

it('returns 404 when the penilaian route parameter does not belong to the routed formulir and indikator', function () {
    $walidata = User::factory()->create([
        'role' => 'walidata',
    ]);
    $opd = User::factory()->create([
        'role' => 'opd',
    ]);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Penilaian',
        'created_by_id' => $opd->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Statistik',
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

    $indikatorLain = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Asing',
        'bobot_indikator' => 100,
    ]);

    $penilaianTarget = Penilaian::create([
        'indikator_id' => $indikator->id,
        'formulir_id' => $formulir->id,
        'nilai' => 3,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => ['bukti-dukung/lampiran.pdf'],
    ]);

    $penilaianAsing = Penilaian::create([
        'indikator_id' => $indikatorLain->id,
        'formulir_id' => $formulir->id,
        'nilai' => 2,
        'tanggal_penilaian' => now(),
        'user_id' => $opd->id,
        'bukti_dukung' => ['bukti-dukung/lampiran-asing.pdf'],
    ]);

    $response = $this->actingAs($walidata)->post(route('formulir.update-penilaian', [
        'formulir' => $formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
        'penilaian' => $penilaianAsing,
    ]), [
        'nilai_update' => 4,
        'koreksi' => 'Tidak boleh tersimpan ke penilaian lain.',
    ]);

    $response->assertNotFound();

    $penilaianTarget->refresh();
    $penilaianAsing->refresh();

    expect($penilaianTarget->nilai_diupdate)->toBeNull()
        ->and($penilaianAsing->nilai_diupdate)->toBeNull()
        ->and($penilaianAsing->catatan_koreksi)->toBeNull()
        ->and($penilaianAsing->diupdate_by)->toBeNull()
        ->and($penilaianAsing->tanggal_diperbarui)->toBeNull();
});
