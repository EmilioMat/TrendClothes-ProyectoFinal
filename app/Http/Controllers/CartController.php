<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Stripe\Stripe;
use Stripe\Checkout\Session;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Stores\CartStore;
use Illuminate\Support\Facades\Auth;

class CartController extends Controller
{
    public function index(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();
        $cartItems = [];
        $addresses = [];

        if ($user) {
            $cartItems = $user->cartItems()->with(['product' => function ($query) {
                $query->select('id', 'name', 'price', 'main_image');
            }])->get()->toArray();

            $addresses = $user->addresses()->get()->toArray();
        }

        return Inertia::render('Cart/Index', [
            'initialItems' => $cartItems,
            'addresses' => $addresses,
            'address' => $request->query('address'),
        ]);
    } 

    public function success()
    {
        $cart = app(CartStore::class);
        $cart->clear();
        return Inertia::render('Cart/Success');
    }
    public function checkout(Request $request)
    {
        Stripe::setApiKey(env('STRIPE_SECRET'));

        $cart = app(CartStore::class);
        $lineItems = [];

        foreach ($cart->getItems() as $item) {
            $lineItems[] = [
                'price_data' => [
                    'currency' => 'eur',
                    'product_data' => [
                        'name' => $item['product']->name,
                    ],
                    'unit_amount' => $item['product']->price * 100, // Convertir a centavos
                ],
                'quantity' => $item['quantity'],
            ];
        }

        $checkoutSession = Session::create([
            'payment_method_types' => ['card'],
            'line_items' => $lineItems,
            'mode' => 'payment',
            'success_url' => route('cart.success'),
            'cancel_url' => route('cart.index'),
        ]);

        return redirect()->away($checkoutSession->url);
    }
}
