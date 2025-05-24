<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;

class AdminCategoryController extends Controller
{
    public function index(Request $request)
    {
        $query = Category::withCount('products')
            ->orderBy('created_at', 'desc');

        if ($request->has('search') && !empty($request->search)) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        $categories = $query->paginate(5);

        return Inertia::render('Admin/Categories/Index', [
            'categories' => $categories,
            'filters' => $request->only(['search'])
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                'unique:categories,name',
                'regex:/^[a-zA-Z0-9\sáéíóúÁÉÍÓÚñÑ\-]+$/u'
            ],
            'description' => [
                'nullable',
                'string',
                'max:1000',
                'regex:/^[a-zA-Z0-9\sáéíóúÁÉÍÓÚñÑ\-.,;:!?¿¡()]+$/u'
            ],
            'image' => [
                'required', // Changed to required for new categories
                'image',
                'mimes:jpeg,png,jpg,gif,webp',
                'max:2048'
            ]
        ], [
            'name.required' => 'El nombre es obligatorio',
            'name.regex' => 'El nombre solo puede contener letras, números y guiones',
            'name.unique' => 'El nombre ya está en uso',
            'description.regex' => 'La descripción contiene caracteres no permitidos',
            'image.required' => 'La imagen es obligatoria',
            'image.image' => 'El archivo debe ser una imagen válida',
            'image.mimes' => 'Formatos permitidos: jpeg, png, jpg, gif, webp',
            'image.max' => 'La imagen no debe superar los 2MB'
        ]);

        $category = new Category();
        $category->name = $validated['name'];
        $category->description = $validated['description'];

        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('categories', 'public');
            Log::info('Image stored at: ' . storage_path('app/public/' . $path));
            $category->image = $path; // Store as categories/filename
        }

        $category->save();

        return redirect()->route('admin.categories.index')
            ->with('success', 'Categoría creada correctamente');
    }

    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                'unique:categories,name,' . $category->id,
                'regex:/^[a-zA-Z0-9\sáéíóúÁÉÍÓÚñÑ\-]+$/u'
            ],
            'description' => [
                'nullable',
                'string',
                'max:1000',
                'regex:/^[a-zA-Z0-9\sáéíóúÁÉÍÓÚñÑ\-.,;:!?¿¡()]+$/u'
            ],
            'image' => [
                'nullable',
                'image',
                'mimes:jpeg,png,jpg,gif,webp',
                'max:2048'
            ]
        ], [
            'name.required' => 'El nombre es obligatorio',
            'name.regex' => 'El nombre solo puede contener letras, números y guiones',
            'name.unique' => 'El nombre ya está en uso',
            'description.regex' => 'La descripción contiene caracteres no permitidos',
            'image.image' => 'El archivo debe ser una imagen válida',
            'image.mimes' => 'Formatos permitidos: jpeg, png, jpg, gif, webp',
            'image.max' => 'La imagen no debe superar los 2MB'
        ]);

        $category->name = $validated['name'];
        $category->description = $validated['description'];

        if ($request->hasFile('image')) {
            if ($category->image) {
                Storage::disk('public')->delete($category->image);
                Log::info('Deleted old image: ' . $category->image);
            }
            $path = $request->file('image')->store('categories', 'public');
            Log::info('Image updated at: ' . storage_path('app/public/' . $path));
            $category->image = $path; // Store as categories/filename
        }

        $category->save();

        return redirect()->route('admin.categories.index')
            ->with('success', 'Categoría actualizada correctamente');
    }

    public function destroy($id)
    {
        $category = Category::findOrFail($id);

        if ($category->products()->exists()) {
            return redirect()->back()->with('error', 'No se puede eliminar la categoría porque tiene productos asociados');
        }

        if ($category->image) {
            Storage::disk('public')->delete($category->image);
            Log::info('Deleted image: ' . $category->image);
        }

        $category->delete();

        return redirect()->back()->with('success', 'Categoría eliminada correctamente');
    }

    public function deleteMultiple(Request $request)
    {
        $request->validate([
            'ids' => 'required|array',
            'ids.*' => 'exists:categories,id',
        ]);

        $categoriesWithProducts = Category::whereIn('id', $request->ids)
            ->whereHas('products')
            ->count();

        if ($categoriesWithProducts > 0) {
            return redirect()->back()->with('error', 'No se pueden eliminar categorías que tienen productos asociados');
        }

        $categories = Category::whereIn('id', $request->ids)->get();
        foreach ($categories as $category) {
            if ($category->image) {
                Storage::disk('public')->delete($category->image);
                Log::info('Deleted image: ' . $category->image);
            }
            $category->delete();
        }

        return redirect()->back()->with('success', 'Categorías eliminadas correctamente');
    }

    public function deleteAll()
    {
        $categoriesWithProducts = Category::whereHas('products')->count();

        if ($categoriesWithProducts > 0) {
            return redirect()->back()->with('error', 'No se pueden eliminar todas las categorías porque algunas tienen productos asociados');
        }

        $categories = Category::all();
        foreach ($categories as $category) {
            if ($category->image) {
                Storage::disk('public')->delete($category->image);
                Log::info('Deleted image: ' . $category->image);
            }
            $category->delete();
        }

        DB::statement('ALTER TABLE categories AUTO_INCREMENT = 1');

        return redirect()->back()->with('success', 'Todas las categorías eliminadas correctamente');
    }
}