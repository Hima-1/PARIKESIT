<?php

namespace Database\Seeders;

use App\Models\AuditLog;
use App\Models\User;
use Illuminate\Database\Seeder;

class AuditLogSeeder extends Seeder
{
    /**
     * Seeder manual untuk demo/QA fitur audit log.
     * Jalankan eksplisit: `php artisan db:seed --class=AuditLogSeeder`
     */
    public function run(): void
    {
        $admin = User::where('email', 'admin@gmail.com')->first();

        if (!$admin) {
            return;
        }

        $logs = [
            [
                'user_id' => $admin->id,
                'action' => 'CREATE',
                'description' => 'Created new user: John Doe',
                'metadata' => [
                    'ip_address' => '192.168.1.1',
                    'user_agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)',
                    'target_id' => 101,
                ],
                'created_at' => now()->subHours(5),
            ],
            [
                'user_id' => $admin->id,
                'action' => 'UPDATE',
                'description' => 'Updated system settings: maintenance_mode set to false',
                'metadata' => [
                    'ip_address' => '192.168.1.1',
                    'changes' => [
                        'maintenance_mode' => [
                            'old' => true,
                            'new' => false,
                        ],
                    ],
                ],
                'created_at' => now()->subHours(3),
            ],
            [
                'user_id' => $admin->id,
                'action' => 'DELETE',
                'description' => 'Deleted domain: Kesehatan',
                'metadata' => [
                    'ip_address' => '10.0.0.5',
                    'target_name' => 'Kesehatan',
                ],
                'created_at' => now()->subHours(1),
            ],
            [
                'user_id' => $admin->id,
                'action' => 'UPDATE',
                'description' => 'Changed password for user: Jane Smith',
                'metadata' => [
                    'ip_address' => '192.168.1.50',
                ],
                'created_at' => now()->subMinutes(30),
            ],
            [
                'user_id' => $admin->id,
                'action' => 'CREATE',
                'description' => 'Added new indikator to Aspek Kebijakan',
                'metadata' => [
                    'ip_address' => '127.0.0.1',
                    'aspek_id' => 5,
                ],
                'created_at' => now()->subMinutes(5),
            ],
        ];

        foreach ($logs as $log) {
            AuditLog::create($log);
        }
    }
}
