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
        Schema::create('penilaians', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('indikator_id');
            $table->foreignId('formulir_id')->constrained();

            $table->decimal('nilai', 5, 2);
            $table->string('catatan')->nullable();
            $table->timestamp('tanggal_penilaian');
            $table->foreignId('user_id')->constrained();
            $table->string('bukti_dukung')->nullable();
            $table->unsignedBigInteger('dikerjakan_by')->nullable();

            $table->decimal('nilai_diupdate', 5, 2)->nullable();
            $table->unsignedBigInteger('diupdate_by')->nullable();
            $table->timestamp('tanggal_diperbarui')->nullable();



            $table->decimal('nilai_koreksi', 5, 2)->nullable();
            $table->unsignedBigInteger('dikoreksi_by')->nullable();
            $table->string('evaluasi')->nullable();
            $table->timestamp('tanggal_dikoreksi')->nullable();

            $table->timestamps();

            $table->softDeletes();

            $table->foreign('indikator_id')->references('id')->on('indikators')->onDelete('cascade');
            $table->foreign('dikerjakan_by')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('diupdate_by')->references('id')->on('users')->onDelete('cascade');

            $table->foreign('dikoreksi_by')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('penilaians');
    }
};
