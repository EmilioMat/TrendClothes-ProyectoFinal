<template>
    <AdminLayout>
        <ProductList :products="products" :categories="categories" :sizes="sizes" />
    </AdminLayout>
</template>

<script setup>
defineProps({
    products: Object,
    categories: Array,
    sizes: Array
})

import AdminLayout from '../Components/AdminLayout.vue'
import ProductList from './ProductList.vue'
</script>
