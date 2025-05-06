<?php
namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Size;
use App\Models\Product;
use App\Models\ProductImage;
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

        $productData = $validated;

        // Create the product
        $product = Product::create($productData);

        // Handle main image
        if ($request->hasFile('main_image')) {
            $mainImagePath = $request->file('main_image')->store('product_images', 'public');
            ProductImage::create([
                'product_id' => $product->id,
                'image_path' => $mainImagePath,
                'is_main' => true,
            ]);
        }

        // Handle additional images
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $imagePath = $image->store('product_images', 'public');
                ProductImage::create([
                    'product_id' => $product->id,
                    'image_path' => $imagePath,
                    'is_main' => false,
                ]);
            }
        }

        return redirect()->route('dashboard')->with('success', 'Product created successfully.');
    }
}