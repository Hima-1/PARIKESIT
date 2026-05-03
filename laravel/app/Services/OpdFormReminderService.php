<?php

namespace App\Services;

use App\Contracts\PushNotificationSender;
use App\Models\AuditLog;
use App\Models\InboxNotification;
use App\Models\OpdFormReminderLog;
use App\Models\User;

class OpdFormReminderService
{
    private const AUTOMATIC_REMINDER_TYPE = 'incomplete_form_reminder';

    private const MANUAL_REMINDER_TYPE = 'incomplete_form_summary';

    public function __construct(
        private readonly DashboardService $dashboardService,
        private readonly PushNotificationSender $sender,
    ) {}

    public function sendDailyReminders(): array
    {
        $sent = 0;
        $skipped = 0;

        User::query()
            ->where('role', 'opd')
            ->with(['deviceTokens' => fn ($query) => $query->active()])
            ->chunk(100, function ($users) use (&$sent, &$skipped) {
                foreach ($users as $user) {
                    $tokens = $this->getActiveTokens($user);
                    $items = $this->getIncompleteItems($user);

                    foreach ($items as $item) {
                        $formulirId = (int) ($item['id'] ?? 0);
                        if ($formulirId === 0 || $this->wasAlreadySentToday($user->id, $formulirId, self::AUTOMATIC_REMINDER_TYPE)) {
                            $skipped++;

                            continue;
                        }

                        $result = $this->sendAutomaticReminder($user, $item, $tokens);
                        $sent += $result['sent'];
                        $skipped += $result['skipped'];
                    }
                }
            });

        return [
            'sent' => $sent,
            'skipped' => $skipped,
        ];
    }

    public function sendManualReminderForUser(User $user, int $adminId): array
    {
        if ($user->role !== 'opd') {
            return [
                'sent' => 0,
                'skipped' => 1,
                'incomplete_form_count' => 0,
                'message' => 'Reminder hanya dapat dikirim ke user OPD.',
            ];
        }

        $items = $this->getIncompleteItems($user);
        $incompleteFormCount = count($items);
        if ($incompleteFormCount === 0) {
            return [
                'sent' => 0,
                'skipped' => 1,
                'incomplete_form_count' => 0,
                'message' => 'Semua formulir OPD ini sudah lengkap.',
            ];
        }

        $tokens = $this->getActiveTokens($user);
        $payload = $this->buildManualSummaryPayload($items);
        $result = $tokens === []
            ? ['success_count' => 0, 'failure_count' => 0]
            : $this->sender->sendToTokens($tokens, $payload['notification'], $payload['data']);

        $this->persistInboxNotification(
            user: $user,
            title: $payload['notification']['title'],
            body: $payload['notification']['body'],
            type: self::MANUAL_REMINDER_TYPE,
            data: $payload['data'],
        );

        AuditLog::create([
            'user_id' => $adminId,
            'action' => 'trigger_opd_reminder',
            'description' => "Admin memicu reminder manual untuk user OPD {$user->id}.",
            'metadata' => [
                'target_user_id' => $user->id,
                'notification_type' => self::MANUAL_REMINDER_TYPE,
                'sent_count' => $result['success_count'] ?? 0,
                'incomplete_form_count' => $incompleteFormCount,
            ],
        ]);

        if ($tokens === []) {
            return [
                'sent' => 0,
                'skipped' => 1,
                'incomplete_form_count' => $incompleteFormCount,
                'message' => 'Reminder dicatat ke inbox, tetapi user belum memiliki token device aktif.',
            ];
        }

        return [
            'sent' => (int) ($result['success_count'] ?? 0),
            'skipped' => (int) ($result['failure_count'] ?? 0),
            'incomplete_form_count' => $incompleteFormCount,
            'message' => "Reminder manual berhasil diproses untuk {$incompleteFormCount} formulir yang belum lengkap.",
        ];
    }

    private function getIncompleteItems(User $user): array
    {
        return collect($this->dashboardService->getOPDProgress($user))
            ->filter(function (array $item) {
                return (float) data_get($item, 'progress_per_indikator.persentase', 0) < 100
                    && (int) data_get($item, 'progress_per_indikator.total', 0) > 0;
            })
            ->values()
            ->all();
    }

    private function getActiveTokens(User $user): array
    {
        return $user->deviceTokens
            ->pluck('token')
            ->filter()
            ->unique()
            ->values()
            ->all();
    }

    private function sendAutomaticReminder(User $user, array $item, array $tokens): array
    {
        $formulirId = (int) ($item['id'] ?? 0);
        if ($formulirId === 0) {
            return ['sent' => 0, 'skipped' => 1];
        }

        $remaining = max(
            0,
            (int) data_get($item, 'progress_per_indikator.total', 0)
                - (int) data_get($item, 'progress_per_indikator.terisi', 0),
        );
        $percentage = (float) data_get($item, 'progress_per_indikator.persentase', 0);
        $payload = $this->buildAutomaticReminderPayload($item, $remaining, $percentage);
        $result = $tokens === []
            ? ['success_count' => 0, 'failure_count' => 0]
            : $this->sender->sendToTokens($tokens, $payload['notification'], $payload['data']);

        $this->persistInboxNotification(
            user: $user,
            title: $payload['notification']['title'],
            body: $payload['notification']['body'],
            type: self::AUTOMATIC_REMINDER_TYPE,
            data: $payload['data'],
        );

        OpdFormReminderLog::create([
            'user_id' => $user->id,
            'formulir_id' => $formulirId,
            'reminder_type' => self::AUTOMATIC_REMINDER_TYPE,
            'reminder_date' => now()->toDateString(),
            'progress_percentage' => $percentage,
            'remaining_indicators' => $remaining,
            'sent_at' => now(),
        ]);

        return [
            'sent' => (int) ($result['success_count'] ?? 0),
            'skipped' => $tokens === [] ? 1 : (int) ($result['failure_count'] ?? 0),
        ];
    }

    private function buildAutomaticReminderPayload(array $item, int $remaining, float $percentage): array
    {
        $formulirId = (string) ($item['id'] ?? 0);

        return [
            'notification' => [
                'title' => 'Formulir belum selesai diisi',
                'body' => "Masih ada {$remaining} indikator di {$item['nama']} yang belum Anda lengkapi.",
            ],
            'data' => [
                'type' => self::AUTOMATIC_REMINDER_TYPE,
                'formulir_id' => $formulirId,
                'activity_id' => $formulirId,
                'progress_percentage' => (string) $percentage,
                'target_route' => "/penilaian-kegiatan?formulirId={$formulirId}",
            ],
        ];
    }

    private function buildManualSummaryPayload(array $items): array
    {
        $formulirIds = array_values(array_filter(array_map(
            static fn (array $item) => (string) ($item['id'] ?? 0),
            $items,
        )));
        $formNames = collect($items)
            ->pluck('nama')
            ->filter()
            ->take(3)
            ->values()
            ->all();
        $count = count($items);
        $summaryNames = $formNames === [] ? '' : ' Contoh: '.implode(', ', $formNames).'.';

        return [
            'notification' => [
                'title' => 'Admin mengirim reminder pengisian formulir',
                'body' => "Anda masih memiliki {$count} formulir yang belum lengkap.{$summaryNames}",
            ],
            'data' => [
                'type' => self::MANUAL_REMINDER_TYPE,
                'incomplete_form_count' => (string) $count,
                'formulir_ids' => json_encode($formulirIds),
                'target_route' => '/penilaian-kegiatan',
            ],
        ];
    }

    private function persistInboxNotification(
        User $user,
        string $title,
        string $body,
        string $type,
        array $data,
    ): void {
        InboxNotification::create([
            'user_id' => $user->id,
            'title' => $title,
            'body' => $body,
            'type' => $type,
            'data' => $data,
        ]);
    }

    private function wasAlreadySentToday(int $userId, int $formulirId, string $reminderType): bool
    {
        return OpdFormReminderLog::query()
            ->where('user_id', $userId)
            ->where('formulir_id', $formulirId)
            ->where('reminder_type', $reminderType)
            ->whereDate('reminder_date', now()->toDateString())
            ->exists();
    }
}
