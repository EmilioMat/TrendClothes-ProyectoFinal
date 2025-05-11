<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Inertia\Inertia;
use Illuminate\Support\Facades\Log;

class CategoryController extends Controller
{
    public function index()
    {
        $categories = Category::withCount('products')->get();
        return Inertia::render('Categories/Index', [
            'categories' => $categories->map(function ($category) {
                return [
                    'id' => $category->id,
                    'name' => $category->name,
                    'slug' => $category->slug, // Ensure slug is included
                    'description' => $category->description,
                    'products_count' => $category->products_count,
                ];
            })
        ]);
    }

    public function show($slug)
    {
        try {
            $category = Category::where('slug', $slug)
                ->with(['products' => function($query) {
                    $query->where('stock', '>', 0)
                          ->orderBy('created_at', 'desc');
                }])
                ->firstOrFail();

            return Inertia::render('Categories/Show', [
                'category' => [
                    'name' => $category->name,
                    'description' => $category->description,
                    'products' => $category->products->map(function($product) {
                        return [
                            'id' => $product->id,
                            'name' => $product->name,
                            'description' => $product->description,
                            'price' => $product->price / 100,
                            'image' => $product->image_url ? asset('storage/' . $product->image_url) : null,
                        ];
                    })
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Error loading category: ' . $e->getMessage());
            return Inertia::render('Errors/404'); // Or handle the error appropriately
        }
    }
}