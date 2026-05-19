# ==========================================
# Балтийский Телекоммуникационный Холдинг
# Makefile для автоматизации проекта
# ==========================================

# Подключаем .env файл, если он существует
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Цвета для вывода в консоль
BLUE := \033[36m
GREEN := \033[32m
RED := \033[31m
YELLOW := \033[33m
NC := \033[0m # No Color

# Имя базы данных из .env (по умолчанию bth_catalog)
DB_NAME ?= bth_catalog
DB_USER ?= postgres

.PHONY: help check setup env install db-create db-migrate db dev serve-backend serve-frontend

# ==========================================
# Основные команды
# ==========================================

help: ## 📖 Показать список доступных команд
    @echo "$(BLUE)Доступные команды:$(NC)"
    @grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2}'

setup: check env install db-create db-migrate ## 🚀 Полная инициализация проекта с нуля
    @echo "$(GREEN)=========================================$(NC)"
    @echo "$(GREEN)🎉 Проект успешно инициализирован(NC)"
    @echo "$(GREEN)=========================================$(NC)"
    @echo "$(YELLOW)Запустите 'make dev' для старта приложения.$(NC)"

dev: ## 💻 Запустить фронтенд и бэкенд (Vite + Artisan)
    @echo "$(BLUE)Запуск серверов разработки...$(NC)"
    $(MAKE) serve-backend & $(MAKE) serve-frontend & wait

# ==========================================
# Проверка зависимостей
# ==========================================

check: ## 🔍 Проверить наличие необходимых утилит (PHP, Node, psql)
    @echo "$(BLUE)Проверка зависимостей...$(NC)"
    @which php > /dev/null || (echo "$(RED)❌ PHP не установлен$(NC)"; exit 1)
    @echo "$(GREEN)✅ PHP: $$(php -v | head -n 1)$(NC)"
    @which composer > /dev/null || (echo "$(RED)❌ Composer не установлен$(NC)"; exit 1)
    @echo "$(GREEN)✅ Composer найден$(NC)"
    @which node > /dev/null || (echo "$(RED)❌ Node.js не установлен$(NC)"; exit 1)
    @echo "$(GREEN)✅ Node.js: $$(node -v)$(NC)"
    @which npm > /dev/null || (echo "$(RED)❌ npm не установлен$(NC)"; exit 1)
    @echo "$(GREEN)✅ npm: $$(npm -v)$(NC)"
    @which psql > /dev/null || (echo "$(RED)❌ psql (PostgreSQL) не установлен$(NC)"; exit 1)
    @echo "$(GREEN)✅ PostgreSQL клиент найден$(NC)"

# ==========================================
# Настройка окружения и зависимостей
# ==========================================

env: ## 📝 Создать .env файл из .env.example, если его нет
    @if [ ! -f .env ]; then \
        echo "$(BLUE)Копирование .env.example -> .env$(NC)"; \
        cp .env.example .env; \
    else \
        echo "$(YELLOW).env файл уже существует$(NC)"; \
    fi

install: ## 📦 Установить зависимости Composer и NPM
    @echo "$(BLUE)Установка PHP зависимостей...$(NC)"
    composer install
    @echo "$(BLUE)Установка Node.js зависимостей...$(NC)"
    npm install
    @echo "$(BLUE)Генерация ключа приложения...$(NC)"
    php artisan key:generate

# ==========================================
# Работа с базой данных
# ==========================================

db-create: ## 🗄️ Создать базу данных PostgreSQL (если не существует)
    @echo "$(BLUE)Попытка создания базы данных '$(DB_NAME)'...$(NC)"
    @PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -tc "SELECT 1 FROM pg_database WHERE datname = '$(DB_NAME)'" | grep -q 1 || \
    PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -c "CREATE DATABASE $(DB_NAME)"
    @echo "$(GREEN)✅ База данных '$(DB_NAME)' готова$(NC)"

db-migrate: ## 🚀 Накатить миграции и сиды (migrate:fresh --seed)
    @echo "$(BLUE)Миграции и сидирование...$(NC)"
    php artisan migrate:fresh --seed

db: db-create db-migrate ## 🗄️ Пересоздать БД, накатить миграции и сиды

# ==========================================
# Запуск серверов
# ==========================================

serve-backend: ## 🔧 Запустить только бэкенд (php artisan serve)
    @echo "$(BLUE)Запуск Laravel... http://localhost:8000$(NC)"
    php artisan serve

serve-frontend: ## 🎨 Запустить только фронтенд (npm run dev)
    @echo "$(BLUE)Запуск Vite...$(NC)"
    npm run dev


# цветное оформление https://gist.github.com/vratiu/9780109
