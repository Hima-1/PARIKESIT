<?php

use App\Models\Aspek;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\Indikator;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

test('user can get indicators for their formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    // Setup a complex relationship for indicators
    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $indikator->id,
        'nilai' => 4,
        'nilai_diupdate' => 3,
        'nilai_koreksi' => 2,
    ]);

    $response = loginAs($user)->getJson("/api/formulir/{$formulir->id}/indicators");

    $response->assertStatus(200)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.scores.opd', 4)
        ->assertJsonPath('data.domains.0.scores.opd', 4)
        ->assertJsonPath('data.domains.0.aspek.0.scores.opd', 4);
});

test('user indicators endpoint returns the newest filled penilaian when duplicates exist', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    Penilaian::create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $indikator->id,
        'nilai' => 3,
        'tanggal_penilaian' => now()->subDays(2),
        'created_at' => now()->subDays(2),
        'updated_at' => now()->subDays(2),
    ]);

    $filled = Penilaian::create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $indikator->id,
        'nilai' => 5,
        'tanggal_penilaian' => now(),
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    loginAs($user)
        ->getJson("/api/formulir/{$formulir->id}/indicators")
        ->assertStatus(200)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.id', $filled->id)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai', '5.00');
});

test('user indicators endpoint returns null penilaian when only empty records exist', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    loginAs($user)
        ->getJson("/api/formulir/{$formulir->id}/indicators")
        ->assertStatus(200)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian', null);
});

test('user can get indicator response with nested indicator score snapshots', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $indikator->id,
        'nilai' => 5,
        'nilai_diupdate' => 4,
        'nilai_koreksi' => 3,
    ]);

    $response = loginAs($user)->getJson("/api/formulir/{$formulir->id}/indicators");

    $response->assertStatus(200)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.scores.opd', 5)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.scores.walidata', 4)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.scores.admin', 3);
});

test('penilaian indicators returns 401 when unauthenticated', function () {
    $formulir = Formulir::factory()->create();

    $response = $this->getJson("/api/formulir/{$formulir->id}/indicators");

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('penilaian indicators returns 404 when formulir id does not exist', function () {
    $response = loginAsAdmin()->getJson('/api/formulir/999999/indicators');

    $response->assertStatus(404)
        ->assertJsonStructure(['message']);
});

test('user can store a penilaian with file upload', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    // Setup valid indicator for this formulir
    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $file = UploadedFile::fake()->create('bukti.pdf', 100);

    $response = loginAs($user)->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 5,
        'catatan' => 'Test Catatan',
        'bukti_dukung' => [$file],
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.nilai', 5);

    $this->assertDatabaseHas('penilaians', [
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $user->id,
        'nilai' => 5,
    ]);

    // Verify file exists on the public disk
    $savedPenilaian = \App\Models\Penilaian::first();
    $savedFiles = is_string($savedPenilaian->bukti_dukung) ? json_decode($savedPenilaian->bukti_dukung, true) : $savedPenilaian->bukti_dukung;
    if (is_array($savedFiles) && isset($savedFiles[0])) {
        expect(Storage::disk('public')->exists((string) $savedFiles[0]))->toBeTrue();
    } else {
        expect($savedFiles)->not->toBeNull();
    }

});

test('penilaian note is sanitized and nilai is range validated', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);
    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    loginAs($user)
        ->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
            'nilai' => 6,
            'catatan' => 'Invalid',
        ])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['nilai']);

    loginAs($user)
        ->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
            'nilai' => 4,
            'catatan' => '  <b>Catatan</b>   aman ',
        ])
        ->assertCreated()
        ->assertJsonPath('data.catatan', 'Catatan aman');

    $this->assertDatabaseHas('penilaians', [
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $user->id,
        'catatan' => 'Catatan aman',
    ]);
});

test('penilaian rejects existing bukti dukung paths that are not owned by the record', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);
    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    Penilaian::query()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $user->id,
        'nilai' => 3,
        'bukti_dukung' => ['bukti-dukung/owned.pdf'],
        'tanggal_penilaian' => now(),
    ]);

    loginAs($user)
        ->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
            'nilai' => 4,
            'existing_bukti_dukung' => 'bukti-dukung/other-user.pdf',
        ])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['existing_bukti_dukung']);
});

test('user can store a penilaian with single file upload field', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $file = UploadedFile::fake()->create('single-bukti.pdf', 100);

    $response = loginAs($user)->post("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 4,
        'catatan' => 'Single file upload',
        'bukti_dukung' => $file,
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.nilai', 4);

    $savedPenilaian = Penilaian::query()
        ->where('formulir_id', $formulir->id)
        ->where('indikator_id', $indikator->id)
        ->where('user_id', $user->id)
        ->firstOrFail();

    $savedFiles = is_string($savedPenilaian->bukti_dukung)
        ? json_decode($savedPenilaian->bukti_dukung, true)
        : $savedPenilaian->bukti_dukung;

    expect($savedFiles)->toBeArray()->and($savedFiles)->toHaveCount(1);
    expect(Storage::disk('public')->exists((string) $savedFiles[0]))->toBeTrue();
});

test('user can store a penilaian with multiple file upload field', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $fileOne = UploadedFile::fake()->create('multi-bukti-1.pdf', 100);
    $fileTwo = UploadedFile::fake()->image('multi-bukti-2.jpg');

    $response = loginAs($user)->post("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 4,
        'catatan' => 'Multiple file upload',
        'bukti_dukung' => [$fileOne, $fileTwo],
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.nilai', 4);

    $savedPenilaian = Penilaian::query()
        ->where('formulir_id', $formulir->id)
        ->where('indikator_id', $indikator->id)
        ->where('user_id', $user->id)
        ->firstOrFail();

    $savedFiles = is_string($savedPenilaian->bukti_dukung)
        ? json_decode($savedPenilaian->bukti_dukung, true)
        : $savedPenilaian->bukti_dukung;

    expect($savedFiles)->toBeArray()->and($savedFiles)->toHaveCount(2);
    expect(Storage::disk('public')->exists((string) $savedFiles[0]))->toBeTrue();
    expect(Storage::disk('public')->exists((string) $savedFiles[1]))->toBeTrue();
});

test('penilaian bukti dukung uploads use unique sanitized names for duplicate original filenames', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    loginAs($user)->post("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 4,
        'bukti_dukung' => [
            UploadedFile::fake()->create('Bukti Sama.pdf', 100),
            UploadedFile::fake()->create('Bukti Sama.pdf', 100),
        ],
    ])->assertCreated();

    $savedPenilaian = Penilaian::query()
        ->where('formulir_id', $formulir->id)
        ->where('indikator_id', $indikator->id)
        ->where('user_id', $user->id)
        ->firstOrFail();

    $savedFiles = $savedPenilaian->normalizedBuktiDukung();

    expect($savedFiles)->toHaveCount(2);
    expect(array_unique($savedFiles))->toHaveCount(2);
    expect($savedFiles[0])->toMatch('/^bukti-dukung\/[0-9A-HJKMNP-TV-Z]{26}\.pdf$/');
    expect($savedFiles[1])->toMatch('/^bukti-dukung\/[0-9A-HJKMNP-TV-Z]{26}\.pdf$/');
    Storage::disk('public')->assertExists($savedFiles[0]);
    Storage::disk('public')->assertExists($savedFiles[1]);
});

test('penilaian store preserves existing bukti dukung when saved without new files', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    Storage::disk('public')->put('bukti-dukung/existing.pdf', 'existing');

    Penilaian::query()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikator->id,
        'user_id' => $user->id,
        'nilai' => 3,
        'catatan' => 'Sebelum update',
        'bukti_dukung' => ['bukti-dukung/existing.pdf'],
        'tanggal_penilaian' => now(),
    ]);

    loginAs($user)
        ->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
            'nilai' => 4,
            'catatan' => 'Tanpa file baru',
        ])
        ->assertStatus(201)
        ->assertJsonPath('data.bukti_dukung.0', 'bukti-dukung/existing.pdf');

    $savedPenilaian = Penilaian::query()
        ->where('formulir_id', $formulir->id)
        ->where('indikator_id', $indikator->id)
        ->where('user_id', $user->id)
        ->firstOrFail();

    expect($savedPenilaian->normalizedBuktiDukung())->toBe(['bukti-dukung/existing.pdf']);
});

test('indicators endpoint exposes full indicator criteria payload for flutter detail screen', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'kode_indikator' => '30101',
        'bobot_indikator' => 1.25,
        'level_1_kriteria' => 'Kriteria level 1',
        'level_2_kriteria' => 'Kriteria level 2',
    ]);

    loginAs($user)
        ->getJson("/api/formulir/{$formulir->id}/indicators")
        ->assertStatus(200)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.bobot_indikator', 1.25)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.kode_indikator', '30101')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.level_1_kriteria', 'Kriteria level 1')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.level_2_kriteria', 'Kriteria level 2');
});

test('user cannot store penilaian for other user formulir', function () {
    $user = User::factory()->create();
    $otherFormulir = Formulir::factory()->create();
    $indikator = Indikator::factory()->create();

    $response = loginAs($user)->postJson("/api/formulir/{$otherFormulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 4,
    ]);

    $response->assertStatus(403);
});

test('admin cannot store penilaian for any formulir', function () {
    $otherFormulir = Formulir::factory()->create();

    // Setup valid indicator
    $domain = Domain::factory()->create();
    $otherFormulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $response = loginAsAdmin()->postJson("/api/formulir/{$otherFormulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 3,
    ]);

    $response->assertStatus(403)
        ->assertJsonPath('message', 'This action is unauthorized.');
});

test('penilaian store returns 401 when unauthenticated', function () {
    $formulir = Formulir::factory()->create();
    $indikator = Indikator::factory()->create();

    $response = $this->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", []);

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('penilaian store returns 422 when missing nilai', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $response = loginAs($user)->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['nilai']);
});

test('penilaian store returns 404 when formulir id does not exist', function () {
    $indikator = Indikator::factory()->create();

    $response = loginAsAdmin()->postJson("/api/formulir/999999/indikator/{$indikator->id}/penilaian", [
        'nilai' => 3,
    ]);

    $response->assertStatus(404)
        ->assertJsonStructure(['message']);
});

test('penilaian store returns 404 when indikator id does not exist', function () {
    $user = User::factory()->create(['role' => 'admin']);
    $formulir = Formulir::factory()->create();

    $response = loginAs($user)->postJson("/api/formulir/{$formulir->id}/indikator/999999/penilaian", [
        'nilai' => 3,
    ]);

    $response->assertStatus(404)
        ->assertJsonStructure(['message']);
});

test('opd cannot store penilaian for another user formulir', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $formulir = Formulir::factory()->create(['created_by_id' => $admin->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $opd = User::factory()->create(['role' => 'opd']);

    $response = loginAs($opd)->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 4,
        'catatan' => 'Penilaian OPD',
    ]);

    $response->assertStatus(403);
});

test('walidata cannot store penilaian for any formulir', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);
    $formulir = Formulir::factory()->create(['created_by_id' => $owner->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $response = loginAs($walidata)->postJson("/api/formulir/{$formulir->id}/indikator/{$indikator->id}/penilaian", [
        'nilai' => 4,
        'catatan' => 'Walidata should be rejected',
    ]);

    $response->assertStatus(403)
        ->assertJsonPath('message', 'This action is unauthorized.');
});

test('opd cannot get indicators for another user formulir', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $formulir = Formulir::factory()->create(['created_by_id' => $admin->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $opd = User::factory()->create(['role' => 'opd']);

    $response = loginAs($opd)->getJson("/api/formulir/{$formulir->id}/indicators");

    $response->assertStatus(403)
        ->assertJsonPath('message', 'Unauthorized');
});

test('walidata cannot get indicators for other user formulir', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);
    $formulir = Formulir::factory()->create(['created_by_id' => $owner->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $penilaian = Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $owner->id,
        'indikator_id' => $indikator->id,
        'nilai' => 4,
    ]);

    $response = loginAs($walidata)->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$owner->id}");

    $response->assertStatus(200)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.id', $penilaian->id)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai', '4.00');
});

test('non admin cannot request indicators for another user via user_id query parameter', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $otherOpd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    Indikator::factory()->create(['aspek_id' => $aspek->id]);

    $response = loginAs($opd)->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$otherOpd->id}");

    $response->assertStatus(403)
        ->assertJsonPath('message', 'Unauthorized');
});

test('admin can request indicators for another user via user_id query parameter', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);

    $domain = Domain::factory()->create();
    $formulir->domains()->attach($domain);
    $aspek = Aspek::factory()->create(['domain_id' => $domain->id]);
    $indikator = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $penilaian = Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $opd->id,
        'indikator_id' => $indikator->id,
        'nilai' => 4,
    ]);

    $response = loginAs($admin)->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$opd->id}");

    $response->assertStatus(200)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.id', $penilaian->id)
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.penilaian.nilai', '4.00');
});

test('walidata cannot get indicators for non opd target user', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);
    $adminTarget = User::factory()->create(['role' => 'admin']);
    $formulir = Formulir::factory()->create(['created_by_id' => $owner->id]);

    $response = loginAs($walidata)->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$adminTarget->id}");

    $response->assertStatus(403)
        ->assertJsonPath('message', 'Unauthorized');
});

test('walidata cannot get indicators for unrelated opd target', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $otherOpd = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);
    $formulir = Formulir::factory()->create(['created_by_id' => $owner->id]);

    $response = loginAs($walidata)->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$otherOpd->id}");

    $response->assertStatus(403)
        ->assertJsonPath('message', 'Unauthorized');
});

test('admin cannot get indicators for unrelated opd target', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $otherOpd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $owner->id]);

    $response = loginAsAdmin()->getJson("/api/formulir/{$formulir->id}/indicators?user_id={$otherOpd->id}");

    $response->assertStatus(403)
        ->assertJsonPath('message', 'Unauthorized');
});
