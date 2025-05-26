<template>
  <AppLayout>
    <div class="bg-white py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold text-gray-900 mb-8">Mi cesta</h1>
        
        <!-- Display flash messages -->
        <div v-if="flash.success" class="mb-4 p-4 bg-green-100 text-green-700 rounded-md">
          {{ flash.success }}
        </div>
        <div v-if="flash.error" class="mb-4 p-4 bg-red-100 text-red-700 rounded-md">
          {{ flash.error }}
        </div>

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
                <div v-for="(item, index) in cartItems" :key="`${item.product.id}-${item.size}`" class="border-b pb-6">
                  <div class="flex flex-col sm:flex-row">
                    <!-- Imagen del producto -->
                    <div class="flex-shrink-0">
                      <img :src="item.product.main_image_url || '/images/placeholder.jpg'" :alt="item.product.name" class="h-24 w-24 rounded-md object-cover">
                    </div>
                    
                    <!-- Detalles del producto -->
                    <div class="ml-4 flex-1">
                      <div class="flex justify-between">
                        <h3 class="text-lg font-medium text-gray-900">{{ item.product.name }}</h3>
                        <p class="ml-4 text-lg font-medium text-gray-900">{{ formatPrice(item.product.price) }}</p>
                      </div>
                      
                      <p class="mt-1 text-sm text-gray-500">Talla: {{ item.size || 'N/A' }}</p>
                      
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
                    <option :value="null">Seleccionar dirección</option>
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
import { toast } from 'vue3-toastify';
import 'vue3-toastify/dist/index.css';

const props = defineProps({
  initialItems: Array,
  addresses: Array,
  address: Object,
  flash: Object, // Add flash prop to receive success/error messages
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
  // Set selectedAddress if address prop is provided
  if (props.address) {
    selectedAddress.value = props.address;
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
  addressForm.post(route('addresses.store'), {
    preserveState: true,
    onSuccess: () => {
      showAddressModal.value = false;
      // Refresh the page to get updated addresses
      window.location.href = route('cart.index');
    },
    onError: (formErrors) => {
      errors.value = formErrors;
      toast.error('Error al guardar la dirección: ' + Object.values(formErrors).join(', '), {
        position: toast.POSITION.TOP_RIGHT,
        autoClose: 3000,
      });
    },
  });
};

// Método para enviar el formulario de checkout
const proceedToCheckout = async () => {
    if (!selectedAddress.value) {
        toast.error('Por favor selecciona una dirección de envío', {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 3000,
        });
        return;
    }

    const form = useForm({
        total: totalPrice.value,
        address_id: selectedAddress.value.id,
    });

    try {
        await form.post(route('checkout.store'), {
            preserveState: true,
            preserveScroll: true,
            onSuccess: () => {
                cartStore.clearCart();
                toast.success('Pedido procesado correctamente', {
                    position: toast.POSITION.TOP_RIGHT,
                    autoClose: 2000,
                });
            },
            onError: (errors) => {
                console.error('Error en el checkout:', errors);
                let errorMessage = 'Ocurrió un error al procesar tu pedido';
                if (errors.error) {
                    errorMessage = errors.error;
                } else if (Object.values(errors).length > 0) {
                    errorMessage += ': ' + Object.values(errors).join(', ');
                }
                toast.error(errorMessage, {
                    position: toast.POSITION.TOP_RIGHT,
                    autoClose: 5000,
                });
            },
        });
    } catch (error) {
        console.error('Error en la solicitud:', error);
        toast.error('Error de conexión al procesar el pago', {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 5000,
        });
    }
};

const increaseQuantity = (index) => {
    const item = cartItems.value[index];
    const itemId = `${item.product.id}-${item.size_id || ''}`;
    cartStore.updateQuantity(itemId, item.quantity + 1);
};

const decreaseQuantity = (index) => {
    const item = cartItems.value[index];
    const itemId = `${item.product.id}-${item.size_id || ''}`;
    if (item.quantity > 1) {
        cartStore.updateQuantity(itemId, item.quantity - 1);
    } else {
        cartStore.removeItem(itemId);
    }
};

const removeItem = (index) => {
    const item = cartItems.value[index];
    const itemId = `${item.product.id}-${item.size_id || ''}`;
    cartStore.removeItem(itemId);
};
</script>