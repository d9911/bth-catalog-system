<script setup>
import { ref, onMounted } from 'vue'
import { Link, router } from '@inertiajs/vue3'
import Layout from '../../Layout.vue'
import axios from 'axios'
import { Plus, Edit2, Trash2 } from 'lucide-vue-next'

const categories = ref([])
const loading = ref(true)

const fetchCategories = async () => {
  const token = localStorage.getItem('api_token')
  if (!token) return router.get('/login')

  try {
    const response = await axios.get('/api/categories')
    categories.value = response.data.data
  } catch (e) {
    if (e.response?.status === 401) {
      localStorage.removeItem('api_token')
      router.get('/login')
    }
  } finally {
    loading.value = false
  }
}

const deleteCategory = async (id) => {
  if (!confirm('Вы уверены, что хотите удалить эту категорию?')) return

  const token = localStorage.getItem('api_token')
  try {
    await axios.delete(`/api/categories/${id}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
    categories.value = categories.value.filter((c) => c.id !== id)
  } catch (e) {
    alert('Ошибка при удалении')
  }
}

onMounted(() => {
  fetchCategories()
})
</script>

<template>
  <Layout>
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Управление категориями</h1>
          <p class="text-gray-500 mt-1">Всего категорий: {{ categories.length }}</p>
        </div>
        <Link href="/admin/categories/create" class="flex items-center gap-2 px-4 py-2 bg-brand-green text-gray-900 font-bold rounded-lg hover:shadow-lg transition-all">
          <Plus class="w-5 h-5" />
          Добавить категорию
        </Link>
      </div>

      <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
        <div class="overflow-x-auto">
          <table class="w-full text-left">
            <thead>
              <tr class="bg-gray-50 border-b border-gray-200">
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest text-center">ID</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Название</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest">Описание</th>
                <th class="px-6 py-4 text-xs font-bold text-gray-400 uppercase tracking-widest text-right">Действия</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-100">
              <tr v-for="category in categories" :key="category.id" class="hover:bg-gray-50/50 transition-colors">
                <td class="px-6 py-4 text-sm text-gray-400 font-mono text-center">{{ category.id }}</td>
                <td class="px-6 py-4">
                  <span class="text-sm font-bold text-gray-900">{{ category.name }}</span>
                </td>
                <td class="px-6 py-4">
                  <span class="text-sm text-gray-500 line-clamp-1">{{ category.description || '-' }}</span>
                </td>
                <td class="px-6 py-4 text-right">
                  <div class="flex justify-end gap-2">
                    <Link :href="`/admin/categories/${category.id}/edit`" class="p-2 text-blue-500 hover:text-blue-700 hover:bg-blue-50 rounded-lg transition-all" title="Редактировать">
                      <Edit2 class="w-4 h-4" />
                    </Link>
                    <button @click="deleteCategory(category.id)" class="p-2 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-all" title="Удалить">
                      <Trash2 class="w-4 h-4" />
                    </button>
                  </div>
                </td>
              </tr>
              <tr v-if="categories.length === 0 && !loading">
                <td colspan="4" class="px-6 py-12 text-center text-gray-500">Список пуст</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
</style>