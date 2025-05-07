<template>
  <AuthenticatedLayout>
    <template #header>
      <h2 class="text-xl font-bold">Categorías</h2>
    </template>

    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 p-6">
      <div
        v-for="category in categories"
        :key="category.id"
        class="p-4 bg-white shadow hover:shadow-md rounded"
      >
        <h3 class="text-lg font-semibold">{{ category.name }}</h3>
        <p class="text-gray-600">{{ category.description }}</p>
        <a :href="route('categories.show', category.id)" class="text-blue-500 underline mt-2 inline-block">
          Ver productos
        </a>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<script setup>
defineProps({ categories: Array });
</script>
