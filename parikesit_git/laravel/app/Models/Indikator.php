<?php

namespace App\Models;

use App\Models\Aspek;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class Indikator extends Model
{
    use HasFactory;
    use SoftDeletes;

    protected $fillable = [
        'aspek_id',
        'kode_indikator',
        'nama_indikator',
        'bobot_indikator',
        'level_1_kriteria',
        'level_2_kriteria',
        'level_3_kriteria',
        'level_4_kriteria',
        'level_5_kriteria',
        'level_1_kriteria_10101',
        'level_2_kriteria_10101',
        'level_3_kriteria_10101',
        'level_4_kriteria_10101',
        'level_5_kriteria_10101',
        'level_1_kriteria_10201',
        'level_2_kriteria_10201',
        'level_3_kriteria_10201',
        'level_4_kriteria_10201',
        'level_5_kriteria_10201',
    ];


    public function aspek()
    {
        return $this->belongsTo(Aspek::class);
    }

    public function penilaian()
    {
        return $this->hasMany(Penilaian::class, 'indikator_id');
    }
}
