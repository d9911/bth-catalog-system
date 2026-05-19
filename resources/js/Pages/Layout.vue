<script setup>
import { Link, router } from '@inertiajs/vue3'
import { Package, LogOut, LayoutDashboard, ShoppingBag } from 'lucide-vue-next'

const logout = () => {
  localStorage.removeItem('api_token')
  router.get('/login')
}

const isAdmin = !!localStorage.getItem('api_token')
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col font-sans">
    <nav class="bg-white border-b border-gray-200 sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <Link href="/" class="flex-shrink-0 flex items-center gap-2 text-xl font-bold text-gray-900">
              <ShoppingBag class="w-6 h-6 text-brand-green" />
              <span>БТХ Каталог</span>
            </Link>
            <div class="hidden sm:-my-px sm:ml-8 sm:flex sm:space-x-8">
              <Link href="/" class="inline-flex items-center px-1 pt-1 border-b-2 border-transparent text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300"> Все товары </Link>
              <template v-if="isAdmin">
                <Link href="/admin/products" class="inline-flex items-center px-1 pt-1 border-b-2 border-transparent text-sm font-medium text-gray-500 hover:text-gray-700 hover:border-gray-300">
                  Управление
                </Link>
              </template>
            </div>
          </div>
          <div class="flex items-center gap-4">
            <template v-if="isAdmin">
              <span class="text-sm text-gray-600 hidden md:block">Админ</span>
              <button @click="logout" class="flex items-center gap-2 text-sm font-medium text-red-600 hover:text-red-800">
                <LogOut class="w-4 h-4" />
                <span>Выйти</span>
              </button>
            </template>
            <template v-else>
              <Link href="/login" class="text-sm font-medium text-gray-500 hover:text-gray-700">Войти</Link>
            </template>
          </div>
        </div>
      </div>
    </nav>

    <main class="flex-grow py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <slot />
      </div>
    </main>

    <footer class="bg-white border-t border-gray-200 py-8 text-center text-gray-500 text-sm">&copy; 2026 Балтийский Телекоммуникационный Холдинг</footer>
  </div>
</template>

<style>
.text-brand-green {
  color: #00ed64;
}
</style>
