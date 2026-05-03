<?php

namespace App\Console\Commands;

use App\Models\InboxNotification;
use Illuminate\Console\Command;

class PruneHiddenNotificationsCommand extends Command
{
    protected $signature = 'notifications:prune-hidden';

    protected $description = 'Delete inbox notifications that were hidden more than 30 days ago.';

    public function handle(): int
    {
        $deleted = InboxNotification::query()
            ->whereNotNull('hidden_at')
            ->where('hidden_at', '<=', now()->subDays(30))
            ->delete();

        $this->info("Pruned {$deleted} hidden notifications.");

        return self::SUCCESS;
    }
}
