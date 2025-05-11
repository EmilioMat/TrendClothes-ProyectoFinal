<template>
    <AppLayout>
        <div class="bg-gray-50 py-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="mb-8">
                    <h1 class="text-3xl font-bold text-gray-900">
                        {{ category.name }}
                    </h1>
                    <p class="mt-2 text-lg text-gray-600">
                        {{ category.description }}
                    </p>
                </div>

                <div
                    v-if="category.products && category.products.length > 0"
                    class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6"
                >
                    <div
                        v-for="product in category.products"
                        :key="product.id"
                        class="bg-white rounded-xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300"
                    >
                        <div
                            class="h-48 bg-gray-200 flex items-center justify-center"
                        >
                            <img
                                v-if="product.main_image"
                                :src="product.main_image"
                                :alt="product.name || 'Producto'"
                                class="h-full w-full object-cover"
                            />
                            <div v-else class="text-gray-500">Sin imagen</div>
                        </div>
                        <div class="p-6">
                            <h3 class="text-lg font-semibold text-gray-900">
                                {{ product.name || 'Producto sin nombre' }}
                            </h3>
                            <p class="mt-2 text-gray-600 line-clamp-2">
                                {{ product.description || 'Sin descripción' }}
                            </p>
                            <div class="mt-4 flex items-center justify-between">
                                <span
                                    class="text-xl font-bold text-indigo-600"
                                    >{{ formatPrice(product.price || 0) }}</span
                                >
                                <Link
                                    :href="
                                        route('products.show', {
                                            product: product.slug || product.id,
                                        })
                                    "
                                    class="text-sm font-medium text-indigo-600 hover:text-indigo-800"
                                >
                                    Ver detalles
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else class="text-center py-12">
                    <p class="text-gray-500 text-lg">
                        Actualmente no hay productos en esta categoría.
                    </p>
                    <Link
                        :href="route('categories.index')"
                        class="mt-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700"
                    >
                        Ver todas las categorías
                    </Link>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { Link } from "@inertiajs/vue3";

const formatPrice = (price) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(price);
};

defineProps({
    category: {
        type: Object,
        required: true,
    },
});
</script>