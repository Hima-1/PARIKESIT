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
        Schema::create('file_dokumentasis', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('dokumentasi_kegiatan_id');
            $table->text('nama_file');
            $table->enum('tipe_file', ['png', 'jpg', 'jpeg', 'mp4', 'pdf', 'docx', 'xlsx', 'pptx', 'zip', 'rar']);

            $table->foreign('dokumentasi_kegiatan_id')->references('id')->on('dokumentasi_kegiatans')->onDelete('cascade')->onUpdate('cascade');
            $table->softDeletes();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('file_dokumentasis');
    }
};
