<?php

use App\Models\DokumentasiKegiatan;
use App\Models\FileDokumentasi;
use App\Models\FilePembinaan;
use App\Models\Pembinaan;
use App\Models\User;
use Illuminate\Support\Facades\Storage;

test('admin sees both dokumentasi and pembinaan on the dashboard', function () {
    $admin = User::factory()->create(['role' => 'admin']);

    $response = $this->actingAs($admin)->get(route('dashboard'));

    $response->assertOk();
    $response->assertSeeText('Dokumentasi Kegiatan');
    $response->assertSeeText('Pembinaan');
});

test('non admin sees only dokumentasi kegiatan on the dashboard', function () {
    $opd = User::factory()->create(['role' => 'opd']);

    $response = $this->actingAs($opd)->get(route('dashboard'));

    $response->assertOk();
    $response->assertSeeText('Dokumentasi Kegiatan');
    $response->assertDontSeeText('Pembinaan');
});

test('admin can open pembinaan index while non admin cannot', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);

    $adminResponse = $this->actingAs($admin)->get(route('pembinaan.index'));
    $adminResponse->assertOk();
    $adminResponse->assertSeeText('Pembinaan');

    $this->actingAs($opd)
        ->get(route('pembinaan.index'))
        ->assertForbidden();

    $this->actingAs($walidata)
        ->get(route('pembinaan.index'))
        ->assertForbidden();
});

test('all authenticated roles can open dokumentasi index', function () {
    $roles = ['admin', 'opd', 'walidata'];

    foreach ($roles as $role) {
        $user = User::factory()->create(['role' => $role]);

        $response = $this->actingAs($user)->get(route('dokumentasi.index'));

        $response->assertOk();
        $response->assertSeeText('Dokumentasi Kegiatan');
        $response->assertSeeText('Tambah Dokumentasi Kegiatan');
    }
});

test('dokumentasi detail renders storage-backed file urls for modern uploads', function () {
    Storage::disk('public')->put('file-dokumentasi/modern-doc/undangan.pdf', 'modern-undangan');
    Storage::disk('public')->put('file-dokumentasi/modern-doc/hadir.pdf', 'modern-hadir');
    Storage::disk('public')->put('file-dokumentasi/modern-doc/materi.pdf', 'modern-materi');
    Storage::disk('public')->put('file-dokumentasi/modern-doc/notula.pdf', 'modern-notula');
    Storage::disk('public')->put('file-dokumentasi/modern-doc/media/photo.jpg', 'img');

    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'directory_dokumentasi' => 'modern-doc',
        'bukti_dukung_undangan_dokumentasi' => 'file-dokumentasi/modern-doc/undangan.pdf',
        'daftar_hadir_dokumentasi' => 'file-dokumentasi/modern-doc/hadir.pdf',
        'materi_dokumentasi' => 'file-dokumentasi/modern-doc/materi.pdf',
        'notula_dokumentasi' => 'file-dokumentasi/modern-doc/notula.pdf',
    ]);

    FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'nama_file' => 'file-dokumentasi/modern-doc/media/photo.jpg',
        'tipe_file' => 'jpg',
    ]);

    $response = $this->actingAs($dokumentasi->profile)->get(route('dokumentasi.show', $dokumentasi));

    $response->assertOk();
    $response->assertSee('/storage/file-dokumentasi/modern-doc/undangan.pdf', false);
    $response->assertSee('/storage/file-dokumentasi/modern-doc/media/photo.jpg', false);
    expect($dokumentasi->publicFilePath('bukti_dukung_undangan_dokumentasi'))->toBe(Storage::disk('public')->path('file-dokumentasi/modern-doc/undangan.pdf'));
});

test('dokumentasi detail keeps legacy public file urls working', function () {
    $legacyDirectory = public_path('legacy-dokumentasi');
    if (! is_dir($legacyDirectory)) {
        mkdir($legacyDirectory, 0777, true);
    }

    file_put_contents($legacyDirectory . DIRECTORY_SEPARATOR . 'undangan.pdf', 'legacy-undangan');
    file_put_contents($legacyDirectory . DIRECTORY_SEPARATOR . 'hadir.pdf', 'legacy-hadir');
    file_put_contents($legacyDirectory . DIRECTORY_SEPARATOR . 'materi.pdf', 'legacy-materi');
    file_put_contents($legacyDirectory . DIRECTORY_SEPARATOR . 'notula.pdf', 'legacy-notula');
    file_put_contents($legacyDirectory . DIRECTORY_SEPARATOR . 'photo.jpg', 'legacy-photo');

    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'bukti_dukung_undangan_dokumentasi' => 'legacy-dokumentasi/undangan.pdf',
        'daftar_hadir_dokumentasi' => 'legacy-dokumentasi/hadir.pdf',
        'materi_dokumentasi' => 'legacy-dokumentasi/materi.pdf',
        'notula_dokumentasi' => 'legacy-dokumentasi/notula.pdf',
    ]);

    FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'nama_file' => 'legacy-dokumentasi/photo.jpg',
        'tipe_file' => 'jpg',
    ]);

    $response = $this->actingAs($dokumentasi->profile)->get(route('dokumentasi.show', $dokumentasi));

    $response->assertOk();
    $response->assertSee(asset('legacy-dokumentasi/undangan.pdf'), false);
    $response->assertSee(asset('legacy-dokumentasi/photo.jpg'), false);
    expect($dokumentasi->publicFilePath('bukti_dukung_undangan_dokumentasi'))->toBe(public_path('legacy-dokumentasi/undangan.pdf'));
});

test('owner can edit update and destroy own dokumentasi via web', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $owner->id,
        'judul_dokumentasi' => 'Dok Awal',
    ]);

    $this->actingAs($owner)
        ->get(route('dokumentasi.edit', $dokumentasi))
        ->assertOk();

    $this->actingAs($owner)
        ->put(route('dokumentasi.update', $dokumentasi), [
            'judul_dokumentasi' => 'Dok Baru',
        ])
        ->assertRedirect(route('dokumentasi.show', $dokumentasi->id));

    $this->assertDatabaseHas('dokumentasi_kegiatans', [
        'id' => $dokumentasi->id,
        'created_by_id' => $owner->id,
        'judul_dokumentasi' => 'Dok Baru',
    ]);

    $this->actingAs($owner)
        ->delete(route('dokumentasi.destroy', $dokumentasi))
        ->assertRedirect(route('dokumentasi.index'));

    $this->assertDatabaseMissing('dokumentasi_kegiatans', ['id' => $dokumentasi->id]);
});

test('admin can edit update and destroy another user dokumentasi via web', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $admin = User::factory()->create(['role' => 'admin']);
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $owner->id,
        'judul_dokumentasi' => 'Dok Awal',
    ]);

    $this->actingAs($admin)
        ->get(route('dokumentasi.edit', $dokumentasi))
        ->assertOk();

    $this->actingAs($admin)
        ->put(route('dokumentasi.update', $dokumentasi), [
            'judul_dokumentasi' => 'Dok Admin',
        ])
        ->assertRedirect(route('dokumentasi.show', $dokumentasi->id));

    $this->assertDatabaseHas('dokumentasi_kegiatans', [
        'id' => $dokumentasi->id,
        'created_by_id' => $owner->id,
        'judul_dokumentasi' => 'Dok Admin',
    ]);

    $this->actingAs($admin)
        ->delete(route('dokumentasi.destroy', $dokumentasi))
        ->assertRedirect(route('dokumentasi.index'));

    $this->assertDatabaseMissing('dokumentasi_kegiatans', ['id' => $dokumentasi->id]);
});

test('non owner non admin gets forbidden for dokumentasi mutating web routes', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'walidata']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);

    $this->actingAs($otherUser)
        ->get(route('dokumentasi.edit', $dokumentasi))
        ->assertForbidden();

    $this->actingAs($otherUser)
        ->put(route('dokumentasi.update', $dokumentasi), [
            'judul_dokumentasi' => 'Tidak Boleh',
        ])
        ->assertForbidden();

    $this->actingAs($otherUser)
        ->delete(route('dokumentasi.destroy', $dokumentasi))
        ->assertForbidden();
});

test('owner can delete dokumentasi media via web delete route', function () {
    Storage::fake('public');

    $owner = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);
    $filePath = 'file-dokumentasi/media/owner-photo.jpg';
    Storage::disk('public')->put($filePath, 'img');

    $media = FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'nama_file' => $filePath,
        'tipe_file' => 'jpg',
    ]);

    $this->actingAs($owner)
        ->delete(route('fileDok.destroy', $media))
        ->assertRedirect();

    $this->assertDatabaseMissing('file_dokumentasis', ['id' => $media->id]);
    Storage::disk('public')->assertMissing($filePath);
});

test('admin can delete another user dokumentasi media via web delete route', function () {
    Storage::fake('public');

    $owner = User::factory()->create(['role' => 'opd']);
    $admin = User::factory()->create(['role' => 'admin']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);
    $filePath = 'file-dokumentasi/media/admin-photo.jpg';
    Storage::disk('public')->put($filePath, 'img');

    $media = FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'nama_file' => $filePath,
        'tipe_file' => 'jpg',
    ]);

    $this->actingAs($admin)
        ->delete(route('fileDok.destroy', $media))
        ->assertRedirect();

    $this->assertDatabaseMissing('file_dokumentasis', ['id' => $media->id]);
    Storage::disk('public')->assertMissing($filePath);
});

test('non owner non admin gets forbidden when deleting dokumentasi media via web', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'walidata']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);
    $media = FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
    ]);

    $this->actingAs($otherUser)
        ->delete(route('fileDok.destroy', $media))
        ->assertForbidden();
});

test('dokumentasi detail hides manage controls for non owner and shows them for owner admin', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'walidata']);
    $admin = User::factory()->create(['role' => 'admin']);
    $dokumentasi = DokumentasiKegiatan::factory()->create(['created_by_id' => $owner->id]);
    $media = FileDokumentasi::factory()->create([
        'dokumentasi_kegiatan_id' => $dokumentasi->id,
        'tipe_file' => 'jpg',
    ]);

    $this->actingAs($otherUser)
        ->get(route('dokumentasi.show', $dokumentasi))
        ->assertOk()
        ->assertDontSee(route('dokumentasi.edit', $dokumentasi), false)
        ->assertDontSee(route('fileDok.destroy', $media), false)
        ->assertDontSeeText('Hapus');

    $this->actingAs($owner)
        ->get(route('dokumentasi.show', $dokumentasi))
        ->assertOk()
        ->assertSee(route('dokumentasi.edit', $dokumentasi), false)
        ->assertSee(route('fileDok.destroy', $media), false)
        ->assertSeeText('Hapus');

    $this->actingAs($admin)
        ->get(route('dokumentasi.show', $dokumentasi))
        ->assertOk()
        ->assertSee(route('dokumentasi.edit', $dokumentasi), false)
        ->assertSee(route('fileDok.destroy', $media), false)
        ->assertSeeText('Hapus');
});

test('admin can delete another user pembinaan media via web delete route', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $admin = User::factory()->create(['role' => 'admin']);
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $owner->id]);
    $filePath = 'file-pembinaan/media/admin-photo.jpg';
    $absoluteFilePath = public_path($filePath);
    if (! is_dir(dirname($absoluteFilePath))) {
        mkdir(dirname($absoluteFilePath), 0777, true);
    }
    file_put_contents($absoluteFilePath, 'img');

    $media = FilePembinaan::factory()->create([
        'pembinaan_id' => $pembinaan->id,
        'nama_file' => $filePath,
        'tipe_file' => 'jpg',
    ]);

    $this->actingAs($admin)
        ->get(route('filePemb.destroy', $media))
        ->assertRedirect();

    $this->assertDatabaseMissing('file_pembinaans', ['id' => $media->id]);
    expect(file_exists($absoluteFilePath))->toBeFalse();
});

test('non owner non admin gets forbidden when deleting pembinaan media via web', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'walidata']);
    $pembinaan = Pembinaan::factory()->create(['created_by_id' => $owner->id]);
    $media = FilePembinaan::factory()->create([
        'pembinaan_id' => $pembinaan->id,
    ]);

    $this->actingAs($otherUser)
        ->get(route('filePemb.destroy', $media))
        ->assertForbidden();

    $this->assertDatabaseHas('file_pembinaans', ['id' => $media->id]);
});
