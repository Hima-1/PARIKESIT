<?php

use App\Models\InboxNotification;
use App\Models\User;
use Carbon\Carbon;

test('authenticated user can list their notifications', function () {
    $user = User::factory()->create(['role' => 'opd']);
    InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Reminder',
        'body' => 'Segera lengkapi formulir.',
        'type' => 'incomplete_form_reminder',
        'data' => [
            'type' => 'incomplete_form_reminder',
            'formulir_id' => '12',
            'target_route' => '/penilaian-kegiatan?formulirId=12',
        ],
    ]);

    $response = loginAs($user)->getJson('/api/notifications');

    $response->assertOk()
        ->assertJsonPath('meta.current_page', 1)
        ->assertJsonPath('meta.per_page', 10)
        ->assertJsonPath('data.0.title', 'Reminder')
        ->assertJsonPath('data.0.type', 'incomplete_form_reminder')
        ->assertJsonPath('data.0.data.formulir_id', '12')
        ->assertJsonPath('data.0.is_read', false);
});

test('notification list only includes the authenticated user records ordered by latest first', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'opd']);

    $older = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Older reminder',
        'body' => 'Older body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '10'],
    ]);
    $older->forceFill([
        'created_at' => Carbon::parse('2026-03-20 08:00:00'),
        'updated_at' => Carbon::parse('2026-03-20 08:00:00'),
    ])->saveQuietly();

    $newer = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Newest reminder',
        'body' => 'Newest body',
        'type' => 'incomplete_form_summary',
        'data' => ['formulir_id' => '11'],
    ]);
    $newer->forceFill([
        'created_at' => Carbon::parse('2026-03-21 08:00:00'),
        'updated_at' => Carbon::parse('2026-03-21 08:00:00'),
    ])->saveQuietly();
    InboxNotification::create([
        'user_id' => $otherUser->id,
        'title' => 'Other user reminder',
        'body' => 'Should not appear',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '99'],
    ]);
    InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Hidden reminder',
        'body' => 'Should not appear',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
        'hidden_at' => Carbon::parse('2026-03-22 08:00:00'),
    ]);

    $response = loginAs($user)->getJson('/api/notifications?page=1&per_page=1');

    $response->assertOk()
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('meta.current_page', 1)
        ->assertJsonPath('meta.last_page', 2)
        ->assertJsonPath('meta.per_page', 1)
        ->assertJsonPath('meta.total', 2)
        ->assertJsonPath('data.0.id', (string) $newer->id)
        ->assertJsonMissing(['id' => (string) $older->id]);

    loginAs($user)
        ->getJson('/api/notifications?page=2&per_page=1')
        ->assertOk()
        ->assertJsonPath('data.0.id', (string) $older->id);
});

test('authenticated user can mark a notification as read', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $notification = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Reminder',
        'body' => 'Segera lengkapi formulir.',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
    ]);

    loginAs($user)
        ->patchJson("/api/notifications/{$notification->id}/read")
        ->assertOk()
        ->assertJsonPath('data.is_read', true);

    $this->assertDatabaseHas('inbox_notifications', [
        'id' => $notification->id,
        'is_read' => true,
    ]);
});

test('marking notification as read returns 404 for another users notification', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'opd']);
    $notification = InboxNotification::create([
        'user_id' => $otherUser->id,
        'title' => 'Other reminder',
        'body' => 'Private reminder',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
    ]);

    loginAs($user)
        ->patchJson("/api/notifications/{$notification->id}/read")
        ->assertNotFound();

    $this->assertDatabaseHas('inbox_notifications', [
        'id' => $notification->id,
        'is_read' => false,
        'read_at' => null,
    ]);
});

test('marking a hidden notification as read returns 404', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $notification = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Hidden reminder',
        'body' => 'Hidden body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
        'hidden_at' => Carbon::parse('2026-03-21 09:30:00'),
    ]);

    loginAs($user)
        ->patchJson("/api/notifications/{$notification->id}/read")
        ->assertNotFound();
});

test('marking an already read notification is idempotent', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $readAt = Carbon::parse('2026-03-21 09:30:00');
    $notification = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Read reminder',
        'body' => 'Already read',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
        'is_read' => true,
        'read_at' => $readAt,
    ]);

    loginAs($user)
        ->patchJson("/api/notifications/{$notification->id}/read")
        ->assertOk()
        ->assertJsonPath('data.is_read', true);

    expect($notification->fresh()?->read_at?->toISOString())->toBe($readAt->toISOString());
});

test('authenticated user can mark all notifications as read', function () {
    $user = User::factory()->create(['role' => 'opd']);
    InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Reminder A',
        'body' => 'A',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '1'],
    ]);
    InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Reminder B',
        'body' => 'B',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '2'],
    ]);

    loginAs($user)
        ->patchJson('/api/notifications/read-all')
        ->assertOk();

    expect($user->inboxNotifications()->where('is_read', false)->count())->toBe(0);
});

test('mark all as read only updates unread notifications owned by the authenticated user', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'opd']);
    $existingReadAt = Carbon::parse('2026-03-21 07:00:00');

    $unread = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Unread reminder',
        'body' => 'Unread body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '1'],
    ]);
    $alreadyRead = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Read reminder',
        'body' => 'Read body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '2'],
        'is_read' => true,
        'read_at' => $existingReadAt,
    ]);
    $otherUsersUnread = InboxNotification::create([
        'user_id' => $otherUser->id,
        'title' => 'Other user unread',
        'body' => 'Other body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '3'],
    ]);

    loginAs($user)
        ->patchJson('/api/notifications/read-all')
        ->assertOk()
        ->assertJsonPath('message', 'Semua notifikasi telah dibaca');

    expect($unread->fresh()?->is_read)->toBeTrue();
    expect($unread->fresh()?->read_at)->not->toBeNull();
    expect($alreadyRead->fresh()?->read_at?->toISOString())->toBe($existingReadAt->toISOString());
    expect($otherUsersUnread->fresh()?->is_read)->toBeFalse();
    expect($otherUsersUnread->fresh()?->read_at)->toBeNull();
});

test('authenticated user can hide a notification', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $notification = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Reminder',
        'body' => 'Segera lengkapi formulir.',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
    ]);

    loginAs($user)
        ->deleteJson("/api/notifications/{$notification->id}")
        ->assertOk()
        ->assertJsonPath('message', 'Notifikasi dihapus');

    expect($notification->fresh()?->hidden_at)->not->toBeNull();
    loginAs($user)
        ->getJson('/api/notifications')
        ->assertOk()
        ->assertJsonCount(0, 'data');
});

test('hiding notification returns 404 for another users notification', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'opd']);
    $notification = InboxNotification::create([
        'user_id' => $otherUser->id,
        'title' => 'Other reminder',
        'body' => 'Private reminder',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
    ]);

    loginAs($user)
        ->deleteJson("/api/notifications/{$notification->id}")
        ->assertNotFound();

    expect($notification->fresh()?->hidden_at)->toBeNull();
});

test('hiding an already hidden notification is idempotent', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $hiddenAt = Carbon::parse('2026-03-21 09:30:00');
    $notification = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Hidden reminder',
        'body' => 'Already hidden',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
        'hidden_at' => $hiddenAt,
    ]);

    loginAs($user)
        ->deleteJson("/api/notifications/{$notification->id}")
        ->assertOk()
        ->assertJsonPath('message', 'Notifikasi dihapus');

    expect($notification->fresh()?->hidden_at?->toISOString())->toBe($hiddenAt->toISOString());
});

test('authenticated user can hide all read notifications', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $read = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Read reminder',
        'body' => 'Read body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '1'],
        'is_read' => true,
        'read_at' => Carbon::parse('2026-03-21 07:00:00'),
    ]);
    $unread = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Unread reminder',
        'body' => 'Unread body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '2'],
    ]);

    loginAs($user)
        ->deleteJson('/api/notifications/read')
        ->assertOk()
        ->assertJsonPath('message', 'Semua notifikasi yang sudah dibaca dihapus');

    expect($read->fresh()?->hidden_at)->not->toBeNull();
    expect($unread->fresh()?->hidden_at)->toBeNull();
});

test('hide read notifications only affects read notifications owned by the authenticated user', function () {
    $user = User::factory()->create(['role' => 'opd']);
    $otherUser = User::factory()->create(['role' => 'opd']);
    $ownRead = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Own read reminder',
        'body' => 'Read body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '1'],
        'is_read' => true,
        'read_at' => Carbon::parse('2026-03-21 07:00:00'),
    ]);
    $ownUnread = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Own unread reminder',
        'body' => 'Unread body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '2'],
    ]);
    $otherUsersRead = InboxNotification::create([
        'user_id' => $otherUser->id,
        'title' => 'Other read reminder',
        'body' => 'Other read body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '3'],
        'is_read' => true,
        'read_at' => Carbon::parse('2026-03-21 08:00:00'),
    ]);

    loginAs($user)
        ->deleteJson('/api/notifications/read')
        ->assertOk();

    expect($ownRead->fresh()?->hidden_at)->not->toBeNull();
    expect($ownUnread->fresh()?->hidden_at)->toBeNull();
    expect($otherUsersRead->fresh()?->hidden_at)->toBeNull();
});

test('notification endpoints require authentication', function () {
    $notification = InboxNotification::create([
        'user_id' => User::factory()->create(['role' => 'opd'])->id,
        'title' => 'Reminder',
        'body' => 'Body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '12'],
    ]);

    $this->getJson('/api/notifications')->assertUnauthorized();
    $this->deleteJson('/api/notifications/read')->assertUnauthorized();
    $this->patchJson('/api/notifications/read-all')->assertUnauthorized();
    $this->patchJson("/api/notifications/{$notification->id}/read")->assertUnauthorized();
    $this->deleteJson("/api/notifications/{$notification->id}")->assertUnauthorized();
});
