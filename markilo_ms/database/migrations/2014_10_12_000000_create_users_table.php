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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('uuid', 36)->unique();
            $table->string('name', 50);
            $table->string('surname', 50);
            $table->string('email')->unique();
            $table->string('dni', 20);
            $table->string('cell_phone', 20);
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            $table->string('image')->unique();
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};
