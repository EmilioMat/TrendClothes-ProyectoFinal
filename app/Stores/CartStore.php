<?php

namespace App\Stores;

use App\Models\CartItem;
use Illuminate\Support\Facades\Auth;

class CartStore
{
    public function getItems()
    {
        if (!Auth::check()) {
            return [];
        }

        return CartItem::where('user_id', Auth::id())
            ->with(['product' => function ($query) {
                $query->select('id', 'name', 'price', 'main_image'); // Ensure price is included
            }])
            ->get()
            ->map(function ($item) {
                return [
                    'product' => [
                        'id' => $item->product->id,
                        'name' => $item->product->name,
                        'price' => $item->product->price, // Explicitly include price
                        'main_image' => $item->product->main_image,
                    ],
                    'quantity' => $item->quantity,
                    'size' => $item->size,
                ];
            })->toArray();
    }

    public function addItem($product, $quantity = 1, $size = null)
    {
        if (!Auth::check()) {
            return;
        }

        $item = CartItem::where('user_id', Auth::id())
            ->where('product_id', $product->id)
            ->where('size', $size)
            ->first();

        if ($item) {
            $item->update(['quantity' => $item->quantity + $quantity]);
        } else {
            CartItem::create([
                'user_id' => Auth::id(),
                'product_id' => $product->id,
                'quantity' => $quantity,
                'size' => $size,
            ]);
        }
    }

    public function removeItem($itemId)
    {
        if (!Auth::check()) {
            return;
        }

        [$productId, $size] = explode('-', $itemId);
        CartItem::where('user_id', Auth::id())
            ->where('product_id', $productId)
            ->where('size', $size)
            ->delete();
    }

    public function updateQuantity($itemId, $quantity)
    {
        if (!Auth::check()) {
            return;
        }

        [$productId, $size] = explode('-', $itemId);
        $item = CartItem::where('user_id', Auth::id())
            ->where('product_id', $productId)
            ->where('size', $size)
            ->first();

        if ($item) {
            if ($quantity <= 0) {
                $item->delete();
            } else {
                $item->update(['quantity' => $quantity]);
            }
        }
    }

    public function getTotalPrice()
    {
        if (!Auth::check()) {
            return 0;
        }

        return CartItem::where('user_id', Auth::id())
            ->with('product')
            ->get()
            ->sum(function ($item) {
                return $item->product->price * $item->quantity;
            });
    }

    public function clear()
    {
        if (!Auth::check()) {
            return;
        }

        CartItem::where('user_id', Auth::id())->delete();
    }
}