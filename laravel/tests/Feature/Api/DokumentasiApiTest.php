<?php

use App\Models\DokumentasiKegiatan;
use App\Models\FileDokumentasi;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

test('user can list dokumentasi', function () {
    DokumentasiKegiatan::factory()->count(3)->create();
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->getJson('/api/dokumentasi');

    $response->assertStatus(200);
});

test('admin opd and walidata can list dokumentasi', function () {
    DokumentasiKegiatan::factory()->count(3)->create();

    foreach (['admin', 'opd', 'walidata'] as $role) {
        $user = User::factory()->create(['role' => $role]);

        $this->actingAs($user, 'sanctum')
            ->getJson('/api/dokumentasi')
            ->assertOk();
    }
});

test('dokumentasi list does not include media relation payload', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create();
    FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
    ]);

    $response = loginAs($user)->getJson('/api/dokumentasi');

    $response->assertStatus(200)
        ->assertJsonMissingPath('data.0.file_dokumentasi');
});

test('dokumentasi index returns 401 when unauthenticated', function () {
    $response = $this->getJson('/api/dokumentasi');

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('user can show dokumentasi detail', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->getJson("/api/dokumentasi/{$dokumentasi->id}");

    $response->assertStatus(200)
        ->assertJsonPath('id', $dokumentasi->id);
});

test('admin opd and walidata can show dokumentasi detail', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);

    foreach (['admin', 'opd', 'walidata'] as $role) {
        $user = User::factory()->create(['role' => $role]);

        $this->actingAs($user, 'sanctum')
            ->getJson("/api/dokumentasi/{$dokumentasi->id}")
            ->assertOk()
            ->assertJsonPath('id', $dokumentasi->id);
    }
});

test('dokumentasi detail still includes media relation payload', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);
    $file = FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
    ]);

    $response = loginAs($user)->getJson("/api/dokumentasi/{$dokumentasi->id}");

    $response->assertStatus(200)
        ->assertJsonPath('file_dokumentasi.0.id', $file->id);
});

test('dokumentasi responses include creator name', function () {
    $user = User::factory()->create([
        'name' => 'Budi Dokumentasi',
        'role' => 'opd',
    ]);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);

    $listResponse = loginAs($user)->getJson('/api/dokumentasi');
    $detailResponse = loginAs($user)->getJson("/api/dokumentasi/{$dokumentasi->id}");

    $listResponse->assertStatus(200)
        ->assertJsonPath('data.0.creator_name', 'Budi Dokumentasi');

    $detailResponse->assertStatus(200)
        ->assertJsonPath('creator_name', 'Budi Dokumentasi');
});

test('dokumentasi show returns 401 when unauthenticated', function () {
    $dokumentasi = DokumentasiKegiatan::factory()->create();

    $response = $this->getJson("/api/dokumentasi/{$dokumentasi->id}");

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('show dokumentasi returns 404 when id does not exist', function () {
    $response = loginAs(User::factory()->create(['role' => 'opd']))
        ->getJson('/api/dokumentasi/999999');

    $response->assertStatus(404)
        ->assertJsonStructure(['message']);
});

test('user can create dokumentasi with files', function () {
    Storage::fake('public');

    $user = User::factory()->create();

    $response = loginAs($user)->postJson('/api/dokumentasi', [
        'judul_dokumentasi' => 'Test Dokumentasi',
        'bukti_dukung_undangan' => UploadedFile::fake()->create('undangan.pdf', 100),
        'daftar_hadir' => UploadedFile::fake()->create('hadir.pdf', 100),
        'materi' => UploadedFile::fake()->create('materi.pdf', 100),
        'notula' => UploadedFile::fake()->create('notula.pdf', 100),
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('data.judul_dokumentasi', 'Test Dokumentasi');

    $this->assertDatabaseHas('dokumentasi_kegiatans', ['judul_dokumentasi' => 'Test Dokumentasi']);
});

test('dokumentasi created with the same title gets unique directories and file paths', function () {
    Storage::fake('public');

    $user = User::factory()->create();

    $payload = fn () => [
        'judul_dokumentasi' => 'Judul Sama',
        'bukti_dukung_undangan' => UploadedFile::fake()->create('undangan.pdf', 100),
        'daftar_hadir' => UploadedFile::fake()->create('hadir.pdf', 100),
        'materi' => UploadedFile::fake()->create('materi.pdf', 100),
        'notula' => UploadedFile::fake()->create('notula.pdf', 100),
    ];

    $first = loginAs($user)->postJson('/api/dokumentasi', $payload())->assertCreated();
    $second = loginAs($user)->postJson('/api/dokumentasi', $payload())->assertCreated();

    expect($first->json('data.directory_dokumentasi'))
        ->not->toBe($second->json('data.directory_dokumentasi'));
    expect($first->json('data.bukti_dukung_undangan_dokumentasi'))
        ->not->toBe($second->json('data.bukti_dukung_undangan_dokumentasi'));
});

test('dokumentasi store returns 422 when missing required files', function () {
    $user = User::factory()->create();

    $response = loginAs($user)->postJson('/api/dokumentasi', [
        'judul_dokumentasi' => 'Test Dokumentasi',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors([
            'bukti_dukung_undangan',
            'daftar_hadir',
            'materi',
            'notula',
        ]);
});

test('user can download dokumentasi zip', function () {
    Storage::fake('public');
    $user = User::factory()->create(['role' => 'opd']);

    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);
    Storage::disk('public')->put($dokumentasi->bukti_dukung_undangan_dokumentasi, 'fake content');

    $response = loginAs($user)->getJson("/api/dokumentasi/{$dokumentasi->id}/download");

    $response->assertStatus(200);
    $response->assertHeader('content-type', 'application/zip');
});

test('admin opd and walidata can download dokumentasi zip', function () {
    Storage::fake('public');

    $owner = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);
    Storage::disk('public')->put($dokumentasi->bukti_dukung_undangan_dokumentasi, 'fake content');

    foreach (['admin', 'opd', 'walidata'] as $role) {
        $user = User::factory()->create(['role' => $role]);

        $this->actingAs($user, 'sanctum')
            ->getJson("/api/dokumentasi/{$dokumentasi->id}/download")
            ->assertOk()
            ->assertHeader('content-type', 'application/zip');
    }
});

test('dokumentasi download zip filenames are unique when requested repeatedly', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $user->id,
        'judul_dokumentasi' => 'Zip Sama',
    ]);

    $first = loginAs($user)->get("/api/dokumentasi/{$dokumentasi->id}/download")->assertOk();
    $second = loginAs($user)->get("/api/dokumentasi/{$dokumentasi->id}/download")->assertOk();

    expect($first->headers->get('content-disposition'))
        ->not->toBe($second->headers->get('content-disposition'));
});

test('dokumentasi download still returns zip when files are missing', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->get("/api/dokumentasi/{$dokumentasi->id}/download");

    $response->assertStatus(200);
    $response->assertHeader('content-type', 'application/zip');
});

test('user can batch download dokumentasi', function () {
    Storage::fake('public');
    $user = User::factory()->create(['role' => 'opd']);
    $d1 = DokumentasiKegiatan::factory()->create();
    $d2 = DokumentasiKegiatan::factory()->create();

    $response = loginAs($user)->getJson("/api/dokumentasi/download-batch?ids[]={$d1->id}&ids[]={$d2->id}");

    $response->assertStatus(200);
    $response->assertHeader('content-type', 'application/zip');
});

test('admin opd and walidata can batch download dokumentasi', function () {
    Storage::fake('public');

    $d1 = DokumentasiKegiatan::factory()->create();
    $d2 = DokumentasiKegiatan::factory()->create();

    foreach (['admin', 'opd', 'walidata'] as $role) {
        $user = User::factory()->create(['role' => $role]);

        $this->actingAs($user, 'sanctum')
            ->getJson("/api/dokumentasi/download-batch?ids[]={$d1->id}&ids[]={$d2->id}")
            ->assertOk()
            ->assertHeader('content-type', 'application/zip');
    }
});

test('dokumentasi batch download returns 400 when ids empty', function () {
    $response = loginAs(User::factory()->create(['role' => 'opd']))
        ->getJson('/api/dokumentasi/download-batch');

    $response->assertStatus(400)
        ->assertJsonPath('message', 'ID dokumentasi tidak boleh kosong');
});

test('admin can delete any dokumentasi', function () {
    $dokumentasi = DokumentasiKegiatan::factory()->create();

    $response = loginAsAdmin()->deleteJson("/api/dokumentasi/{$dokumentasi->id}");

    $response->assertStatus(200);
    $this->assertDatabaseMissing('dokumentasi_kegiatans', ['id' => $dokumentasi->id]);
});

test('dokumentasi destroy returns 401 when unauthenticated', function () {
    $dokumentasi = DokumentasiKegiatan::factory()->create();

    $response = $this->deleteJson("/api/dokumentasi/{$dokumentasi->id}");

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('user can update own dokumentasi title', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $user->id,
        'judul_dokumentasi' => 'Old Title',
    ]);

    $response = loginAs($user)->patchJson("/api/dokumentasi/{$dokumentasi->id}", [
        'judul_dokumentasi' => 'New Title',
    ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.judul_dokumentasi', 'New Title');

    $this->assertDatabaseHas('dokumentasi_kegiatans', ['id' => $dokumentasi->id, 'judul_dokumentasi' => 'New Title']);
});

test('dokumentasi main file update stores new file before deleting old file', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $user->id,
        'bukti_dukung_undangan_dokumentasi' => 'file-dokumentasi/existing/undangan-old.pdf',
    ]);
    Storage::disk('public')->put($dokumentasi->bukti_dukung_undangan_dokumentasi, 'old content');

    $response = loginAs($user)->post("/api/dokumentasi/{$dokumentasi->id}", [
        '_method' => 'PATCH',
        'judul_dokumentasi' => $dokumentasi->judul_dokumentasi,
        'bukti_dukung_undangan' => UploadedFile::fake()->create('undangan.pdf', 100),
    ])->assertOk();

    $newPath = $response->json('data.bukti_dukung_undangan_dokumentasi');

    expect($newPath)->not->toBe('file-dokumentasi/existing/undangan-old.pdf');
    Storage::disk('public')->assertMissing('file-dokumentasi/existing/undangan-old.pdf');
    Storage::disk('public')->assertExists($newPath);
});

test('user can update own dokumentasi with a single media file', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $user->id,
    ]);

    $response = loginAs($user)->post("/api/dokumentasi/{$dokumentasi->id}", [
        '_method' => 'PATCH',
        'judul_dokumentasi' => $dokumentasi->judul_dokumentasi,
        'files' => UploadedFile::fake()->image('media.jpg'),
    ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.id', $dokumentasi->id);

    $this->assertDatabaseHas('file_dokumentasis', [
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
    ]);
});

test('dokumentasi media uploads use unique paths for files with the same original name', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $user->id,
    ]);

    loginAs($user)->post("/api/dokumentasi/{$dokumentasi->id}", [
        '_method' => 'PATCH',
        'judul_dokumentasi' => $dokumentasi->judul_dokumentasi,
        'files' => [
            UploadedFile::fake()->image('media.jpg'),
            UploadedFile::fake()->image('media.jpg'),
        ],
    ])->assertOk();

    $paths = FileDokumentasi::query()
        ->where('dokumentasi_kegiatan_id', $dokumentasi->id)
        ->pluck('nama_file')
        ->all();

    expect($paths)->toHaveCount(2);
    expect(array_unique($paths))->toHaveCount(2);
});

test('dokumentasi update returns 401 when unauthenticated', function () {
    $dokumentasi = DokumentasiKegiatan::factory()->create();

    $response = $this->patchJson("/api/dokumentasi/{$dokumentasi->id}", [
        'judul_dokumentasi' => 'New Title',
    ]);

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('update dokumentasi returns 422 when missing required fields', function () {
    $user = User::factory()->create();
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->patchJson("/api/dokumentasi/{$dokumentasi->id}", []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['judul_dokumentasi']);
});

test('user cannot update other user dokumentasi', function () {
    $user = User::factory()->create();
    $otherDokumentasi = DokumentasiKegiatan::factory()->create();

    $response = loginAs($user)->patchJson("/api/dokumentasi/{$otherDokumentasi->id}", [
        'judul_dokumentasi' => 'Malicious Update',
    ]);

    $response->assertStatus(403);
});
