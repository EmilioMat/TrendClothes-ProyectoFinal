<template>
  <AppLayout>
    <template #header>
      <h2 class="text-xl font-bold">Productos en {{ category.name }}</h2>
    </template>

    <div class="p-6">
      <p class="text-gray-700 mb-4">{{ category.description }}</p>

      <div v-if="category.products.length > 0" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <div
          v-for="product in category.products"
          :key="product.id"
          class="p-4 bg-white rounded-lg shadow hover:shadow-md transition-shadow"
        >
          <h3 class="font-semibold text-lg">{{ product.name }}</h3>
          <p class="text-gray-600 mt-2">{{ product.description }}</p>
          <p class="font-bold mt-2 text-indigo-600">{{ formatPrice(product.price) }}</p>
          <Link 
            :href="route('products.show', { product: product.id })" 
            class="mt-3 inline-block text-sm text-indigo-500 hover:text-indigo-700"
          >
            Ver detalles
          </Link>
        </div>
      </div>

      <div v-else class="text-gray-500 text-center py-8">
        No hay productos en esta categoría.
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
  category: {
    type: Object,
    required: true
  }
});
</script>
