<?php

use App\Contracts\PushNotificationSender;
use App\Models\DeviceToken;
use App\Models\Domain;
use App\Models\Formulir;
use App\Models\FormulirDomain;
use App\Models\Indikator;
use App\Models\OpdFormReminderLog;
use App\Models\Penilaian;
use App\Models\User;
use App\Services\OpdFormReminderService;

test('reminder command sends only for opd users with incomplete forms', function () {
    $sender = new class implements PushNotificationSender
    {
        public array $messages = [];

        public function sendToTokens(array $tokens, array $notification, array $data = []): array
        {
            $this->messages[] = compact('tokens', 'notification', 'data');

            return ['success_count' => count($tokens), 'failure_count' => 0];
        }
    };
    app()->instance(PushNotificationSender::class, $sender);

    $opd = User::factory()->create(['role' => 'opd']);
    $walidata = User::factory()->create(['role' => 'walidata']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $domain = Domain::factory()->create();
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $indikatorA = Indikator::factory()->create();
    $indikatorB = Indikator::factory()->create();
    $domain->aspek()->create(['nama_aspek' => 'Aspek A']);
    $aspek = $domain->fresh()->aspek()->first();
    $indikatorA->update(['aspek_id' => $aspek->id]);
    $indikatorB->update(['aspek_id' => $aspek->id]);

    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorA->id,
        'user_id' => $opd->id,
        'nilai' => 4,
    ]);

    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);
    DeviceToken::create([
        'user_id' => $walidata->id,
        'token' => 'token-walidata',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $this->artisan('reminders:send-opd-form')
        ->expectsOutputToContain('Reminder sent: 1')
        ->assertSuccessful();

    expect($sender->messages)->toHaveCount(1);
    expect($sender->messages[0]['tokens'])->toBe(['token-opd']);
    expect($sender->messages[0]['data']['type'])->toBe('incomplete_form_reminder');

    $this->assertDatabaseHas('opd_form_reminder_logs', [
        'user_id' => $opd->id,
        'formulir_id' => $formulir->id,
        'reminder_type' => 'incomplete_form_reminder',
    ]);
    $this->assertDatabaseHas('inbox_notifications', [
        'user_id' => $opd->id,
        'type' => 'incomplete_form_reminder',
        'is_read' => false,
    ]);
});

test('reminder command does not send duplicate reminder for the same form on the same day', function () {
    $sender = new class implements PushNotificationSender
    {
        public int $calls = 0;

        public function sendToTokens(array $tokens, array $notification, array $data = []): array
        {
            $this->calls++;

            return ['success_count' => count($tokens), 'failure_count' => 0];
        }
    };
    app()->instance(PushNotificationSender::class, $sender);

    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    OpdFormReminderLog::create([
        'user_id' => $opd->id,
        'formulir_id' => $formulir->id,
        'reminder_type' => 'incomplete_form_reminder',
        'reminder_date' => now()->toDateString(),
        'progress_percentage' => 50,
        'remaining_indicators' => 2,
        'sent_at' => now(),
    ]);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $domain = Domain::factory()->create();
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $domain->aspek()->create(['nama_aspek' => 'Aspek A']);
    $aspek = $domain->fresh()->aspek()->first();
    $indikatorA = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $indikatorB = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorA->id,
        'user_id' => $opd->id,
        'nilai' => 4,
    ]);

    $this->artisan('reminders:send-opd-form')->assertSuccessful();

    expect($sender->calls)->toBe(0);
});

test('manual reminder sends a single summary notification and bypasses daily dedup', function () {
    $sender = new class implements PushNotificationSender
    {
        public array $messages = [];

        public function sendToTokens(array $tokens, array $notification, array $data = []): array
        {
            $this->messages[] = compact('tokens', 'notification', 'data');

            return ['success_count' => count($tokens), 'failure_count' => 0];
        }
    };
    app()->instance(PushNotificationSender::class, $sender);

    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create(['created_by_id' => $opd->id]);
    $domain = Domain::factory()->create();
    FormulirDomain::query()->create([
        'formulir_id' => $formulir->id,
        'domain_id' => $domain->id,
    ]);
    $domain->aspek()->create(['nama_aspek' => 'Aspek A']);
    $aspek = $domain->fresh()->aspek()->first();
    $indikatorA = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    $indikatorB = Indikator::factory()->create(['aspek_id' => $aspek->id]);
    Penilaian::factory()->create([
        'formulir_id' => $formulir->id,
        'indikator_id' => $indikatorA->id,
        'user_id' => $opd->id,
        'nilai' => 4,
    ]);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);
    OpdFormReminderLog::create([
        'user_id' => $opd->id,
        'formulir_id' => $formulir->id,
        'reminder_type' => 'incomplete_form_reminder',
        'reminder_date' => now()->toDateString(),
        'progress_percentage' => 50,
        'remaining_indicators' => 1,
        'sent_at' => now(),
    ]);

    $result = app(OpdFormReminderService::class)->sendManualReminderForUser($opd, $admin->id);

    expect($result['sent'])->toBe(1);
    expect($result['incomplete_form_count'])->toBe(1);
    expect($sender->messages)->toHaveCount(1);
    expect($sender->messages[0]['data']['type'])->toBe('incomplete_form_summary');
    $this->assertDatabaseHas('inbox_notifications', [
        'user_id' => $opd->id,
        'type' => 'incomplete_form_summary',
    ]);
    $this->assertDatabaseHas('audit_logs', [
        'user_id' => $admin->id,
        'action' => 'trigger_opd_reminder',
    ]);
});
