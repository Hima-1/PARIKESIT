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
        Schema::table('penilaians', function (Blueprint $table) {
            // Ubah kolom evaluasi dari string ke text untuk penjelasan lebih panjang
            $table->text('evaluasi')->nullable()->change();
            
            // Tambah kolom catatan_koreksi untuk penjelasan koreksi walidata
            $table->text('catatan_koreksi')->nullable()->after('nilai_diupdate');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('penilaians', function (Blueprint $table) {
            // Kembalikan evaluasi ke string
            $table->string('evaluasi')->nullable()->change();
            
            // Hapus kolom catatan_koreksi
            $table->dropColumn('catatan_koreksi');
        });
    }
};
