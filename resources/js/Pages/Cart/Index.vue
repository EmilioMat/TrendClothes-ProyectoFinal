<template>
  <AppLayout>
    <div class="bg-white py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Mi cesta</h1>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Lista de productos -->
          <div class="lg:col-span-2">
            <div v-if="cartItems.length === 0" class="text-center py-12">
              <p class="text-gray-500 text-lg mb-4">Tu carrito está vacío</p>
              <Link href="/" class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">
                Continuar comprando
              </Link>
            </div>
            
            <div v-else>
              <div class="mb-4">
                <p class="text-gray-600">{{ cartItems.length }} producto(s)</p>
              </div>
              
              <div class="space-y-6">
                <div v-for="(item, index) in cartItems" :key="index" class="border-b pb-6">
                  <div class="flex flex-col sm:flex-row">
                    <!-- Imagen del producto -->
                    <div class="flex-shrink-0">
                      <img :src="item.product.main_image" :alt="item.product.name" class="h-24 w-24 rounded-md object-cover">
                    </div>
                    
                    <!-- Detalles del producto -->
                    <div class="ml-4 flex-1">
                      <div class="flex justify-between">
                        <h3 class="text-lg font-medium text-gray-900">{{ item.product.name }}</h3>
                        <p class="ml-4 text-lg font-medium text-gray-900">{{ formatPrice(item.product.price) }}</p>
                      </div>
                      
                      <p class="mt-1 text-sm text-gray-500">Talla: {{ item.size }}</p>
                      
                      <div class="flex items-center justify-between mt-4">
                        <div class="flex items-center space-x-2">
                          <button @click="decreaseQuantity(index)" class="text-gray-500 hover:text-indigo-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                              <path fill-rule="evenodd" d="M5 10a1 1 0 011-1h8a1 1 0 110 2H6a1 1 0 01-1-1z" clip-rule="evenodd" />
                            </svg>
                          </button>
                          <span class="text-gray-700">{{ item.quantity }}</span>
                          <button @click="increaseQuantity(index)" class="text-gray-500 hover:text-indigo-600">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                              <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
                            </svg>
                          </button>
                        </div>
                        
                        <button @click="removeItem(index)" class="text-sm text-red-600 hover:text-red-800">
                          Eliminar
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Resumen del pedido -->
          <div v-if="cartItems.length > 0" class="lg:col-span-1">
            <div class="bg-gray-50 p-6 rounded-lg">
              <h2 class="text-lg font-medium text-gray-900 mb-4">Resumen del pedido</h2>
              
              <div class="space-y-4">
                <div class="flex justify-between">
                  <p class="text-gray-600">Subtotal</p>
                  <p class="text-gray-900">{{ formatPrice(totalPrice) }}</p>
                </div>
                
                <div class="border-t border-gray-200 pt-4">
                  <div class="flex justify-between">
                    <p class="text-gray-600">Gastos de envío</p>
                    <p class="text-gray-600">Calculado en el siguiente paso</p>
                  </div>
                </div>
                
                <div class="border-t border-gray-200 pt-4">
                  <div class="flex justify-between">
                    <p class="font-medium text-gray-900">Total</p>
                    <p class="font-medium text-gray-900">{{ formatPrice(totalPrice) }}</p>
                  </div>
                  <p class="text-sm text-gray-500 mt-1">IVA incl.</p>
                </div>
                
                <div class="mt-6">
                  <Link href="/checkout" class="w-full flex justify-center items-center px-6 py-3 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700">
                    Tramitar compra
                  </Link>
                </div>
                
                <div class="mt-4 text-center">
                  <p class="text-sm text-gray-500">o <Link href="/" class="text-indigo-600 hover:text-indigo-500">continuar comprando</Link></p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';
import { useCartStore } from '@/stores/cart';
import { computed } from 'vue';

const cartStore = useCartStore();

const cartItems = computed(() => cartStore.items);
const totalPrice = computed(() => cartStore.totalPrice);

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};

const increaseQuantity = (index) => {
  cartStore.items[index].quantity += 1;
  cartStore.saveToLocalStorage();
};

const decreaseQuantity = (index) => {
  if (cartStore.items[index].quantity > 1) {
    cartStore.items[index].quantity -= 1;
  } else {
    cartStore.removeItem(index);
  }
  cartStore.saveToLocalStorage();
};

const removeItem = (index) => {
  cartStore.removeItem(index);
};
</script>