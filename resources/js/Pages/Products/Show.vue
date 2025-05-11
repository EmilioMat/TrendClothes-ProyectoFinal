<template>
  <AppLayout>
    <div class="bg-gray-50 py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <!-- Breadcrumb dinámico -->
        <div class="text-sm text-gray-500 mb-4">
          <Link :href="route('categories.index')" class="hover:text-gray-700">
            {{ product.gender === 'male' ? 'Hombre' : product.gender === 'female' ? 'Mujer' : 'Unisex' }}
          </Link>
          <span v-if="product.category"> - </span>
          <Link v-if="product.category" 
                :href="route('categories.show', { category: product.category.toLowerCase().replace(/ /g, '-') })" 
                class="hover:text-gray-700">
            {{ product.category }}
          </Link>
          <span> - </span>
          <span class="font-semibold">{{ product.name }}</span>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Images Section -->
          <div>
            <!-- Main Image -->
            <div class="h-96 bg-gray-100 rounded-lg flex items-center justify-center mb-4">
              <img 
                v-if="product.main_image" 
                :src="product.main_image" 
                :alt="product.name"
                class="h-full w-full object-contain"
              >
              <div v-else class="text-gray-500">Sin imagen</div>
            </div>

            <!-- Thumbnails -->
            <div v-if="product.images.length" class="grid grid-cols-4 gap-2">
              <div v-for="(image, index) in product.images" :key="index" 
                   class="h-24 bg-gray-100 rounded flex items-center justify-center cursor-pointer hover:border-2 hover:border-indigo-500"
                   @click="changeMainImage(image)">
                <img :src="image" :alt="product.name + ' - Imagen ' + (index + 1)" class="h-full w-full object-contain">
              </div>
            </div>
          </div>

          <!-- Product Details -->
          <div>
            <h1 class="text-2xl font-bold text-gray-900">{{ product.name }}</h1>
            <p class="text-gray-600 mt-2">{{ product.type || 'Zapatillas Running' }} {{ product.gender === 'male' ? 'Hombre' : product.gender === 'female' ? 'Mujer' : 'Unisex' }} | {{ product.brand || 'Marca' }}</p>
            
            <!-- Price -->
            <div class="mt-6">
              <span class="text-3xl font-bold">{{ formatPrice(product.price) }}</span>
              <span v-if="product.original_price" class="ml-2 text-sm text-gray-500 line-through">{{ formatPrice(product.original_price) }}</span>
            </div>

            <!-- Discount and points -->
            <div class="mt-2 text-sm" v-if="product.discount || product.points">
              <p>Hasta acceso del <span class="font-semibold">{{ product.discount || 0 }}%</span> y reanhela <span class="font-semibold">{{ product.points || 0 }}</span> puntos por esta compra.</p>
            </div>

            <!-- Sizes -->
            <div class="mt-8">
              <h3 class="text-sm font-medium text-gray-900">Tallas disponibles:</h3>
              <div class="grid grid-cols-3 gap-2 mt-2">
                <button v-for="size in product.sizes || []" 
                        :key="size"
                        class="border border-gray-300 rounded-md py-2 px-3 text-sm font-medium hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                        :class="{ 'bg-indigo-100 border-indigo-500': selectedSize === size }"
                        @click="selectedSize = size">
                  {{ size }}
                </button>
              </div>
            </div>

            <!-- Add to cart button -->
            <button class="mt-8 w-full bg-indigo-600 border border-transparent rounded-md py-3 px-8 flex items-center justify-center text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                    @click="addToCart"
                    :disabled="!selectedSize">
              Añadir a la cesta
            </button>

            <!-- Shipping info -->
            <div class="mt-6 border-t border-gray-200 pt-6">
              <p class="text-sm text-gray-600">Vendido y enviado por <span class="font-semibold">{{ product.seller || 'Spiritier' }}</span></p>
              <p class="text-sm text-gray-600 mt-1">Envío <span class="font-semibold">GRATIS</span> a domicilio</p>
              <p class="text-sm text-gray-600 mt-1">Entrega estimada el <span class="font-semibold">{{ estimatedDeliveryDate }}</span></p>
              <p class="text-sm text-gray-600 mt-1">- Envío domicilio en pantalla</p>
              <p class="text-sm text-gray-600 mt-1">Puede ser realizado de 23,35€ en intereses con PayPal.</p>
            </div>

            <!-- Payment info -->
            <div class="mt-4">
              <p class="text-sm text-gray-600">Normal:</p>
              <p class="text-xs text-gray-500">Pagar n° 2 (estate de 23) 21 € en intereses (90°, 100), Norma</p>
              <p class="text-xs text-gray-500">UM: Información</p>
            </div>
          </div>
        </div>

        <!-- Product information section -->
        <div class="mt-12 border-t border-gray-200 pt-8">
          <h2 class="text-lg font-medium text-gray-900">Información de producto</h2>
          <div class="mt-4">
            <p class="text-gray-600">{{ product.description || 'Descripción detallada del producto no disponible.' }}</p>
          </div>
        </div>

        <!-- Shipping section -->
        <div class="mt-8 border-t border-gray-200 pt-8">
          <h2 class="text-lg font-medium text-gray-900">Envío</h2>
          <div class="mt-4">
            <p class="text-gray-600">Información sobre políticas de envío, plazos de entrega y costes asociados.</p>
          </div>
        </div>
      </div>
    </div>
  </AppLayout>
</template>

<script setup>
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

const props = defineProps({
  product: {
    type: Object,
    required: true,
    default: () => ({
      name: '',
      brand: '',
      category: '',
      gender: '',
      type: '',
      price: 0,
      original_price: null,
      description: '',
      main_image: null,
      images: [],
      sizes: [],
      stock: 0,
      discount: 0,
      points: 0,
      seller: ''
    })
  }
});

const selectedSize = ref(null);
const currentMainImage = ref(props.product.main_image);

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR'
  }).format(price);
};

const changeMainImage = (image) => {
  currentMainImage.value = image;
};

const addToCart = () => {
  if (!selectedSize.value) return;
  
  // Lógica para añadir al carrito
  console.log('Añadiendo al carrito:', {
    product: props.product.name,
    size: selectedSize.value,
    price: props.product.price
  });
  
  // Aquí podrías llamar a una acción de tu store (Pinia) o hacer una petición API
};

const estimatedDeliveryDate = computed(() => {
  const date = new Date();
  date.setDate(date.getDate() + 3); // 3 días para entrega
  return date.toLocaleDateString('es-ES', { day: 'numeric', month: 'long' });
});
</script>