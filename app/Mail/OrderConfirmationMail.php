<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Mail\Mailables\Attachment;
use Illuminate\Queue\SerializesModels;
use App\Models\Order;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

class OrderConfirmationMail extends Mailable
{
    use Queueable, SerializesModels;

    public $order;
    public $user;

    /**
     * Create a new message instance.
     */
    public function __construct(Order $order, $user)
    {
        $this->order = $order;
        $this->user = $user;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Confirmación de tu Pedido #' . $this->order->id . ' - TrendClothes',
            from: 'noreply@trendclothes.com'
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            markdown: 'emails.order-confirmation',
        );
    }

    /**
     * Get the attachments for the message.
     */
public function attachments(): array
{
    try {
        $pdf = Pdf::loadView('invoices.invoice-pdf', [
            'order' => $this->order,
            'user' => $this->user
        ]);

        $filename = 'factura-' . $this->order->id . '.pdf';

        // Guardar temporalmente para adjuntar
        $tempPath = storage_path('app/temp/' . $filename);
        if (!file_exists(dirname($tempPath))) {
            mkdir(dirname($tempPath), 0755, true);
        }
        $pdf->save($tempPath);

        return [
            Attachment::fromPath($tempPath)
                ->as($filename)
                ->withMime('application/pdf')
                ->withData(function () use ($tempPath) {
                    if (file_exists($tempPath)) {
                        unlink($tempPath);
                    }
                })
        ];

    } catch (\Exception $e) {
        Log::error('Error generando PDF para pedido #' . $this->order->id . ': ' . $e->getMessage());
        return [];
    }
}
}
