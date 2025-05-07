<?php
namespace App\Http\Controllers;

use App\Models\Category;
use Inertia\Inertia;

class CategoryController extends Controller
{
    // Mostrar todas las categorías
    public function index()
    {
        $categories = Category::all();
        return Inertia::render('Categories/Index', [
            'categories' => $categories
        ]);
    }

    // Mostrar productos de una categoría específica
    public function show(Category $category)
    {
        $category->load('products'); // Cargar los productos relacionados
        return Inertia::render('Categories/Show', [
            'category' => $category
        ]);
    }
}

