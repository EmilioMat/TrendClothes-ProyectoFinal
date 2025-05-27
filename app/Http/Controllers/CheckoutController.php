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
use Stripe\Exception\ApiErrorException;
use App\Mail\OrderConfirmationMail;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class CheckoutController extends Controller
{
public function store(Request $request)
{
    $user = $request->user();

    // Obtener los ítems del carrito del usuario autenticado desde la base de datos
    $cartItems = $user->cartItems()->with('product')->get();

    if ($cartItems->isEmpty()) {
        return redirect()->route('cart.index')->with('error', 'Tu carrito está vacío');
    }

    // Validar dirección y total
    $validated = $request->validate([
        'total' => 'required|numeric|min:0',
        'address_id' => 'required|exists:user_addresses,id',
    ]);

    // Verificar que la dirección pertenece al usuario autenticado
    $address = UserAddress::where('id', $validated['address_id'])
        ->where('user_id', $user->id)
        ->first();

    if (!$address) {
        Log::error('Dirección no encontrada o no pertenece al usuario', [
            'address_id' => $validated['address_id'],
            'user_id' => $user->id,
        ]);
        return redirect()->route('cart.index')->with('error', 'La dirección seleccionada no es válida.');
    }

    // Verificar stock
    foreach ($cartItems as $item) {
        if (!$item->product->hasStock($item->quantity, $item->size_id)) {
            return back()->with('error', "El producto {$item->product->name} no tiene suficiente stock");
        }
    }

    // Crear la orden
    $order = Order::create([
        'user_id' => $user->id,
        'total' => $validated['total'],
        'status' => 'pending',
        'user_address_id' => $validated['address_id'],
    ]);

    // Crear ítems de la orden y reducir stock
    foreach ($cartItems as $item) {
        OrderItem::create([
            'order_id' => $order->id,
            'product_id' => $item->product_id,
            'quantity' => $item->quantity,
            'price' => $item->product->price,
            'size_id' => $item->size_id,
            'size' => $item->size,
        ]);

        $item->product->decreaseStock($item->quantity, $item->size_id);
    }

    // Configurar Stripe
    $stripeSecret = env('STRIPE_SECRET');
    if (!$stripeSecret) {
        Log::error('STRIPE_SECRET is not set in .env');
        return redirect()->route('cart.index')->with('error', 'Error de configuración del servidor. Contacta con soporte.');
    }

    try {
        Stripe::setApiKey($stripeSecret);

        $lineItems = $order->orderItems->map(function ($item) {
            return [
                'price_data' => [
                    'currency' => 'eur',
                    'product_data' => ['name' => $item->product->name],
                    'unit_amount' => (int) ($item->price * 100),
                ],
                'quantity' => $item->quantity,
            ];
        })->toArray();

        $session = Session::create([
            'payment_method_types' => ['card'],
            'line_items' => $lineItems,
            'mode' => 'payment',
            'success_url' => route('checkout.success', $order) . '?session_id={CHECKOUT_SESSION_ID}',
            'cancel_url' => route('checkout.cancel', $order),
            'customer_email' => $user->email,
        ]);

        Payment::create([
            'order_id' => $order->id,
            'amount' => $order->total,
            'status' => 'pending',
            'payment_method' => 'stripe',
            'transaction_id' => $session->id,
        ]);

        // Limpiar el carrito después de crear la sesión de Stripe
        $user->cartItems()->delete();

        return Inertia::location($session->url);
    } catch (ApiErrorException $e) {
        Log::error('Stripe API error: ' . $e->getMessage());
        // Revertir el stock
        foreach ($order->orderItems as $item) {
            $item->product->increaseStock($item->quantity, $item->size_id);
        }
        return redirect()->route('cart.index')->with('error', 'Error al procesar el pago: ' . $e->getMessage());
    }
}

    public function success(Request $request, Order $order)
    {
        $stripeSecret = env('STRIPE_SECRET');
        if (!$stripeSecret) {
            Log::error('STRIPE_SECRET is not set in .env');
            return redirect()->route('cart.index')->with('error', 'Error de configuración del servidor. Contacta con soporte.');
        }

        try {
            Stripe::setApiKey($stripeSecret);
            $session = Session::retrieve($request->query('session_id'));

            if ($session->payment_status === 'paid') {
                $order->update(['status' => 'completed']);

                $payment = Payment::where('order_id', $order->id)->first();
                $payment->update([
                    'status' => 'completed',
                    'transaction_id' => $session->payment_intent,
                ]);

                // Enviar correo de confirmación al usuario
                $user = Auth::user();
                Log::info('Enviando correo de confirmación para el pedido #' . $order->id, [
                    'user_id' => $user->id,
                    'user_email' => $user->email,
                    'order_id' => $order->id,
                    'user_address_id' => $order->user_address_id,
                    'userAddress_exists' => $order->userAddress ? true : false,
                ]);
                try {
                    if ($user->email) {
                        Mail::to($user->email)->send(new OrderConfirmationMail($order, $user));
                    } else {
                        Log::warning('Usuario sin correo para el pedido #' . $order->id, ['user_id' => $user->id]);
                    }
                } catch (\Exception $e) {
                    Log::error('Error al enviar el correo de confirmación del pedido #' . $order->id . ': ' . $e->getMessage());
                }

                // Limpiar el carrito
                CartItem::where('user_id', Auth::id())->delete();

                return Inertia::render('Checkout/Success', [
                    'order' => $order,
                ]);
            }

            // Revertir el stock
            foreach ($order->orderItems as $item) {
                $item->product->increaseStock($item->quantity, $item->size_id);
            }

            return redirect()->route('checkout.cancel', $order);
        } catch (ApiErrorException $e) {
            Log::error('Stripe API error in success: ' . $e->getMessage());
            // Revertir el stock
            foreach ($order->orderItems as $item) {
                $item->product->increaseStock($item->quantity, $item->size_id);
            }
            return redirect()->route('cart.index')->with('error', 'Error al verificar el pago: ' . $e->getMessage());
        }
    }

    public function cancel(Order $order)
    {
        $order->update(['status' => 'cancelled']);
        $payment = Payment::where('order_id', $order->id)->first();
        $payment->update(['status' => 'cancelled']);

        // Revertir el stock
        foreach ($order->orderItems as $item) {
            $item->product->increaseStock($item->quantity, $item->size_id);
        }

        return Inertia::render('Checkout/Cancel', [
            'order' => $order
        ]);
    }

    public function generateInvoicePdf(Order $order)
{
    $user = $order->user;
    
    $pdf = Pdf::loadView('invoices.invoice-pdf', [
        'order' => $order,
        'user' => $user
    ]);
    
    $pdf->setPaper('A4', 'portrait');
    
    return $pdf->stream('factura-' . $order->id . '.pdf');
}
}