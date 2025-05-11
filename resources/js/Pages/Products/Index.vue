<template>
  <AppLayout>
    <div class="bg-white py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Nuestros Productos</h1>

        <!-- Filters -->
        <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between">
          <div class="w-full sm:w-auto mb-4 sm:mb-0">
            <select class="block w-full sm:w-40 border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
              <option value="">Ordenar por</option>
              <option value="price_asc">Precio: Bajo a Alto</option>
              <option value="price_desc">Precio: Alto a Bajo</option>
              <option value="newest">Más nuevos</option>
            </select>
          </div>
          <div class="flex space-x-2">
            <button class="px-4 py-2 text-sm text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200">Ocultar filtros</button>
            <button class="px-4 py-2 text-sm text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200">Vista</button>
          </div>
        </div>

        <!-- Product Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          <div
            v-for="product in products"
            :key="product.id"
            class="group relative bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
          >
            <div class="h-48 bg-gray-200 flex items-center justify-center">
              <img 
                v-if="product.main_image" 
                :src="product.main_image" 
                :alt="product.name"
                class="h-full w-full object-cover"
              >
              <div v-else class="text-gray-500">Sin imagen</div>
            </div>
            <div class="p-6">
              <h3 class="text-xl font-semibold text-gray-900 mb-2">{{ product.name }}</h3>
              <p class="text-gray-600 mb-4 line-clamp-2">{{ product.description }}</p>
              <div class="flex items-center justify-between">
                <span class="text-xl font-bold text-indigo-600">{{ formatPrice(product.price) }}</span>
                <Link 
                  :href="route('products.show', { product: product.slug })"
                  class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 transition-colors"
                >
                  Ver detalles
                </Link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};

defineProps({
  products: {
    type: Array,
    required: true
  }
});
</script>