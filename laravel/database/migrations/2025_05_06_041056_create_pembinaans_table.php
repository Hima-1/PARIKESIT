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
        Schema::create('pembinaans', function (Blueprint $table) {
            $table->id();

            $table->unsignedBigInteger('created_by_id');

            $table->string('directory_pembinaan');
            $table->string('judul_pembinaan');
            $table->string('bukti_dukung_undangan_pembinaan'); // Untuk PDF Undangan
            $table->string('daftar_hadir_pembinaan'); // Untuk PDF Daftar Hadir
            $table->string('materi_pembinaan'); // Text Materi
            $table->string('notula_pembinaan'); // Untuk PDF Notula


            $table->foreign('created_by_id')->references('id')->on('users')->onDelete('cascade')->onUpdate('cascade');

            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pembinaans');
    }
};
