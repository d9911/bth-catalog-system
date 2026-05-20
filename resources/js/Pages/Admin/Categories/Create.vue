<script setup>
import { ref } from 'vue'
import { router } from '@inertiajs/vue3'
import Layout from '../../../Layout.vue'
import axios from 'axios'
import { CheckSquare, AlertTriangle } from 'lucide-vue-next'

const form = ref({
  name: '',
  description: '',
})

const errors = ref({})
const processing = ref(false)

const submit = async () => {
  errors.value = {}
  processing.value = true

  try {
    const token = localStorage.getItem('api_token')
    await axios.post('/api/categories', form.value, {
      headers: { Authorization: `Bearer ${token}` },
    })
    router.get('/admin/categories')
  } catch (e) {
    if (e.response?.status === 422) {
      errors.value = e.response.data.errors
    } else {
      alert('Ошибка при сохранении')
    }
  } finally {
    processing.value = false
  }
}
</script>

<template>
  <Layout>
    <div class="space-y-6">
      <div class="flex justify-between items-center">
        <div>
          <h1 class="text-3xl font-bold text-gray-900">Добавить категорию</h1>
          <p class="text-gray-500 mt-1">Создайте новую категорию товаров</p>
        </div>
        <Link href="/admin/categories" class="px-4 py-2 bg-gray-200 text-gray-600 rounded-lg hover:bg-gray-300 transition-colors text-sm font-medium">
          Назад к списку
        </Link>
      </div>

      <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
        <div class="p-8">
          <form @submit.prevent="submit" class="space-y-6">
            <div v-if="Object.keys(errors).length > 0" class="bg-red-50 p-4 rounded-lg">
              <div class="flex">
                <AlertTriangle class="w-5 h-5 flex-shrink-0 mt-0.5" />
                <div class="ml-3">
                  <p class="text-sm font-medium text-red-800">Пожалуйста, исправьте следующие ошибки:</p>
                  <ul class="list-disc list-inside mt-1 text-sm text-red-600">
                    <li v-for="(error, field) in errors" :key="field">{{ error[0] }}</li>
                  </ul>
                </div>
              </div>
            </div>

            <div>
              <label class="block text-sm font-bold text-gray-700 mb-2">Название</label>
              <div class="relative">
                <input
                  v-model="form.name"
                  type="text"
                  required
                  class="w-full pl-3 pr-4 py-3 bg-gray-50 border:border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all"
                  placeholder="Введите название категории"
                />
                <div class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none">
                  <CheckSquare v-if="form.name" class="w-4 h-4" />
                </div>
              </div>
              <p v-if="errors.name" class="mt-1 text-sm text-red-600">{{ errors.name[0] }}</p>
            </div>

            <div>
              <label class="block text-sm font-bold text-gray-700 mb-2">Описание</label>
              <div class="relative">
                <textarea
                  v-model="form.description"
                  rows="4"
                  class="w-full pl-3 pr-4 py-3 bg-gray-50 border:border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all resize-none"
                  placeholder="Введите описание категории (необязательно)"
                ></textarea>
              </div>
              <p v-if="errors.description" class="mt-1 text-sm text-red-600">{{ errors.description[0] }}</p>
            </div>

            <div class="pt-4">
              <button
                type="submit"
                :disabled="processing"
                class="w-flex bg-gray-900 text-white rounded-xl py-3 px-6 font-bold hover:bg-gray-800 focus:ring-4 focus:ring-gray-200 transition-all disabled:opacity-50 flex items-center justify-center gap-2"
              >
                <span v-if="processing" class="w-5 h-5 border-2 border-white/20 border-t-white rounded-full animate-spin"></span>
                Сохранить категорию
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
</style>