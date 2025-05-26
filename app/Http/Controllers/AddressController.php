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

        /** @var \App\Models\User $user */
        $user = Auth::user();

        // Create the address
        $address = $user->addresses()->create(array_merge($validated, [
            'is_main' => $user->addresses()->count() === 0, // Set as main if it's the first address
        ]));

        // Fetch updated addresses
        $addresses = $user->addresses()->get()->toArray();

        // Return Inertia response
        return redirect()->route('cart.index', ['address' => $address->id])
            ->with('success', 'Dirección añadida correctamente');
    }
}  