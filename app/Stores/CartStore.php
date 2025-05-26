<?php

namespace App\Stores;

use App\Models\CartItem;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class CartStore
{
public function getItems()
{
    if (!Auth::check()) {
        return [];
    }

    return CartItem::where('user_id', Auth::id())
        ->with(['product' => function ($query) {
            $query->select('id', 'name', 'price', 'main_image');
        }, 'size'])
        ->get()
        ->map(function ($item) {
            return [
                'product' => [
                    'id' => $item->product->id,
                    'name' => $item->product->name,
                    'price' => $item->product->price,
                    'main_image' => $item->product->main_image,
                    'main_image_url' => $item->product->main_image ? Storage::url($item->product->main_image) : null,
                ],
                'quantity' => $item->quantity,
                'size' => $item->size,
                'size_id' => $item->size_id,
            ];
        })->toArray();
}

public function addItem($product, $quantity = 1, $sizeId = null)
{
    if (!Auth::check()) {
        return;
    }

    $sizeName = $sizeId ? \App\Models\Size::find($sizeId)?->name : null;

    $item = CartItem::where('user_id', Auth::id())
        ->where('product_id', $product->id)
        ->where('size_id', $sizeId)
        ->first();

    if ($item) {
        $item->update(['quantity' => $item->quantity + $quantity]);
    } else {
        CartItem::create([
            'user_id' => Auth::id(),
            'product_id' => $product->id,
            'quantity' => $quantity,
            'size_id' => $sizeId,
            'size' => $sizeName,
        ]);
    }
}

public function removeItem($itemId)
{
    if (!Auth::check()) {
        return;
    }

    [$productId, $sizeId] = explode('-', $itemId);
    CartItem::where('user_id', Auth::id())
        ->where('product_id', $productId)
        ->where('size_id', $sizeId)
        ->delete();
}

public function updateQuantity($itemId, $quantity)
{
    if (!Auth::check()) {
        return;
    }

    [$productId, $sizeId] = explode('-', $itemId);
    $item = CartItem::where('user_id', Auth::id())
        ->where('product_id', $productId)
        ->where('size_id', $sizeId)
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