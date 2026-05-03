<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('opd_form_reminder_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('formulir_id')->constrained()->cascadeOnDelete();
            $table->string('reminder_type', 100);
            $table->date('reminder_date');
            $table->decimal('progress_percentage', 5, 2)->nullable();
            $table->unsignedInteger('remaining_indicators')->nullable();
            $table->timestamp('sent_at');

            $table->unique(
                ['user_id', 'formulir_id', 'reminder_type', 'reminder_date'],
                'opd_form_reminder_logs_unique_daily',
            );
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('opd_form_reminder_logs');
    }
};
