<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Size;
use Illuminate\Http\Request;
use Inertia\Inertia;

class AdminSizeController extends Controller
{
    // Listar tallas con paginación
    public function index(Request $request)
    {
        $query = Size::orderBy('created_at', 'desc');

        // Búsqueda
        if ($request->has('search') && !empty($request->search)) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        $sizes = $query->paginate(5);

        return Inertia::render('Admin/Sizes/Index', [
            'sizes' => $sizes,
            'filters' => $request->only(['search'])
        ]);
    }

    // Almacenar nueva talla
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:sizes,name',
        ]);

        Size::create($validated);

        return redirect()->route('admin.sizes.index')->with('success', 'Talla creada correctamente');
    }

    // Actualizar talla
    public function update(Request $request, $id)
    {
        $size = Size::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:sizes,name,' . $size->id,
        ]);

        $size->update($validated);

        return redirect()->back()->with('success', 'Talla actualizada correctamente');
    }

    // Eliminar talla
    public function destroy($id)
    {
        $size = Size::findOrFail($id);
        
        // Verificar si hay productos asociados
        if ($size->products()->exists()) {
            return redirect()->back()
                ->with('error', 'No se puede eliminar la talla porque tiene productos asociados');
        }

        $size->delete();
        
        return redirect()->route('admin.sizes.index')->with('success', 'Talla eliminada correctamente');
    }

    // Eliminar múltiples tallas
    public function deleteMultiple(Request $request)
    {
        $request->validate([
            'ids' => 'required|array',
            'ids.*' => 'exists:sizes,id',
        ]);

        // Verificar que ninguna talla tenga productos
        $sizesWithProducts = Size::whereIn('id', $request->ids)
            ->whereHas('products')
            ->count();

        if ($sizesWithProducts > 0) {
            return redirect()->back()
                ->with('error', 'No se pueden eliminar tallas que tienen productos asociados');
        }

        Size::whereIn('id', $request->ids)->delete();

        return redirect()->back()->with('success', 'Tallas eliminadas correctamente');
    }

    // Eliminar todas las tallas
     public function deleteAll()
    {
        // Verificar que no haya tallas con productos
        $sizesWithProducts = Size::whereHas('products')->count();

        if ($sizesWithProducts > 0) {
            return redirect()->back()
                ->with('error', 'No se pueden eliminar todas las tallas porque algunas tienen productos asociados');
        }

        // Usar delete() en lugar de truncate() para respetar las relaciones
        Size::whereDoesntHave('products')->delete();

        return redirect()->back()->with('success', 'Todas las tallas sin productos asociados eliminadas correctamente');
    }
}