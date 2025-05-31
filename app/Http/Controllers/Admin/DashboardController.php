<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Product;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;

class DashboardController extends Controller
{
    public function getMetrics()
    {
        return Inertia::render('Admin/Dashboard', [
            'totalUsers' => User::count(),
            'totalProducts' => Product::count(),
            'totalSales' => Order::where('status', 'completed')->count(),
            'totalIncome' => Order::where('status', 'completed')->sum('total'),
            'salesByDay' => $this->getSalesByDay(),
            'recentOrders' => $this->getRecentOrders(),
            'topProducts' => $this->getTopProducts(),
        ]);
    }

    protected function getSalesByDay()
    {
        $sales = Order::selectRaw('DAYNAME(created_at) as day, COUNT(*) as count, SUM(total) as total')
            ->where('status', 'completed')
            ->where('created_at', '>=', now()->subDays(7))
            ->groupBy('day')
            ->orderByRaw("FIELD(DAYNAME(created_at), 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')")
            ->get()
            ->map(function ($item) {
                $diasTraducidos = [
                    'Monday' => 'Lunes',
                    'Tuesday' => 'Martes',
                    'Wednesday' => 'Miércoles',
                    'Thursday' => 'Jueves',
                    'Friday' => 'Viernes',
                    'Saturday' => 'Sábado',
                    'Sunday' => 'Domingo',
                ];

                return [
                    'day' => $diasTraducidos[$item->day] ?? $item->day,
                    'count' => $item->count,
                    'total' => $item->total,
                ];
            })
            ->toArray();

        return $sales;
    }

protected function getRecentOrders()
{
    return Order::with('user')
        ->where('status', 'completed')
        ->latest()
        ->take(5)
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
}

    protected function getTopProducts()
    {
        return OrderItem::selectRaw('product_id, SUM(quantity) as total_sold')
            ->with('product')
            ->groupBy('product_id')
            ->orderByDesc('total_sold')
            ->take(5)
            ->get()
            ->map(function ($item) {
                return [
                    'product_id' => $item->product_id,
                    'product_name' => $item->product ? $item->product->name : 'Producto desconocido',
                    'total_sold' => $item->total_sold,
                ];
            })
            ->toArray();
    }
}