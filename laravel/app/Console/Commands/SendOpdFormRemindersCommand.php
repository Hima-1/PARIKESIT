<?php

namespace App\Console\Commands;

use App\Services\OpdFormReminderService;
use Illuminate\Console\Command;

class SendOpdFormRemindersCommand extends Command
{
    protected $signature = 'reminders:send-opd-form';

    protected $description = 'Send daily Firebase reminders to OPD users with incomplete forms.';

    public function handle(OpdFormReminderService $service): int
    {
        $result = $service->sendDailyReminders();

        $this->info("Reminder sent: {$result['sent']}, skipped: {$result['skipped']}");

        return self::SUCCESS;
    }
}
