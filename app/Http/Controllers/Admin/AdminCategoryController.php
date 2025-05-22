<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\DB;

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

        $categories = $query->paginate(5);

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

        Category::create($validated);

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

    public function destroy($id)
    {
        $category = Category::findOrFail($id);

        if ($category->products()->exists()) {
            return redirect()->back()->with('error', 'No se puede eliminar la categoría porque tiene productos asociados');
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

        Category::whereIn('id', $request->ids)->delete();

        return redirect()->back()->with('success', 'Categorías eliminadas correctamente');
    }

    public function deleteAll()
    {
        $categoriesWithProducts = Category::whereHas('products')->count();

        if ($categoriesWithProducts > 0) {
            return redirect()->back()->with('error', 'No se pueden eliminar todas las categorías porque algunas tienen productos asociados');
        }

        Category::query()->delete();
        DB::statement('ALTER TABLE categories AUTO_INCREMENT = 1');

        return redirect()->back()->with('success', 'Todas las categorías eliminadas correctamente');
    }
}