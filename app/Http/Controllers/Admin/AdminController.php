<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth; // Corregí la importación
use Inertia\Inertia;

class AdminController extends Controller
{
    public function index()
    {
        return Inertia::render('Admin/Dashboard', [
            'auth' => [
                'user' => optional(Auth::user())->only('name', 'email') + [
                    'profile_photo_url' => Auth::user()?->profile_photo_url
                ]
            ]
        ]);
    }
}
