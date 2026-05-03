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
        Schema::table('indikators', function (Blueprint $table) {
            // Tambahkan kolom kode_indikator jika belum ada
            if (!Schema::hasColumn('indikators', 'kode_indikator')) {
                $table->string('kode_indikator')->nullable();
            }

            // Kriteria untuk Standar Data Statistik (Kode Indikator 10101)
            $table->text('level_1_kriteria_10101')->nullable();
            $table->text('level_2_kriteria_10101')->nullable();
            $table->text('level_3_kriteria_10101')->nullable();
            $table->text('level_4_kriteria_10101')->nullable();
            $table->text('level_5_kriteria_10101')->nullable();

            // Kriteria untuk Metadata Statistik (Kode Indikator 10201)
            $table->text('level_1_kriteria_10201')->nullable();
            $table->text('level_2_kriteria_10201')->nullable();
            $table->text('level_3_kriteria_10201')->nullable();
            $table->text('level_4_kriteria_10201')->nullable();
            $table->text('level_5_kriteria_10201')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('indikators', function (Blueprint $table) {
            // Hapus kolom kode_indikator
            $table->dropColumn('kode_indikator');

            // Hapus kolom untuk Standar Data Statistik
            $table->dropColumn([
                'level_1_kriteria_10101',
                'level_2_kriteria_10101',
                'level_3_kriteria_10101',
                'level_4_kriteria_10101',
                'level_5_kriteria_10101'
            ]);

            // Hapus kolom untuk Metadata Statistik
            $table->dropColumn([
                'level_1_kriteria_10201',
                'level_2_kriteria_10201',
                'level_3_kriteria_10201',
                'level_4_kriteria_10201',
                'level_5_kriteria_10201'
            ]);
        });
    }
};
