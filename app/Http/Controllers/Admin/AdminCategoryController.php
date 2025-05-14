<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;

class AdminCategoryController extends Controller
{
    // Listar categorías con paginación
    public function index(Request $request)
    {
        $query = Category::withCount('products')
            ->orderBy('created_at', 'desc');

        // Búsqueda
        if ($request->has('search') && !empty($request->search)) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        $categories = $query->paginate(6);

        return Inertia::render('Admin/Categories/Index', [
            'categories' => $categories,
            'filters' => $request->only(['search'])
        ]);
    }

    // Almacenar nueva categoría
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:categories,name',
            'description' => 'nullable|string',
        ]);

        $category = Category::create($validated);

        return redirect()->route('admin.categories.index')->with('success', 'Categoría creada correctamente');
    }

    // Actualizar categoría
    public function update(Request $request, $id)
    {
        $category = Category::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:categories,name,'.$category->id,
            'description' => 'nullable|string',
        ]);

        $category->update($validated);

        return redirect()->back()->with('success', 'Categoría actualizada correctamente');
    }

    // Eliminar categoría
    public function destroy($id)
    {
        $category = Category::findOrFail($id);
        
        // Verificar si hay productos asociados
        if ($category->products()->exists()) {
            return redirect()->back()
                ->with('error', 'No se puede eliminar la categoría porque tiene productos asociados');
        }

        $category->delete();
        
        return redirect()->route('admin.categories.index')->with('success', 'Categoría eliminada correctamente');
    }

    // Eliminar múltiples categorías
    public function deleteMultiple(Request $request)
    {
        $request->validate([
            'ids' => 'required|array',
            'ids.*' => 'exists:categories,id',
        ]);

        // Verificar que ninguna categoría tenga productos
        $categoriesWithProducts = Category::whereIn('id', $request->ids)
            ->whereHas('products')
            ->count();

        if ($categoriesWithProducts > 0) {
            return redirect()->back()
                ->with('error', 'No se pueden eliminar categorías que tienen productos asociados');
        }

        Category::whereIn('id', $request->ids)->delete();

        return redirect()->back()->with('success', 'Categorías eliminadas correctamente');
    }

    // Eliminar todas las categorías
    public function deleteAll()
    {
        // Verificar que no haya categorías con productos
        $categoriesWithProducts = Category::whereHas('products')->count();

        if ($categoriesWithProducts > 0) {
            return redirect()->back()
                ->with('error', 'No se pueden eliminar todas las categorías porque algunas tienen productos asociados');
        }

        Category::truncate();

        return redirect()->back()->with('success', 'Todas las categorías eliminadas correctamente');
    }
}