<?php

use App\Models\DeviceToken;
use App\Models\User;

test('authenticated user can register fcm token', function () {
    $user = User::factory()->create(['role' => 'opd']);

    $response = loginAs($user)->postJson('/api/me/devices/fcm-token', [
        'token' => 'fcm-token-123',
        'platform' => 'android',
        'app_version' => '1.0.0',
        'device_name' => 'Pixel',
    ]);

    $response->assertStatus(200)
        ->assertJsonPath('data.token', 'fcm-token-123')
        ->assertJsonPath('data.platform', 'android');

    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $user->id,
        'token' => 'fcm-token-123',
        'platform' => 'android',
        'is_active' => true,
    ]);
});

test('registering the same fcm token updates the existing record', function () {
    $user = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $user->id,
        'token' => 'fcm-token-123',
        'platform' => 'android',
        'is_active' => false,
    ]);

    loginAs($user)->postJson('/api/me/devices/fcm-token', [
        'token' => 'fcm-token-123',
        'platform' => 'android',
    ])->assertOk();

    expect(DeviceToken::query()->where('token', 'fcm-token-123')->count())->toBe(1);
    expect(DeviceToken::query()->where('token', 'fcm-token-123')->first()?->is_active)->toBeTrue();
});

test('fcm token registration requires authentication', function () {
    $this->postJson('/api/me/devices/fcm-token', [
        'token' => 'fcm-token-123',
        'platform' => 'android',
    ])->assertStatus(401);
});

test('authenticated user can deactivate their fcm token', function () {
    $user = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $user->id,
        'token' => 'fcm-token-123',
        'platform' => 'android',
        'is_active' => true,
    ]);

    loginAs($user)->deleteJson('/api/me/devices/fcm-token', [
        'token' => 'fcm-token-123',
    ])->assertOk();

    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $user->id,
        'token' => 'fcm-token-123',
        'is_active' => false,
    ]);
});

test('fcm token registration validates required fields', function () {
    $user = User::factory()->create(['role' => 'opd']);

    loginAs($user)->postJson('/api/me/devices/fcm-token', [
        'token' => '',
        'platform' => '',
    ])->assertStatus(422)
        ->assertJsonValidationErrors(['token', 'platform']);
});

test('deactivating fcm token validates token field', function () {
    $user = User::factory()->create(['role' => 'opd']);

    loginAs($user)
        ->deleteJson('/api/me/devices/fcm-token', [])
        ->assertStatus(422)
        ->assertJsonValidationErrors(['token']);
});

test('deactivating a token only affects records owned by the authenticated user', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'opd']);

    DeviceToken::create([
        'user_id' => $user->id,
        'token' => 'fcm-token-123',
        'platform' => 'android',
        'is_active' => true,
    ]);
    DeviceToken::create([
        'user_id' => $otherUser->id,
        'token' => 'other-users-token',
        'platform' => 'ios',
        'is_active' => true,
    ]);

    loginAs($user)->deleteJson('/api/me/devices/fcm-token', [
        'token' => 'fcm-token-123',
    ])->assertOk();

    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $user->id,
        'token' => 'fcm-token-123',
        'is_active' => false,
    ]);
    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $otherUser->id,
        'token' => 'other-users-token',
        'is_active' => true,
    ]);
});

test('registering an existing token transfers ownership to the active user', function () {
    $originalOwner = User::factory()->create(['role' => 'opd']);
    $newOwner = User::factory()->create(['role' => 'opd']);

    DeviceToken::create([
        'user_id' => $originalOwner->id,
        'token' => 'shared-token',
        'platform' => 'android',
        'is_active' => false,
        'device_name' => 'Old device',
        'app_version' => '0.9.0',
    ]);

    loginAs($newOwner)->postJson('/api/me/devices/fcm-token', [
        'token' => 'shared-token',
        'platform' => 'ios',
        'app_version' => '2.0.0',
        'device_name' => 'New device',
    ])->assertOk()
        ->assertJsonPath('data.token', 'shared-token')
        ->assertJsonPath('data.platform', 'ios');

    $this->assertDatabaseHas('device_tokens', [
        'token' => 'shared-token',
        'user_id' => $newOwner->id,
        'platform' => 'ios',
        'device_name' => 'New device',
        'app_version' => '2.0.0',
        'is_active' => true,
    ]);
});
