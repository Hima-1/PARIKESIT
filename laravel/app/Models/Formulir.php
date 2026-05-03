<?php

namespace App\Models;

use App\Models\Domain;
use App\Models\FormulirDomain;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;

class Formulir extends Model
{
    use HasFactory;
    use SoftDeletes;

    public const KIND_ASSESSMENT = 'assessment';
    public const KIND_TEMPLATE = 'template';


    protected $fillable = [
        'nama_formulir',
        'tanggal_dibuat',
        'created_by_id', // Tambahkan created_by_id
        'kind',
    ];

    // Tambahkan atribut yang diatur secara otomatis
    protected $attributes = [
        'tanggal_dibuat' => null,
        'kind' => self::KIND_ASSESSMENT,
    ];

    // Tambahkan boot method untuk mengatur tanggal secara otomatis
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($model) {
            if (is_null($model->tanggal_dibuat)) {
                $model->tanggal_dibuat = now();
            }
        });
    }

    // protected $dates = [
    //     'tanggal_dibuat'
    // ];



    public function formulir_domains()
    {
        return $this->hasMany(FormulirDomain::class);
    }

    public function domains()
    {
        return $this->belongsToMany(Domain::class, 'formulir_domains');
    }

     public function dokumentasi()
    {
        return $this->hasMany(DokumentasiKegiatan::class);
    }

    public function formulir_penilaian_diposisi()
    {
        return $this->hasMany(FormulirPenilaianDisposisi::class);
    }

    public function penilaians()
    {
        return $this->hasMany(Penilaian::class);
    }

    // Relasi dengan user yang membuat formulir
    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by_id');
    }

    public function scopeOperational($query)
    {
        return $query->where('kind', self::KIND_ASSESSMENT);
    }

    public function isOperational(): bool
    {
        return $this->kind === self::KIND_ASSESSMENT;
    }
}
