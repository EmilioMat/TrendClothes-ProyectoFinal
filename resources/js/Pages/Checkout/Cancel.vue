<template>
  <AppLayout>
    <div class="bg-white py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
          <h1 class="text-2xl font-bold mb-2">Pago cancelado</h1>
          <p>El pedido #{{ order.id }} no se ha completado.</p>
        </div>
        
        <div class="mt-8 space-x-4">
          <Link href="/cart" class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">
            Volver al carrito
          </Link>
          <Link href="/" class="inline-flex items-center px-4 py-2 bg-gray-600 text-white rounded-md hover:bg-gray-700">
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