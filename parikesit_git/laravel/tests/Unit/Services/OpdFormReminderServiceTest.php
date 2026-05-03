<?php

use App\Contracts\PushNotificationSender;
use App\Models\DeviceToken;
use App\Models\Formulir;
use App\Models\InboxNotification;
use App\Models\OpdFormReminderLog;
use App\Models\User;
use App\Services\DashboardService;
use App\Services\OpdFormReminderService;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(Tests\TestCase::class, RefreshDatabase::class);

beforeEach(function () {
    $this->sender = new class implements PushNotificationSender
    {
        public array $messages = [];

        public function sendToTokens(array $tokens, array $notification, array $data = []): array
        {
            $this->messages[] = compact('tokens', 'notification', 'data');

            return ['success_count' => count($tokens), 'failure_count' => 0];
        }
    };
});

test('send daily reminders skips invalid form ids and ignores complete or empty progress items', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $service = makeReminderService([
        $opd->id => [
            [
                'id' => 0,
                'nama' => 'Invalid form',
                'progress_per_indikator' => ['total' => 2, 'terisi' => 1, 'persentase' => 50],
            ],
            [
                'id' => 101,
                'nama' => 'Complete form',
                'progress_per_indikator' => ['total' => 2, 'terisi' => 2, 'persentase' => 100],
            ],
            [
                'id' => 102,
                'nama' => 'No indicators',
                'progress_per_indikator' => ['total' => 0, 'terisi' => 0, 'persentase' => 0],
            ],
        ],
    ], $this->sender);

    $result = $service->sendDailyReminders();

    expect($result)->toBe(['sent' => 0, 'skipped' => 1]);
    expect($this->sender->messages)->toHaveCount(0);
    expect(InboxNotification::query()->count())->toBe(0);
    expect(OpdFormReminderLog::query()->count())->toBe(0);
});

test('send daily reminders only sends to active tokens and locks automatic payload fields', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'id' => 201,
        'created_by_id' => $opd->id,
    ]);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'first-token',
        'platform' => 'android',
        'is_active' => true,
    ]);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'unique-token',
        'platform' => 'ios',
        'is_active' => true,
    ]);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'inactive-token',
        'platform' => 'android',
        'is_active' => false,
    ]);

    $service = makeReminderService([
        $opd->id => [
            [
                'id' => 201,
                'nama' => 'Form belum lengkap',
                'progress_per_indikator' => ['total' => 4, 'terisi' => 1, 'persentase' => 25],
            ],
        ],
    ], $this->sender);

    $result = $service->sendDailyReminders();

    expect($result)->toBe(['sent' => 2, 'skipped' => 0]);
    expect($this->sender->messages)->toHaveCount(1);
    expect($this->sender->messages[0]['tokens'])->toBe(['first-token', 'unique-token']);
    expect($this->sender->messages[0]['data'])->toMatchArray([
        'type' => 'incomplete_form_reminder',
        'formulir_id' => (string) $formulir->id,
        'activity_id' => (string) $formulir->id,
        'target_route' => "/penilaian-kegiatan?formulirId={$formulir->id}",
    ]);
    expect($this->sender->messages[0]['data']['progress_percentage'])->toBe('25');
});

test('send daily reminders persists inbox and reminder log even without active tokens', function () {
    $opd = User::factory()->create(['role' => 'opd']);
    $formulir = Formulir::factory()->create([
        'id' => 301,
        'created_by_id' => $opd->id,
    ]);

    $service = makeReminderService([
        $opd->id => [
            [
                'id' => $formulir->id,
                'nama' => 'Form tanpa token',
                'progress_per_indikator' => ['total' => 5, 'terisi' => 3, 'persentase' => 60],
            ],
        ],
    ], $this->sender);

    $result = $service->sendDailyReminders();

    expect($result)->toBe(['sent' => 0, 'skipped' => 1]);
    expect($this->sender->messages)->toHaveCount(0);
    $this->assertDatabaseHas('inbox_notifications', [
        'user_id' => $opd->id,
        'type' => 'incomplete_form_reminder',
        'is_read' => false,
    ]);
    $this->assertDatabaseHas('opd_form_reminder_logs', [
        'user_id' => $opd->id,
        'formulir_id' => $formulir->id,
        'reminder_type' => 'incomplete_form_reminder',
    ]);
});

test('manual reminder returns expected payload for non opd user and opd without incomplete forms', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $walidata = User::factory()->create(['role' => 'walidata']);
    $opd = User::factory()->create(['role' => 'opd']);

    $service = makeReminderService([
        $opd->id => [],
    ], $this->sender);

    $nonOpdResult = $service->sendManualReminderForUser($walidata, $admin->id);
    $emptyOpdResult = $service->sendManualReminderForUser($opd, $admin->id);

    expect($nonOpdResult)->toBe([
        'sent' => 0,
        'skipped' => 1,
        'incomplete_form_count' => 0,
        'message' => 'Reminder hanya dapat dikirim ke user OPD.',
    ]);
    expect($emptyOpdResult)->toBe([
        'sent' => 0,
        'skipped' => 1,
        'incomplete_form_count' => 0,
        'message' => 'Semua formulir OPD ini sudah lengkap.',
    ]);
    expect($this->sender->messages)->toHaveCount(0);
    expect(InboxNotification::query()->count())->toBe(0);
});

test('manual reminder locks summary payload fields', function () {
    $admin = User::factory()->create(['role' => 'admin']);
    $opd = User::factory()->create(['role' => 'opd']);
    DeviceToken::create([
        'user_id' => $opd->id,
        'token' => 'token-opd',
        'platform' => 'android',
        'is_active' => true,
    ]);

    $service = makeReminderService([
        $opd->id => [
            [
                'id' => 401,
                'nama' => 'Form A',
                'progress_per_indikator' => ['total' => 3, 'terisi' => 1, 'persentase' => 33.33],
            ],
            [
                'id' => 402,
                'nama' => 'Form B',
                'progress_per_indikator' => ['total' => 4, 'terisi' => 2, 'persentase' => 50],
            ],
        ],
    ], $this->sender);

    $result = $service->sendManualReminderForUser($opd, $admin->id);

    expect($result['sent'])->toBe(1);
    expect($result['skipped'])->toBe(0);
    expect($result['incomplete_form_count'])->toBe(2);
    expect($this->sender->messages)->toHaveCount(1);
    expect($this->sender->messages[0]['data'])->toMatchArray([
        'type' => 'incomplete_form_summary',
        'incomplete_form_count' => '2',
        'target_route' => '/penilaian-kegiatan',
    ]);
    expect(json_decode($this->sender->messages[0]['data']['formulir_ids'], true))->toBe(['401', '402']);
    $this->assertDatabaseHas('inbox_notifications', [
        'user_id' => $opd->id,
        'type' => 'incomplete_form_summary',
    ]);
    $this->assertDatabaseHas('audit_logs', [
        'user_id' => $admin->id,
        'action' => 'trigger_opd_reminder',
    ]);
});

function makeReminderService(array $progressMap, PushNotificationSender $sender): OpdFormReminderService
{
    $dashboard = new class($progressMap) extends DashboardService
    {
        public function __construct(private array $progressMap) {}

        public function getOPDProgress($user)
        {
            return $this->progressMap[$user->id] ?? [];
        }
    };

    return new OpdFormReminderService($dashboard, $sender);
}
