<?php

namespace App\Models;

use App\Models\Concerns\ResolvesPublicFiles;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FileDokumentasi extends Model
{
    use HasFactory;
    use ResolvesPublicFiles;

    protected $fillable =
    [
        'nama_file',
        'tipe_file',
        'dokumentasi_kegiatan_id',
    ];


    public function dokumentasi()
    {
        return $this->belongsTo(DokumentasiKegiatan::class, 'dokumentasi_kegiatan_id');
    }

    public function publicUrl(): ?string
    {
        return $this->publicFileUrl('nama_file');
    }

    public function publicPath(): ?string
    {
        return $this->publicFilePath('nama_file');
    }
}
