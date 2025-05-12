<template>
  <div class="group relative bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
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
      <p class="text-gray-500 text-sm mb-1">{{ product.category }}</p>
      <p class="text-gray-600 mb-4 line-clamp-2">{{ product.description }}</p>
      <div class="flex items-center justify-between">
        <span class="text-xl font-bold text-indigo-600">{{ formatPrice(product.price) }}</span>
        <Link 
          :href="route('products.show', { product: product.id })"
          class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 transition-colors"
        >
          Ver detalles
        </Link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3';

const props = defineProps({
  product: {
    type: Object,
    required: true
  }
});

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};
</script>