<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class OpdFormReminderLog extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $fillable = [
        'user_id',
        'formulir_id',
        'reminder_type',
        'reminder_date',
        'progress_percentage',
        'remaining_indicators',
        'sent_at',
    ];

    protected $casts = [
        'reminder_date' => 'date',
        'sent_at' => 'datetime',
    ];
}
