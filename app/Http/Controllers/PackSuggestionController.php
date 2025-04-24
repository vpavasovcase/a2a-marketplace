<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class PackSuggestionController extends Controller
{
    /**
     * Store a new pack suggestion.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'pack_name' => 'required|string|max:255',
            'problem_it_solves' => 'required|string',
            'use_case' => 'required|string',
            'additional_details' => 'nullable|string',
        ]);

        // For now, just log the suggestion
        Log::info('New pack suggestion', $validated);

        // In a real application, you would save this to the database
        // PackSuggestion::create($validated);

        return redirect()->back()->with('success', 'Thank you for your suggestion!');
    }
}
