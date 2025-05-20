<?php

use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\AdminCategoryController;
use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\AdminSizeController;
use App\Http\Controllers\Admin\AdminUserController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\CartController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProfileController;
use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

// Rutas públicas
Route::get('/', function () {
    return Inertia::render('Home', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
        'flash' => session()->only(['success', 'error']),
    ]);
})->name('home');

// Rutas de autenticación de usuario normal
Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::post('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
    Route::post('/profile/avatar', [ProfileController::class, 'updateAvatar'])->name('profile.avatar.update');
});

// Rutas públicas de productos y carrito
Route::get('/carrito', [CartController::class, 'index'])->name('cart.index');
Route::get('/categories', [CategoryController::class, 'index'])->name('categories.index');
Route::get('/categories/{category:slug}', [CategoryController::class, 'show'])->name('categories.show');
Route::get('/products', [ProductController::class, 'index'])->name('products.index');
Route::get('/products/{product:slug}', [ProductController::class, 'show'])->name('products.show');

// Rutas de autenticación de administrador
Route::group(['prefix' => 'admin', 'middleware' => 'redirectAdmin'], function () {
    Route::get('login', [AdminAuthController::class, 'showLoginForm'])->name('admin.login');
    Route::post('login', [AdminAuthController::class, 'login'])->name('admin.login.post');
    Route::post('logout', [AdminAuthController::class, 'logout'])->name('admin.logout');
});

// Rutas protegidas de administrador
Route::middleware(['auth', 'admin'])->prefix('admin')->group(function () {
    Route::get('/dashboard', [AdminController::class, 'index'])->name('admin.dashboard');

    // Productos
    Route::get('/products', [ProductController::class, 'adminIndex'])->name('admin.products.index');
    Route::get('/products/create', [ProductController::class, 'create'])->name('admin.products.create');
    Route::post('/products/store', [ProductController::class, 'store'])->name('admin.products.store');
    Route::post('/products/update/{id}', [ProductController::class, 'update'])->name('admin.products.update');
    Route::delete('/products/image/{id}', [ProductController::class, 'deleteImage'])->name('admin.products.image.delete');
    Route::delete('/products/destroy/{id}', [ProductController::class, 'destroy'])->name('admin.products.destroy');
    Route::post('/products/{id}/toggle-publish', [ProductController::class, 'togglePublish'])->name('admin.products.toggle-publish');
    Route::post('/products/delete-multiple', [ProductController::class, 'deleteMultiple'])->name('admin.products.delete-multiple');
    Route::post('/products/delete-all', [ProductController::class, 'deleteAll'])->name('admin.products.delete-all');
    Route::get('/dashboard', [DashboardController::class, 'getMetrics'])->name('admin.dashboard');

    // Categorías
    Route::get('/categories', [AdminCategoryController::class, 'index'])->name('admin.categories.index');
    Route::post('/categories/store', [AdminCategoryController::class, 'store'])->name('admin.categories.store');
    Route::post('/categories/update/{id}', [AdminCategoryController::class, 'update'])->name('admin.categories.update');
    Route::delete('/categories/destroy/{id}', [AdminCategoryController::class, 'destroy'])->name('admin.categories.destroy');
    Route::post('/categories/delete-multiple', [AdminCategoryController::class, 'deleteMultiple'])->name('admin.categories.delete-multiple');
    Route::post('/categories/delete-all', [AdminCategoryController::class, 'deleteAll'])->name('admin.categories.delete-all');

    // Tallas
    Route::get('/sizes', [AdminSizeController::class, 'index'])->name('admin.sizes.index');
    Route::post('/sizes/store', [AdminSizeController::class, 'store'])->name('admin.sizes.store');
    Route::post('/sizes/update/{id}', [AdminSizeController::class, 'update'])->name('admin.sizes.update');
    Route::delete('/sizes/destroy/{id}', [AdminSizeController::class, 'destroy'])->name('admin.sizes.destroy');
    Route::post('/sizes/delete-multiple', [AdminSizeController::class, 'deleteMultiple'])->name('admin.sizes.delete-multiple');
    Route::post('/sizes/delete-all', [AdminSizeController::class, 'deleteAll'])->name('admin.sizes.delete-all');

    Route::get('/users', [AdminUserController::class, 'index'])->name('admin.users.index');
    Route::post('/users/store', [AdminUserController::class, 'store'])->name('admin.users.store');
    Route::post('/users/update/{id}', [AdminUserController::class, 'update'])->name('admin.users.update');
    Route::delete('/users/destroy/{id}', [AdminUserController::class, 'destroy'])->name('admin.users.destroy');
    Route::delete('/users/delete-multiple', [AdminUserController::class, 'deleteMultiple'])->name('admin.users.delete-multiple');
    Route::delete('/users/delete-all', [AdminUserController::class, 'deleteAll'])->name('admin.users.delete-all');
});

require __DIR__ . '/auth.php';
