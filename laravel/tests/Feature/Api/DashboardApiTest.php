<?php

use App\Models\Formulir;
use App\Models\Penilaian;
use App\Models\User;

test('admin can view global dashboard stats', function () {
    $user = User::factory()->create();

    $response = loginAsAdmin()->getJson('/api/dashboard/stats');

    $response->assertStatus(200)
        ->assertJsonStructure([
            'data' => [
                'stats' => [
                    'jumlahKegiatanPenilaian',
                    'jumlahPenilaianSelesai',
                    'jumlahPenilaianProgres',
                    'userTerdaftar'
                ],
                'progress_data'
            ]
        ]);
});

test('dashboard stats exclude template formulirs from aggregate counts', function () {
    Formulir::factory()->count(2)->create();
    Formulir::factory()->create([
        'kind' => Formulir::KIND_TEMPLATE,
        'nama_formulir' => 'Formulir Master Data',
    ]);

    $response = loginAsAdmin()->getJson('/api/dashboard/stats');

    $response->assertOk()
        ->assertJsonPath('data.stats.jumlahKegiatanPenilaian', 2);
});

test('opd can view their own dashboard stats', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->getJson('/api/dashboard/stats');

    $response->assertStatus(200)
        ->assertJsonStructure([
            'data' => [
                'stats',
                'progress_data'
            ]
        ]);
});

test('admin can view opd performance', function () {
    $response = loginAsAdmin()->getJson('/api/dashboard/performa-opd');

    $response->assertStatus(200);
    // Since it returns an array directly, we don't expect 'data' wrapper unless we change the controller
});

test('admin can view assessment progress', function () {
    $response = loginAsAdmin()->getJson('/api/dashboard/progress-penilaian');

    $response->assertStatus(200);
});
