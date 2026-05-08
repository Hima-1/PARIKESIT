<?php

use App\Models\DeviceToken;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

test('user can login through api', function () {
    $password = 'password123';
    $user = User::factory()->create([
        'password' => Hash::make($password),
    ]);

    $response = $this->postJson('/api/login', [
        'email' => $user->email,
        'password' => $password,
    ]);

    $response->assertStatus(200)
        ->assertJsonStructure([
            'access_token',
            'token_type',
            'user' => [
                'id', 'name', 'email', 'role',
            ],
        ]);
});

test('user cannot login with wrong credentials', function () {
    $user = User::factory()->create();

    $response = $this->postJson('/api/login', [
        'email' => $user->email,
        'password' => 'wrong-password',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email']);
});

test('login returns 422 when missing required fields', function () {
    $response = $this->postJson('/api/login', []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email', 'password']);
});

test('authenticated user can logout', function () {
    $user = User::factory()->create();

    $response = loginAs($user)->postJson('/api/logout');

    $response->assertStatus(200)
        ->assertJson(['message' => 'Berhasil logout']);

    expect($user->tokens()->count())->toBe(0);
});

test('logout deactivates the current access token device record', function () {
    $user = User::factory()->create();
    $token = $user->createToken('mobile-token');

    DeviceToken::create([
        'user_id' => $user->id,
        'personal_access_token_id' => $token->accessToken->id,
        'token' => 'fcm-token-logout',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $this
        ->withHeader('Authorization', 'Bearer '.$token->plainTextToken)
        ->postJson('/api/logout')
        ->assertOk();

    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $user->id,
        'token' => 'fcm-token-logout',
        'is_active' => false,
    ]);
});

test('logout returns 401 when unauthenticated', function () {
    $response = $this->postJson('/api/logout');

    $response->assertStatus(401)
        ->assertJson(['message' => 'Unauthenticated']);
});

test('authenticated user can view their profile', function () {
    $user = User::factory()->create();

    $response = loginAs($user)->getJson('/api/profile');

    $response->assertStatus(200)
        ->assertJsonStructure([
            'data' => [
                'id', 'name', 'email', 'role', 'alamat', 'nomor_telepon',
            ],
        ])
        ->assertJsonPath('data.id', $user->id);
});

test('authenticated user can update their profile', function () {
    $user = User::factory()->create([
        'name' => 'Old Name',
        'email' => 'old@example.com',
    ]);

    $response = loginAs($user)->patchJson('/api/profile', [
        'name' => 'New Name',
        'email' => 'new@example.com',
    ]);

    $response->assertStatus(200);

    $user->refresh();
    expect($user->name)->toBe('New Name');
    expect($user->email)->toBe('new@example.com');
});

test('authenticated user can change password without storing plaintext copy', function () {
    $currentPassword = 'password123';
    $user = User::factory()->create([
        'password' => Hash::make($currentPassword),
    ]);

    $response = loginAs($user)->patchJson('/api/profile', [
        'name' => $user->name,
        'email' => $user->email,
        'current_password' => $currentPassword,
        'password' => 'new-password-123',
        'password_confirmation' => 'new-password-123',
    ]);

    $response->assertStatus(200);

    $user->refresh();
    expect(Hash::check('new-password-123', $user->password))->toBeTrue();
    expect(array_key_exists('plain_password', $user->getAttributes()))->toBeFalse();
});

test('update profile returns 422 when payload invalid', function () {
    $user = User::factory()->create();

    $response = loginAs($user)->patchJson('/api/profile', []);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['name', 'email']);
});

test('unauthenticated user cannot access profile', function () {
    $response = $this->getJson('/api/profile');

    $response->assertStatus(401);
});

test('authenticated user can get their basic info', function () {
    $user = User::factory()->create();

    $response = loginAs($user)->getJson('/api/user');

    $response->assertStatus(200)
        ->assertJsonPath('id', $user->id);
});
