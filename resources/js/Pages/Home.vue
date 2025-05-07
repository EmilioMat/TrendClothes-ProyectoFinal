<template>
    <div class="min-h-screen bg-gray-100">
        <!-- Mostrar mensaje flash -->
        <div v-if="$page.props.flash.success" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative" role="alert">
            <span class="block sm:inline">{{ $page.props.flash.success }}</span>
            <span class="absolute top-0 bottom-0 right-0 px-4 py-3" @click="$page.props.flash.success = null">
                <svg class="fill-current h-6 w-6 text-green-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Cerrar</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
            </span>
        </div>

        <!-- Navegación -->
        <nav class="bg-white shadow-md">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex justify-between h-16">
                    <div class="flex">
                        <div class="flex-shrink-0 flex items-center">
                            <span class="text-xl font-bold text-gray-800">TrendClothes</span>
                        </div>
                        <div class="hidden sm:-my-px sm:ml-6 sm:flex sm:space-x-8">
                            <Link href="/" :class="{ 'border-indigo-500 text-gray-900': true, 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700': false }" class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium" :aria-current="true ? 'page' : undefined">Inicio</Link>
                            <Link href="/categories" class="inline-flex items-center px-1 pt-1 border-b-2 border-transparent text-sm font-medium text-gray-500 hover:border-gray-300 hover:text-gray-700">Categorías</Link>
                        </div>
                    </div>
                    <div class="hidden sm:ml-6 sm:flex sm:items-center">
                        <template v-if="$page.props.auth.user">
                            <!-- Menú desplegable -->
                            <div class="relative ml-3">
                                <Dropdown align="right" width="48">
                                    <template #trigger>
                                        <span class="inline-flex rounded-md">
                                            <button
                                                type="button"
                                                class="inline-flex items-center rounded-md border border-transparent bg-white px-3 py-2 text-sm font-medium leading-4 text-gray-500 transition duration-150 ease-in-out hover:text-gray-700 focus:outline-none"
                                            >
                                                {{ $page.props.auth.user.name }}
                                                <svg
                                                    class="-me-0.5 ms-2 h-4 w-4"
                                                    xmlns="http://www.w3.org/2000/svg"
                                                    viewBox="0 0 20 20"
                                                    fill="currentColor"
                                                >
                                                    <path
                                                        fill-rule="evenodd"
                                                        d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                                        clip-rule="evenodd"
                                                    />
                                                </svg>
                                            </button>
                                        </span>
                                    </template>

                                    <template #content>
                                        <DropdownLink :href="route('profile.edit')">
                                            Perfil
                                        </DropdownLink>

                                        <DropdownLink 
                                            v-if="$page.props.auth.user.is_admin"
                                            :href="route('admin.panel')"
                                        >
                                            Panel de Administración
                                        </DropdownLink>

                                        <DropdownLink
                                            :href="route('logout')"
                                            method="post"
                                            as="button"
                                        >
                                            Cerrar Sesión
                                        </DropdownLink>
                                    </template>
                                </Dropdown>
                            </div>
                        </template>
                        <template v-else>
                            <Link :href="route('login')" class="text-sm text-gray-700 hover:text-gray-900 mr-4">Iniciar Sesión</Link>
                            <Link v-if="$page.props.canRegister" :href="route('register')" class="text-sm text-gray-700 hover:text-gray-900">Registrarse</Link>
                        </template>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Contenido Principal -->
        <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
            <div class="px-4 py-6 sm:px-0">
                <h1 class="text-3xl font-bold text-gray-900">Bienvenido a Nuestra Tienda de Ropa</h1>
                <p class="mt-2 text-sm text-gray-600">Descubre las últimas tendencias de moda y ropa de alta calidad para todos.</p>
                <div class="mt-6 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
                    <div v-for="category in ['Hombre', 'Mujer', 'Unisex']" :key="category" class="bg-white overflow-hidden shadow rounded-lg">
                        <div class="p-6">
                            <h3 class="text-lg font-medium text-gray-900">{{ category }}</h3>
                            <p class="mt-2 text-sm text-gray-500">Explora nuestra amplia selección de ropa para {{ category.toLowerCase() }}.</p>
                            <Link :href="route('categories.index') + '?gender=' + category.toLowerCase()" class="mt-4 inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">Comprar Ahora</Link>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Pie de Página -->
        <footer class="bg-white shadow-inner mt-6">
            <div class="max-w-7xl mx-auto py-6 px-4 overflow-hidden sm:px-6 lg:px-8">
                <p class="text-center text-sm text-gray-500">&copy; 2025 Tienda de Ropa. Todos los derechos reservados.</p>
            </div>
        </footer>
    </div>
</template>

<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { watchEffect } from 'vue';
import Dropdown from '@/Components/Dropdown.vue';
import DropdownLink from '@/Components/DropdownLink.vue';

const props = defineProps({
    canLogin: Boolean,
    canRegister: Boolean,
    laravelVersion: String,
    phpVersion: String,
    flash: Object,
    auth: Object
});

// Auto-ocultar el mensaje después de 5 segundos
watchEffect(() => {
    if (props.flash?.success) {
        setTimeout(() => {
            props.flash.success = null;
        }, 5000);
    }
});
</script>