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
        Schema::create('penjadwalans', function (Blueprint $table) {
            $table->id();
            // $table->unsignedBigInteger('pemateri_id');
            $table->string('nama_pemateri');
            $table->string('judul_jadwal', 255);
            $table->date('tanggal_jadwal');
            $table->time('waktu_mulai');
            $table->text('keterangan_jadwal')->nullable();
            // $table->string('pemateri_jadwal', 220);
            $table->string('lokasi', 255);

            $table->unsignedBigInteger('created_by');

            // $table->foreign('pemateri_id')->references('id')->on('users')->onDelete('cascade')->onUpdate('cascade');
            $table->foreign('created_by')->references('id')->on('users')->onDelete('cascade')->onUpdate('cascade');

            $table->softDeletes();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('penjadwalans');
    }
};
