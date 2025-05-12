<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Size;
use App\Models\Product;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ProductController extends Controller
{
    public function create()
    {
        $categories = Category::all();
        $sizes = Size::all();

        return Inertia::render('Products/Create', [
            'categories' => $categories,
            'sizes' => $sizes,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'category_id' => 'required|exists:categories,id',
            'size_id' => 'required|exists:sizes,id',
            'gender' => 'required|in:male,female,unisex',
            'color' => 'nullable|string|max:255',
            'brand' => 'nullable|string|max:255',
            'main_image' => 'nullable|image|max:2048',
            'images' => 'nullable|array',
            'images.*' => 'image|max:2048',
        ]);

        // Prepare product data
        $productData = $validated;

        // Handle main_image
        if ($request->hasFile('main_image')) {
            $mainImagePath = $request->file('main_image')->store('product_images', 'public');
            $productData['main_image'] = $mainImagePath;
        } else {
            $productData['main_image'] = null;
        }

        // Handle additional images
        $additionalImages = [];
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $imagePath = $image->store('product_images', 'public');
                $additionalImages[] = $imagePath;
            }
        }
        $productData['images'] = json_encode($additionalImages);

        // Create the product
        $product = Product::create($productData);

        return redirect()->route('dashboard')->with('success', 'Producto creado exitosamente.');
    }

    public function index(Request $request)
    {
        $query = Product::query();
        
        // Filtro por género
        if ($request->has('genders') && !empty($request->genders)) {
            $query->whereIn('gender', explode(',', $request->genders));
        }
        
        // Filtro por categoría
        if ($request->has('categories') && !empty($request->categories)) {
            $query->whereIn('category', explode(',', $request->categories));
        }
        
        // Filtro por precio
        if ($request->has('min_price')) {
            $query->where('price', '>=', $request->min_price);
        }
        
        if ($request->has('max_price')) {
            $query->where('price', '<=', $request->max_price);
        }
        
        // Ordenación
        $sortOptions = [
            'price-asc' => ['price', 'asc'],
            'price-desc' => ['price', 'desc'],
            'name-asc' => ['name', 'asc'],
            'name-desc' => ['name', 'desc'],
        ];
        
        $sort = $request->get('sort', 'price-asc');
        $sortOption = $sortOptions[$sort] ?? $sortOptions['price-asc'];
        
        $query->orderBy($sortOption[0], $sortOption[1]);
        
        $products = $query->get();
        
        return Inertia::render('Products/Index', [
            'products' => $products,
            'filters' => $request->only(['genders', 'categories', 'min_price', 'max_price', 'sort'])
        ]);
    }

public function show(Product $product)
{
    $product->load(['category', 'size']);

    // Obtener todas las tallas disponibles para productos similares
    $availableSizes = Size::whereHas('products', function($query) use ($product) {
        $query->where('category_id', $product->category_id)
              ->where('gender', $product->gender);
    })->pluck('name')->toArray();

    return Inertia::render('Products/Show', [
        'product' => [
            'id' => $product->id,
            'name' => $product->name,
            'slug' => $product->slug,
            'description' => $product->description,
            'price' => $product->price / 100,
            'stock' => $product->stock,
            'gender' => $product->gender,
            'size' => $product->size->name,
            'sizes' => $availableSizes ?: [$product->size->name], // Usar tallas disponibles o la talla actual
            'category' => $product->category->name,
            'main_image' => $product->main_image ? asset('storage/' . $product->main_image) : null,
            'images' => $product->images ? array_map(function ($imagePath) {
                return asset('storage/' . $imagePath);
            }, json_decode($product->images, true)) : [],
        ]
    ]);
}
}