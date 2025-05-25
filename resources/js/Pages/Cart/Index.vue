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
                
                <!-- Selección de dirección -->
                <div class="mt-6">
                  <h3 class="text-md font-medium text-gray-900 mb-2">Dirección de envío</h3>
                  <select v-model="selectedAddress" class="w-full p-2 border rounded-md">
                    <option value="">Seleccionar dirección</option>
                    <option v-for="address in addresses" :key="address.id" :value="address">
                      {{ address.address }}, {{ address.city }}, {{ address.country }}
                    </option>
                  </select>
                </div>
                
                <!-- Botón para abrir el modal o proceder al checkout -->
                <div class="mt-6">
                  <button 
                    @click="openAddressModal"
                    :disabled="cartItems.length === 0"
                    class="w-full flex justify-center items-center px-6 py-3 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-indigo-600 hover:bg-indigo-700 disabled:bg-gray-400"
                  >
                    Tramitar compra
                  </button>
                </div>
                
                <div class="mt-4 text-center">
                  <Link href="/" class="text-indigo-600 hover:text-indigo-500">
                    Continuar comprando
                  </Link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Modal para añadir dirección -->
      <div v-if="showAddressModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white p-6 rounded-lg w-full max-w-md">
          <h2 class="text-xl font-bold mb-4">Añadir nueva dirección</h2>
          <form @submit.prevent="submitAddress">
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700">Dirección</label>
              <input v-model="addressForm.address" type="text" class="mt-1 p-2 w-full border rounded-md" required />
              <p v-if="errors.address" class="text-red-600 text-sm">{{ errors.address }}</p>
            </div>
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700">Ciudad</label>
              <input v-model="addressForm.city" type="text" class="mt-1 p-2 w-full border rounded-md" required />
              <p v-if="errors.city" class="text-red-600 text-sm">{{ errors.city }}</p>
            </div>
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700">Estado/Provincia</label>
              <input v-model="addressForm.state" type="text" class="mt-1 p-2 w-full border rounded-md" required />
              <p v-if="errors.state" class="text-red-600 text-sm">{{ errors.state }}</p>
            </div>
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700">Código postal</label>
              <input v-model="addressForm.zip_code" type="text" class="mt-1 p-2 w-full border rounded-md" required />
              <p v-if="errors.zip_code" class="text-red-600 text-sm">{{ errors.zip_code }}</p>
            </div>
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700">País</label>
              <input v-model="addressForm.country" type="text" class="mt-1 p-2 w-full border rounded-md" required />
              <p v-if="errors.country" class="text-red-600 text-sm">{{ errors.country }}</p>
            </div>
            <div class="flex justify-end space-x-2">
              <button type="button" @click="showAddressModal = false" class="px-4 py-2 bg-gray-300 rounded-md">Cancelar</button>
              <button type="submit" class="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700">Guardar y continuar</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import { defineProps, onMounted, computed, ref } from 'vue';
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link, useForm } from '@inertiajs/vue3';
import { useCartStore } from '@/stores/cart';

const props = defineProps({
  initialItems: Array,
  addresses: Array,
  address: Object,
});

const cartStore = useCartStore();
const cartItems = computed(() => cartStore.items);
const totalPrice = computed(() => cartStore.totalPrice);
const selectedAddress = ref(props.address || null);
const showAddressModal = ref(false);
const addressForm = useForm({
  address: '',
  city: '',
  state: '',
  zip_code: '',
  country: '',
});
const errors = ref({});

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR',
  }).format(price);
};

// Sincronizar con ítems iniciales del backend
onMounted(() => {
  if (props.initialItems && props.initialItems.length > 0) {
    cartStore.syncWithBackend(props.initialItems);
  } else {
    cartStore.loadFromLocalStorage();
  }
});

// Abrir modal si no hay dirección seleccionada
const openAddressModal = () => {
  if (selectedAddress.value) {
    proceedToCheckout();
  } else {
    showAddressModal.value = true;
  }
};

// Enviar formulario de dirección
const submitAddress = () => {
  addressForm.post('/addresses', {
    preserveState: true,
    onSuccess: (response) => {
      showAddressModal.value = false;
      selectedAddress.value = response.props.address;
      proceedToCheckout();
    },
    onError: (formErrors) => {
      errors.value = formErrors;
    },
  });
};

// Método para enviar el formulario de checkout
const proceedToCheckout = async () => {
  if (!selectedAddress.value) {
    alert('Por favor selecciona una dirección de envío');
    return;
  }

  const form = useForm({
    cartItems: cartItems.value.map(item => ({
      product_id: item.product.id,
      quantity: item.quantity,
      size: item.size || null
    })),
    total: totalPrice.value,
    address_id: selectedAddress.value.id
  });

  try {
    await form.post(route('checkout.store'), {
      onSuccess: () => {
        // Limpiar carrito después de éxito
        cartStore.clearCart();
      },
      onError: (errors) => {
        console.error('Error en el checkout:', errors);
        alert('Ocurrió un error al procesar tu pedido');
      }
    });
  } catch (error) {
    console.error('Error en la solicitud:', error);
    alert('Error de conexión al procesar el pago');
  }
};

// Métodos para actualizar el carrito
const increaseQuantity = (index) => {
  cartStore.items[index].quantity += 1;
  cartStore.updateCount();
  cartStore.saveToLocalStorage();
};

const decreaseQuantity = (index) => {
  if (cartStore.items[index].quantity > 1) {
    cartStore.items[index].quantity -= 1;
  } else {
    cartStore.removeItem(index);
  }
  cartStore.updateCount();
  cartStore.saveToLocalStorage();
};

const removeItem = (index) => {
  cartStore.removeItem(index);
};
</script>