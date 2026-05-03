<?php

use App\Models\DokumentasiKegiatan;
use App\Models\User;

test('unknown role cannot list dokumentasi api records', function () {
    loginAs(User::factory()->create(['role' => 'operator']))
        ->getJson('/api/dokumentasi')
        ->assertStatus(403);
});

test('opd owner can view dokumentasi api detail', function () {
    $owner = User::factory()->create(['role' => 'opd']);
    $dokumentasi = DokumentasiKegiatan::factory()->create([
        'created_by_id' => $owner->id,
    ]);

    loginAs($owner)
        ->getJson("/api/dokumentasi/{$dokumentasi->id}")
        ->assertOk()
        ->assertJsonPath('id', $dokumentasi->id);
});

test('unknown role cannot download dokumentasi api batch', function () {
    loginAs(User::factory()->create(['role' => 'operator']))
        ->getJson('/api/dokumentasi/download-batch?ids[]=1')
        ->assertStatus(403);
});
