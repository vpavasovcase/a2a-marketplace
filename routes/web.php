<?php

use App\Http\Controllers\ProfileController;
use App\Http\Controllers\WaitlistController;
use App\Http\Controllers\PackSuggestionController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    return Inertia::render('LandingPage', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
    ]);
});

// Waitlist routes
Route::get('/waitlist', function () {
    return Inertia::render('Forms/WaitlistForm');
})->name('waitlist.form');

Route::post('/waitlist', [WaitlistController::class, 'store'])->name('waitlist.store');

// Pack suggestion routes
Route::get('/pack-suggestion', function () {
    return Inertia::render('Forms/PackSuggestionForm');
})->name('pack-suggestion.form');

Route::post('/pack-suggestion', [PackSuggestionController::class, 'store'])->name('pack-suggestion.store');

Route::get('/dashboard', function () {
    return Inertia::render('Dashboard');
})->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

require __DIR__.'/auth.php';
