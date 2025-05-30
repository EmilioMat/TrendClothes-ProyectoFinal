<template>
    <div class="min-h-screen bg-gray-50">
        <!-- Mensaje flash -->
        <div
            v-if="$page.props.flash.success"
            class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-700 p-4"
        >
            <div
                class="mx-auto px-4 sm:px-6 lg:px-8"
                style="max-width: 1440px; width: 100%"
            >
                <p>{{ $page.props.flash.success }}</p>
                <button
                    @click="$page.props.flash.success = null"
                    class="text-emerald-700 hover:text-emerald-900"
                    aria-label="Cerrar mensaje"
                >
                    <svg
                        class="h-5 w-5"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                        aria-hidden="true"
                    >
                        <path
                            fill-rule="evenodd"
                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                            clip-rule="evenodd"
                        />
                    </svg>
                </button>
            </div>
        </div>

        <!-- Navegación -->
        <nav
            :class="{ scrolled: isScrolled }"
            class="fixed top-0 left-0 w-full z-10 transition-all duration-300 bg-white shadow-lg"
        >
            <div
                class="mx-auto px-4 sm:px-6 lg:px-8"
                style="max-width: 1440px; width: 100%"
            >
                <div
                    class="flex justify-between h-20 items-center"
                    :class="isScrolled ? 'h-16' : 'h-20'"
                >
                    <!-- Logo -->
                    <div class="flex items-center">
                        <Link
                            :href="route('home')"
                            class="text-2xl font-bold"
                            :class="
                                isScrolled
                                    ? 'text-indigo-600'
                                    : 'text-indigo-600'
                            "
                            aria-label="Ir a la página principal de TrendClothes"
                            >TrendClothes</Link
                        >
                    </div>

                    <!-- Menú de Escritorio -->
                    <div
                        class="hidden md:flex md:items-center md:ml-6 md:space-x-8"
                    >
                        <Link
                            :href="route('home')"
                            class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                            :class="[
                                route().current('home')
                                    ? 'border-indigo-500 text-gray-900'
                                    : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700',
                            ]"
                            aria-label="Ir a Inicio"
                        >
                            Inicio
                        </Link>
                        <Link
                            :href="route('categories.index')"
                            class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                            :class="[
                                route().current('categories.*')
                                    ? 'border-indigo-500 text-gray-900'
                                    : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700',
                            ]"
                            aria-label="Ir a Categorías"
                        >
                            Categorías
                        </Link>
                        <Link
                            :href="route('about')"
                            class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                            :class="[
                                route().current('about')
                                    ? 'border-indigo-500 text-gray-900'
                                    : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700',
                            ]"
                            aria-label="Ir a Sobre Nosotros"
                        >
                            Sobre Nosotros
                        </Link>
                    </div>

                    <!-- Menú Derecho (Carrito y Usuario) -->
                    <div class="flex items-center space-x-4">
                        <!-- Carrito con Vista Previa al Pasar el Ratón -->
                        <div class="relative group">
                            <Link
                                :href="route('cart.index')"
                                class="flex items-center text-gray-700 hover:text-indigo-600"
                                aria-label="Ir al carrito de compras"
                            >
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    class="h-6 w-6"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                    stroke="currentColor"
                                    aria-hidden="true"
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
                            <!-- Vista Previa del Carrito -->
                            <div
                                class="fixed md:absolute left-0 md:left-auto right-0 md:right-auto mt-2 w-full md:w-80 bg-white rounded-lg shadow-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none group-hover:pointer-events-auto z-10"
                                style="
                                    max-width: 95vw;
                                    margin: 0 auto;
                                    transform: translateX(-50%);
                                    left: 50%;
                                "
                            >
                                <div class="p-4">
                                    <span
                                        class="text-sm font-semibold text-gray-900"
                                        >Carrito</span
                                    >
                                    <div
                                        v-if="cartItems.length > 0"
                                        class="mt-2 space-y-2"
                                    >
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
                                                <p
                                                    class="text-sm text-gray-700"
                                                >
                                                    {{ item.product.name }}
                                                </p>
                                                <p
                                                    class="text-xs text-gray-600"
                                                >
                                                    Cantidad:
                                                    {{ item.quantity }}
                                                </p>
                                                <p
                                                    class="text-sm font-semibold text-indigo-600"
                                                >
                                                    {{
                                                        formatPrice(
                                                            item.product.price *
                                                                item.quantity
                                                        )
                                                    }}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <p v-else class="text-sm text-gray-600">
                                        Tu carrito está vacío
                                    </p>
                                    <Link
                                        :href="route('cart.index')"
                                        class="mt-4 block text-center text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-md py-2"
                                        aria-label="Ver detalles del carrito"
                                    >
                                        Ver Carrito
                                    </Link>
                                </div>
                            </div>
                        </div>

                        <!-- Menú de Usuario -->
                        <template v-if="$page.props.auth.user">
                            <div class="hidden md:block">
                                <Dropdown align="right" width="48">
                                    <template #trigger>
                                        <button
                                            class="flex items-center text-sm font-medium focus:outline-none text-gray-700 hover:text-indigo-600"
                                            aria-label="Abrir menú de usuario"
                                        >
                                            <svg
                                                xmlns="http://www.w3.org/2000/svg"
                                                class="h-6 w-6"
                                                fill="none"
                                                viewBox="0 0 24 24"
                                                stroke="currentColor"
                                                aria-hidden="true"
                                            >
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="2"
                                                    d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                                                />
                                            </svg>
                                            <span class="sr-only"
                                                >Menú de usuario</span
                                            >
                                        </button>
                                    </template>
                                    <template #content>
                                        <DropdownLink
                                            :href="route('profile.edit')"
                                            aria-label="Editar perfil"
                                            >Perfil</DropdownLink
                                        >
                                        <DropdownLink
                                            v-if="
                                                $page.props.auth.user.is_admin
                                            "
                                            :href="route('admin.dashboard')"
                                            aria-label="Ir al panel de administración"
                                        >
                                            Panel de Administración
                                        </DropdownLink>
                                        <DropdownLink
                                            :href="route('logout')"
                                            method="post"
                                            as="button"
                                            aria-label="Cerrar sesión"
                                        >
                                            Cerrar Sesión
                                        </DropdownLink>
                                    </template>
                                </Dropdown>
                            </div>
                        </template>
                        <template v-else>
                            <Link
                                :href="route('login')"
                                class="text-sm font-medium mr-4 hidden md:block text-gray-700 hover:text-indigo-600"
                                aria-label="Iniciar sesión"
                            >
                                Iniciar Sesión
                            </Link>
                            <Link
                                v-if="$page.props.canRegister"
                                :href="route('register')"
                                class="text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 px-4 py-2 rounded-md hidden md:block"
                                aria-label="Registrarse"
                            >
                                Registrarse
                            </Link>
                        </template>

                        <!-- Botón de Menú Móvil -->
                        <div class="md:hidden">
                            <button
                                @click="mobileMenuOpen = !mobileMenuOpen"
                                class="focus:outline-none text-gray-600 hover:text-gray-700"
                                aria-label="Abrir menú móvil"
                            >
                                <svg
                                    v-if="!mobileMenuOpen"
                                    class="h-6 w-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                    aria-hidden="true"
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
                                    aria-hidden="true"
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

                <!-- Contenido del Menú Móvil -->
                <div v-if="mobileMenuOpen" class="md:hidden fixed inset-0 z-50">
                    <div
                        class="absolute inset-0 overflow-y-auto bg-gray-900 bg-opacity-80 backdrop-blur-md"
                        style="
                            border: 0;
                            bottom: 0;
                            height: 100%;
                            left: 0;
                            overflow-y: scroll;
                            padding: 0;
                            position: absolute;
                            right: 20px;
                            width: calc(100% - 20px);
                        "
                    >
                        <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
                            <div class="flex justify-end p-4">
                                <button
                                    @click="mobileMenuOpen = false"
                                    class="text-white hover:text-gray-300 focus:outline-none"
                                    aria-label="Cerrar menú móvil"
                                >
                                    <svg
                                        class="h-8 w-8"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                        aria-hidden="true"
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
                                    :class="
                                        route().current('home')
                                            ? 'text-indigo-300'
                                            : 'hover:text-gray-300'
                                    "
                                    @click="mobileMenuOpen = false"
                                    aria-label="Ir a Inicio"
                                >
                                    Inicio
                                </Link>
                                <Link
                                    :href="route('categories.index')"
                                    class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                                    :class="
                                        route().current('categories.*')
                                            ? 'text-indigo-300'
                                            : 'hover:text-gray-300'
                                    "
                                    @click="mobileMenuOpen = false"
                                    aria-label="Ir a Categorías"
                                >
                                    Categorías
                                </Link>
                                <Link
                                    :href="route('about')"
                                    class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                                    :class="
                                        route().current('about')
                                            ? 'text-indigo-300'
                                            : 'hover:text-gray-300'
                                    "
                                    @click="mobileMenuOpen = false"
                                    aria-label="Ir a Sobre Nosotros"
                                >
                                    Sobre Nosotros
                                </Link>

                                <template v-if="$page.props.auth.user">
                                    <div class="w-full">
                                        <button
                                            @click="subMenuOpen = !subMenuOpen"
                                            class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                            aria-label="Abrir menú de usuario"
                                        >
                                            MI TRENDCLOTHES
                                        </button>
                                        <div
                                            v-if="subMenuOpen"
                                            class="pl-6 space-y-2"
                                        >
                                            <Link
                                                :href="route('profile.edit')"
                                                class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                                @click="
                                                    mobileMenuOpen = false;
                                                    subMenuOpen = false;
                                                "
                                                aria-label="Ir a Mi Perfil"
                                            >
                                                Mi Perfil
                                            </Link>
                                            <Link
                                                v-if="
                                                    $page.props.auth.user
                                                        .is_admin
                                                "
                                                :href="route('admin.dashboard')"
                                                class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                                @click="
                                                    mobileMenuOpen = false;
                                                    subMenuOpen = false;
                                                "
                                                aria-label="Ir a Panel de Administración"
                                            >
                                                Panel de Administración
                                            </Link>
                                            <Link
                                                :href="route('logout')"
                                                method="post"
                                                as="button"
                                                class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                                @click="
                                                    mobileMenuOpen = false;
                                                    subMenuOpen = false;
                                                "
                                                aria-label="Cerrar Sesión"
                                            >
                                                Cerrar Sesión
                                            </Link>
                                        </div>
                                    </div>
                                </template>
                                <template v-else>
                                    <Link
                                        :href="route('login')"
                                        class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                        @click="mobileMenuOpen = false"
                                        aria-label="Iniciar sesión"
                                    >
                                        Iniciar Sesión
                                    </Link>
                                    <Link
                                        v-if="$page.props.canRegister"
                                        :href="route('register')"
                                        class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                        @click="mobileMenuOpen = false"
                                        aria-label="Registrarse"
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

        <!-- Contenido principal -->
        <main
            class="mx-auto py-8 px-4 sm:px-6 lg:px-8"
            style="max-width: 1440px; width: 100%"
            :class="isScrolled ? 'mt-16' : 'mt-20'"
        >
            <slot />
        </main>

        <!-- Pie de Página -->
        <footer class="bg-gray-800 text-white py-12">
            <!-- Contenido del Footer -->
            <div class="mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <div>
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >TrendClothes</span
                        >
                        <p class="text-gray-400">
                            La mejor selección de moda para todos los estilos.
                        </p>
                    </div>
                    <div class="ml-8">
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >Mapa del Sitio</span
                        >
                        <ul class="space-y-2">
                            <li>
                                <Link
                                    :href="'/'"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Ir a la página de Inicio"
                                    >Inicio</Link
                                >
                            </li>
                            <li>
                                <Link
                                    :href="'/categories'"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Ir a la página de Categorías"
                                    >Categorías</Link
                                >
                            </li>
                            <li>
                                <Link
                                    :href="'/about'"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Ir a la página de Nosotros"
                                    >Nosotros</Link
                                >
                            </li>
                        </ul>
                    </div>
                    <div>
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >Ayuda</span
                        >
                        <ul class="space-y-2">
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Página de Contacto (en construcción)"
                                    >Contacto</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Página de Envíos (en construcción)"
                                    >Envíos</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Página de Devoluciones (en construcción)"
                                    >Devoluciones</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                        </ul>
                    </div>
                    <div>
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >Legal</span
                        >
                        <ul class="space-y-2">
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Página de Términos y Condiciones (en construcción)"
                                    >Términos y condiciones</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Página de Política de Privacidad (en construcción)"
                                    >Política de privacidad</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                        </ul>
                    </div>
                </div>
                <div
                    class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400"
                >
                    <p>© 2025 TrendClothes. Todos los derechos reservados.</p>
                </div>
            </div>
        </footer>
    </div>
</template>

<script setup>
import { Link } from "@inertiajs/vue3";
import Dropdown from "@/Components/Dropdown.vue";
import DropdownLink from "@/Components/DropdownLink.vue";
import { useCartStore } from "@/stores/cart";
import { ref, computed, onMounted, onUnmounted } from "vue";

const cartStore = useCartStore();
const cartCount = computed(() => cartStore.count);
const cartItems = computed(() => cartStore.items);
const isScrolled = ref(false);
const mobileMenuOpen = ref(false);
const subMenuOpen = ref(false);

// Cargar carrito al montar el componente
onMounted(() => {
    cartStore.loadFromLocalStorage();

    // Manejar el cambio de estilo al hacer scroll
    const handleScroll = () => {
        isScrolled.value = window.scrollY > 50;
    };

    window.addEventListener("scroll", handleScroll);

    // Limpieza al desmontar el componente
    onUnmounted(() => {
        window.removeEventListener("scroll", handleScroll);
    });
});

// Formatear precio
const formatPrice = (price) => {
    return new Intl.NumberFormat("es-CL", {
        style: "currency",
        currency: "CLP",
    }).format(price);
};
</script>
