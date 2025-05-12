<template>
  <div class="bg-white p-4 rounded-lg shadow mb-6">
    <h3 class="font-bold text-lg mb-4">Filtrar productos</h3>
    
    <!-- Filtro por Género -->
    <div class="mb-6">
      <h4 class="font-medium text-gray-900 mb-2">Género</h4>
      <div class="space-y-2">
        <label v-for="gender in genders" :key="gender.value" class="flex items-center">
          <input 
            type="checkbox" 
            v-model="selectedGenders" 
            :value="gender.value" 
            class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
            @change="applyFilters"
          >
          <span class="ml-3 text-sm text-gray-700">{{ gender.label }}</span>
        </label>
      </div>
    </div>

    <!-- Filtro por Categoría -->
    <div class="mb-6" v-if="categories.length">
      <h4 class="font-medium text-gray-900 mb-2">Categoría</h4>
      <div class="space-y-2">
        <label v-for="category in categories" :key="category.id" class="flex items-center">
          <input 
            type="checkbox" 
            v-model="selectedCategories" 
            :value="category.id" 
            class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
            @change="applyFilters"
          >
          <span class="ml-3 text-sm text-gray-700">{{ category.name }}</span>
        </label>
      </div>
    </div>

    <!-- Filtro por Precio -->
    <div class="mb-6">
      <h4 class="font-medium text-gray-900 mb-2">Rango de precio</h4>
      <div class="flex items-center justify-between mb-2">
        <span class="text-sm text-gray-500">{{ formatPrice(priceRange[0]) }}</span>
        <span class="text-sm text-gray-500">{{ formatPrice(priceRange[1]) }}</span>
      </div>
      <vue-slider 
        v-model="priceRange" 
        :min="0" 
        :max="1000" 
        :interval="10"
        @change="applyFilters"
        tooltip="always"
        :tooltip-formatter="formatPrice"
      />
    </div>

    <button 
      @click="resetFilters"
      class="mt-4 w-full py-2 px-4 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
    >
      Limpiar filtros
    </button>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { router } from '@inertiajs/vue3';
import VueSlider from 'vue-slider-component';
import 'vue-slider-component/theme/default.css';

const props = defineProps({
  categories: {
    type: Array,
    default: () => []
  },
  filters: {
    type: Object,
    default: () => ({})
  }
});

const genders = [
  { value: 'male', label: 'Hombre' },
  { value: 'female', label: 'Mujer' },
  { value: 'unisex', label: 'Unisex' }
];

const selectedGenders = ref(props.filters.genders ? props.filters.genders.split(',') : []);
const selectedCategories = ref(props.filters.categories ? props.filters.categories.split(',') : []);
const priceRange = ref([
  props.filters.min_price ? parseInt(props.filters.min_price) : 0,
  props.filters.max_price ? parseInt(props.filters.max_price) : 1000
]);

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};

const applyFilters = () => {
  router.get(route('products.index'), {
    genders: selectedGenders.value.join(','),
    categories: selectedCategories.value.join(','),
    min_price: priceRange.value[0],
    max_price: priceRange.value[1],
    sort: route().params.sort
  }, {
    preserveState: true,
    replace: true
  });
};

const resetFilters = () => {
  selectedGenders.value = [];
  selectedCategories.value = [];
  priceRange.value = [0, 1000];
  applyFilters();
};

// Observar cambios en los filtros iniciales
watch(() => props.filters, (newFilters) => {
  selectedGenders.value = newFilters.genders ? newFilters.genders.split(',') : [];
  selectedCategories.value = newFilters.categories ? newFilters.categories.split(',') : [];
  priceRange.value = [
    newFilters.min_price ? parseInt(newFilters.min_price) : 0,
    newFilters.max_price ? parseInt(newFilters.max_price) : 1000
  ];
});
</script>