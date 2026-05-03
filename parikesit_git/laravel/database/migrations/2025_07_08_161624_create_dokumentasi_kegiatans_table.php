<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('dokumentasi_kegiatans', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('created_by_id');

            $table->string('directory_dokumentasi');
            $table->string('judul_dokumentasi');
            $table->string('bukti_dukung_undangan_dokumentasi'); // Untuk PDF Undangan
            $table->string('daftar_hadir_dokumentasi'); // Untuk PDF Daftar Hadir
            $table->string('materi_dokumentasi'); // Text Materi
            $table->string('notula_dokumentasi'); // Untuk PDF Notula

            $table->timestamps();
            $table->softDeletes();
            $table->foreign('created_by_id')->references('id')->on('users')->onDelete('cascade')->onUpdate('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('dokumentasi_kegiatans');
    }
};
