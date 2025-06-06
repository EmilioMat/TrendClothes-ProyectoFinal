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
use Illuminate\Support\Facades\DB;


class ProductController extends Controller
{
    // Método para el panel de administración
    public function adminIndex(Request $request)
    {
        $query = Product::with(['category', 'sizes', 'product_images'])
            ->orderBy('created_at', 'desc');

        if ($request->has('search') && !empty($request->search)) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        $products = $query->paginate(6);

        $categories = Category::all();
        $sizes = Size::all();

        return Inertia::render('Admin/Products/Index', [
            'products' => $products,
            'categories' => $categories,
            'sizes' => $sizes,
            'filters' => $request->only(['search'])
        ]);
    }

    // Método para la tienda pública
    public function index(Request $request)
    {
        // Solo productos publicados
        $query = Product::where('published', true);

        $products = $query->get();

        return Inertia::render('Products/Index', [
            'products' => $products,
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
            'category_id' => 'required|exists:categories,id',
            'gender' => 'required|in:male,female,unisex',
            'color' => 'nullable|string|max:100',
            'brand' => 'nullable|string|max:100',
            'main_image' => 'required|image',
            'product_images.*' => 'nullable|image',
            'sizes' => 'required|array|min:1',
            'sizes.*.size_id' => 'required|exists:sizes,id',
            'sizes.*.stock' => 'required|integer|min:0'
        ]);

        // Guardar el producto
        $productData = $request->only([
            'name',
            'description',
            'price',
            'category_id',
            'gender',
            'color',
            'brand'
        ]);

        // Manejar la imagen principal
        if ($request->hasFile('main_image')) {
            $path = $request->file('main_image')->store('products', 'public');
            $productData['main_image'] = $path;
        }

        $product = Product::create($productData);

        // Guardar imágenes adicionales
        if ($request->hasFile('product_images')) {
            foreach ($request->file('product_images') as $image) {
                $path = $image->store('product_images', 'public');
                $product->product_images()->create(['image_path' => $path]);
            }
        }

        // Guardar tallas con stock
        $sizesToAttach = [];
        foreach ($request->input('sizes') as $size) {
            $sizesToAttach[$size['size_id']] = ['stock' => $size['stock']];
        }
        $product->sizes()->sync($sizesToAttach);

        return redirect()->route('admin.products.index')
            ->with('success', 'Producto creado exitosamente');
    }

    public function update(Request $request, $id)
    {
        $product = Product::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'category_id' => 'required|exists:categories,id',
            'gender' => 'required|in:male,female,unisex',
            'color' => 'nullable|string|max:100',
            'brand' => 'nullable|string|max:100',
            'main_image' => 'nullable|image',
            'product_images.*' => 'nullable|image',
            'sizes' => 'required|array',
            'sizes.*.size_id' => 'required|exists:sizes,id',
            'sizes.*.stock' => 'required|integer|min:0'
        ]);

        // Actualizar campos básicos
        $product->update($request->only([
            'name',
            'description',
            'price',
            'category_id',
            'gender',
            'color',
            'brand'
        ]));

        // Actualizar imagen principal si se proporciona
        if ($request->hasFile('main_image')) {
            // Eliminar imagen anterior si existe
            if ($product->main_image) {
                Storage::delete($product->main_image);
            }
            $path = $request->file('main_image')->store('products', 'public');
            $product->main_image = $path;
            $product->save();
        }

        // Manejar imágenes adicionales
        if ($request->hasFile('product_images')) {
            foreach ($request->file('product_images') as $image) {
                $path = $image->store('product_images', 'public');
                $product->product_images()->create(['image_path' => $path]);
            }
        }

        // Sincronizar tallas con stock
        $sizesToSync = [];
        foreach ($request->input('sizes') as $size) {
            $sizesToSync[$size['size_id']] = ['stock' => $size['stock']];
        }
        $product->sizes()->sync($sizesToSync);

        return redirect()->route('admin.products.index')
            ->with('success', 'Producto actualizado exitosamente');
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
    $product->load(['category', 'sizes', 'product_images']);
    
    return Inertia::render('Products/Show', [
        'product' => [
            'id' => $product->id,
            'name' => $product->name,
            'description' => $product->description,
            'price' => $product->price,
            'category' => $product->category->name,
            'gender' => $product->gender,
            'brand' => $product->brand,
            'color' => $product->color,
            'main_image' => $product->main_image ? Storage::url($product->main_image) : null,
            'images' => $product->product_images->map(function ($image) {
                return Storage::url($image->image_path);
            }),
             'sizes' => $product->sizes->map(function ($size) {
                return [
                    'id' => $size->id,
                    'name' => $size->name,
                    'pivot' => ['stock' => $size->pivot->stock]
                ];
            }), 
            'stock' => $product->stock
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


    public function deleteMultiple(Request $request)
    {
        $request->validate([
            'ids' => 'required|array',
            'ids.*' => 'exists:products,id',
        ]);

        Product::whereIn('id', $request->ids)->delete();

        return redirect()->back()->with('success', 'Productos eliminados correctamente');
    }

public function deleteAll()
{
    // Borrar primero las relaciones dependientes
    DB::table('order_items')->delete();

    // Luego borrar los productos
    Product::query()->delete();

    // (Opcional) Reiniciar el ID auto-incremental
    DB::statement('ALTER TABLE products AUTO_INCREMENT = 1');

    return redirect()->back()->with('success', 'Todos los productos y sus relaciones fueron eliminados correctamente');
}
}
