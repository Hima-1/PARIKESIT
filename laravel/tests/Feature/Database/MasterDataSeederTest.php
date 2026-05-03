<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use App\Support\EpssReference;
use Database\Seeders\IndikatorKriteriaSeeder;
use Database\Seeders\MasterDataSeeder;
use Database\Seeders\UserSeeder;

test('master data seeder creates a single template formulir', function () {
    $this->seed([
        UserSeeder::class,
        MasterDataSeeder::class,
    ]);

    expect(
        Formulir::query()
            ->where('nama_formulir', 'Formulir Master Data')
            ->count()
    )->toBe(1);

    $this->assertDatabaseHas('formulirs', [
        'nama_formulir' => 'Formulir Master Data',
        'kind' => Formulir::KIND_TEMPLATE,
    ]);
});

test('master data seeder aligns domains aspek and indikator with epss reference', function () {
    $this->seed([
        UserSeeder::class,
        MasterDataSeeder::class,
    ]);

    $referenceDomains = EpssReference::domains();
    $referenceIndicators = EpssReference::indicatorsByCode();

    expect(Domain::count())->toBe(count($referenceDomains));
    expect(Aspek::count())->toBe(array_sum(array_map(
        fn (array $domain) => count($domain['aspeks']),
        $referenceDomains,
    )));
    expect(Indikator::count())->toBe(count($referenceIndicators));

    foreach ($referenceIndicators as $kodeIndikator => $reference) {
        $indikator = Indikator::query()
            ->where('kode_indikator', $kodeIndikator)
            ->first();

        expect($indikator)->not->toBeNull();
        expect($indikator->nama_indikator)->toBe($reference['nama_indikator']);
        expect($indikator->level_1_kriteria)->toBe($reference['kriteria'][1]);
    }
});

test('master data seeder stores canonical names without problematic whitespace', function () {
    $this->seed([
        UserSeeder::class,
        MasterDataSeeder::class,
    ]);

    foreach (Domain::all('nama_domain') as $domain) {
        expect($domain->nama_domain)->toBe(trim($domain->nama_domain));
        expect($domain->nama_domain)->not->toContain('  ');
    }

    foreach (Aspek::all('nama_aspek') as $aspek) {
        expect($aspek->nama_aspek)->toBe(trim($aspek->nama_aspek));
        expect($aspek->nama_aspek)->not->toContain('  ');
    }

    foreach (Indikator::all(['nama_indikator', 'kode_indikator']) as $indikator) {
        expect($indikator->kode_indikator)->not->toBeNull();
        expect($indikator->nama_indikator)->toBe(trim($indikator->nama_indikator));
        expect($indikator->nama_indikator)->not->toContain('  ');
    }
});

test('master data seeder backfills legacy indikator records without creating duplicates', function () {
    $this->seed([UserSeeder::class]);

    $reference = EpssReference::indicatorByCode('30101');
    expect($reference)->not->toBeNull();

    $legacyDomain = Domain::factory()->create([
        'nama_domain' => ' '.$reference['nama_domain'].'  ',
        'bobot_domain' => 1,
    ]);
    $legacyAspek = Aspek::factory()->create([
        'domain_id' => $legacyDomain->id,
        'nama_aspek' => ' '.$reference['nama_aspek'].'  ',
        'bobot_aspek' => 1,
    ]);
    $legacyIndikator = Indikator::factory()->create([
        'aspek_id' => $legacyAspek->id,
        'kode_indikator' => null,
        'nama_indikator' => ' '.$reference['nama_indikator'].'  ',
        'bobot_indikator' => 1,
        'level_1_kriteria' => 'Legacy criteria',
        'level_2_kriteria' => 'Legacy criteria',
        'level_3_kriteria' => 'Legacy criteria',
        'level_4_kriteria' => 'Legacy criteria',
        'level_5_kriteria' => 'Legacy criteria',
    ]);

    $masterFormulir = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Master Data',
        'kind' => Formulir::KIND_TEMPLATE,
    ]);
    FormulirDomain::query()->create([
        'formulir_id' => $masterFormulir->id,
        'domain_id' => $legacyDomain->id,
    ]);

    $this->seed([MasterDataSeeder::class]);

    $legacyIndikator->refresh();
    $legacyAspek->refresh();
    $legacyDomain->refresh();

    expect($legacyDomain->nama_domain)->toBe($reference['nama_domain']);
    expect($legacyAspek->nama_aspek)->toBe($reference['nama_aspek']);
    expect($legacyIndikator->kode_indikator)->toBe('30101');
    expect($legacyIndikator->nama_indikator)->toBe($reference['nama_indikator']);
    expect($legacyIndikator->level_1_kriteria)->toBe($reference['kriteria'][1]);

    expect(
        Indikator::query()
            ->where('kode_indikator', '30101')
            ->count()
    )->toBe(1);
});

test('indikator kriteria seeder backfills operational legacy indicators without changing penilaian relations', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $reference = EpssReference::indicatorByCode('30201');
    expect($reference)->not->toBeNull();

    $formulir = Formulir::factory()->create([
        'created_by_id' => $user->id,
        'kind' => Formulir::KIND_ASSESSMENT,
    ]);
    $domain = Domain::factory()->create([
        'nama_domain' => $reference['nama_domain'],
        'bobot_domain' => 1,
    ]);
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $aspek = Aspek::factory()->create([
        'domain_id' => $domain->id,
        'nama_aspek' => $reference['nama_aspek'],
        'bobot_aspek' => 1,
    ]);
    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'kode_indikator' => null,
        'nama_indikator' => 'Tingkat Kematangan Proses Pengumpulan Data atau Akuisisi Data',
        'bobot_indikator' => 1,
        'level_1_kriteria' => null,
        'level_2_kriteria' => null,
        'level_3_kriteria' => null,
        'level_4_kriteria' => null,
        'level_5_kriteria' => null,
    ]);
    $penilaian = Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $indikator->id,
        'nilai' => 3,
    ]);

    $this->seed(IndikatorKriteriaSeeder::class);

    $indikator->refresh();
    $penilaian->refresh();

    expect(Indikator::count())->toBe(1);
    expect($indikator->kode_indikator)->toBe('30201');
    expect($indikator->nama_indikator)->toBe($reference['nama_indikator']);
    expect($indikator->level_1_kriteria)->toBe($reference['kriteria'][1]);
    expect($indikator->level_5_kriteria)->toBe($reference['kriteria'][5]);
    expect($penilaian->indikator_id)->toBe($indikator->id);
});

test('indikator kriteria seeder handles known legacy labels from existing operational forms', function () {
    $domain = Domain::factory()->create(['nama_domain' => 'Domain Kelembagaan']);
    $profesionalitas = Aspek::factory()->create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Profesionalitas',
    ]);
    $pengorganisasian = Aspek::factory()->create([
        'domain_id' => $domain->id,
        'nama_aspek' => 'Pengorganisasian Statistik',
    ]);

    $netralitas = Indikator::factory()->create([
        'aspek_id' => $profesionalitas->id,
        'kode_indikator' => null,
        'nama_indikator' => 'Tingkat Kematangan  Penjaminan Netralitas dan  Objektivitas terhadap  Penggunaan Sumber Data  Metodologi',
        'level_1_kriteria' => null,
    ]);
    $walidata = Indikator::factory()->create([
        'aspek_id' => $pengorganisasian->id,
        'kode_indikator' => null,
        'nama_indikator' => 'Tingkat Kematangan Penyelenggaraan Pelaksanaan Tugas Sebagai Walidata',
        'level_1_kriteria' => null,
    ]);

    $this->seed(IndikatorKriteriaSeeder::class);

    $netralitas->refresh();
    $walidata->refresh();

    expect(Indikator::count())->toBe(2);
    expect($netralitas->kode_indikator)->toBe('40102');
    expect($netralitas->level_1_kriteria)->toBe(EpssReference::indicatorByCode('40102')['kriteria'][1]);
    expect($walidata->kode_indikator)->toBe('40304');
    expect($walidata->level_1_kriteria)->toBe(EpssReference::indicatorByCode('40304')['kriteria'][1]);
});

test('master data seeder keeps template formulir isolated from non-template domains on rerun', function () {
    $this->seed([UserSeeder::class]);

    $customDomain = Domain::factory()->create([
        'nama_domain' => 'Domain Custom Operasional',
    ]);
    $operationalFormulir = Formulir::factory()->create([
        'kind' => Formulir::KIND_ASSESSMENT,
    ]);
    FormulirDomain::query()->create([
        'formulir_id' => $operationalFormulir->id,
        'domain_id' => $customDomain->id,
    ]);

    $masterFormulir = Formulir::factory()->create([
        'nama_formulir' => 'Formulir Master Data',
        'kind' => Formulir::KIND_TEMPLATE,
    ]);
    FormulirDomain::query()->create([
        'formulir_id' => $masterFormulir->id,
        'domain_id' => $customDomain->id,
    ]);

    $this->seed([MasterDataSeeder::class]);

    expect(
        FormulirDomain::query()
            ->where('formulir_id', $masterFormulir->id)
            ->where('domain_id', $customDomain->id)
            ->count()
    )->toBe(0);

    expect(
        FormulirDomain::withTrashed()
            ->where('formulir_id', $masterFormulir->id)
            ->where('domain_id', $customDomain->id)
            ->whereNotNull('deleted_at')
            ->count()
    )->toBe(1);

    expect(
        FormulirDomain::query()
            ->where('formulir_id', $masterFormulir->id)
            ->count()
    )->toBe(count(EpssReference::domains()));
});
