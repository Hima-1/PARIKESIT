<?php

namespace App\Models;

use App\Models\Formulir;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class Domain extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = [
        // 'formulir_id',
        'nama_domain',
        'bobot_domain'
    ];


    public function formulirs()
    {
        return $this->belongsToMany(Formulir::class, 'formulir_domains');
    }

    public function aspek()
    {
        return $this->hasMany(Aspek::class);
    }
}
