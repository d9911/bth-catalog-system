.PHONY: clean-ports
# ==========================================
# Балтийский Телекоммуникационный Холдинг
# Makefile для автоматизации проекта
# ==========================================
BACKEND_PORT=8001
FRONTEND_PORT=5174 #base 5173


clean-ports:
	@echo "Очищаем порты $(BACKEND_PORT) (Backend) и $(FRONTEND_PORT) (Frontend)..."
	-npx --yes kill-port $(BACKEND_PORT) $(FRONTEND_PORT)

# Подключаем .env файл, если он существует
ifneq (,$(wildcard ./.env))
	include .env
	export
endif

# Цветное оформление
COLOR_RESET   := \033[0m
COLOR_BOLD    := \033[1m
COLOR_RED     := \033[31m
COLOR_GREEN   := \033[32m
COLOR_YELLOW  := \033[33m
COLOR_BLUE    := \033[34m
COLOR_MAGENTA := \033[35m
COLOR_CYAN    := \033[36m

# Настройки БД из .env
DB_NAME ?= bth_catalog
DB_USER ?= postgres
DB_HOST ?= 127.0.0.1
DB_PORT ?= 5432

.PHONY: help check setup env install db-create db-migrate db dev serve-backend serve-frontend

# ==========================================
# Основные команды
# ==========================================

help: ## 📖 Показать список доступных команд
	@printf "$(COLOR_CYAN)Доступные команды:$(COLOR_RESET)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(COLOR_GREEN)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'

setup: check env install db-create db-migrate ## 🚀 Полная инициализация проекта с нуля
	@printf "$(COLOR_GREEN)=========================================\n"
	@printf "$(COLOR_GREEN)🎉 Проект успешно инициализирован!$(COLOR_RESET)\n"
	@printf "$(COLOR_GREEN)=========================================\n"
	@printf "$(COLOR_YELLOW)Запустите 'make dev' для старта приложения.$(COLOR_RESET)\n"

dev: ## 💻 Запустить фронтенд и бэкенд (Vite + Artisan)
	@printf "$(COLOR_MAGENTA)🚀 Запуск серверов разработки...$(COLOR_RESET)\n"
	$(MAKE) serve-backend & $(MAKE) serve-frontend & wait

# ==========================================
# Проверка зависимостей
# ==========================================

check: ## 🔍 Проверить наличие необходимых утилит (PHP, Node, psql)
	@printf "$(COLOR_CYAN)🔍 Проверка зависимостей...$(COLOR_RESET)\n"
	@which php > /dev/null 2>&1 || (printf "$(COLOR_RED)❌ PHP не установлен$(COLOR_RESET)\n"; exit 1)
	@printf "$(COLOR_GREEN)✅ PHP: $$(php -v | head -n 1)$(COLOR_RESET)\n"
	@which composer > /dev/null 2>&1 || (printf "$(COLOR_RED)❌ Composer не установлен$(COLOR_RESET)\n"; exit 1)
	@printf "$(COLOR_GREEN)✅ Composer найден$(COLOR_RESET)\n"
	@command -v node > /dev/null 2>&1 || (printf "$(COLOR_RED)❌ Node.js не установлен$(COLOR_RESET)\n"; exit 1)
	@printf "$(COLOR_GREEN)✅ Node.js: $$(node -v)$(COLOR_RESET)\n"
	@command -v npm > /dev/null 2>&1 || (printf "$(COLOR_RED)❌ npm не установлен$(COLOR_RESET)\n"; exit 1)
	@printf "$(COLOR_GREEN)✅ npm: $$(npm -v)$(COLOR_RESET)\n"
	@command -v psql > /dev/null 2>&1 || (printf "$(COLOR_RED)❌ psql (PostgreSQL) не установлен или не в PATH$(COLOR_RESET)\n"; exit 1)
	@printf "$(COLOR_GREEN)✅ PostgreSQL клиент найден$(COLOR_RESET)\n"

# ==========================================
# Настройка окружения и зависимостей
# ==========================================

env: ## 📝 Создать .env файл из .env.example, если его нет
	@if [ ! -f .env ]; then \
		printf "$(COLOR_BLUE)📝 Копирование .env.example -	.env$(COLOR_RESET)\n"; \
		cp .env.example .env; \
	else \
		printf "$(COLOR_YELLOW)⚠️ .env файл уже существует$(COLOR_RESET)\n"; \
	fi

install: ## 📦 Установить зависимости Composer и NPM
	@printf "$(COLOR_BLUE)📦 Установка PHP зависимостей...$(COLOR_RESET)\n"
	composer install
	@printf "$(COLOR_BLUE)📦 Установка Node.js зависимостей...$(COLOR_RESET)\n"
	npm install
	@printf "$(COLOR_BLUE)🔑 Генерация ключа приложения...$(COLOR_RESET)\n"
	php artisan key:generate

# ==========================================
# Работа с базой данных
# ==========================================

db-create: ## 🗄️ Создать базу данных PostgreSQL (если не существует)
	@printf "$(COLOR_CYAN)🗄️ Попытка создания базы данных '$(DB_NAME)'...$(COLOR_RESET)\n"
	@PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -tc "SELECT 1 FROM pg_database WHERE datname = '$(DB_NAME)'" | grep -q 1 || \
	PGPASSWORD=$(DB_PASSWORD) psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER) -c "CREATE DATABASE $(DB_NAME)"
	@printf "$(COLOR_GREEN)✅ База данных '$(DB_NAME)' готова$(COLOR_RESET)\n"

db-migrate: ## 🚀 Накатить миграции и сиды (migrate:fresh --seed)
	@printf "$(COLOR_CYAN)🚀 Миграции и сидирование...$(COLOR_RESET)\n"
	php artisan migrate:fresh --seed

db: db-create db-migrate ## 🗄️ Пересоздать БД, накатить миграции и сиды

# ==========================================
# Запуск серверов
# ==========================================

serve-backend: ## 🔧 Запустить только бэкенд (php artisan serve)
	@printf "$(COLOR_BLUE)🔧 Запуск Laravel... http://localhost:8000$(COLOR_RESET)\n"
	php artisan serve

serve-frontend: ## 🎨 Запустить только фронтенд (npm run dev)
	@printf "$(COLOR_MAGENTA)🎨 Запуск Vite...$(COLOR_RESET)\n"
	npm run dev
