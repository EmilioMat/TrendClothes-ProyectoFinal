<template>
  <AppLayout>
    <div class="bg-gray-50 py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900">{{ product.name }}</h1>
          <p class="mt-2 text-lg text-gray-600">Categoría: {{ product.category }}</p>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <!-- Main Image -->
          <div class="h-96 bg-gray-200 flex items-center justify-center">
            <img 
              v-if="product.main_image" 
              :src="product.main_image" 
              :alt="product.name"
              class="h-full w-full object-cover"
            >
            <div v-else class="text-gray-500">Sin imagen</div>
          </div>

          <!-- Additional Images (Carousel or Grid) -->
          <div v-if="product.images.length" class="grid grid-cols-2 gap-2 mb-4">
            <div v-for="(image, index) in product.images" :key="index" class="h-24 bg-gray-200 flex items-center justify-center">
              <img :src="image" :alt="product.name + ' - Imagen ' + (index + 1)" class="h-full w-full object-cover">
            </div>
          </div>

          <!-- Product Details -->
          <div class="p-6">
            <p class="text-gray-600 mb-4">{{ product.description }}</p>
            <div class="mt-4">
              <span class="text-2xl font-bold text-indigo-600">{{ formatPrice(product.price) }}</span>
            </div>
            <div class="mt-4">
              <p class="text-gray-700">Stock disponible: {{ product.stock }}</p>
              <p class="text-gray-700">Género: {{ product.gender === 'male' ? 'Hombre' : product.gender === 'female' ? 'Mujer' : 'Unisex' }}</p>
            </div>
            <Link 
              :href="route('categories.show', { category: product.category.toLowerCase().replace(/ /g, '-') })"
              class="mt-6 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700"
            >
              Volver a categoría
            </Link>
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
  product: {
    type: Object,
    required: true
  }
});
</script>