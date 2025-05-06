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
        ]);

        Product::create($validated);

        return redirect()->route('dashboard')->with('success', 'Product created successfully.');
    }
}