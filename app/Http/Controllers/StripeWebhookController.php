<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Stripe\Stripe;
use Stripe\Webhook;
use App\Models\Payment;
use Illuminate\Support\Facades\Log;

class StripeWebhookController extends Controller
{
    public function handleWebhook(Request $request)
    {
        Stripe::setApiKey(env('STRIPE_SECRET'));

        $payload = $request->getContent();
        $sig_header = $request->header('Stripe-Signature');
        $event = null;

        try {
            $event = Webhook::constructEvent(
                $payload,
                $sig_header,
                env('STRIPE_WEBHOOK_SECRET')
            );
        } catch (\Exception $e) {
            Log::error('Stripe webhook error: ' . $e->getMessage());
            return response()->json(['error' => 'Invalid signature'], 403);
        }

        switch ($event->type) {
            case 'payment_intent.succeeded':
                $paymentIntent = $event->data->object;
                $this->handlePaymentSucceeded($paymentIntent);
                break;

            case 'payment_intent.payment_failed':
                $paymentIntent = $event->data->object;
                $this->handlePaymentFailed($paymentIntent);
                break;

                // Agrega más casos según necesites
        }

        return response()->json(['status' => 'success']);
    }


    protected function handlePaymentSucceeded($paymentIntent)
    {
        $payment = Payment::where('transaction_id', $paymentIntent->id)->firstOrFail();

        $payment->update([
            'status' => 'completed',
            'transaction_id' => $paymentIntent->id,
        ]);

        $payment->order->update(['status' => 'completed']);
    } 

    protected function handlePaymentFailed($paymentIntent)
    {
        $payment = Payment::where('transaction_id', $paymentIntent->id)->firstOrFail();

        $payment->update([
            'status' => 'failed',
            'transaction_id' => $paymentIntent->id,
        ]);

        $payment->order->update(['status' => 'failed']);
    }
}
 