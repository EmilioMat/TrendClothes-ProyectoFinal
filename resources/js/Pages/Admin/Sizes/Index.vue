<template>
  <AdminLayout>
    <SizesList :sizes="sizes" />
  </AdminLayout>
</template>

<script setup>
defineProps({
  sizes: Object,
});

import AdminLayout from '../Components/AdminLayout.vue';
import SizesList from './SizesList.vue';
</script>
