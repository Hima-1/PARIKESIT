<?php

namespace App\Models;

use App\Models\Domain;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class Aspek extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = [
        'domain_id',
        'nama_aspek',
        'bobot_aspek',
    ];

    public function domain()
    {
        return $this->belongsTo(Domain::class);
    }

    public function indikator()
    {
        return $this->hasMany(Indikator::class);
    }
}
