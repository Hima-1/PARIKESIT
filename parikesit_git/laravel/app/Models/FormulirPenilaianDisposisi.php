<?php

namespace App\Models;

use App\Models\User;
use App\Models\Formulir;
use App\Models\Indikator;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class FormulirPenilaianDisposisi extends Model
{
    use HasFactory;

    protected $fillable = [
        'formulir_id',
        'indikator_id',
        'from_profile_id',
        'to_profile_id',
        'assigned_profile_id',
        'status',
        'catatan',
        'is_completed',
    ];

    // RELATIONS

    public function formulir()
    {
        return $this->belongsTo(Formulir::class);
    }

    public function indikator()
    {
        return $this->belongsTo(Indikator::class);
    }

    public function fromProfile()
    {
        return $this->belongsTo(User::class, 'from_profile_id');
    }

    public function toProfile()
    {
        return $this->belongsTo(User::class, 'to_profile_id');
    }

    public function assignedProfile()
    {
        return $this->belongsTo(User::class, 'assigned_profile_id');
    }
}
