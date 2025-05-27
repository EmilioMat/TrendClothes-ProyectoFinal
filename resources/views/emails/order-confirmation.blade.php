{{-- order-confirmation.blade.php --}}
<x-mail::message>
{{-- Header personalizado --}}
<div style="text-align: center; margin-bottom: 30px;">
    <img src="{{ asset('images/logo-email.png') }}" alt="TrendClothes" style="max-width: 200px; height: auto;">
    <h1 style="color: #2563eb; font-size: 28px; margin: 20px 0 10px 0;">¡Pedido Confirmado!</h1>
    <p style="color: #6b7280; font-size: 16px;">Gracias por confiar en TrendClothes, {{ $user->name }}</p>
</div>

{{-- Información del pedido en panel destacado --}}
<x-mail::panel>
<div style="text-align: center;">
    <h2 style="color: #059669; margin: 0 0 10px 0;">Pedido #{{ $order->id }}</h2>
    <p style="margin: 5px 0; color: #374151;"><strong>Fecha:</strong> {{ $order->created_at->format('d/m/Y H:i') }}</p>
    <p style="margin: 5px 0; color: #374151;"><strong>Estado:</strong> <span style="color: #059669; font-weight: bold;">{{ ucfirst($order->status) }}</span></p>
    <p style="margin: 5px 0; color: #374151; font-size: 18px;"><strong>Total:</strong> <span style="color: #dc2626; font-weight: bold;">{{ number_format($order->total, 2) }} €</span></p>
</div>
</x-mail::panel>

## 📦 Resumen de tu Compra

<x-mail::table>
| Producto | Talla | Cantidad | Precio | Subtotal |
|:---------|:------|:--------:|-------:|---------:|
@foreach($order->orderItems as $item)
| **{{ $item->product->name }}** | {{ $item->size?->name ?? 'N/A' }} | {{ $item->quantity }} | {{ number_format($item->price, 2) }} € | **{{ number_format($item->price * $item->quantity, 2) }} €** |
@endforeach
| | | | **TOTAL** | **{{ number_format($order->total, 2) }} €** |
</x-mail::table>

## 🚚 Dirección de Envío

<x-mail::panel>
<div style="line-height: 1.6;">
    <strong>{{ $user->name }}</strong><br>
    {{ $order->userAddress->address }}<br>
    {{ $order->userAddress->city }}, {{ $order->userAddress->postal_code }}<br>
    {{ $order->userAddress->country }}
</div>
</x-mail::panel>

## 📋 Información Importante

- **Tu pedido está siendo procesado** y recibirás actualizaciones por email
- **Tiempo estimado de entrega:** 3-5 días laborables
- **Factura adjunta:** Encontrarás tu factura en PDF adjunta a este correo
- **También puedes descargar tu factura:** 
<x-mail::button :url="route('invoice.download', $order)" color="success">
    Descargar Factura PDF
</x-mail::button>
- **Seguimiento:** Pronto recibirás el código de seguimiento

---

<div style="text-align: center; margin: 30px 0;">
    <p style="color: #6b7280; font-size: 14px;">¿Necesitas ayuda? Contáctanos:</p>
    <p style="margin: 10px 0;">
        <a href="mailto:soporte@trendclothes.com" style="color: #2563eb;">📧 soporte@trendclothes.com</a><br>
        <span style="color: #6b7280;">📞 +34 900 123 456</span>
    </p>
</div>

<div style="text-align: center; padding: 20px; background-color: #f9fafb; border-radius: 8px; margin: 20px 0;">
    <p style="margin: 0; color: #6b7280; font-size: 12px;">
        Síguenos en redes sociales para las últimas tendencias<br>
        <a href="#" style="color: #2563eb; text-decoration: none;">Instagram</a> | 
        <a href="#" style="color: #2563eb; text-decoration: none;">Facebook</a> | 
        <a href="#" style="color: #2563eb; text-decoration: none;">Twitter</a>
    </p>
</div>

Gracias por elegir **TrendClothes**,<br>
El equipo de TrendClothes

<x-mail::subcopy>
Si tienes problemas con el botón "Ver Detalles del Pedido", copia y pega la siguiente URL en tu navegador: 
{{ url('/orders/' . $order->id) }}
</x-mail::subcopy>
</x-mail::message>

<?php