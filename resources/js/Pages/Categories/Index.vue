<template>
  <AppLayout>
    <template #header>
      <h2 class="text-xl font-bold">Categorías</h2>
    </template>

    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 p-6">
      <div
        v-for="category in categories"
        :key="category.id"
        class="p-4 bg-white shadow hover:shadow-md rounded-lg transition-shadow"
      >
        <h3 class="text-lg font-semibold">{{ category.name }}</h3>
        <p class="text-gray-600">{{ category.description }}</p>
        <Link 
          :href="route('categories.show', { category: category.id })" 
          class="text-blue-500 hover:text-blue-700 underline mt-2 inline-block"
        >
          Ver productos
        </Link>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

defineProps({ 
  categories: {
    type: Array,
    required: true
  }
});
</script>