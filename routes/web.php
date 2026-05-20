<?php
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    // 'Index' — это название твоего Vue-компонента в папке resources/js/Pages/Index.vue
    return Inertia::render('Index');
});

// Admin routes (protected by Sanctum)
Route::middleware('auth:sanctum')->prefix('admin')->group(function () {
    // Categories
    Route::get('/categories', function () {
        return Inertia::render('Admin/Categories/Index');
    })->name('admin.categories.index');

    Route::get('/categories/create', function () {
        return Inertia::render('Admin/Categories/Create');
    })->name('admin.categories.create');

    Route::get('/categories/{category}/edit', function ($category) {
        return Inertia::render('Admin/Categories/Edit', [
            'category' => $category,
        ]);
    })->name('admin.categories.edit');

    // Products (existing)
    Route::get('/products', function () {
        return Inertia::render('Admin/Products/Index');
    })->name('admin.products.index');

    Route::get('/products/create', function () {
        return Inertia::render('Admin/Products/Create');
    })->name('admin.products.create');

    Route::get('/products/{product}/edit', function ($product) {
        return Inertia::render('Admin/Products/Edit', [
            'product' => $product,
        ]);
    })->name('admin.products.edit');
});
