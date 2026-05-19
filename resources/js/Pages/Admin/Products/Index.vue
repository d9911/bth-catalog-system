<script setup>
import { ref, onMounted } from 'vue'
import { Link, router } from '@inertiajs/vue3'
import Layout from '../../Layout.vue'
import axios from 'axios'
import { Plus, Edit2, Trash2, ExternalLink } from 'lucide-vue-next'

const products = ref([])
const loading = ref(true)

const fetchProducts = async () => {
  const token = localStorage.getItem('api_token')
  if (!token) return router.get('/login')

  try {
    const response = await axios.get('/api/products')
    products.value = response.data.data
  } catch (e) {
    if (e.response?.status === 401) {
      localStorage.removeItem('api_token')
      router.get('/login')
    }
  } finally {
    loading.value = false
  }
}

const deleteProduct = async (id) => {
  if (!confirm('Вы уверены, что хотите удалить этот товар?')) return

  const token = localStorage.getItem('api_token')
  try {
    await axios.delete(`/api/products/${id}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
    products.value = products.value.filter((p) => p.id !== id)
  } catch (e) {
    alert('Ошибка при удалении')
  }
}

onMounted(() => {
  fetchProducts()
})
</script>

<template>
  <Layout>
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Управление товарами</h1>
          <p class="text-gray-500 mt-1">Всего позиций: {{ products.length }}</p>
        </div>
        <Link href="/admin/products/create" class="flex items-center gap-2 px-4 py-2 bg-brand-green text-gray-900 font-bold rounded-lg hover:shadow-lg transition-all">
          <Plus class="w-5 h-5" />
          Добавить товар
        </Link>
      </div>

      <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
        <div class="overflow-x-auto">
          <table class="w-full text-left">
            <thead>
              <tr class="bg-gray-50 border-b border-gray-200">
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest text-center">ID</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Название</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Категория</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Цена</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest text-right">Действия</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="product in products" :key="product.id" class="hover:bg-gray-50/50 transition-colors">
                <td class="px-6 py-4 text-sm text-gray-400 font-mono text-center">{{ product.id }}</td>
                <td class="px-6 py-4">
                  <div class="flex flex-col">
                    <span class="text-sm font-bold text-gray-900">{{ product.name }}</span>
                    <span class="text-xs text-gray-400 line-clamp-1 truncate max-w-xs">{{ product.description }}</span>
                  </div>
                </td>
                <td class="px-6 py-4">
                  <span class="px-2 py-0.5 bg-gray-100 text-gray-600 text-[10px] font-bold rounded uppercase tracking-wider">
                    {{ product.category.name }}
                  </span>
                </td>
                <td class="px-6 py-4 text-sm font-black text-gray-900">{{ product.price }} ₽</td>
                <td class="px-6 py-4 text-right">
                  <div class="flex justify-end gap-2">
                    <Link :href="`/product/${product.id}`" target="_blank" class="p-2 text-gray-400 hover:text-gray-600 hover:bg-gray-100 rounded-lg transition-all" title="Просмотр">
                      <ExternalLink class="w-4 h-4" />
                    </Link>
                    <Link :href="`/admin/products/${product.id}/edit`" class="p-2 text-blue-500 hover:text-blue-700 hover:bg-blue-50 rounded-lg transition-all" title="Редактировать">
                      <Edit2 class="w-4 h-4" />
                    </Link>
                    <button @click="deleteProduct(product.id)" class="p-2 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all" title="Удалить">
                      <Trash2 class="w-4 h-4" />
                    </button>
                  </div>
                </td>
              </tr>
              <tr v-if="products.length === 0 && !loading">
                <td colspan="5" class="px-6 py-12 text-center text-gray-500">Список пуст</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
.bg-brand-green {
  background-color: #00ed64;
}
</style>
