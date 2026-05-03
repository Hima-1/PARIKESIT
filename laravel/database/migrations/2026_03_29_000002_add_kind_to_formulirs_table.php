<?php

use App\Models\Formulir;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('formulirs', function (Blueprint $table) {
            $table->string('kind', 32)
                ->default(Formulir::KIND_ASSESSMENT)
                ->after('created_by_id');
        });

        DB::table('formulirs')
            ->where('nama_formulir', 'Formulir Master Data')
            ->update(['kind' => Formulir::KIND_TEMPLATE]);
    }

    public function down(): void
    {
        Schema::table('formulirs', function (Blueprint $table) {
            $table->dropColumn('kind');
        });
    }
};
