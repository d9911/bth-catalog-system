<?php
namespace Database\Seeders;
use App\Models\Category;
use App\Models\User;
use Illuminate\Database\Seeder;
class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::updateOrCreate(
            ['email' => 'admin@bth.com'],
            [
                'name' => 'Admin',
                'password' => bcrypt('password')
            ]
        );
        // Create categories using factory
        Category::factory()->count(3)->create();

        // Get category IDs for product assignment
        $categories = Category::all()->pluck('id')->toArray();

        // Create sample products for each category
        \App\Models\Product::factory()->count(5)->create();
        \App\Models\Product::factory()->count(5)->create([
            'category_id' => $categories[1] ?? 2
        ]);
        \App\Models\Product::factory()->count(5)->create([
            'category_id' => $categories[2] ?? 3
        ]);
    }
}
