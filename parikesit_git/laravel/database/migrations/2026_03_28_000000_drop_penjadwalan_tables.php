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
        Schema::disableForeignKeyConstraints();

        if (Schema::hasTable('peserta_pembinaans')) {
            Schema::dropIfExists('peserta_pembinaans');
        }

        if (Schema::hasTable('penjadwalans')) {
            Schema::dropIfExists('penjadwalans');
        }

        Schema::enableForeignKeyConstraints();
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::create('penjadwalans', function (Blueprint $table) {
            $table->id();
            $table->string('nama_pemateri');
            $table->string('judul_jadwal', 255);
            $table->date('tanggal_jadwal');
            $table->time('waktu_mulai');
            $table->text('keterangan_jadwal')->nullable();
            $table->string('lokasi', 255);
            $table->unsignedBigInteger('created_by');
            $table->foreign('created_by')->references('id')->on('users')->onDelete('cascade')->onUpdate('cascade');
            $table->softDeletes();
            $table->timestamps();
        });

        Schema::create('peserta_pembinaans', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('penjadwalan_id');
            $table->unsignedBigInteger('peserta_id');
            $table->text('ringkasan_pembinaan')->nullable();
            $table->text('bukti_pembinaan')->nullable();
            $table->text('pemateri')->nullable();
            $table->softDeletes();
            $table->timestamps();
            $table->foreign('penjadwalan_id')->references('id')->on('penjadwalans')->onDelete('cascade');
            $table->foreign('peserta_id')->references('id')->on('users')->onDelete('cascade');
        });
    }
};
