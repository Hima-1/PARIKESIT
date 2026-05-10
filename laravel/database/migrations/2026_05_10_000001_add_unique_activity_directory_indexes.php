<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $this->deduplicateDirectoryColumn('dokumentasi_kegiatans', 'directory_dokumentasi');
        $this->deduplicateDirectoryColumn('pembinaans', 'directory_pembinaan');

        Schema::table('dokumentasi_kegiatans', function (Blueprint $table) {
            $table->unique('directory_dokumentasi', 'dokumentasi_kegiatans_directory_dokumentasi_unique');
        });

        Schema::table('pembinaans', function (Blueprint $table) {
            $table->unique('directory_pembinaan', 'pembinaans_directory_pembinaan_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('dokumentasi_kegiatans', function (Blueprint $table) {
            $table->dropUnique('dokumentasi_kegiatans_directory_dokumentasi_unique');
        });

        Schema::table('pembinaans', function (Blueprint $table) {
            $table->dropUnique('pembinaans_directory_pembinaan_unique');
        });
    }

    private function deduplicateDirectoryColumn(string $table, string $column): void
    {
        $duplicateValues = DB::table($table)
            ->select($column)
            ->groupBy($column)
            ->havingRaw('COUNT(*) > 1')
            ->pluck($column);

        foreach ($duplicateValues as $directory) {
            $ids = DB::table($table)
                ->where($column, $directory)
                ->orderBy('id')
                ->pluck('id');

            foreach ($ids->skip(1) as $id) {
                DB::table($table)
                    ->where('id', $id)
                    ->update([$column => $this->uniqueDirectoryValue($table, $column, $directory, (int) $id)]);
            }
        }
    }

    private function uniqueDirectoryValue(string $table, string $column, string $directory, int $id): string
    {
        $base = Str::limit($directory, 200, '');
        $candidate = "{$base}-{$id}";
        $suffix = 1;

        while (DB::table($table)->where($column, $candidate)->exists()) {
            $candidate = "{$base}-{$id}-{$suffix}";
            $suffix++;
        }

        return $candidate;
    }
};
