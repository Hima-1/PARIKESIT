<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\User;

it('rejects admin from storing penilaian via the web route', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $admin = User::factory()->create(['role' => 'admin']);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Web OPD',
        'created_by_id' => $owner->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Web',
        'bobot_domain' => 100,
    ]);
    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);

    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Web',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Web',
        'bobot_indikator' => 100,
    ]);

    $response = $this->actingAs($admin)->post(route('formulir.store-penilaian', [
        'formulir' => $formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
    ]), [
        'nilai' => 4,
        'catatan' => 'Admin should be rejected',
    ]);

    $response->assertForbidden();
});

it('rejects walidata from storing penilaian via the web route', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    $formulir = Formulir::create([
        'nama_formulir' => 'Formulir Web OPD',
        'created_by_id' => $owner->id,
    ]);

    $domain = Domain::create([
        'nama_domain' => 'Domain Web',
        'bobot_domain' => 100,
    ]);
    FormulirDomain::create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);

    $aspek = Aspek::create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Aspek Web',
        'bobot_aspek' => 100,
    ]);

    $indikator = Indikator::create([
        'aspek_id' => $aspek->id,
        'nama_indikator' => 'Indikator Web',
        'bobot_indikator' => 100,
    ]);

    $response = $this->actingAs($walidata)->post(route('formulir.store-penilaian', [
        'formulir' => $formulir,
        'domain' => $domain->nama_domain,
        'aspek' => $aspek->nama_aspek,
        'indikator' => $indikator->nama_indikator,
    ]), [
        'nilai' => 4,
        'catatan' => 'Walidata should be rejected',
    ]);

    $response->assertForbidden();
});
