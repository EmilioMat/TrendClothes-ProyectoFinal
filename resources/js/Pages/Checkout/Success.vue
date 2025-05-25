<template>
  <AppLayout>
    <div class="bg-white py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
          <h1 class="text-2xl font-bold mb-2">¡Pago completado con éxito!</h1>
          <p>Tu pedido #{{ order.id }} ha sido procesado correctamente.</p>
        </div>
        
        <div class="mt-8">
          <Link href="/" class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">
            Volver a la tienda
          </Link>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

defineProps({
  order: Object
});
</script> 