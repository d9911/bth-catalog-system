<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::factory()->create([
            'name' => 'Admin',
            'email' => 'admin@bth.com',
            'password' => bcrypt('password') // Стандартный пароль для тестов
        ]);

        Category::insert([
            ['name' => 'Роутеры', 'description' => 'Сетевое оборудование', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Коммутаторы', 'description' => 'Оборудование для локальных сетей', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'Оптика', 'description' => 'Оптоволоконное оборудование', 'created_at' => now(), 'updated_at' => now()],
        ]);
    }
}
