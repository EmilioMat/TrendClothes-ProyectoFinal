<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Stripe\Stripe;
use Stripe\Checkout\Session;
use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use App\Stores\CartStore;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class CartController extends Controller
{
    public function index(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();
        $cartItems = [];
        $addresses = [];
        $selectedAddress = null;

        if ($user) {
            $cartItems = $user->cartItems()->with(['product' => function ($query) {
                $query->select('id', 'name', 'price', 'main_image');
            }, 'size'])->get()->map(function ($item) {
                $itemArray = $item->toArray();
                if ($itemArray['product']['main_image']) {
                    $itemArray['product']['main_image_url'] = Storage::url($itemArray['product']['main_image']);
                }
                return $itemArray;
            })->toArray();

            $addresses = $user->addresses()->get()->toArray();

            // Set selected address if provided in query
            if ($request->query('address')) {
                $selectedAddress = $user->addresses()->find($request->query('address'));
            }
        }

        return Inertia::render('Cart/Index', [
            'initialItems' => $cartItems,
            'addresses' => $addresses,
            'address' => $selectedAddress ? $selectedAddress->toArray() : null,
            'flash' => [
                'success' => $request->session()->get('success'),
                'error' => $request->session()->get('error'),
            ],
        ]);
    }

    public function success()
    {
        $cart = app(CartStore::class);
        $cart->clear();
        return Inertia::render('Cart/Success');
    }


    // app/Http/Controllers/CartController.php

public function addItem(Request $request)
{
    $request->validate([
        'product_id' => 'required|exists:products,id',
        'quantity' => 'required|integer|min:1',
        'size_id' => 'nullable|exists:sizes,id',
    ]);

    /** @var \App\Models\User $user */
    $user = Auth::user();
    $product = Product::findOrFail($request->product_id);
    $sizeId = $request->size_id;
    $sizeName = $sizeId ? \App\Models\Size::find($sizeId)?->name : null;

    // Verificar stock
    if ($sizeId) {
        if (!$product->hasStock($request->quantity, $sizeId)) {
            return back()->with('error', 'No hay suficiente stock para la talla seleccionada');
        }
    } else {
        if (!$product->hasStock($request->quantity)) {
            return back()->with('error', 'No hay suficiente stock para este producto');
        }
    }

    // Buscar item existente
    $existingItem = $user->cartItems()
        ->where('product_id', $product->id)
        ->where('size_id', $sizeId)
        ->first();

    if ($existingItem) {
        $newQuantity = $existingItem->quantity + $request->quantity;
        if ($sizeId && !$product->hasStock($newQuantity, $sizeId)) {
            return back()->with('error', 'No hay suficiente stock para la talla seleccionada');
        }
        $existingItem->update(['quantity' => $newQuantity]);
    } else {
        $user->cartItems()->create([
            'product_id' => $product->id,
            'size_id' => $sizeId,
            'size' => $sizeName,
            'quantity' => $request->quantity,
        ]);
    }

    return back()->with('success', 'Producto añadido al carrito');
}
}
