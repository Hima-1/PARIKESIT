<?php

namespace App\Models;

use App\Models\Pembinaan;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class FilePembinaan extends Model
{
    use HasFactory;
protected $fillable =
    [
        'nama_file',
        'tipe_file',
        'pembinaan_id',
    ];


    public function pembinaan()
    {
        return $this->belongsTo(Pembinaan::class);
    }

}
