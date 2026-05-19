1 Создание проекта Laravel

```bash
composer create-project laravel/laravel bth-catalog-system
cd bth-catalog-system
```

2 Установка Inertia + Vue 3

```bash
composer require inertiajs/inertia-laravel
php artisan inertia:middleware

npm install vue@3 @inertiajs/vue3
```

3 Установка фронтенд-зависимостей

```bash
npm install
npm install axios
```

4 опционально UI

```bash
npm install tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

- .env

```bash
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=bth_catalog
DB_USERNAME=postgres
DB_PASSWORD=yourpassword
```

- Создай БД-
если ошибка я поставил ui + pgAdmin 4
```bash
createdb bth_catalog
```

5 Установка Sanctum (аутентификация)

```bash
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
php artisan migrate
```

6 Создание моделей + миграций

```bash
php artisan make:model Category -m
php artisan make:model Product -m
```

7 Контроллеры API

```bash
php artisan make:controller Api/ProductController --api
php artisan make:controller Api/CategoryController --api
```

8. Form Request (валидация)

```bash
php artisan make:request StoreProductRequest
php artisan make:request UpdateProductRequest
```

9. Запуск проекта

```bash
php artisan serve
npm run dev
```

```bash

```
