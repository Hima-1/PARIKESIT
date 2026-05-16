<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        $duplicates = DB::table('penilaians')
            ->select(
                'indikator_id',
                'formulir_id',
                'user_id',
                DB::raw('MAX(id) as keep_id'),
                DB::raw('COUNT(*) as duplicate_count'),
            )
            ->groupBy('indikator_id', 'formulir_id', 'user_id')
            ->having('duplicate_count', '>', 1)
            ->get();

        foreach ($duplicates as $duplicate) {
            DB::table('penilaians')
                ->where('indikator_id', $duplicate->indikator_id)
                ->where('formulir_id', $duplicate->formulir_id)
                ->where('user_id', $duplicate->user_id)
                ->where('id', '<>', $duplicate->keep_id)
                ->delete();
        }

        Schema::table('penilaians', function (Blueprint $table) {
            $table->unique(
                ['indikator_id', 'formulir_id', 'user_id'],
                'penilaians_unique_user_indicator_form',
            );
        });
    }

    public function down(): void
    {
        Schema::table('penilaians', function (Blueprint $table) {
            $table->dropUnique('penilaians_unique_user_indicator_form');
        });
    }
};
