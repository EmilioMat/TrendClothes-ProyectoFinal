<?php

namespace App\Http\Controllers;

use App\Models\UserAddress;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class AddressController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'address' => 'required|string|max:255',
            'city' => 'required|string|max:100',
            'state' => 'required|string|max:100',
            'zip_code' => 'required|string|max:20',
            'country' => 'required|string|max:100',
        ]);

        // Desmarcar cualquier dirección principal existente
        UserAddress::where('user_id', Auth::id())
            ->where('is_main', true)
            ->update(['is_main' => false]);

        // Crear la nueva dirección
        $address = UserAddress::create([
            'user_id' => Auth::id(),
            'address' => $validated['address'],
            'city' => $validated['city'],
            'state' => $validated['state'],
            'zip_code' => $validated['zip_code'],
            'country' => $validated['country'],
            'is_main' => true,
        ]);

        return response()->json(['address' => $address]);
    }
}