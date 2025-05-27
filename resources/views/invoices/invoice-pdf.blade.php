<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Factura #{{ $order->id }}</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'DejaVu Sans', Arial, sans-serif;
            font-size: 12px;
            line-height: 1.6;
            color: #333;
            background: #fff;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px;
        }
        
        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
            padding-bottom: 20px;
            border-bottom: 3px solid #2563eb;
        }
        
        .logo-section h1 {
            font-size: 28px;
            font-weight: bold;
            color: #2563eb;
            margin-bottom: 5px;
        }
        
        .logo-section p {
            color: #6b7280;
            font-size: 14px;
        }
        
        .invoice-info {
            text-align: right;
        }
        
        .invoice-number {
            font-size: 24px;
            font-weight: bold;
            color: #1f2937;
            margin-bottom: 5px;
        }
        
        .invoice-date {
            color: #6b7280;
            font-size: 12px;
        }
        
        /* Info Section */
        .info-section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 40px;
        }
        
        .bill-to, .ship-to {
            width: 48%;
        }
        
        .section-title {
            font-size: 14px;
            font-weight: bold;
            color: #374151;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .info-box {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #2563eb;
        }
        
        /* Table */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .items-table thead {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: white;
        }
        
        .items-table th {
            padding: 12px 8px;
            text-align: left;
            font-weight: 600;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .items-table td {
            padding: 12px 8px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 11px;
        }
        
        .items-table tbody tr:nth-child(even) {
            background: #f9fafb;
        }
        
        .items-table tbody tr:hover {
            background: #f3f4f6;
        }
        
        .text-right {
            text-align: right;
        }
        
        .text-center {
            text-align: center;
        }
        
        .font-semibold {
            font-weight: 600;
        }
        
        /* Totals */
        .totals-section {
            margin: 30px 0;
            display: flex;
            justify-content: flex-end;
        }
        
        .totals-table {
            width: 300px;
            border-collapse: collapse;
        }
        
        .totals-table td {
            padding: 8px 12px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .totals-table .total-row {
            background: #2563eb;
            color: white;
            font-weight: bold;
            font-size: 14px;
        }
        
        .totals-table .subtotal-row {
            background: #f3f4f6;
            font-weight: 500;
        }
        
        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-completed {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        /* Footer */
        .footer {
            margin-top: 50px;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
            text-align: center;
        }
        
        .footer-content {
            background: #f9fafb;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .footer h3 {
            color: #2563eb;
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .footer p {
            color: #6b7280;
            font-size: 11px;
            margin: 5px 0;
        }
        
        .contact-info {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin: 15px 0;
        }
        
        .contact-item {
            font-size: 10px;
            color: #374151;
        }
        
        /* Utilities */
        .mb-2 { margin-bottom: 8px; }
        .mb-4 { margin-bottom: 16px; }
        .text-sm { font-size: 11px; }
        .text-gray { color: #6b7280; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div class="logo-section">
                <h1>TrendClothes</h1>
                <p>Moda y estilo para todos</p>
                <p class="text-sm text-gray">www.trendclothes.com</p>
            </div>
            
            <div class="invoice-info">
                <div class="invoice-number">FACTURA #{{ $order->id }}</div>
                <div class="invoice-date">{{ $order->created_at->format('d/m/Y H:i') }}</div>
                <div style="margin-top: 10px;">
                    <span class="status-badge status-{{ $order->status }}">
                        {{ ucfirst($order->status) }}
                    </span>
                </div>
            </div>
        </div>
        
        <!-- Info Section -->
        <div class="info-section">
            <div class="bill-to">
                <div class="section-title">Facturar a:</div>
                <div class="info-box">
                    <div class="font-semibold mb-2">{{ $user->name }}</div>
                    <div class="text-sm text-gray">{{ $user->email }}</div>
                    @if($user->phone)
                    <div class="text-sm text-gray">{{ $user->phone }}</div>
                    @endif
                </div>
            </div>
            
            <div class="ship-to">
                <div class="section-title">Enviar a:</div>
                <div class="info-box">
                    <div class="font-semibold mb-2">{{ $user->name }}</div>
                    <div class="text-sm">
                        {{ $order->userAddress->address ?? 'N/A' }}<br>
                        {{ $order->userAddress->postal_code ?? '' }} {{ $order->userAddress->city ?? '' }}<br>
                        {{ $order->userAddress->country ?? '' }}
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 40%;">Producto</th>
                    <th style="width: 15%;" class="text-center">Talla</th>
                    <th style="width: 15%;" class="text-center">Cantidad</th>
                    <th style="width: 15%;" class="text-right">Precio Unit.</th>
                    <th style="width: 15%;" class="text-right">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                @foreach($order->orderItems as $item)
                <tr>
                    <td>
                        <div class="font-semibold">{{ $item->product->name }}</div>
                        @if($item->product->description)
                        <div class="text-sm text-gray">{{ Str::limit($item->product->description, 100) }}</div>
                        @endif
                    </td>
                    <td class="text-center">{{ $item->size?->name ?? 'N/A' }}</td>
                    <td class="text-center">{{ $item->quantity }}</td>
                    <td class="text-right">{{ number_format($item->price, 2) }} €</td>
                    <td class="text-right font-semibold">{{ number_format($item->price * $item->quantity, 2) }} €</td>
                </tr>
                @endforeach
            </tbody>
        </table>
        
        <!-- Totals -->
        <div class="totals-section">
            <table class="totals-table">
                <tr class="subtotal-row">
                    <td>Subtotal</td>
                    <td class="text-right">{{ number_format($order->total, 2) }} €</td>
                </tr>
                <tr>
                    <td>Envío</td>
                    <td class="text-right">0,00 €</td>
                </tr>
                <tr>
                    <td>IVA (21%)</td>
                    <td class="text-right">{{ number_format($order->total * 0.21, 2) }} €</td>
                </tr>
                <tr class="total-row">
                    <td>TOTAL</td>
                    <td class="text-right">{{ number_format($order->total * 1.21, 2) }} €</td>
                </tr>
            </table>
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <div class="footer-content">
                <h3>¡Gracias por tu compra!</h3>
                <p>Tu pedido será procesado en las próximas 24 horas.</p>
                <p>Recibirás un email con el código de seguimiento cuando tu pedido sea enviado.</p>
                
                <div class="contact-info">
                    <div class="contact-item">
                        <strong>Email:</strong> soporte@trendclothes.com
                    </div>
                    <div class="contact-item">
                        <strong>Teléfono:</strong> +34 900 123 456
                    </div>
                    <div class="contact-item">
                        <strong>Horario:</strong> L-V 9:00-18:00
                    </div>
                </div>
            </div>
            
            <p class="text-sm text-gray">
                Esta factura ha sido generada automáticamente por el sistema TrendClothes.<br>
                Para cualquier consulta, no dudes en contactar con nuestro equipo de soporte.
            </p>
        </div>
    </div>
</body>
</html>