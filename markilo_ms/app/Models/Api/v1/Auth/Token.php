<?php

namespace App\Models\Api\v1\Token;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Token extends Model
{
    use HasFactory;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'uuid',
        'order', // orden
        'name', // nombre
        'address', // direccion
        'dni', // dni
        'dni_type', // dni tipo
        'voting_table'
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'voting_table' => 'integer',
        'dni' => 'integer'
    ];
}
