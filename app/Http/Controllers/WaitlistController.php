<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class WaitlistController extends Controller
{
    /**
     * Store a new waitlist entry.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'company' => 'nullable|string|max:255',
            'user_type' => 'required|string|in:business,individual',
            'comments' => 'nullable|string',
            'is_developer' => 'boolean',
        ]);

        // For now, just log the entry
        Log::info('New waitlist entry', $validated);

        // In a real application, you would save this to the database
        // WaitlistEntry::create($validated);

        return redirect()->back()->with('success', 'Thank you for joining our waitlist!');
    }
}
