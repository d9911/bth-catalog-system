<script setup>
import { ref, onMounted } from 'vue'
import { Link } from '@inertiajs/vue3'
import Layout from '../Layout.vue'
import axios from 'axios'
import { ArrowLeft, Tag, Clock } from 'lucide-vue-next'

const props = defineProps({
  id: String,
})

const product = ref(null)
const loading = ref(true)

const fetchProduct = async () => {
  try {
    const response = await axios.get(`/api/products/${props.id}`)
    product.value = response.data.data
  } catch (e) {
    console.error(e)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchProduct()
})

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('ru-RU')
}
</script>

<template>
  <Layout>
    <div v-if="loading" class="flex justify-center py-20">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-gray-900"></div>
    </div>

    <div v-else-if="!product" class="text-center py-20">
      <h1 class="text-2xl font-bold text-gray-900">Товар не найден</h1>
      <Link href="/" class="mt-4 inline-block text-brand-green hover:underline">Вернуться в каталог</Link>
    </div>

    <div v-else class="max-w-4xl mx-auto">
      <nav class="mb-8">
        <Link href="/" class="flex items-center gap-2 text-sm font-medium text-gray-500 hover:text-gray-700">
          <ArrowLeft class="w-4 h-4" />
          Назад к списку
        </Link>
      </nav>

      <div class="bg-white rounded-2xl border border-gray-200 overflow-hidden shadow-sm">
        <div class="md:flex">
          <div class="md:w-1/2 bg-gray-100 flex items-center justify-center p-12">
            <div class="w-48 h-48 bg-white/50 rounded-full flex items-center justify-center text-gray-300">
              <Tag class="w-24 h-24" />
            </div>
          </div>
          <div class="md:w-1/2 p-8 md:p-12">
            <div class="mb-6">
              <span class="px-3 py-1 bg-green-50 text-green-700 text-xs font-bold rounded-full uppercase tracking-widest">
                {{ product.category.name }}
              </span>
            </div>

            <h1 class="text-3xl font-extrabold text-gray-900 mb-4">{{ product.name }}</h1>

            <div class="text-4xl font-black text-gray-900 mb-8">{{ product.price }} <span class="text-2xl font-medium text-gray-500">₽</span></div>

            <div class="space-y-6">
              <div>
                <h3 class="text-sm font-bold text-gray-900 uppercase tracking-wider mb-2">Описание</h3>
                <p class="text-gray-600 leading-relaxed">
                  {{ product.description || 'Описание отсутствует.' }}
                </p>
              </div>

              <div class="pt-6 border-t border-gray-100 flex items-center gap-2 text-xs text-gray-400">
                <Clock class="w-3 h-3" />
                Обновлено: {{ formatDate(product.created_at) }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
.text-brand-green {
  color: #00ed64;
}
</style>
