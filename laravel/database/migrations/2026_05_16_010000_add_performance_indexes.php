<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('penilaians', function (Blueprint $table) {
            $table->index(['formulir_id', 'user_id'], 'penilaians_formulir_user_index');
            $table->index(['user_id', 'formulir_id'], 'penilaians_user_formulir_index');
        });

        Schema::table('formulirs', function (Blueprint $table) {
            $table->index(['kind', 'created_at'], 'formulirs_kind_created_at_index');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->index(['role', 'name'], 'users_role_name_index');
        });

        Schema::table('formulir_domains', function (Blueprint $table) {
            $table->index(['formulir_id', 'domain_id'], 'formulir_domains_formulir_domain_index');
        });
    }

    public function down(): void
    {
        Schema::table('formulir_domains', function (Blueprint $table) {
            $table->dropIndex('formulir_domains_formulir_domain_index');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex('users_role_name_index');
        });

        Schema::table('formulirs', function (Blueprint $table) {
            $table->dropIndex('formulirs_kind_created_at_index');
        });

        Schema::table('penilaians', function (Blueprint $table) {
            $table->dropIndex('penilaians_user_formulir_index');
            $table->dropIndex('penilaians_formulir_user_index');
        });
    }
};
