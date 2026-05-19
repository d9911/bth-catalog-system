<script setup>
import { ref, onMounted } from 'vue'
import { Link, router } from '@inertiajs/vue3'
import Layout from '../../Layout.vue'
import axios from 'axios'
import { Save, X, ArrowLeft } from 'lucide-vue-next'

const form = ref({
  name: '',
  description: '',
  price: 0,
  category_id: '',
})

const categories = ref([])
const loading = ref(false)
const errors = ref({})

const fetchCategories = async () => {
  try {
    const response = await axios.get('/api/categories')
    categories.value = response.data.data
  } catch (e) {
    console.error(e)
  }
}

const submit = async () => {
  loading.value = true
  errors.value = {}

  const token = localStorage.getItem('api_token')
  try {
    await axios.post('/api/products', form.value, {
      headers: { Authorization: `Bearer ${token}` },
    })
    router.get('/admin/products')
  } catch (e) {
    if (e.response?.status === 422) {
      errors.value = e.response.data.errors || {}
    } else if (e.response?.status === 401) {
      router.get('/login')
    } else {
      alert('Произошла ошибка при сохранении')
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  if (!localStorage.getItem('api_token')) return router.get('/login')
  fetchCategories()
})
</script>

<template>
  <Layout>
    <div class="max-w-2xl mx-auto">
      <nav class="mb-8">
        <Link href="/admin/products" class="flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-gray-700">
          <ArrowLeft class="w-4 h-4" />
          Назад к списку
        </Link>
      </nav>

      <div class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gray-50">
          <h1 class="text-xl font-bold text-gray-900">Добавление товара</h1>
          <Link href="/admin/products" class="p-2 text-gray-400 hover:text-gray-600">
            <X class="w-5 h-5" />
          </Link>
        </div>

        <form @submit.prevent="submit" class="p-8 space-y-6">
          <div class="grid grid-cols-1 gap-6">
            <div>
              <label class="block text-sm font-bold text-gray-700 mb-2">Название товара <span class="text-red-500">*</span></label>
              <input
                v-model="form.name"
                type="text"
                required
                class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all"
                placeholder="например, Mikrotik hAP ac2"
              />
              <p v-if="errors.name" class="mt-1 text-xs text-red-500">{{ errors.name[0] }}</p>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Категория <span class="text-red-500">*</span></label>
                <select
                  v-model="form.category_id"
                  required
                  class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all appearance-none"
                >
                  <option value="" disabled>Выберите категорию</option>
                  <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                </select>
                <p v-if="errors.category_id" class="mt-1 text-xs text-red-500">{{ errors.category_id[0] }}</p>
              </div>

              <div>
                <label class="block text-sm font-bold text-gray-700 mb-2">Цена (₽) <span class="text-red-500">*</span></label>
                <input
                  v-model="form.price"
                  type="number"
                  step="0.01"
                  min="0.01"
                  required
                  class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all"
                />
                <p v-if="errors.price" class="mt-1 text-xs text-red-500">{{ errors.price[0] }}</p>
              </div>
            </div>

            <div>
              <label class="block text-sm font-bold text-gray-700 mb-2">Описание</label>
              <textarea
                v-model="form.description"
                rows="4"
                class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all resize-none"
                placeholder="Краткое описание характеристик..."
              ></textarea>
              <p v-if="errors.description" class="mt-1 text-xs text-red-500">{{ errors.description[0] }}</p>
            </div>
          </div>

          <div class="flex gap-4 pt-4">
            <button
              type="submit"
              :disabled="loading"
              class="flex-grow flex items-center justify-center gap-2 py-4 bg-gray-900 text-white rounded-xl font-bold hover:bg-gray-800 focus:ring-4 focus:ring-gray-200 transition-all disabled:opacity-50"
            >
              <Save class="w-5 h-5" />
              Создать товар
            </button>
            <Link href="/admin/products" class="px-8 flex items-center justify-center py-4 bg-gray-100 text-gray-700 rounded-xl font-bold hover:bg-gray-200 transition-all"> Отмена </Link>
          </div>
        </form>
      </div>
    </div>
  </Layout>
</template>
