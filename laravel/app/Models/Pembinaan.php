<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pembinaan extends Model
{
    use HasFactory;


    protected $fillable = [
        'created_by_id',
        'directory_pembinaan',
        'judul_pembinaan',
        'bukti_dukung_undangan_pembinaan',
        'daftar_hadir_pembinaan',
        'materi_pembinaan',
        'notula_pembinaan',

    ];

    public function profile()
    {
        return $this->belongsTo(User::class, 'created_by_id');
    }

    // public function peserta()
    // {
    //     return $this->belongsTo(PesertaPembinaan::class, 'peserta_id');
    // }

    // public function creator()
    // {
    //     return $this->belongsTo(User::class, 'created_by');
    // }

    public function file_pembinaan()
    {
        return $this->hasMany(FilePembinaan::class);
    }
}
