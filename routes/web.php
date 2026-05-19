<?php
use Illuminate\Support\Facades\Route;
Route::get('/', function () {
    return view('app');
});

// use Inertia\Inertia;

// Route::get('/', function () {
//     // 'Index' — это название твоего Vue-компонента в папке resources/js/Pages/Index.vue
//     return Inertia::render('Index');
// });
