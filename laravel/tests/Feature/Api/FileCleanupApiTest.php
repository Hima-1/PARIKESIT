<?php

use App\Models\FilePembinaan;
use App\Models\Pembinaan;
use App\Models\User;
use Illuminate\Support\Facades\Storage;

test('owner can delete media file', function () {
    Storage::fake('public');
    $user = User::factory()->create(['role' => 'opd']);
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $user->id]);

    $filePath = 'file-pembinaan/media/test.jpg';
    Storage::disk('public')->put($filePath, 'fake image content');

    $fileMedia = FilePembinaan::factory()->create([
        'pembinaan_id' => $pembinaan->id,
        'nama_file' => $filePath,
    ]);

    $response = loginAs($user)->deleteJson("/api/file-pembinaan/{$fileMedia->id}");

    $response->assertStatus(200);
    $this->assertDatabaseMissing('file_pembinaans', ['id' => $fileMedia->id]);
    Storage::disk('public')->assertMissing($filePath);
});

test('admin can delete pembinaan media file', function () {
    Storage::fake('public');
    $admin = User::factory()->create(['role' => 'admin']);
    $owner = User::factory()->create(['role' => 'opd']);
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $owner->id]);
    $filePath = 'file-pembinaan/media/admin-delete.jpg';
    Storage::disk('public')->put($filePath, 'fake image content');

    $fileMedia = FilePembinaan::factory()->create([
        'pembinaan_id' => $pembinaan->id,
        'nama_file' => $filePath,
    ]);

    $response = loginAs($admin)->deleteJson("/api/file-pembinaan/{$fileMedia->id}");

    $response->assertStatus(200)
        ->assertJson(['message' => 'File berhasil dihapus']);
    $this->assertDatabaseMissing('file_pembinaans', ['id' => $fileMedia->id]);
    Storage::disk('public')->assertMissing($filePath);
});

test('user cannot delete other user media file', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherFileMedia = FilePembinaan::factory()->create(); // different owner

    $response = loginAs($user)->deleteJson("/api/file-pembinaan/{$otherFileMedia->id}");

    $response->assertStatus(403);
});

test('owner can delete dokumentasi media file', function () {
    Storage::fake('public');
    $user = User::factory()->create(['role' => 'opd']);
    $dokumentasi = \App\Models\DokumentasiKegiatan::factory()->create(['created_by_id' => $user->id]);

    $filePath = 'file-dokumentasi/media/test-dok.jpg';
    Storage::disk('public')->put($filePath, 'fake image content');

    $fileMedia = \App\Models\FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'nama_file' => $filePath,
    ]);

    $response = loginAs($user)->deleteJson("/api/file-dokumentasi/{$fileMedia->id}");

    $response->assertStatus(200);
    $this->assertDatabaseMissing('file_dokumentasis', ['id' => $fileMedia->id]);
    Storage::disk('public')->assertMissing($filePath);
});

test('admin can delete dokumentasi media file', function () {
    Storage::fake('public');
    $admin = User::factory()->create(['role' => 'admin']);
    $owner = User::factory()->create(['role' => 'opd']);
    $dokumentasi = \App\Models\DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);

    $filePath = 'file-dokumentasi/media/admin-delete.jpg';
    Storage::disk('public')->put($filePath, 'fake image content');

    $fileMedia = \App\Models\FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'nama_file' => $filePath,
    ]);

    $response = loginAs($admin)->deleteJson("/api/file-dokumentasi/{$fileMedia->id}");

    $response->assertStatus(200)
        ->assertJson(['message' => 'File berhasil dihapus']);
    $this->assertDatabaseMissing('file_dokumentasis', ['id' => $fileMedia->id]);
    Storage::disk('public')->assertMissing($filePath);
});
