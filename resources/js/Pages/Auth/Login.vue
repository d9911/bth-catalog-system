<script setup>
import { ref } from 'vue'
import { router } from '@inertiajs/vue3'
import Layout from '../Layout.vue'
import axios from 'axios'
import { Lock, Mail, AlertCircle } from 'lucide-vue-next'

const form = ref({
  email: 'admin@bth.com',
  password: 'password',
})

const error = ref('')
const loading = ref(false)

const login = async () => {
  loading.value = true
  error.value = ''
  try {
    const response = await axios.post('/api/login', form.value)
    localStorage.setItem('api_token', response.data.token)
    router.get('/admin/products')
  } catch (e) {
    error.value = e.response?.data?.message || 'Ошибка входа'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <Layout>
    <div class="max-w-md mx-auto py-12">
      <div class="bg-white p-8 rounded-2xl border border-gray-200 shadow-xl">
        <div class="text-center mb-8">
          <div class="inline-flex items-center justify-center w-16 h-16 bg-gray-900 rounded-2xl mb-4">
            <Lock class="w-8 h-8 text-white" />
          </div>
          <h1 class="text-2xl font-bold text-gray-900">Вход в панель</h1>
          <p class="text-gray-500 mt-1">Только для администраторов</p>
        </div>

        <form @submit.prevent="login" class="space-y-6">
          <div v-if="error" class="bg-red-50 text-red-700 p-4 rounded-xl flex items-center gap-3 text-sm animate-shake">
            <AlertCircle class="w-5 h-5 flex-shrink-0" />
            <span>{{ error }}</span>
          </div>

          <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Email</label>
            <div class="relative">
              <Mail class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                v-model="form.email"
                type="email"
                required
                class="w-full pl-10 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all"
                placeholder="admin@example.com"
              />
            </div>
          </div>

          <div>
            <label class="block text-sm font-bold text-gray-700 mb-2">Пароль</label>
            <div class="relative">
              <Lock class="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
              <input
                v-model="form.password"
                type="password"
                required
                class="w-full pl-10 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl focus:ring-2 focus:ring-gray-900 focus:bg-white outline-none transition-all"
                placeholder="••••••••"
              />
            </div>
          </div>

          <button
            type="submit"
            :disabled="loading"
            class="w-full py-4 bg-gray-900 text-white rounded-xl font-bold hover:bg-gray-800 focus:ring-4 focus:ring-gray-200 transition-all disabled:opacity-50 flex items-center justify-center gap-2"
          >
            <span v-if="loading" class="w-5 h-5 border-2 border-white/20 border-t-white rounded-full animate-spin"></span>
            Войти
          </button>
        </form>
      </div>
    </div>
  </Layout>
</template>

<style scoped>
@keyframes shake {
  0%,
  100% {
    transform: translateX(0);
  }
  25% {
    transform: translateX(-4px);
  }
  75% {
    transform: translateX(4px);
  }
}
.animate-shake {
  animation: shake 0.2s ease-in-out 0s 2;
}
</style>
