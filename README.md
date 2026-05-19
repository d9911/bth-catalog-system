# 🛍️ BTH Catalog System

Простое веб-приложение — каталог товаров с административной панелью.

Проект выполнен в рамках тестового задания для Junior Full-Stack Developer (Laravel + Vue.js + Inertia).

---

## ⚙️ Стек технологий

### Backend

- Laravel 10+ (RESTful API)
- Laravel Sanctum (аутентификация)
- Eloquent ORM
- PostgreSQL

### Frontend

- Vue.js 3 (Composition API)
- Inertia.js
- Tailwind CSS

---

## 🎯 Функционал

### 📦 Публичная часть

- Список товаров с пагинацией
- Просмотр карточки товара
- Фильтрация по категориям
- Отображение:
  - название
  - категория
  - цена
  - описание

---

### 🔐 Административная часть

- Авторизация по токену (Sanctum)
- CRUD товаров:
  - создание
  - редактирование
  - удаление
- Управление через отдельный `/admin` интерфейс

---

## 🧱 Основные сущности

### Product

- id
- name
- description
- price
- category_id
- timestamps

### Category

- id
- name
- description
- timestamps

Связи:

- Product → belongsTo Category
- Category → hasMany Products

---

## 🚀 Установка проекта

### 1. Клонировать репозиторий

```bash
git clone https://github.com/your-username/bth-catalog-system.git
cd bth-catalog-system
```

---

### 2. Установка backend зависимостей

```bash
composer install
cp .env.example .env
php artisan key:generate
```

---

### 3. Настройка базы данных (PostgreSQL)

В `.env`:

```env
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=bth_catalog
DB_USERNAME=postgres
DB_PASSWORD=your_password
```

Создать базу:

```bash
createdb bth_catalog
```

---

### 4. Миграции и сидеры

```bash
php artisan migrate --seed
```

---

### 5. Установка фронтенда

```bash
npm install
npm run dev
```

---

### 6. Запуск сервера

```bash
php artisan serve
npm run dev
```

---

## 🔐 Авторизация

Для доступа к административной части:

- `POST /api/login`
- возвращает Sanctum token

Токен сохраняется в `localStorage` и используется для запросов.

---

## 🎨 UI

- Tailwind CSS используется для быстрой и адаптивной верстки
- Vue 3 Composition API для логики компонентов
- Inertia.js для SPA-подобного поведения без отдельного API клиента

---

## 📁 Структура проекта (упрощённо)

```
app/
  Http/
    Controllers/
    Requests/
    Resources/

resources/
  js/
    Pages/
    Components/
    Layouts/

routes/
  api.php
  web.php
```

---

## 🧪 API Endpoints

### Products

- `GET /api/products`
- `GET /api/products/{id}`
- `POST /api/products` 🔐
- `PUT /api/products/{id}` 🔐
- `DELETE /api/products/{id}` 🔐

### Categories

- `GET /api/categories`

### Auth

- `POST /api/login`

---

## 🧠 Технические решения

- RESTful архитектура
- Resource/Collection для API ответов
- Form Request для валидации
- Sanctum token authentication
- Eager loading (`with`) для оптимизации запросов

---

## ✨ Бонус (если реализовано)

- Soft Deletes для товаров
- Seeders с тестовыми данными
- Docker / docker-compose
- Composables (useAuth, useProductApi)
- Подтверждение удаления (modal)
- Debounce для поиска
- Базовые тесты API

---

## 📌 Деплой

Проект можно развернуть на:

- Laravel Forge
- VPS (Nginx + PHP-FPM)
- Docker (если добавлен)

---

## 📄 Лицензия

Проект распространяется под лицензией MIT.
См. файл лицензии в корне проекта: [LICENSE](./LICENSE)
