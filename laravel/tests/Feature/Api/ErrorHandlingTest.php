<?php

use App\Models\User;

test('it returns json for non-existent routes', function () {
    $response = $this->getJson('/api/non-existent-route');

    // Default Laravel biasanya mengembalikan 404 JSON jika Accept: application/json dikirim
    // Namun kita ingin memastikan formatnya konsisten dan prediktabel.
    $response->assertStatus(404)
        ->assertHeader('Content-Type', 'application/json')
        ->assertJson(['message' => 'Data yang diminta tidak ditemukan.']);
});

test('it returns json for model not found exceptions', function () {
    // Mencoba dapet user yang tidak ada (misal ID 9999)
    $response = loginAsAdmin()->getJson('/api/users/9999');

    $response->assertStatus(404)
        ->assertJson(['message' => 'Data yang diminta tidak ditemukan.']);
});

test('it returns json for internal server errors', function () {
    config()->set('app.debug', false);

    $response = $this->getJson('/api/test-500');

    $response->assertStatus(500)
        ->assertJson([
            'message' => 'Server sedang mengalami gangguan. Silakan coba lagi nanti.',
        ])
        ->assertJsonMissing(['message' => 'Test 500 error'])
        ->assertJsonMissingPath('exception');
});

test('it returns json for unauthenticated requests', function () {
    $response = $this->getJson('/api/user');

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('it returns friendly json for unauthorized requests', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->getJson('/api/users');

    $response->assertStatus(403)
        ->assertJson([
            'message' => 'Anda tidak memiliki akses untuk melakukan aksi ini.',
        ]);
});
