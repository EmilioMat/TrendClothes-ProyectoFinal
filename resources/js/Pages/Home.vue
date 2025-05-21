<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Flash Message -->
    <div
      v-if="page.props.flash.success"
      class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-700 p-4 fixed top-0 w-full z-50"
      role="alert"
    >
      <div class="max-w-7xl mx-auto flex justify-between items-center">
        <p>{{ page.props.flash.success }}</p>
        <button
          @click="page.props.flash.success = null"
          class="text-emerald-700 hover:text-emerald-900"
          aria-label="Cerrar mensaje"
        >
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path
              fill-rule="evenodd"
              d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
      </div>
    </div>

    <!-- Navigation -->
    <nav class="bg-white shadow-lg">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-20 items-center">
          <!-- Logo -->
          <div class="flex items-center">
            <Link :href="route('home')" class="text-2xl font-bold text-indigo-600">TrendClothes</Link>
          </div>

          <!-- Desktop Menu -->
          <div class="hidden md:flex md:items-center md:ml-6 md:space-x-8">
            <Link
              :href="route('home')"
              class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
              :class="route().current('home') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'"
            >
              Inicio
            </Link>
            <Link
              :href="route('categories.index')"
              class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
              :class="route().current('categories.*') ? 'border-indigo-500 text-gray-900' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700'"
            >
              Categorías
            </Link>
          </div>

<!-- Right Menu (Cart & User) -->
<div class="flex items-center space-x-4">
  <!-- Cart with Hover Preview -->
  <div class="relative group">
    <Link :href="route('cart.index')" class="text-gray-700 hover:text-indigo-600 flex items-center">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        class="h-6 w-6"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
        />
      </svg>
      <span
        v-if="cartCount > 0"
        class="absolute -top-2 -right-2 bg-indigo-600 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center"
      >
        {{ cartCount }}
      </span>
    </Link>
    <!-- Cart Preview Dropdown - Position fixed -->
    <div
      class="fixed md:absolute left-0 md:left-auto right-0 md:right-auto mt-2 w-full md:w-80 bg-white rounded-lg shadow-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none group-hover:pointer-events-auto z-10"
      style="max-width: 95vw; margin: 0 auto; transform: translateX(-50%); left: 50%;"
    >
      <div class="p-4">
        <h3 class="text-sm font-semibold text-gray-900">Carrito</h3>
        <div v-if="cartItems.length > 0" class="mt-2 space-y-2">
          <div
            v-for="item in cartItems"
            :key="item.id"
            class="flex items-center space-x-4"
          >
            <img
              v-if="item.product.main_image"
              :src="item.product.main_image"
              :alt="item.product.name"
              class="h-12 w-12 object-cover rounded"
            />
            <div>
              <p class="text-sm text-gray-700">{{ item.product.name }}</p>
              <p class="text-xs text-gray-500">Cantidad: {{ item.quantity }}</p>
              <p class="text-sm font-semibold text-indigo-600">
                {{ formatPrice(item.product.price * item.quantity) }}
              </p>
            </div>
          </div>
        </div>
        <p v-else class="text-sm text-gray-500">Tu carrito está vacío</p>
        <Link
          :href="route('cart.index')"
          class="mt-4 block text-center text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-md py-2"
        >
          Ver Carrito
        </Link>
      </div>
    </div>
  </div>

            <!-- User Menu -->
            <template v-if="page.props.auth.user">
              <div class="hidden md:block">
                <Dropdown align="right" width="48">
                  <template #trigger>
                    <button
                      class="flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 focus:outline-none"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        class="h-6 w-6"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                        />
                      </svg>
                    </button>
                  </template>
                  <template #content>
                    <DropdownLink :href="route('profile.edit')">Perfil</DropdownLink>
                    <DropdownLink v-if="page.props.auth.user.is_admin" :href="route('admin.dashboard')">
                      Panel de Administración
                    </DropdownLink>
                    <DropdownLink :href="route('logout')" method="post" as="button">
                      Cerrar Sesión
                    </DropdownLink>
                  </template>
                </Dropdown>
              </div>
            </template>
            <template v-else>
              <Link
                :href="route('login')"
                class="text-sm font-medium text-gray-700 hover:text-gray-900 mr-4 hidden md:block"
              >
                Iniciar Sesión
              </Link>
              <Link
                v-if="page.props.canRegister"
                :href="route('register')"
                class="text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 px-4 py-2 rounded-md hidden md:block"
              >
                Registrarse
              </Link>
            </template>

            <!-- Mobile Menu Button -->
            <div class="md:hidden">
              <button
                @click="mobileMenuOpen = !mobileMenuOpen"
                class="text-gray-500 hover:text-gray-700 focus:outline-none"
                aria-label="Abrir menú"
              >
                <svg
                  v-if="!mobileMenuOpen"
                  class="h-6 w-6"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M4 6h16M4 12h16M4 18h16"
                  />
                </svg>
                <svg
                  v-else
                  class="h-6 w-6"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
          </div>
        </div>

        <!-- Mobile Menu Content (Updated with margin and submenu) -->
        <div v-if="mobileMenuOpen" class="md:hidden fixed inset-0 z-50">
          <div 
            class="absolute inset-0 overflow-y-auto bg-gray-900 bg-opacity-80 backdrop-blur-md"
            style="border: 0; bottom: 0; height: 100%; left: 0; overflow-y: scroll; padding: 0; position: absolute; right: 20px; width: calc(100% - 20px);"
          >
            <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
              <div class="flex justify-end p-4">
                <button
                  @click="mobileMenuOpen = false"
                  class="text-white hover:text-gray-300 focus:outline-none"
                  aria-label="Cerrar menú"
                >
                  <svg
                    class="h-8 w-8"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M6 18L18 6M6 6l12 12"
                    />
                  </svg>
                </button>
              </div>
              
              <div class="flex flex-col items-center mt-8">
                <Link
                  :href="route('home')"
                  class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                  :class="route().current('home') ? 'text-indigo-300' : 'hover:text-gray-300'"
                  @click="mobileMenuOpen = false"
                >
                  Inicio
                </Link>
                <Link
                  :href="route('categories.index')"
                  class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                  :class="route().current('categories.*') ? 'text-indigo-300' : 'hover:text-gray-300'"
                  @click="mobileMenuOpen = false"
                >
                  Categorías
                </Link>
                
                <template v-if="page.props.auth.user">
                  <div class="w-full">
                    <button
                      @click="subMenuOpen = !subMenuOpen"
                      class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                    >
                      MI TRENDCLOTHES
                    </button>
                    <div v-if="subMenuOpen" class="pl-6 space-y-2">
                      <Link
                        :href="route('profile.edit')"
                        class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                        @click="mobileMenuOpen = false; subMenuOpen = false"
                      >
                        Mi Perfil
                      </Link>
                      <Link
                        v-if="page.props.auth.user.is_admin"
                        :href="route('admin.dashboard')"
                        class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                        @click="mobileMenuOpen = false; subMenuOpen = false"
                      >
                        Panel de Administración
                      </Link>
                      <Link
                        :href="route('logout')"
                        method="post"
                        as="button"
                        class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                        @click="mobileMenuOpen = false; subMenuOpen = false"
                      >
                        Log Out
                      </Link>
                    </div>
                  </div>
                </template>
                <template v-else>
                  <Link
                    :href="route('login')"
                    class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                    @click="mobileMenuOpen = false"
                  >
                    Iniciar Sesión
                  </Link>
                  <Link
                    v-if="page.props.canRegister"
                    :href="route('register')"
                    class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                    @click="mobileMenuOpen = false"
                  >
                    Registrarse
                  </Link>
                </template>
              </div>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Carousel (Full Width and Height) -->
    <div class="relative overflow-hidden w-full h-[600px] md:h-[800px]">
      <div class="flex transition-transform duration-500 h-full" :style="{ transform: `translateX(-${currentSlide * 100}%)` }">
        <!-- Slide 1 -->
        <div class="min-w-full h-full flex items-center justify-center relative">
          <picture>
            <source media="(max-width: 767px)" srcset="https://i8.amplience.net/i/jpl/mobile-top-banner-720x1050-2025-05-13t153525771-ca27ab2d2b8c5016e2e5eade26786edc?qlt=80&fmt=auto">
            <source media="(min-width: 768px)" srcset="https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-2025-05-13t153517759-f5467e4fe2ccef4878308f95714fbb98?qlt=80&fmt=auto">
            <img
              src="https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-2025-05-13t153517759-f5467e4fe2ccef4878308f95714fbb98?qlt=80&fmt=auto"
              alt="Nueva Colección Otoño"
              class="w-full h-full object-cover object-center md:object-top"
            />
          </picture>
          <div class="absolute text-center text-white px-4 hidden md:block" style="top: 50%; left: 50%; transform: translate(-50%, -50%);">
            <h2 class="text-2xl md:text-4xl font-bold">Nueva Colección Otoño</h2>
            <p class="mt-2 text-sm md:text-base">Descubre las últimas tendencias</p>
            <Link
              :href="route('categories.index')"
              class="mt-4 inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 text-sm md:text-base"
            >
              Comprar Ahora
            </Link>
          </div>
        </div>
        
        <!-- Slide 2 -->
        <div class="min-w-full h-full flex items-center justify-center relative">
          <picture>
            <source media="(max-width: 767px)" srcset="https://i8.amplience.net/i/jpl/mobile-top-banner-720x1050-2025-05-09t163826380-eafc57802cbc15d2968582c44e919c4c?qlt=80&fmt=auto">
            <source media="(min-width: 768px)" srcset="https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-2025-05-09t163833757-e61e5ea4614aaf39dabf51f435f15209?qlt=80&fmt=auto">
            <img
              src="https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-2025-05-09t163833757-e61e5ea4614aaf39dabf51f435f15209?qlt=80&fmt=auto"
              alt="Ofertas Exclusivas"
              class="w-full h-full object-cover object-center md:object-top"
            />
          </picture>
          <div class="absolute text-center text-white px-4 hidden md:block" style="top: 50%; left: 50%; transform: translate(-50%, -50%);">
            <h2 class="text-2xl md:text-4xl font-bold">Ofertas Exclusivas</h2>
            <p class="mt-2 text-sm md:text-base">Hasta 50% de descuento</p>
            <Link
              :href="route('categories.index')"
              class="mt-4 inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 text-sm md:text-base"
            >
              Ver Ofertas
            </Link>
          </div>
        </div>
        
        <!-- Slide 3 (Updated content) -->
        <div class="min-w-full h-full flex items-center justify-center relative">
          <picture>
            <source media="(max-width: 767px)" srcset="https://i8.amplience.net/i/jpl/mobile-top-banner-720x1050-home-es-1-8f2cf45a6668e331e7b3be780447eec8?qlt=80&fmt=auto">
            <source media="(min-width: 768px)" srcset="https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-home-3-ca175881606ef5740db12f2ecffce811?qlt=80&fmt=auto">
            <img
              src="https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-home-3-ca175881606ef5740db12f2ecffce811?qlt=80&fmt=auto"
              alt="Moda Sostenible"
              class="w-full h-full object-cover object-center md:object-top"
            />
          </picture>
          <div class="absolute text-center text-white px-4 hidden md:block" style="top: 50%; left: 50%; transform: translate(-50%, -50%);">
            <h2 class="text-2xl md:text-4xl font-bold">Moda Sostenible</h2>
            <p class="mt-2 text-sm md:text-base">Estilo con conciencia ecológica</p>
            <Link
              :href="route('categories.index')"
              class="mt-4 inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 text-sm md:text-base"
            >
              Descubrir Ahora
            </Link>
          </div>
        </div>
      </div>
      <button
        @click="prevSlide"
        class="absolute top-1/2 left-4 transform -translate-y-1/2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100"
        aria-label="Diapositiva anterior"
      >
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
      </button>
      <button
        @click="nextSlide"
        class="absolute top-1/2 right-4 transform -translate-y-1/2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100"
        aria-label="Siguiente diapositiva"
      >
        <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
      </button>
    </div>

    <!-- Message Slider (No Margin After Carousel) -->
    <div class="bg-indigo-600 text-white h-11">
      <div class="w-full overflow-hidden">
        <div
          class="flex transition-transform duration-500"
          :style="{ transform: `translateX(-${currentMessage * 100}%)` }"
        >
          <div
            v-for="(message, index) in messages"
            :key="index"
            class="min-w-full flex items-center justify-center h-11"
          >
            <p class="text-base font-semibold">{{ message.text }}</p>
            <Link
              v-if="message.link"
              :href="message.link"
              class="ml-4 text-sm text-white border border-white rounded-md px-2 py-1 hover:bg-indigo-700"
            >
              {{ message.cta }}
            </Link>
          </div>
        </div>
      </div>
    </div>

    <!-- Categories Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mb-12 mt-12">
      <h2 class="text-3xl font-bold text-gray-900 mb-6 text-center">Explora por Categoría</h2>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="category in categories"
          :key="category.id"
          class="relative w-full h-[700px] bg-cover bg-center rounded-lg shadow-md overflow-hidden hover:shadow-lg group"
          :style="{ backgroundImage: `url(${category.image || 'https://via.placeholder.com/500x700'})` }"
        >
          <Link
            :href="route('categories.index') + '?type=' + category.name.toLowerCase()"
            class="absolute inset-0 flex flex-col items-center justify-end bg-black bg-opacity-0 group-hover:bg-opacity-30 transition duration-300 pb-12"
          >
            <!-- Category Title -->
            <span class="spot_cta_title text-white text-center mb-4" style="
              font-size: 50px;
              font-weight: normal;
              font-stretch: normal;
              font-style: normal;
              line-height: 0.79;
              text-align: center;
              color: #fff !important;
              margin: 0;
              padding: 0;
              margin-bottom: 20px;
              letter-spacing: 0px;
              font-family: 'Gotham Ultra';
              text-shadow: 1px 1px 2px #000000;
              text-decoration: none;
              display: block;
              text-align: center;
              padding: 1rem;
              font-weight: 900;
              text-transform: uppercase;
            ">
              {{ category.name }}
            </span>
            
            <!-- Category Button -->
            <span class="spot_cta" style="
              border-color: #fff;
              cursor: pointer;
              color: #000;
              background: #fff;
              width: calc(100% - 40px);
              padding: 6% 10%;
              margin: 0 20px;
              border-color: #000;
              display: flex;
              align-items: center;
              justify-content: center;
              font-size: 16px; /* Updated to 16px */
              white-space: nowrap;
              font-weight: 700;
              max-height: 15px;
              transition: background-color .5s, color .5s;
              font-family: Gotham SSm A, Gotham SSm B, Arial, sans-serif;
            ">
              Ver categoría
            </span>
          </Link>
        </div>
      </div>
    </div>

    <!-- Brand Slider (updated) -->
    <div class="bg-white py-8 mb-12">
      <h2 class="text-2xl font-bold text-gray-900 mb-6 text-center">Nuestras Marcas</h2>
      <div class="w-full overflow-hidden relative">
        <div class="flex items-center justify-center">
          <div
            v-for="(brand, index) in visibleBrands"
            :key="index"
            class="flex-shrink-0 w-[150px] flex items-center justify-center px-4"
          >
            <a
              :target="brand.target"
              :label="brand.label"
              :date="brand.date"
              :href="brand.href"
            >
              <img
                :alt="brand.name"
                :title="brand.name"
                loading="lazy"
                width="77"
                height="50"
                decoding="async"
                class="hover:opacity-70"
                :src="brand.src"
              />
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 class="text-lg font-semibold mb-4">TrendClothes</h3>
            <p class="text-gray-400">La mejor selección de moda para todos los estilos.</p>
          </div>
          <div>
            <h3 class="text-lg font-semibold mb-4">Categorías</h3>
            <ul class="space-y-2">
              <li>
                <Link :href="route('categories.index')" class="text-gray-400 hover:text-white">
                  Todas las categorías
                </Link>
              </li>
              <li v-for="category in categories" :key="category.id">
                <a :href="route('categories.index') + '?type=' + category.name.toLowerCase()" class="text-gray-400 hover:text-white">
                  {{ category.name }}
                </a>
              </li>
            </ul>
          </div>
          <div>
            <h3 class="text-lg font-semibold mb-4">Ayuda</h3>
            <ul class="space-y-2">
              <li><a href="#" class="text-gray-400 hover:text-white">Contacto</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Envíos</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Devoluciones</a></li>
            </ul>
          </div>
          <div>
            <h3 class="text-lg font-semibold mb-4">Legal</h3>
            <ul class="space-y-2">
              <li><a href="#" class="text-gray-400 hover:text-white">Términos y condiciones</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Política de privacidad</a></li>
            </ul>
          </div>
        </div>
        <div class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400">
          <p>© 2025 TrendClothes. Todos los derechos reservados.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import Dropdown from '@/Components/Dropdown.vue';
import DropdownLink from '@/Components/DropdownLink.vue';
import { useCartStore } from '@/stores/cart';
import { ref, computed, onMounted, onUnmounted } from 'vue';

// Access page props using usePage()
const page = usePage();

const cartStore = useCartStore();
const cartCount = computed(() => cartStore.count);
const cartItems = computed(() => cartStore.items);

const mobileMenuOpen = ref(false);
const subMenuOpen = ref(false);

const formatPrice = (price) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR',
  }).format(price);
};

// Carousel
const slides = [
  {
    image: 'https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-2025-05-13t153517759-f5467e4fe2ccef4878308f95714fbb98?qlt=80&fmt=auto',
    alt: 'Promoción 1',
    title: 'Nueva Colección Otoño',
    description: 'Descubre las últimas tendencias',
    link: route('categories.index'),
    cta: 'Comprar Ahora',
  },
  {
    image: 'https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-2025-05-09t163833757-e61e5ea4614aaf39dabf51f435f15209?qlt=80&fmt=auto',
    alt: 'Promoción 2',
    title: 'Ofertas Exclusivas',
    description: 'Hasta 50% de descuento',
    link: route('categories.index'),
    cta: 'Ver Ofertas',
  },
  {
    image: 'https://i8.amplience.net/i/jpl/desktop-top-banner-1920x840-home-3-ca175881606ef5740db12f2ecffce811?qlt=80&fmt=auto',
    alt: 'Promoción 3',
    title: 'Moda Sostenible',
    description: 'Estilo con conciencia ecológica',
    link: route('categories.index'),
    cta: 'Descubrir Ahora',
  }
];
const currentSlide = ref(0);
const nextSlide = () => {
  currentSlide.value = (currentSlide.value + 1) % slides.length;
};
const prevSlide = () => {
  currentSlide.value = (currentSlide.value - 1 + slides.length) % slides.length;
};

// Message Slider
const messages = [
  { text: 'RECOGIDA EN TIENDA EL MISMO DÍA', link: null, cta: null },
  { text: 'HAZ TU PEDIDO ANTES DE LAS 14H', link: route('cart.index'), cta: 'Pedir Ahora' },
  { text: 'TEMPORADA DE CHAQUETAS FINAS', link: route('categories.index'), cta: 'COMPRAR AHORA' },
  { text: 'CAMISETAS THE NORTH FACE', link: route('categories.index'), cta: 'COMIENZA TU AVENTURA' },
];
const currentMessage = ref(0);
let messageInterval = null;
const startMessageSlider = () => {
  messageInterval = setInterval(() => {
    currentMessage.value = (currentMessage.value + 1) % messages.length;
  }, 5000);
};

// Brand Slider
const brands = [
  { name: 'Nike', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-nike-online', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/nike.svg?w=1440&q=75' },
  { name: 'adidas', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-adidas-online', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/adidas.svg?w=1440&q=75' },
  { name: 'Puma', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-puma-online', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/puma.svg?w=1440&q=75' },
  { name: 'Fila', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-fila-online', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/fila.svg?w=1440&q=75' },
  { name: 'Under Armour', target: '_self', label: 'upper_brand', date: '200624', href: '/under-armour', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/under-armour.svg?w=1440&q=75' },
  { name: 'The North Face', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-the-north-face', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/tnf.svg?w=1440&q=75' },
  { name: 'New Balance', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-new-balance', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/new-balance.svg?w=1440&q=75' },
  { name: 'Converse', target: '_self', label: 'upper_brand', date: '200624', href: '/tienda-converse', src: 'https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/converse.svg?w=1440&q=75' },
];
const currentBrand = ref(0);
const visibleBrands = ref([...brands]);
let brandInterval = null;

const startBrandSlider = () => {
  brandInterval = setInterval(() => {
    // Move first brand to end
    const first = visibleBrands.value.shift();
    visibleBrands.value.push(first);
  }, 2000); // Reduced from 7000 to 2000 for faster transition
};

// Categories (Dynamic from props)
const categories = computed(() => page.props.categories || [
  { id: 1, name: 'Pantalones', image: 'https://i8.amplience.net/i/jpl/midspots-552x823-mens-14-3fc9c49ab359786a184b06e40071740b?qlt=80&fmt=auto' },
  { id: 2, name: 'Camisetas', image: 'https://i8.amplience.net/i/jpl/midspots-552x823-womens-14-655f0bafedb389032dd5f7a8f341eac9?qlt=80&fmt=auto' },
  { id: 3, name: 'Sudaderas', image: 'https://i8.amplience.net/i/jpl/midspots-552x823-kids-3-17648eade84eea684109ffcb4a1cf908?qlt=80&fmt=auto' },
]);

// Lifecycle Hooks
onMounted(() => {
  cartStore.loadFromLocalStorage();
  startMessageSlider();
  startBrandSlider();
});

onUnmounted(() => {
  clearInterval(messageInterval);
  clearInterval(brandInterval);
});
</script>