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
            'main_image' => 'nullable|image|max:2048',
            'images' => 'nullable|array',
            'images.*' => 'image|max:2048',
        ]);

        // Prepare product data
        $productData = $validated;

        // Handle main_image
        if ($request->hasFile('main_image')) {
            $mainImagePath = $request->file('main_image')->store('product_images', 'public');
            $productData['main_image'] = $mainImagePath; // Store the path
        } else {
            $productData['main_image'] = null;
        }

        // Handle additional images
        $additionalImages = [];
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $imagePath = $image->store('product_images', 'public');
                $additionalImages[] = $imagePath; // Collect paths in an array
            }
        }
        $productData['images'] = json_encode($additionalImages); // Encode as JSON

        // Create the product
        $product = Product::create($productData);

        return redirect()->route('dashboard')->with('success', 'Producto creado exitosamente.');
    }

    public function index()
    {
        $products = Product::with(['category'])
            ->orderBy('created_at', 'desc')
            ->get();

        return Inertia::render('Products/Index', [
            'products' => $products->map(function ($product) {
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'slug' => $product->slug,
                    'description' => $product->description,
                    'price' => $product->price / 100,
                    'stock' => $product->stock,
                    'gender' => $product->gender,
                    'main_image' => $product->main_image ? asset('storage/' . $product->main_image) : null,
                    'images' => $product->images ? array_map(function ($imagePath) {
                        return asset('storage/' . $imagePath);
                    }, json_decode($product->images, true)) : [],
                    'category' => $product->category->name,
                ];
            })
        ]);
    }

    public function show(Product $product)
    {
        $product->load(['category', 'size']);

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
                'category' => $product->category->name,
                'main_image' => $product->main_image ? asset('storage/' . $product->main_image) : null,
                'images' => $product->images ? array_map(function ($imagePath) {
                    return asset('storage/' . $imagePath);
                }, json_decode($product->images, true)) : [],
            ]
        ]);
    }
}