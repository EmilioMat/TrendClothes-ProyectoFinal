<?php

namespace App\Http\Controllers;

use App\Models\Category;
use Inertia\Inertia;

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
                    'slug' => $category->slug,
                    'description' => $category->description,
                    'products_count' => $category->products_count,
                ];
            })
        ]);
    }

        public function show($slug)
        {
            $category = Category::where('slug', $slug)
                ->with(['products' => function ($query) {
                    $query->where('stock', '>', 0)
                        ->orderBy('created_at', 'desc');
                }])
                ->firstOrFail();

            return Inertia::render('Categories/Show', [
                'category' => [
                    'name' => $category->name,
                    'description' => $category->description,
                    'products' => $category->products->map(function ($product) {
                        // Decode images JSON if it exists, otherwise empty array
                        $imagesArray = $product->images ? json_decode($product->images, true) : [];
                        $mappedImages = array_map(function ($imagePath) {
                            return $imagePath ? asset('storage/' . $imagePath) : null;
                        }, $imagesArray);

                        return [
                            'id' => $product->id,
                            'name' => $product->name,
                            'slug' => $product->slug,
                            'description' => $product->description,
                            'price' => $product->price / 100, // Adjust price to match expected format
                            'main_image' => $product->main_image ? asset('storage/' . $product->main_image) : null,
                            'images' => $mappedImages,
                        ];
                    })
                ]
            ]);
        }
}