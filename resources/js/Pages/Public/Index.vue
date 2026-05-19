<script setup>
import { ref, onMounted, watch } from 'vue'
import { Link } from '@inertiajs/vue3'
import Layout from '../Layout.vue'
import axios from 'axios'
import { ChevronLeft, ChevronRight, Filter } from 'lucide-vue-next'

const products = ref([])
const categories = ref([])
const selectedCategory = ref('')
const pagination = ref({ current_page: 1, last_page: 1 })
const loading = ref(true)

const fetchCategories = async () => {
  try {
    const response = await axios.get('/api/categories')
    categories.value = response.data.data
  } catch (e) {
    console.error(e)
  }
}

const fetchProducts = async (page = 1) => {
  loading.ref = true
  try {
    const response = await axios.get('/api/products', {
      params: {
        page,
        category_id: selectedCategory.value,
      },
    })
    products.value = response.data.data
    pagination.value = response.data.meta
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchCategories()
  fetchProducts()
})

watch(selectedCategory, () => {
  fetchProducts(1)
})
</script>

<template>
  <Layout>
    <div class="space-y-6">
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Каталог товаров</h1>
          <p class="text-gray-500 mt-1">Оборудование для телекоммуникаций</p>
        </div>

        <div class="flex items-center gap-3 bg-white p-2 rounded-lg border border-gray-200">
          <Filter class="w-4 h-4 text-gray-400" />
          <select v-model="selectedCategory" class="bg-transparent border-none focus:ring-0 text-sm font-medium text-gray-700 min-w-[200px]">
            <option value="">Все категории</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">
              {{ cat.name }}
            </option>
          </select>
        </div>
      </div>

      <div v-if="loading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 animate-pulse">
        <div v-for="i in 6" :key="i" class="bg-gray-200 h-64 rounded-xl"></div>
      </div>

      <div v-else-if="products.length === 0" class="text-center py-12 bg-white rounded-xl border border-dashed border-gray-300">
        <p class="text-gray-500">Товары не найдены</p>
      </div>

      <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="product in products" :key="product.id" class="bg-white rounded-xl border border-gray-200 overflow-hidden hover:shadow-lg transition-shadow group">
          <div class="p-6">
            <div class="flex justify-between items-start mb-4">
              <span class="px-2 py-1 bg-green-50 text-green-700 text-xs font-semibold rounded uppercase tracking-wider">
                {{ product.category.name }}
              </span>
              <span class="text-xl font-bold text-gray-900">{{ product.price }} ₽</span>
            </div>
            <h3 class="text-lg font-bold text-gray-900 group-hover:text-brand-green transition-colors">
              {{ product.name }}
            </h3>
            <p class="text-gray-500 text-sm mt-2 line-clamp-2">
              {{ product.description || 'Нет описания' }}
            </p>
            <div class="mt-6">
              <Link :href="`/product/${product.id}`" class="block w-full text-center py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors text-sm font-medium"> Подробнее </Link>
            </div>
          </div>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="pagination.last_page > 1" class="flex justify-center gap-2 mt-8">
        <button
          @click="fetchProducts(pagination.current_page - 1)"
          :disabled="pagination.current_page === 1"
          class="p-2 rounded-lg border border-gray-200 bg-white disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
        >
          <ChevronLeft class="w-5 h-5" />
        </button>
        <span class="flex items-center px-4 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg"> Страница {{ pagination.current_page }} из {{ pagination.last_page }} </span>
        <button
          @click="fetchProducts(pagination.current_page + 1)"
          :disabled="pagination.current_page === pagination.last_page"
          class="p-2 rounded-lg border border-gray-200 bg-white disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
        >
          <ChevronRight class="w-5 h-5" />
        </button>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
.text-brand-green {
  color: #00ed64;
}
</style>
