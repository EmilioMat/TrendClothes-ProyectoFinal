<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up()
    {
        Schema::table('order_items', function (Blueprint $table) {
            $table->foreignId('size_id')->nullable()->constrained()->onDelete('set null');
        });
    }


    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::table('order_items', function (Blueprint $table) {
            $table->dropForeign(['size_id']);
            $table->dropColumn('size_id');
        });
    }
};
