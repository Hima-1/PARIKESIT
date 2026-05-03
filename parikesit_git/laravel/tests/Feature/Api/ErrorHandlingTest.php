<?php

test('it returns json for non-existent routes', function () {
    $response = $this->getJson('/api/non-existent-route');

    // Default Laravel biasanya mengembalikan 404 JSON jika Accept: application/json dikirim
    // Namun kita ingin memastikan formatnya konsisten dan prediktabel.
    $response->assertStatus(404)
             ->assertHeader('Content-Type', 'application/json');
});

test('it returns json for model not found exceptions', function () {
    // Mencoba dapet user yang tidak ada (misal ID 9999)
    $response = loginAsAdmin()->getJson('/api/users/9999');

    $response->assertStatus(404)
             ->assertJsonStructure(['message']);
});

test('it returns json for internal server errors', function () {
    config()->set('app.debug', false);

    $response = $this->getJson('/api/test-500');

    $response->assertStatus(500)
             ->assertJson(['message' => 'Internal Server Error']);
});

test('it returns json for unauthenticated requests', function () {
    $response = $this->getJson('/api/user');

    $response->assertStatus(401)
             ->assertJson(['message' => 'Unauthenticated']);
});
