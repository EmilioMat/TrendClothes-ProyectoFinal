<template>
  <AppLayout>
    <div class="bg-white py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <h1 class="text-3xl font-bold text-gray-900 mb-4">¡Pago realizado con éxito!</h1>
        <p class="text-gray-600 mb-6">Gracias por tu compra. Recibirás un correo con los detalles de tu pedido.</p>
        <Link href="/" class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">
          Volver a la tienda
        </Link>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';
</script> 