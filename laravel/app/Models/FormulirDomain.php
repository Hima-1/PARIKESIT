<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class FormulirDomain extends Model
{
    use HasFactory;
    use SoftDeletes;


    protected $fillable =
    [
        'formulir_id',
        'domain_id',
    ];



    public function formulir()
    {
        return $this->belongsTo(Formulir::class,'formulir_id');
    }

    public function domain()
    {
        return $this->belongsTo(Domain::class,'domain_id');
    }
}
