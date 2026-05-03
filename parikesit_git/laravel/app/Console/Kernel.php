<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule): void
    {
        $schedule
            ->command('reminders:send-opd-form')
            ->dailyAt(config('services.firebase.reminder_time', '09:00'))
            ->timezone(config('services.firebase.reminder_timezone', config('app.timezone')))
            ->withoutOverlapping();

        $schedule
            ->command('notifications:prune-hidden')
            ->dailyAt('01:00')
            ->withoutOverlapping();
    }

    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
