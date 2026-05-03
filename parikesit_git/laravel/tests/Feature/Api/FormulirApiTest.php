<?php

use App\Models\Formulir;
use App\Models\Penilaian;
use App\Models\User;
use Illuminate\Support\Facades\Storage;

test('regular user can list their own formulirs', function () {
    $user = User::factory()->create();
    Formulir::factory()->count(3)->create(['created_by_id' => $user->id]);
    Formulir::factory()->count(2)->create(); // Other user's formulirs

    $response = loginAs($user)->getJson('/api/formulir');

    $response->assertStatus(200)
        ->assertJsonCount(3, 'data');
});

test('admin can list all formulirs', function () {
    Formulir::factory()->count(5)->create();
    Formulir::factory()->create(['kind' => Formulir::KIND_TEMPLATE]);

    $response = loginAsAdmin()->getJson('/api/formulir');

    $response->assertStatus(200)
        ->assertJsonCount(5, 'data');
});

test('user can create a formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->postJson('/api/formulir', [
        'nama_formulir' => 'Test API Formulir'
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('data.nama_formulir', 'Test API Formulir')
        ->assertJsonPath('data.created_by.id', $user->id);

    $this->assertDatabaseHas('formulirs', [
        'nama_formulir' => 'Test API Formulir',
        'created_by_id' => $user->id,
        'kind' => Formulir::KIND_ASSESSMENT,
    ]);
    $response->assertJsonCount(5, 'data.domains');

    $formulir = Formulir::where('nama_formulir', 'Test API Formulir')->firstOrFail();

    expect($formulir->domains()->count())->toBe(5);
    $this->assertDatabaseCount('formulir_domains', 5);
});

test('admin and walidata cannot create formulir through api endpoint', function () {
    loginAsAdmin()->postJson('/api/formulir', [
        'nama_formulir' => 'Form Admin',
    ])->assertStatus(403);

    $walidata = User::factory()->create(['role' => 'walidata']);

    loginAs($walidata)->postJson('/api/formulir', [
        'nama_formulir' => 'Form Walidata',
    ])->assertStatus(403);

    $this->assertDatabaseMissing('formulirs', [
        'nama_formulir' => 'Form Admin',
    ]);
    $this->assertDatabaseMissing('formulirs', [
        'nama_formulir' => 'Form Walidata',
    ]);
});

test('user can create a formulir without template domains', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->postJson('/api/formulir', [
        'nama_formulir' => 'Form Kosong',
        'use_template' => false,
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('data.nama_formulir', 'Form Kosong')
        ->assertJsonCount(0, 'data.domains');

    $formulir = Formulir::where('nama_formulir', 'Form Kosong')->firstOrFail();

    expect($formulir->domains()->count())->toBe(0);
    expect(
        \App\Models\Aspek::whereHas('domain.formulirs', function ($query) use ($formulir) {
            $query->where('formulirs.id', $formulir->id);
        })->count()
    )->toBe(0);
});

test('user can show their own formulir', function () {
    $user = User::factory()->create();
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->getJson("/api/formulir/{$formulir->id}");

    $response->assertStatus(200)
        ->assertJsonPath('data.id', $formulir->id);
});

test('opd formulir detail includes score snapshots', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = \App\Models\Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    $indikator = \App\Models\Indikator::factory()->create(['aspek_id' => $aspek->id, 'bobot_indikator' => 100]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'user_id' => $user->id,
        'indikator_id' => $indikator->id,
        'nilai' => 4,
        'nilai_diupdate' => 3,
        'nilai_koreksi' => 2,
    ]);

    $response = loginAs($user)->getJson("/api/formulir/{$formulir->id}");

    $response->assertStatus(200)
        ->assertJsonPath('data.scores.opd', 4)
        ->assertJsonPath('data.domains.0.scores.opd', 4)
        ->assertJsonPath('data.domains.0.aspek.0.scores.opd', 4);
});

test('formulir detail exposes kode indikator and criteria payload', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $domain = \App\Models\Domain::factory()->create(['bobot_domain' => 100]);
    $formulir->domains()->attach($domain);
    $aspek = \App\Models\Aspek::factory()->create(['domain_id' => $domain->id, 'bobot_aspek' => 100]);
    \App\Models\Indikator::factory()->create([
        'aspek_id' => $aspek->id,
        'kode_indikator' => '30101',
        'bobot_indikator' => 100,
        'level_1_kriteria' => 'Pendefinisian level 1',
        'level_2_kriteria' => 'Pendefinisian level 2',
    ]);

    loginAs($user)
        ->getJson("/api/formulir/{$formulir->id}")
        ->assertOk()
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.kode_indikator', '30101')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.level_1_kriteria', 'Pendefinisian level 1')
        ->assertJsonPath('data.domains.0.aspek.0.indikator.0.level_2_kriteria', 'Pendefinisian level 2');
});

test('user cannot show other user formulir', function () {
    $user = User::factory()->create();
    $otherFormulir = Formulir::factory()->create();

    $response = loginAs($user)->getJson("/api/formulir/{$otherFormulir->id}");

    $response->assertStatus(403);
});

test('admin can show any formulir', function () {
    $otherFormulir = Formulir::factory()->create();

    $response = loginAsAdmin()->getJson("/api/formulir/{$otherFormulir->id}");

    $response->assertStatus(200)
        ->assertJsonPath('data.id', $otherFormulir->id);
});

test('operational formulir endpoints hide template formulirs', function () {
    $templateFormulir = Formulir::factory()->create([
        'kind' => Formulir::KIND_TEMPLATE,
        'nama_formulir' => 'Formulir Master Data',
    ]);

    loginAsAdmin()->getJson('/api/formulir')
        ->assertOk()
        ->assertJsonCount(0, 'data');

    loginAsAdmin()->getJson("/api/formulir/{$templateFormulir->id}")
        ->assertStatus(404);
});

test('opd can update their own formulir name', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'created_by_id' => $user->id,
        'nama_formulir' => 'Nama Lama',
    ]);

    $response = loginAs($user)->patchJson("/api/formulir/{$formulir->id}", [
        'nama_formulir' => 'Nama Baru',
    ]);

    $response->assertStatus(200)
        ->assertJsonPath('message', 'Formulir berhasil diperbarui')
        ->assertJsonPath('data.nama_formulir', 'Nama Baru');

    $this->assertDatabaseHas('formulirs', [
        'id' => $formulir->id,
        'nama_formulir' => 'Nama Baru',
    ]);
});

test('opd cannot update another user formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherFormulir = Formulir::factory()->create();

    loginAs($user)->patchJson("/api/formulir/{$otherFormulir->id}", [
        'nama_formulir' => 'Nama Baru',
    ])->assertStatus(403);
});

test('admin cannot update formulir through api endpoint', function () {
    $formulir = Formulir::factory()->create();

    loginAsAdmin()->patchJson("/api/formulir/{$formulir->id}", [
        'nama_formulir' => 'Nama Baru',
    ])->assertStatus(403);
});

test('opd can delete their own formulir and related pivots', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'created_by_id' => $user->id,
    ]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
    ]);

    $response = loginAs($user)->deleteJson("/api/formulir/{$formulir->id}");

    $response->assertStatus(200)
        ->assertJsonPath('message', 'Formulir berhasil dihapus');

    $this->assertSoftDeleted('formulirs', [
        'id' => $formulir->id,
    ]);
    $this->assertDatabaseMissing('formulir_domains', [
        'formulir_id' => $formulir->id,
    ]);
    $this->assertDatabaseMissing('penilaians', [
        'formulir_id' => $formulir->id,
    ]);
});

test('opd cannot delete another user formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherFormulir = Formulir::factory()->create();

    loginAs($user)->deleteJson("/api/formulir/{$otherFormulir->id}")
        ->assertStatus(403);
});

test('admin cannot delete formulir through api endpoint', function () {
    $formulir = Formulir::factory()->create();

    loginAsAdmin()->deleteJson("/api/formulir/{$formulir->id}")
        ->assertStatus(403);
});

test('user can set default children for their formulir', function () {
    $user = User::factory()->create();
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->postJson("/api/formulir/{$formulir->id}/set-default-children");

    $response->assertStatus(200)
        ->assertJsonPath('message', 'Default children set successfully');

    $response->assertJsonCount(5, 'data.domains');
    expect($formulir->fresh()->domains()->count())->toBe(5);
});

test('opd can add custom domain with aspects to their formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->postJson("/api/formulir/{$formulir->id}/domains", [
        'nama_domain' => 'Domain Baru',
        'nama_aspek' => ['Aspek A', 'Aspek B'],
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('message', 'Domain berhasil ditambahkan')
        ->assertJsonPath('data.nama_domain', 'Domain Baru');

    $this->assertDatabaseHas('domains', [
        'nama_domain' => 'Domain Baru',
    ]);
    $this->assertDatabaseHas('aspeks', [
        'nama_aspek' => 'Aspek A',
    ]);
    $this->assertDatabaseHas('aspeks', [
        'nama_aspek' => 'Aspek B',
    ]);
});

test('opd cannot add the same custom domain twice to one formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $user->id]);
    $payload = [
        'nama_domain' => 'Domain Baru',
        'nama_aspek' => ['Aspek A', 'Aspek B'],
    ];

    loginAs($user)->postJson("/api/formulir/{$formulir->id}/domains", $payload)
        ->assertStatus(201);

    loginAs($user)->postJson("/api/formulir/{$formulir->id}/domains", $payload)
        ->assertStatus(422)
        ->assertJsonValidationErrors(['nama_domain']);

    $this->assertDatabaseCount('domains', 1);
    $this->assertDatabaseCount('formulir_domains', 1);
    $this->assertDatabaseCount('aspeks', 2);
});

test('formulir endpoints return 401 when unauthenticated', function () {
    $formulir = Formulir::factory()->create();

    $this->getJson('/api/formulir')->assertStatus(401);
    $this->postJson('/api/formulir', [])->assertStatus(401);
    $this->getJson("/api/formulir/{$formulir->id}")->assertStatus(401);
    $this->patchJson("/api/formulir/{$formulir->id}", [
        'nama_formulir' => 'Nama Baru',
    ])->assertStatus(401);
    $this->deleteJson("/api/formulir/{$formulir->id}")->assertStatus(401);
    $this->postJson("/api/formulir/{$formulir->id}/set-default-children")->assertStatus(401);
});

test('formulir store returns 422 when missing nama_formulir', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->postJson('/api/formulir', []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['nama_formulir']);
});

test('formulir show returns 404 when id does not exist', function () {
    $response = loginAsAdmin()->getJson('/api/formulir/999999');

    $response->assertStatus(404)
        ->assertJsonStructure(['message']);
});

test('formulir update returns 422 when nama_formulir is missing', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'created_by_id' => $user->id,
    ]);

    loginAs($user)->patchJson("/api/formulir/{$formulir->id}", [])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['nama_formulir']);
});
