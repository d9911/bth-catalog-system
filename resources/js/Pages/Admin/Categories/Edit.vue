<script setup>
import { ref, onMounted } from 'vue'
import { Link, router } from '@inertiajs/vue3'
import Layout from '../../../Layout.vue'
import axios from 'axios'
import { Save, X, ArrowLeft } from 'lucide-vue-next'

const props = defineProps({
  id: String,
})

const form = ref({
  name: '',
  description: '',
})

const loading = ref(false)
const fetching = ref(true)
const errors = ref({})

const fetchCategory = async () => {
  try {
    const token = localStorage.getItem('api_token')
    const response = await axios.get(`/api/categories/${props.id}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
    const c = response.data.data
    form.value = {
      name: c.name,
      description: c.description,
    }
  } catch (e) {
    if (e.response?.status === 401) {
      router.get('/login')
    } else {
      alert('Категория не найдена')
      router.get('/admin/categories')
    }
  } finally {
    fetching.value = false
  }
}

const submit = async () => {
  loading.value = true
  errors.value = {}

  const token = localStorage.getItem('api_token')
  try {
    await axios.put(`/api/categories/${props.id}`, form.value, {
      headers: { Authorization: `Bearer ${token}` },
    })
    router.get('/admin/categories')
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
  fetchCategory()
})
</script>

<template>
  <Layout>
    <div class="max-w-2xl mx-auto">
      <nav class="mb-8">
        <Link href="/admin/categories" class="flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-gray-700">
          <ArrowLeft class="w-4 h-4" />
          Назад к списку
        </Link>
      </nav>

      <div v-if="fetching" class="flex justify-center py-20">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-gray-900"></div>
      </div>

      <div v-else class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between bg-gray-50">
          <h1 class="text-xl font-bold text-gray-900">Редактирование категории #{{ id }}</h1>
          <Link href="/admin/categories" class="p-2 text-gray-400 hover:text-gray-600">
            <X class="w-5 h-5" />
          </Link>
        </div>

        <form @submit.prevent="submit" class="p-8 space-y-6">
          <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Название категории <span class="text-red-500">*</span></label>
            <input
              v-model="form.name"
              type="text"
              required
              class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all"
            />
            <p v-if="errors.name" class="mt-1 text-xs text-red-500">{{ errors.name[0] }}</p>
          </div>

          <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Описание</label>
            <textarea
              v-model="form.description"
              rows="4"
              class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all resize-none"
            ></textarea>
            <p v-if="errors.description" class="mt-1 text-xs text-red-500">{{ errors.description[0] }}</p>
          </div>

          <div class="flex gap-4 pt-4">
            <button
              type="submit"
              :disabled="loading"
              class="flex-grow flex items-center justify-center gap-2 py-4 bg-gray-900 text-white rounded-xl font-bold hover:bg-gray-800 focus:ring-4 focus:ring-gray-200 transition-all disabled:opacity-50"
            >
              <Save class="w-5 h-5" />
              Сохранить изменения
            </button>
            <Link href="/admin/categories" class="px-8 flex items-center justify-center py-4 bg-gray-100 text-gray-700 rounded-xl font-bold hover:bg-gray-200 transition-all"> Отмена </Link>
          </div>
        </form>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
</style>