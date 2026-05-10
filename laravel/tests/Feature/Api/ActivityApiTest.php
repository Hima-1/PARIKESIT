<?php

use App\Models\FilePembinaan;
use App\Models\Pembinaan;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

test('admin can list pembinaan', function () {
    Pembinaan::factory()->count(3)->create();

    $response = loginAsAdmin()->getJson('/api/pembinaan');

    $response->assertStatus(200);
});

test('pembinaan list does not include media relation payload', function () {
    $pembinaan = Pembinaan::factory()->create();
    FilePembinaan::factory()->create([
        'pembinaan_id' => $pembinaan->id,
    ]);

    $response = loginAsAdmin()->getJson('/api/pembinaan');

    $response->assertStatus(200)
        ->assertJsonMissingPath('data.0.file_pembinaan');
});

test('non-admin cannot list pembinaan', function () {
    Pembinaan::factory()->count(2)->create();

    $response = loginAs()->getJson('/api/pembinaan');

    $response->assertStatus(403)
        ->assertJson(['message' => 'Unauthorized']);
});

test('pembinaan index returns 401 when unauthenticated', function () {
    $response = $this->getJson('/api/pembinaan');

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('admin can show pembinaan detail', function () {
    $user = User::factory()->create();
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAsAdmin()->getJson("/api/pembinaan/{$pembinaan->id}");

    $response->assertStatus(200)
        ->assertJsonPath('id', $pembinaan->id);
});

test('pembinaan detail still includes media relation payload', function () {
    $user = User::factory()->create();
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);
    $file = FilePembinaan::factory()->create([
        'pembinaan_id' => $pembinaan->id,
    ]);

    $response = loginAsAdmin()->getJson("/api/pembinaan/{$pembinaan->id}");

    $response->assertStatus(200)
        ->assertJsonPath('file_pembinaan.0.id', $file->id);
});

test('pembinaan responses include creator name', function () {
    $user = User::factory()->create(['name' => 'Sari Pembinaan']);
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $listResponse = loginAsAdmin()->getJson('/api/pembinaan');
    $detailResponse = loginAsAdmin()->getJson("/api/pembinaan/{$pembinaan->id}");

    $listResponse->assertStatus(200)
        ->assertJsonPath('data.0.creator_name', 'Sari Pembinaan');

    $detailResponse->assertStatus(200)
        ->assertJsonPath('creator_name', 'Sari Pembinaan');
});

test('pembinaan show returns 401 when unauthenticated', function () {
    $pembinaan = Pembinaan::factory()->create();

    $response = $this->getJson("/api/pembinaan/{$pembinaan->id}");

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('non-admin cannot show pembinaan detail', function () {
    $user = User::factory()->create();
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->getJson("/api/pembinaan/{$pembinaan->id}");

    $response->assertStatus(403)
        ->assertJson(['message' => 'Unauthorized']);
});

test('show pembinaan returns 404 when id does not exist', function () {
    $response = loginAs()->getJson('/api/pembinaan/999999');

    $response->assertStatus(404)
        ->assertJsonStructure(['message']);
});

test('admin can create pembinaan with files', function () {
    Storage::fake('public');

    $response = loginAsAdmin()->postJson('/api/pembinaan', [
        'judul_pembinaan' => 'Test Pembinaan',
        'bukti_dukung_undangan' => UploadedFile::fake()->create('undangan.pdf', 100),
        'daftar_hadir' => UploadedFile::fake()->create('hadir.pdf', 100),
        'materi' => UploadedFile::fake()->create('materi.pdf', 100),
        'notula' => UploadedFile::fake()->create('notula.pdf', 100),
    ]);

    $response->assertStatus(201)
        ->assertJsonPath('data.judul_pembinaan', 'Test Pembinaan');

    $this->assertDatabaseHas('pembinaans', ['judul_pembinaan' => 'Test Pembinaan']);
});

test('pembinaan created with the same title gets unique directories and file paths', function () {
    Storage::fake('public');

    $admin = User::factory()->create(['role' => 'admin']);

    $payload = fn () => [
        'judul_pembinaan' => 'Judul Sama',
        'bukti_dukung_undangan' => UploadedFile::fake()->create('undangan.pdf', 100),
        'daftar_hadir' => UploadedFile::fake()->create('hadir.pdf', 100),
        'materi' => UploadedFile::fake()->create('materi.pdf', 100),
        'notula' => UploadedFile::fake()->create('notula.pdf', 100),
    ];

    $first = loginAsAdmin($admin)->postJson('/api/pembinaan', $payload())->assertCreated();
    $second = loginAsAdmin($admin)->postJson('/api/pembinaan', $payload())->assertCreated();

    expect($first->json('data.directory_pembinaan'))
        ->not->toBe($second->json('data.directory_pembinaan'));
    expect($first->json('data.bukti_dukung_undangan_pembinaan'))
        ->not->toBe($second->json('data.bukti_dukung_undangan_pembinaan'));
});

test('pembinaan store returns 422 when missing required files', function () {
    $response = loginAsAdmin()->postJson('/api/pembinaan', [
        'judul_pembinaan' => 'Test Pembinaan',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors([
            'bukti_dukung_undangan',
            'daftar_hadir',
            'materi',
            'notula',
        ]);
});

test('admin can download pembinaan zip', function () {
    Storage::fake('public');
    $user = User::factory()->create();

    // Create a pembinaan with a real file in fake storage
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);
    Storage::disk('public')->put($pembinaan->bukti_dukung_undangan_pembinaan, 'fake content');

    $response = loginAsAdmin()->getJson("/api/pembinaan/{$pembinaan->id}/download");

    $response->assertStatus(200);
    $response->assertHeader('content-type', 'application/zip');
});

test('pembinaan download still returns zip when files are missing', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAsAdmin()->get("/api/pembinaan/{$pembinaan->id}/download");

    $response->assertStatus(200);
    $response->assertHeader('content-type', 'application/zip');
});

test('admin can batch download pembinaan', function () {
    Storage::fake('public');
    $p1 = Pembinaan::factory()->create();
    $p2 = Pembinaan::factory()->create();

    $response = loginAsAdmin()->getJson("/api/pembinaan/download-batch?ids[]={$p1->id}&ids[]={$p2->id}");

    $response->assertStatus(200);
    $response->assertHeader('content-type', 'application/zip');
});

test('pembinaan batch download zip filenames are unique when requested repeatedly', function () {
    Storage::fake('public');

    $pembinaan = Pembinaan::factory()->create(['judul_pembinaan' => 'Zip Sama']);

    $first = loginAsAdmin()->get("/api/pembinaan/download-batch?ids[]={$pembinaan->id}")->assertOk();
    $second = loginAsAdmin()->get("/api/pembinaan/download-batch?ids[]={$pembinaan->id}")->assertOk();

    expect($first->headers->get('content-disposition'))
        ->not->toBe($second->headers->get('content-disposition'));
});

test('pembinaan batch download returns 400 when ids empty', function () {
    $response = loginAsAdmin()->getJson('/api/pembinaan/download-batch');

    $response->assertStatus(400)
        ->assertJsonPath('message', 'ID pembinaan tidak boleh kosong');
});

test('non-admin cannot download pembinaan zip', function () {
    Storage::fake('public');

    $user = User::factory()->create();
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAs($user)->getJson("/api/pembinaan/{$pembinaan->id}/download");

    $response->assertStatus(403)
        ->assertJson(['message' => 'Unauthorized']);
});

test('non-admin cannot batch download pembinaan', function () {
    Storage::fake('public');
    $p1 = Pembinaan::factory()->create();
    $p2 = Pembinaan::factory()->create();

    $response = loginAs()->getJson("/api/pembinaan/download-batch?ids[]={$p1->id}&ids[]={$p2->id}");

    $response->assertStatus(403)
        ->assertJson(['message' => 'Unauthorized']);
});

test('user cannot update other user pembinaan', function () {
    $user = User::factory()->create();
    $otherPembinaan = Pembinaan::factory()->create();

    $response = loginAs($user)->patchJson("/api/pembinaan/{$otherPembinaan->id}", [
        'judul_pembinaan' => 'Malicious Update',
    ]);

    $response->assertStatus(403);
});

test('admin can update pembinaan title', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'admin']);
    $pembinaan = Pembinaan::factory()->create([
        'created_by_id' => $user->id,
        'judul_pembinaan' => 'Old Title',
    ]);

    $response = loginAsAdmin($user)->patchJson("/api/pembinaan/{$pembinaan->id}", [
        'judul_pembinaan' => 'New Title',
    ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.judul_pembinaan', 'New Title');

    $this->assertDatabaseHas('pembinaans', ['id' => $pembinaan->id, 'judul_pembinaan' => 'New Title']);
});

test('pembinaan main file update replaces old file after new file is stored', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'admin']);
    $pembinaan = Pembinaan::factory()->create([
        'created_by_id' => $user->id,
        'bukti_dukung_undangan_pembinaan' => 'file-pembinaan/existing/undangan-old.pdf',
    ]);
    Storage::disk('public')->put($pembinaan->bukti_dukung_undangan_pembinaan, 'old content');

    $response = loginAsAdmin($user)->post("/api/pembinaan/{$pembinaan->id}", [
        '_method' => 'PATCH',
        'judul_pembinaan' => $pembinaan->judul_pembinaan,
        'bukti_dukung_undangan' => UploadedFile::fake()->create('undangan.pdf', 100),
    ])->assertOk();

    $newPath = $response->json('data.bukti_dukung_undangan_pembinaan');

    expect($newPath)->not->toBe('file-pembinaan/existing/undangan-old.pdf');
    Storage::disk('public')->assertMissing('file-pembinaan/existing/undangan-old.pdf');
    Storage::disk('public')->assertExists($newPath);
});

test('admin can update pembinaan with a single media file', function () {
    Storage::fake('public');

    $user = User::factory()->create(['role' => 'admin']);
    $pembinaan = Pembinaan::factory()->create([
        'created_by_id' => $user->id,
    ]);

    $response = loginAsAdmin($user)->post("/api/pembinaan/{$pembinaan->id}", [
        '_method' => 'PATCH',
        'judul_pembinaan' => $pembinaan->judul_pembinaan,
        'files' => UploadedFile::fake()->image('media.jpg'),
    ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.id', $pembinaan->id);

    $this->assertDatabaseHas('file_pembinaans', [
        'pembinaan_id' => $pembinaan->id,
    ]);
});

test('pembinaan update returns 401 when unauthenticated', function () {
    $pembinaan = Pembinaan::factory()->create();

    $response = $this->patchJson("/api/pembinaan/{$pembinaan->id}", [
        'judul_pembinaan' => 'New Title',
    ]);

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('update pembinaan returns 422 when missing required fields', function () {
    $user = User::factory()->create(['role' => 'admin']);
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $response = loginAsAdmin($user)->patchJson("/api/pembinaan/{$pembinaan->id}", []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['judul_pembinaan']);
});

test('admin can delete any pembinaan', function () {
    $otherPembinaan = Pembinaan::factory()->create();

    $response = loginAsAdmin()->deleteJson("/api/pembinaan/{$otherPembinaan->id}");

    $response->assertStatus(200);
    $this->assertDatabaseMissing('pembinaans', ['id' => $otherPembinaan->id]);
});

test('pembinaan destroy returns 401 when unauthenticated', function () {
    $pembinaan = Pembinaan::factory()->create();

    $response = $this->deleteJson("/api/pembinaan/{$pembinaan->id}");

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});
