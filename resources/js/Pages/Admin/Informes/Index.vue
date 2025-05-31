<template>
    <AdminLayout>
        <InformesList :orders="orders" />
    </AdminLayout>
</template>

<script setup>
defineProps({
    orders: Array,
});

import AdminLayout from "../Components/AdminLayout.vue";
import InformesList from "./InformesList.vue";
</script>
