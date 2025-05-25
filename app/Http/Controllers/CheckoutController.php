<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Stripe\Stripe;
use Stripe\Checkout\Session;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Payment;
use App\Models\UserAddress;
use App\Models\CartItem;
use App\Models\Product;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class CheckoutController extends Controller
{
public function store(Request $request)
{
    $user = $request->user();
    
    $validated = $request->validate([
        'cartItems' => 'required|array',
        'total' => 'required|numeric',
        'address_id' => 'required|exists:user_addresses,id'
    ]);

    // Crear la orden
    $order = Order::create([
        'user_id' => $user->id,
        'total' => $validated['total'],
        'status' => 'pending',
        'user_address_id' => $validated['address_id']
    ]);

    // Crear items de la orden
    foreach ($validated['cartItems'] as $item) {
        OrderItem::create([
            'order_id' => $order->id,
            'product_id' => $item['product_id'],
            'quantity' => $item['quantity'],
            'price' => Product::find($item['product_id'])->price,
            'size' => $item['size'] ?? null
        ]);
    } 

    // Configurar Stripe
    Stripe::setApiKey(env('STRIPE_SECRET'));
    
    $lineItems = [];
    foreach ($order->orderItems as $item) {
        $lineItems[] = [
            'price_data' => [
                'currency' => 'eur',
                'product_data' => ['name' => $item->product->name],
                'unit_amount' => $item->price * 100,
            ],
            'quantity' => $item->quantity,
        ];
    }

    $session = Session::create([
        'payment_method_types' => ['card'],
        'line_items' => $lineItems,
        'mode' => 'payment',
        'success_url' => route('checkout.success', $order) . '?session_id={CHECKOUT_SESSION_ID}',
        'cancel_url' => route('checkout.cancel', $order),
        'customer_email' => $user->email,
    ]);

    // Crear registro de pago
    Payment::create([
        'order_id' => $order->id,
        'amount' => $order->total,
        'status' => 'pending',
        'payment_method' => 'stripe',
        'transaction_id' => $session->id,
    ]);

    return Inertia::location($session->url);
}

    public function success(Request $request, Order $order)
    {
        // Verificar el pago con Stripe
        Stripe::setApiKey(env('STRIPE_SECRET'));
        $session = Session::retrieve($request->query('session_id'));

        if ($session->payment_status === 'paid') {
            $order->update(['status' => 'completed']);
            
            $payment = Payment::where('order_id', $order->id)->first();
            $payment->update([
                'status' => 'completed',
                'transaction_id' => $session->payment_intent
            ]);

            // Limpiar el carrito
            CartItem::where('user_id', Auth::id())->delete();

            return Inertia::render('Checkout/Success', [
                'order' => $order
            ]);
        }

        return redirect()->route('checkout.cancel', $order);
    }

    public function cancel(Order $order)
    {
        $order->update(['status' => 'cancelled']);
        $payment = Payment::where('order_id', $order->id)->first();
        $payment->update(['status' => 'cancelled']);

        return Inertia::render('Checkout/Cancel', [
            'order' => $order
        ]);
    }
}