<template>
    <AuthenticatedLayout>
      <template #header>
        <h2 class="text-xl font-bold">Productos en {{ category.name }}</h2>
      </template>
  
      <div class="p-6">
        <p class="text-gray-700 mb-4">{{ category.description }}</p>
  
        <div v-if="category.products.length > 0" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
          <div
            v-for="product in category.products"
            :key="product.id"
            class="p-4 bg-white rounded shadow hover:shadow-md"
          >
            <h3 class="font-semibold">{{ product.name }}</h3>
            <p class="text-gray-600">{{ product.description }}</p>
            <p class="font-bold mt-2">{{ product.price }} €</p>
          </div>
        </div>
  
        <div v-else class="text-gray-500">No hay productos en esta categoría.</div>
      </div>
    </AuthenticatedLayout>
  </template>
  
  <script setup>
  defineProps({ category: Object });
  </script>
  