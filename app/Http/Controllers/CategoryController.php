<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\Size;
use Illuminate\Http\Request;
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

public function show(Request $request, $slug)
{
    $category = Category::where('slug', $slug)->firstOrFail();

    // Convertir parámetros de filtro a array si son strings o null
    $filters = [
        'colors' => is_array($request->colors) ? $request->colors : (is_string($request->colors) ? explode(',', $request->colors) : []),
        'genders' => is_array($request->genders) ? $request->genders : (is_string($request->genders) ? explode(',', $request->genders) : []),
        'sizes' => is_array($request->sizes) ? $request->sizes : (is_string($request->sizes) ? explode(',', $request->sizes) : []),
        'brands' => is_array($request->brands) ? $request->brands : (is_string($request->brands) ? explode(',', $request->brands) : []),
        'price_min' => $request->price_min ? (float) $request->price_min : null,
        'price_max' => $request->price_max ? (float) $request->price_max : null,
        'sort' => $request->sort,
    ];

    // Obtener el valor de per_page del frontend (por defecto 9)
    $perPage = $request->input('per_page', 9);

    // Obtener productos con filtros aplicados
    $productsQuery = Product::with(['category', 'product_images', 'sizes'])
        ->select('products.*') // Explicitly select product columns
        ->where('published', true)
        ->where('category_id', $category->id)
        ->whereHas('sizes', function ($query) {
            $query->where('stock', '>', 0);
        })
        ->filtered($filters)
        ->distinct(); // Ensure unique products

    // Obtener valores únicos para los filtros
    $filterValues = [
        'colors' => Product::where('published', true)
            ->where('category_id', $category->id)
            ->whereHas('sizes', fn($q) => $q->where('stock', '>', 0))
            ->select('color')
            ->distinct()
            ->pluck('color')
            ->filter()
            ->values(),

        'genders' => Product::where('published', true)
            ->where('category_id', $category->id)
            ->whereHas('sizes', fn($q) => $q->where('stock', '>', 0))
            ->select('gender')
            ->distinct()
            ->pluck('gender')
            ->filter()
            ->values(),

        'sizes' => Size::whereHas('products', function ($query) use ($category) {
            $query->where('published', true)
                ->where('category_id', $category->id)
                ->whereHas('sizes', fn($q) => $q->where('stock', '>', 0));
        })->pluck('name', 'id'),

        'brands' => Product::where('published', true)
            ->where('category_id', $category->id)
            ->whereHas('sizes', fn($q) => $q->where('stock', '>', 0))
            ->select('brand')
            ->distinct()
            ->pluck('brand')
            ->filter()
            ->values(),

        'priceRange' => [
            'min' => Product::where('published', true)
                ->where('category_id', $category->id)
                ->whereHas('sizes', fn($q) => $q->where('stock', '>', 0))
                ->min('price') ?? 0,

            'max' => Product::where('published', true)
                ->where('category_id', $category->id)
                ->whereHas('sizes', fn($q) => $q->where('stock', '>', 0))
                ->max('price') ?? 1000,
        ],
    ];

    // Paginación y transformación de productos
    $products = $productsQuery->paginate($perPage)->through(function ($product) {
        return [
            'id' => $product->id,
            'name' => $product->name,
            'slug' => $product->slug,
            'description' => $product->description,
            'price' => $product->price,
            'main_image' => $product->main_image ? asset('storage/' . $product->main_image) : null,
            'product_images' => $product->product_images->map(fn($image) => [
                'image_path' => $image->image_path ? asset('storage/' . $image->image_path) : null,
                'is_main' => $image->is_main,
            ])->toArray(),
            'sizes' => $product->sizes->map(fn($size) => [
                'id' => $size->id,
                'name' => $size->name,
                'stock' => $size->pivot->stock,
            ])->toArray(),
        ];
    });

    return Inertia::render('Categories/Show', [
        'category' => [
            'name' => $category->name,
            'description' => $category->description,
            'slug' => $category->slug,
        ],
        'products' => $products,
        'filterValues' => $filterValues,
        'filters' => $filters,
    ]);
}
}