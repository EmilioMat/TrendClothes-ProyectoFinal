<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { ref, computed, watch } from 'vue';
import { router, Link } from '@inertiajs/vue3';
import { ElIcon } from 'element-plus';
import { View, ShoppingCart } from '@element-plus/icons-vue';
import { toast } from 'vue3-toastify';

// Estado para controlar la apertura de cada sección de filtros
const filterSections = ref({
    price: true,
    colors: true,
    genders: true,
    sizes: true,
    brands: true
});

const props = defineProps({
    category: {
        type: Object,
        required: true,
    },
    products: Object,
    filterValues: Object,
    filters: Object
});

const formatPrice = (price) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(price);
};

// Refs para los filtros seleccionados
const selectedFilters = ref({
    colors: props.filters.colors || [],
    genders: props.filters.genders || [],
    sizes: props.filters.sizes || [],
    brands: props.filters.brands || [],
    price_min: props.filters.price_min || props.filterValues.priceRange.min,
    price_max: props.filters.price_max || props.filterValues.priceRange.max,
    sort: props.filters.sort || 'newest',
    per_page: props.filters.per_page || 9
});

// Variable para manejar el debounce
let timeoutId = null;

// Estado para controlar la visibilidad de los filtros en móviles
const isFilterOpen = ref(false);

// Estado para los iconos de hover por producto
const hoveredProduct = ref(null);

// Función para determinar la imagen a mostrar
const getProductImage = (product, index) => {
    if (
        hoveredProduct.value === index &&
        product.product_images &&
        Array.isArray(product.product_images) &&
        product.product_images.length > 0 &&
        product.product_images[0].image_path
    ) {
        return product.product_images[0].image_path; // Primera imagen adicional
    }
    return product.main_image || '/images/placeholder.jpg'; // Imagen principal o fallback
};

// Aplicar filtros automáticamente al cambiar
const applyFilters = () => {
    if (timeoutId) {
        clearTimeout(timeoutId);
    }
    timeoutId = setTimeout(() => {
        router.get(route('categories.show', props.category.slug), {
            colors: selectedFilters.value.colors,
            genders: selectedFilters.value.genders,
            sizes: selectedFilters.value.sizes,
            brands: selectedFilters.value.brands,
            price_min: selectedFilters.value.price_min,
            price_max: selectedFilters.value.price_max,
            sort: selectedFilters.value.sort,
            per_page: selectedFilters.value.per_page
        }, {
            preserveState: true,
            replace: true,
            preserveScroll: true
        }).catch((error) => {
            console.error('Error applying filters:', error);
        });
    }, 300);
};

// Resetear filtros
const resetFilters = () => {
    selectedFilters.value = {
        colors: [],
        genders: [],
        sizes: [],
        brands: [],
        price_min: props.filterValues.priceRange.min,
        price_max: props.filterValues.priceRange.max,
        sort: 'newest',
        per_page: 9
    };
    applyFilters();
};

// Computed para ver si hay filtros activos
const hasActiveFilters = computed(() => {
    return selectedFilters.value.colors.length > 0 ||
           selectedFilters.value.genders.length > 0 ||
           selectedFilters.value.sizes.length > 0 ||
           selectedFilters.value.brands.length > 0 ||
           selectedFilters.value.price_min !== props.filterValues.priceRange.min ||
           selectedFilters.value.price_max !== props.filterValues.priceRange.max ||
           selectedFilters.value.sort !== 'newest';
});

// Función para añadir un producto al carrito
const addToCart = (productId) => {
    router.post(route('cart.add'), { product_id: productId }, {
        preserveState: true,
        onSuccess: () => {
            toast.success('Producto añadido al carrito', {
                position: toast.POSITION.TOP_RIGHT,
                autoClose: 3000,
            });
        },
        onError: (errors) => {
            toast.error('Error al añadir el producto al carrito', {
                position: toast.POSITION.TOP_RIGHT,
                autoClose: 3000,
            });
        }
    }).catch((error) => {
        console.error('Error adding to cart:', error);
    });
};

// Observar cambios en los filtros y aplicar automáticamente
watch(() => ({ ...selectedFilters.value }), () => {
    applyFilters();
}, { deep: true });

// Función para añadir parámetros de filtros a los enlaces de paginación
const addFilterParamsToPaginationLink = (url) => {
    if (!url) return url;

    const urlObj = new URL(url);
    const params = new URLSearchParams(); // Create a new params object to avoid duplicates

    // Always add all active filter parameters
    selectedFilters.value.colors.forEach(color => params.append('colors[]', color));
    selectedFilters.value.genders.forEach(gender => params.append('genders[]', gender));
    selectedFilters.value.sizes.forEach(size => params.append('sizes[]', size));
    selectedFilters.value.brands.forEach(brand => params.append('brands[]', brand));
    params.set('price_min', selectedFilters.value.price_min);
    params.set('price_max', selectedFilters.value.price_max);
    params.set('sort', selectedFilters.value.sort);
    params.set('per_page', selectedFilters.value.per_page);

    // Preserve the page parameter from the original URL
    const page = urlObj.searchParams.get('page');
    if (page) {
        params.set('page', page);
    }

    // Update the URL with the new parameters
    urlObj.search = params.toString();
    return urlObj.toString();
};
</script>
<template>
    <AppLayout>
        <div class="bg-gray-50 py-12">
            <!-- Contenedor principal ajustado a 1440px -->
            <div class="mx-auto px-4 sm:px-6 lg:px-8" style="max-width: 1440px; width: 100%;">
                <div class="flex flex-col md:flex-row gap-10">
                    <!-- Filtros -->
                    <div class="w-full md:w-80 lg:w-64 flex-shrink-0">
                        <button 
                            class="md:hidden w-full bg-gradient-to-r from-indigo-600 to-indigo-700 text-white py-3 rounded-lg mb-4 font-medium shadow-md hover:from-indigo-700 hover:to-indigo-800 transition-all duration-300 flex items-center justify-center gap-2"
                            @click="isFilterOpen = !isFilterOpen"
                        >
                            <svg v-if="!isFilterOpen" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586l-5 5V17a1 1 0 01-.293.707l-2 2A1 1 0 0113 19v-5.414l-5-5V4z" />
                            </svg>
                            <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                            </svg>
                            {{ isFilterOpen ? 'Ocultar filtros' : 'Mostrar filtros' }}
                        </button>
                        <div 
                            :class="{ 'hidden': !isFilterOpen }" 
                            class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 sticky top-6 md:block"
                        >
                            <div class="flex justify-between items-center mb-6 border-b border-gray-200 pb-4">
                                <span class="text-xl font-semibold text-gray-900">Filtros</span>
                                <button 
                                    v-if="hasActiveFilters"
                                    @click="resetFilters"
                                    class="text-sm text-indigo-600 hover:text-indigo-800 font-medium transition-colors"
                                >
                                    Limpiar todo
                                </button>
                            </div>

                            <!-- Filtro por precio -->
                            <div class="mb-6 border-b border-gray-200 pb-4">
                                <button 
                                    @click="filterSections.price = !filterSections.price" 
                                    class="flex justify-between items-center w-full text-lg font-medium text-gray-800 mb-3 hover:text-indigo-600 transition-colors"
                                >
                                    Precio
                                    <svg :class="{ 'rotate-180': filterSections.price }" class="w-5 h-5 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </button>
                                <div v-show="filterSections.price" class="space-y-4 transition-all duration-300">
                                    <div class="relative">
                                        <label for="price-min" class="text-sm text-gray-700">Precio mínimo</label>
                                        <input 
                                            type="range" 
                                            id="price-min"
                                            v-model.number="selectedFilters.price_min"
                                            :min="filterValues.priceRange.min"
                                            :max="filterValues.priceRange.max"
                                            class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer mt-1"
                                            style="background: linear-gradient(to right, #4b5563 0%, #4b5563 50%, #e5e7eb 50%, #e5e7eb 100%)"
                                        />
                                        <label for="price-max" class="text-sm text-gray-700 mt-4">Precio máximo</label>
                                        <input 
                                            type="range" 
                                            id="price-max"
                                            v-model.number="selectedFilters.price_max"
                                            :min="filterValues.priceRange.min"
                                            :max="filterValues.priceRange.max"
                                            class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer mt-1"
                                            style="background: linear-gradient(to right, #e5e7eb 0%, #e5e7eb 50%, #4b5563 50%, #4b5563 100%)"
                                        />
                                        <div class="flex justify-between text-sm text-gray-600 mt-2">
                                            <span>{{ formatPrice(selectedFilters.price_min) }}</span>
                                            <span>{{ formatPrice(selectedFilters.price_max) }}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Filtro por color -->
                            <div class="mb-6 border-b border-gray-200 pb-4" v-if="filterValues.colors.length">
                                <button 
                                    @click="filterSections.colors = !filterSections.colors" 
                                    class="flex justify-between items-center w-full text-lg font-medium text-gray-800 mb-3 hover:text-indigo-600 transition-colors"
                                >
                                    Color
                                    <svg :class="{ 'rotate-180': filterSections.colors }" class="w-5 h-5 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </button>
                                <div v-show="filterSections.colors" class="space-y-3 transition-all duration-300">
                                    <div v-for="color in filterValues.colors" :key="color" class="flex items-center">
                                        <input 
                                            type="checkbox" 
                                            :id="`color-${color}`"
                                            v-model="selectedFilters.colors"
                                            :value="color"
                                            class="hidden custom-checkbox"
                                        />
                                        <label :for="`color-${color}`" class="flex items-center cursor-pointer group">
                                            <span class="w-5 h-5 mr-3 rounded-full border-2 border-gray-300 flex items-center justify-center transition-all duration-300 group-hover:border-indigo-500" :style="{ backgroundColor: color }">
                                                <span v-if="selectedFilters.colors.includes(color)" class="w-3 h-3 rounded-full bg-white border-2 border-indigo-600"></span>
                                            </span>
                                            <span class="text-sm text-gray-700 capitalize group-hover:text-indigo-600 transition-colors">{{ color }}</span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Filtro por género -->
                            <div class="mb-6 border-b border-gray-200 pb-4" v-if="filterValues.genders.length">
                                <button 
                                    @click="filterSections.genders = !filterSections.genders" 
                                    class="flex justify-between items-center w-full text-lg font-medium text-gray-800 mb-3 hover:text-indigo-600 transition-colors"
                                >
                                    Género
                                    <svg :class="{ 'rotate-180': filterSections.genders }" class="w-5 h-5 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </button>
                                <div v-show="filterSections.genders" class="space-y-3 transition-all duration-300">
                                    <div v-for="gender in filterValues.genders" :key="gender" class="flex items-center">
                                        <input 
                                            type="checkbox" 
                                            :id="`gender-${gender}`"
                                            v-model="selectedFilters.genders"
                                            :value="gender"
                                            class="hidden custom-checkbox"
                                        />
                                        <label :for="`gender-${gender}`" class="flex items-center cursor-pointer group">
                                            <span class="w-5 h-5 mr-3 rounded border border-gray-300 flex items-center justify-center transition-all duration-300 group-hover:border-indigo-500">
                                                <span v-if="selectedFilters.genders.includes(gender)" class="w-3 h-3 rounded bg-indigo-600"></span>
                                            </span>
                                            <span class="text-sm text-gray-700 capitalize group-hover:text-indigo-600 transition-colors">{{ gender }}</span>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Filtro por talla -->
                            <div class="mb-6 border-b border-gray-200 pb-4" v-if="filterValues.sizes.length">
                                <button 
                                    @click="filterSections.sizes = !filterSections.sizes" 
                                    class="flex justify-between items-center w-full text-lg font-medium text-gray-800 mb-3 hover:text-indigo-600 transition-colors"
                                >
                                    Talla
                                    <svg :class="{ 'rotate-180': filterSections.sizes }" class="w-5 h-5 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </button>
                                <div v-show="filterSections.sizes" class="grid grid-cols-3 gap-3 transition-all duration-300">
                                    <div v-for="(sizeName, sizeId) in filterValues.sizes" :key="sizeId" class="flex items-center">
                                        <input 
                                            type="checkbox" 
                                            :id="`size-${sizeId}`"
                                            v-model="selectedFilters.sizes"
                                            :value="sizeId"
                                            class="hidden custom-checkbox"
                                        />
                                        <label :for="`size-${sizeId}`" class="w-full">
                                            <div 
                                                class="w-full py-2 px-3 text-center text-sm text-gray-700 rounded-lg border border-gray-200 cursor-pointer transition-all duration-300 hover:border-indigo-500 hover:text-indigo-600"
                                                :class="{ 'bg-indigo-50 border-indigo-500 text-indigo-600': selectedFilters.sizes.includes(sizeId) }"
                                            >
                                                {{ sizeName }}
                                            </div>
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- Filtro por marca -->
                            <div class="mb-6 border-b border-gray-200 pb-4" v-if="filterValues.brands.length">
                                <button 
                                    @click="filterSections.brands = !filterSections.brands" 
                                    class="flex justify-between items-center w-full text-lg font-medium text-gray-800 mb-3 hover:text-indigo-600 transition-colors"
                                >
                                    Marcas
                                    <svg :class="{ 'rotate-180': filterSections.brands }" class="w-5 h-5 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </button>
                                <div v-show="filterSections.brands" class="space-y-3 transition-all duration-300">
                                    <div v-for="brand in filterValues.brands" :key="brand" class="flex items-center">
                                        <input 
                                            type="checkbox" 
                                            :id="`brand-${brand}`"
                                            v-model="selectedFilters.brands"
                                            :value="brand"
                                            class="hidden custom-checkbox"
                                        />
                                        <label :for="`brand-${brand}`" class="flex items-center cursor-pointer group">
                                            <span class="w-5 h-5 mr-3 rounded border border-gray-300 flex items-center justify-center transition-all duration-300 group-hover:border-indigo-500">
                                                <span v-if="selectedFilters.brands.includes(brand)" class="w-3 h-3 rounded bg-indigo-600"></span>
                                            </span>
                                            <span class="text-sm text-gray-700 group-hover:text-indigo-600 transition-colors">{{ brand }}</span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Contenido principal -->
                    <div class="flex-1 min-w-0">
                        <div class="mb-10">
                            <div 
                                class="bg-black bg-cover text-white mb-4"
                                style="background-image: url('https://i8.amplience.net/i/jpl/fredhopper-1130x511-mixed-15-449a1eb08a749fea9b06cbf819a2f8e7?fmt=auto'); width: 100%; height: 240px; background-position: center 0%;"
                            >
                                <div class="flex justify-between items-center p-6">
                                    <h1 class="text-2xl font-bold">
                                        {{ category.name }}<br>
                                        <span v-if="products.total" class="text-base font-medium ml-2">
                                            ({{ products.total }} resultados)
                                        </span>
                                    </h1>
                                </div>
                            </div>
                            <!-- Ordenar movido fuera de la caja negra, a la izquierda -->
                            <div class="mb-4">
                                <div class="relative">
                                    <label for="sort-select" class="text-sm text-gray-700">Ordenar por</label>
                                    <select 
                                        id="sort-select"
                                        v-model="selectedFilters.sort"
                                        @change="applyFilters"
                                        class="appearance-none bg-white border border-gray-300 text-gray-700 py-2 px-4 pr-8 rounded-lg leading-tight focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 font-medium mt-1"
                                    >
                                        <option value="newest">Más recientes</option>
                                        <option value="price_asc">Precio: menor a mayor</option>
                                        <option value="price_desc">Precio: mayor a menor</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div
                            v-if="products.data && products.data.length > 0"
                            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"
                        >
                            <Link
                                v-for="(product, index) in products.data"
                                :key="product.id"
                                :href="route('products.show', { product: product.slug || product.id })"
                                class="bg-gray-50 transition-all duration-300 transform hover:-translate-y-2"
                            >
                                <div
                                    class="relative flex items-center justify-center transition-opacity duration-300 aspect-square"
                                    @mouseover="hoveredProduct = index"
                                    @mouseleave="hoveredProduct = null"
                                >
                                    <img
                                        v-if="product.main_image"
                                        :src="getProductImage(product, index)"
                                        :alt="product.name || 'Producto'"
                                        class="h-full w-full object-cover transition-opacity duration-500 ease-in-out"
                                    />
                                    <div v-else class="text-gray-500">Sin imagen</div>
                                    <div 
                                        v-if="hoveredProduct === index" 
                                        class="absolute inset-0 flex items-end justify-center pb-4 opacity-0 hover:opacity-100 transition-opacity duration-300"
                                    >
                                        <Link :href="route('products.show', { product: product.slug || product.id })" class="hover-button">
                                            <el-icon :size="48" class="rounded-full p-4 bg-white hover:bg-gray-200 transition-colors">
                                                <View />
                                            </el-icon>
                                        </Link>
                                    </div>
                                </div>
                                <div class="pt-4 pb-2 px-2 flex flex-col justify-between">
                                    <span class="text-lg font-semibold text-gray-900 line-clamp-1">
                                        {{ product.name || 'Producto sin nombre' }}
                                    </span>
                                    <div class="flex items-center justify-between mt-2">
                                        <span class="text-xl font-bold text-indigo-600">
                                            {{ formatPrice(product.price || 0) }}
                                        </span>
                                    </div>
                                </div>
                            </Link>
                        </div>

                        <div v-else class="text-center py-16">
                            <p class="text-gray-700 text-lg">
                                No se encontraron productos con los filtros seleccionados.
                            </p>
                            <button 
                                @click="resetFilters"
                                class="mt-6 inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 transition-colors"
                            >
                                Limpiar filtros
                            </button>
                        </div>

                        <!-- Paginación -->
                        <div v-if="products.links && products.links.length > 3" class="pagination mt-8">
                            <div class="flex flex-wrap justify-center gap-2">
                                <template v-for="(link, key) in products.links" :key="key">
                                    <div 
                                        v-if="link.url === null" 
                                        class="page-item px-4 py-2 text-sm text-gray-700 bg-[#CCCCCC] border border-gray-300 cursor-not-allowed"
                                    >
                                        {{ key === 0 ? '<' : key === products.links.length - 1 ? '>' : link.label }}
                                    </div>
                                    <Link
                                        v-else
                                        class="page-item page-link px-4 py-2 text-sm border border-gray-300 hover:bg-[#2E2E2E] hover:text-white focus:bg-[#2E2E2E] focus:text-white transition-colors"
                                        :class="{ 'bg-[#2E2E2E] text-white border-[#2E2E2E]': link.active }"
                                        :href="addFilterParamsToPaginationLink(link.url)"
                                    >
                                        {{ key === 0 ? '<' : key === products.links.length - 1 ? '>' : link.label }}
                                    </Link>
                                </template>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
<style scoped>
.line-clamp-1 {
    display: -webkit-box;
    -webkit-line-clamp: 1;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.pagination {
    display: flex;
    justify-content: center;
    margin-top: 2rem;
}

.page-item {
    margin: 0 0.25rem;
}

.page-link {
    padding: 0.5rem 1rem;
}

/* Estilo para los íconos de hover */
.hover-button .el-icon {
    color: black; /* Ícono negro */
}

/* Estilo para el slider de precio */
input[type="range"] {
    -webkit-appearance: none;
    margin: 10px 0;
    width: 100%;
}
input[type="range"]:focus {
    outline: none;
}
input[type="range"]::-webkit-slider-runnable-track {
    width: 100%;
    height: 8px;
    cursor: pointer;
    animate: 0.2s;
    box-shadow: 0px 0px 0px #000000;
    background: #e5e7eb;
    border-radius: 5px;
    border: 0px solid #000000;
}
input[type="range"]::-webkit-slider-thumb {
    box-shadow: 0px 0px 0px #000000;
    border: 2px solid #4b5563;
    height: 18px;
    width: 18px;
    border-radius: 50%;
    background: #ffffff;
    cursor: pointer;
    -webkit-appearance: none;
    margin-top: -5px;
}
input[type="range"]:focus::-webkit-slider-runnable-track {
    background: #e5e7eb;
}
</style>