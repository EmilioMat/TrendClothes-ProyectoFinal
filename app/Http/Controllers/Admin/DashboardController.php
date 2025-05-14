<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
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
            return [
                'day' => $item->day,
                'count' => $item->count,
                'total' => $item->total,
            ];
        })
        ->toArray();

    return $sales;
}

}
