<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BuktiDukung extends Model
{
    use HasFactory;

    protected $fillable = [
        'penilaian_id',
        'path',
        'nama_file',
        'ukuran_file',
    ];

    public function penilaian()
    {
        return $this->belongsTo(Penilaian::class);
    }
}
