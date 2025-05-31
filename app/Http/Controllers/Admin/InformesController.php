<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use Inertia\Inertia;

class InformesController extends Controller
{
    public function index()
    {
        $orders = Order::with('user')
            ->latest()
            ->get()
            ->map(function ($order) {
                $statusTraducidos = [
                    'completed' => 'Completado',
                    'pending' => 'Pendiente',
                    'cancelled' => 'Cancelado',
                ];

                return [
                    'id' => $order->id,
                    'user_name' => $order->user ? $order->user->name : 'Usuario desconocido',
                    'total' => $order->total,
                    'created_at' => $order->created_at->format('d/m/Y H:i'),
                    'status' => $statusTraducidos[$order->status] ?? $order->status,
                ];
            })
            ->toArray();

        return Inertia::render('Admin/Informes/Index', [
            'orders' => $orders,
        ]);
    }
}