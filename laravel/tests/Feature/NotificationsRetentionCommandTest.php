<?php

use App\Models\InboxNotification;
use App\Models\User;
use Carbon\Carbon;

test('hidden notifications older than 30 days are pruned by the retention command', function () {
    Carbon::setTestNow('2026-03-28 09:00:00');

    $user = User::factory()->create(['role' => 'opd']);
    $prunable = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Prunable reminder',
        'body' => 'Old hidden body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '1'],
        'hidden_at' => now()->subDays(31),
    ]);
    $recentlyHidden = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Recent hidden reminder',
        'body' => 'Recent hidden body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '2'],
        'hidden_at' => now()->subDays(29),
    ]);
    $visible = InboxNotification::create([
        'user_id' => $user->id,
        'title' => 'Visible reminder',
        'body' => 'Visible body',
        'type' => 'incomplete_form_reminder',
        'data' => ['formulir_id' => '3'],
    ]);

    $this->artisan('notifications:prune-hidden')
        ->expectsOutputToContain('Pruned 1 hidden notifications.')
        ->assertSuccessful();

    $this->assertDatabaseMissing('inbox_notifications', [
        'id' => $prunable->id,
    ]);
    $this->assertDatabaseHas('inbox_notifications', [
        'id' => $recentlyHidden->id,
    ]);
    $this->assertDatabaseHas('inbox_notifications', [
        'id' => $visible->id,
    ]);

    Carbon::setTestNow();
});
