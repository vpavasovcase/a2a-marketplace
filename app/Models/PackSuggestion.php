<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PackSuggestion extends Model
{
    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'pack_name',
        'problem_it_solves',
        'use_case',
        'additional_details',
    ];
}
