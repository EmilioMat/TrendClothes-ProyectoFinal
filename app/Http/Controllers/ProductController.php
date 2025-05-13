<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Size;
use App\Models\Product;
use App\Models\ProductImage; // Añade este modelo
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\Request;
use Illuminate\Support\Str; // Añade para manejar slugs
use Inertia\Inertia;

class ProductController extends Controller
{
    // Método para el panel de administración
    public function adminIndex()
    {
        $products = Product::with('category', 'size', 'product_images')->get();
        $categories = Category::all();
        $sizes = Size::all();

        return Inertia::render('Admin/Products/Index', [
            'products' => $products,
            'categories' => $categories,
            'sizes' => $sizes
        ]);
    }

    // Método para la tienda pública
    public function index(Request $request)
    {
        // Solo productos publicados
        $query = Product::where('published', true);

        // Filtros (mantén tu lógica actual)
        if ($request->has('genders') && !empty($request->genders)) {
            $query->whereIn('gender', explode(',', $request->genders));
        }

        // ... (si tienes más filtros, mantenlos aquí)

        $products = $query->get();

        return Inertia::render('Products/Index', [
            'products' => $products,
            'filters' => $request->only(['genders', 'categories', 'min_price', 'max_price', 'sort'])
        ]);
    }


    public function create()
    {
        $categories = Category::all();
        $sizes = Size::all();

        return Inertia::render('Admin/Products/Create', [
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
            'main_image' => 'required|image|max:2048',
            'images' => 'nullable|array', // Cambiado a 'images' para coincidir con el frontend
            'images.*' => 'image|max:2048',
        ]);

        // Guardar imagen principal
        $mainImagePath = $request->file('main_image')->store('products', 'public');

        $product = Product::create([
            'name' => $validated['name'],
            'description' => $validated['description'],
            'price' => $validated['price'],
            'stock' => $validated['stock'],
            'category_id' => $validated['category_id'],
            'size_id' => $validated['size_id'],
            'gender' => $validated['gender'],
            'color' => $validated['color'],
            'brand' => $validated['brand'],
            'main_image' => $mainImagePath,
        ]);

        // Guardar imágenes adicionales
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('products', 'public');
                $product->product_images()->create(['image_path' => $path]);
            }
        }

        return redirect()->route('admin.products.index')->with('success', 'Product created.');
    }

    // Añade estos métodos nuevos
    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

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
            'product_images' => 'nullable|array',
            'product_images.*' => 'image|max:2048',
        ]);

        // Actualiza los campos básicos
        $product->update($request->except(['main_image', 'product_images']));

        // Manejo de la imagen principal
        if ($request->hasFile('main_image')) {
            // Elimina la imagen anterior si existe
            if ($product->main_image) {
                Storage::disk('public')->delete($product->main_image);
            }

            $path = $request->file('main_image')->store('products', 'public');
            $product->update(['main_image' => $path]);
        }

        // Manejo de imágenes adicionales
        if ($request->hasFile('product_images')) {
            foreach ($request->file('product_images') as $image) {
                $path = $image->store('products', 'public');
                $product->product_images()->create(['image_path' => $path]);
            }
        }

        return redirect()->route('admin.products.index')->with('success', 'Product updated successfully.');
    }

    public function deleteImage($id)
    {
        ProductImage::where('id', $id)->delete();
        return redirect()->back()->with('success', 'Image deleted successfully.');
    }

    public function destroy($id)
    {
        Product::findOrFail($id)->delete();
        return redirect()->route('admin.products.index')->with('success', 'Product deleted successfully.');
    }

    public function show(Product $product)
    {
        $product->load(['category', 'size', 'product_images']);

        // Obtener todas las tallas disponibles para productos similares
        $availableSizes = Size::whereHas('products', function ($query) use ($product) {
            $query->where('category_id', $product->category_id)
                ->where('gender', $product->gender);
        })->pluck('name')->toArray();

        return Inertia::render('Products/Show', [
            'product' => [
                'id' => $product->id,
                'name' => $product->name,
                'slug' => $product->slug,
                'description' => $product->description,
                'price' => $product->price,
                'stock' => $product->stock,
                'gender' => $product->gender,
                'size' => $product->size->name,
                'sizes' => $availableSizes ?: [$product->size->name],
                'category' => $product->category->name,
                'main_image' => $product->main_image ? Storage::url($product->main_image) : null,
                'images' => $product->product_images->map(function ($image) {
                    return Storage::url($image->image_path);
                })->toArray(),
                'brand' => $product->brand,
                'color' => $product->color
            ]
        ]);
    }
    public function togglePublish($id)
    {
        $product = Product::findOrFail($id);
        $product->published = !$product->published;
        $product->save();

        return redirect()->back()->with('success', 'Product status updated');
    }
}
