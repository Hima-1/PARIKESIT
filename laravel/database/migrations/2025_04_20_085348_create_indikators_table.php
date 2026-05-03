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
        Schema::create('indikators', function (Blueprint $table) {
            $table->id();
            $table->foreignId('aspek_id')->constrained()->constrained()->onDelete('cascade')->onUpdate('cascade');
            $table->string('nama_indikator');
            $table->decimal('bobot_indikator', 5, 2)->nullable();
            $table->text('level_1_kriteria')->nullable();
            $table->text('level_2_kriteria')->nullable();
            $table->text('level_3_kriteria')->nullable();
            $table->text('level_4_kriteria')->nullable();
            $table->text('level_5_kriteria')->nullable();


            $table->softDeletes();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('indikators');
    }
};
