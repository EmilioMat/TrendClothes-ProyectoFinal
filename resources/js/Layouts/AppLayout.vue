<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Mensaje flash -->
    <div v-if="$page.props.flash.success" class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-700 p-4">
      <div class="mx-auto px-4 sm:px-6 lg:px-8" style="max-width: 1440px; width: 100%;">
        <p>{{ $page.props.flash.success }}</p>
        <button @click="$page.props.flash.success = null" class="text-emerald-700 hover:text-emerald-900">
          <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
      </div>
    </div>

    <!-- Navegación -->
    <nav class="bg-white shadow-lg">
      <div class="mx-auto px-4 sm:px-6 lg:px-8" style="max-width: 1440px; width: 100%;">
        <div class="flex justify-between h-20">
          <div class="flex items-center">
            <Link :href="route('home')" class="text-2xl font-bold text-indigo-600">TrendClothes</Link>
          </div>
          
          <!-- Menú central -->
          <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
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
          
          <!-- Menú derecho -->
          <div class="hidden sm:ml-6 sm:flex sm:items-center space-x-4">
            <!-- Icono del carrito -->
            <div class="relative">
              <Link :href="route('cart.index')" class="text-gray-700 hover:text-indigo-600">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
                <span v-if="cartCount > 0" class="absolute -top-2 -right-2 bg-indigo-600 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center">
                  {{ cartCount }}
                </span>
              </Link>
            </div>
            
            <!-- Icono de usuario -->
            <template v-if="$page.props.auth.user">
              <Dropdown align="right" width="48">
                <template #trigger>
                  <button class="flex items-center text-sm font-medium text-gray-700 hover:text-gray-900 focus:outline-none">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                  </button>
                </template>
                <template #content>
                  <DropdownLink :href="route('profile.edit')">Perfil</DropdownLink>
                  <DropdownLink v-if="$page.props.auth.user.is_admin" :href="route('admin.dashboard')">
                    Panel de Administración
                  </DropdownLink>
                  <DropdownLink :href="route('logout')" method="post" as="button">
                    Cerrar Sesión
                  </DropdownLink>
                </template>
              </Dropdown>
            </template>
            <template v-else>
              <Link :href="route('login')" class="text-sm font-medium text-gray-700 hover:text-gray-900 mr-4">Iniciar Sesión</Link>
              <Link v-if="$page.props.canRegister" :href="route('register')" class="text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 px-4 py-2 rounded-md">
                Registrarse
              </Link>
            </template>
          </div>
        </div>
      </div>
    </nav>

    <!-- Contenido principal -->
    <main class="mx-auto py-8 px-4 sm:px-6 lg:px-8" style="max-width: 1440px; width: 100%;">
      <slot />
    </main>

    <!-- Pie de página -->
    <footer class="bg-gray-800 text-white py-12">
      <div class="mx-auto px-4 sm:px-6 lg:px-8" style="max-width: 1440px; width: 100%;">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 class="text-lg font-semibold mb-4">TrendClothes</h3>
            <p class="text-gray-400">La mejor selección de moda para todos los estilos.</p>
          </div>
          <div>
            <h3 class="text-lg font-semibold mb-4">Categorías</h3>
            <ul class="space-y-2">
              <li><Link :href="route('categories.index')" class="text-gray-400 hover:text-white">Todas las categorías</Link></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Hombre</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Mujer</a></li>
              <li><a href="#" class="text-gray-400 hover:text-white">Unisex</a></li>
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
import { Link } from '@inertiajs/vue3';
import Dropdown from '@/Components/Dropdown.vue';
import DropdownLink from '@/Components/DropdownLink.vue';
import { useCartStore } from '@/stores/cart';
import { computed, onMounted } from 'vue';

const cartStore = useCartStore();
const cartCount = computed(() => cartStore.count);

// Cargar carrito al montar el componente
onMounted(() => {
  cartStore.loadFromLocalStorage();
});
</script>