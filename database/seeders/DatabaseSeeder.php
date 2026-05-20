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
        Category::insert([
            ['name' => 'Роутеры', 'description' => 'Сетевое оборудование', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Коммутаторы', 'description' => 'Оборудование для локальных сетей', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Оптика', 'description' => 'Оптоволоконное оборудование', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Create sample products for each category
        \App\Models\Product::factory()->count(5)->create();
        \App\Models\Product::factory()->count(5)->create([
            'category_id' => 2
        ]);
        \App\Models\Product::factory()->count(5)->create([
            'category_id' => 3
        ]);
    }
}
