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

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('peserta_pembinaans');
    }
};
