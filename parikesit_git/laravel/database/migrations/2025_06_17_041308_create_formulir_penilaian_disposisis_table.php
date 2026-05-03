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
        Schema::create('formulir_penilaian_disposisis', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('formulir_id');
            $table->unsignedBigInteger('indikator_id')->nullable(); // bisa null jika berlaku umum
            $table->unsignedBigInteger('from_profile_id')->nullable();
            $table->unsignedBigInteger('to_profile_id')->nullable();
            $table->unsignedBigInteger('assigned_profile_id')->nullable(); // yang mengerjakan
            $table->enum('status', ['sent', 'returned', 'approved', 'rejected'])->default('sent');
            $table->text('catatan')->nullable(); // alasan revisi, atau catatan koreksi
            $table->boolean('is_completed')->default(false); // sudah dikerjakan atau belum

            $table->softDeletes();
            $table->timestamps();

            $table->foreign('formulir_id')->references('id')->on('formulirs')->onDelete('cascade');
            $table->foreign('indikator_id')->references('id')->on('indikators')->onDelete('set null');
            $table->foreign('from_profile_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('to_profile_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('assigned_profile_id')->references('id')->on('users')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    
    public function down(): void
    {
        Schema::dropIfExists('formulir_penilaian_disposisis');
    }
};
