<script setup>
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <div class="min-h-screen flex flex-col">
        <!-- Header -->
        <header class="bg-gray-800 text-white p-4">
            <div class="container mx-auto flex justify-between items-center">
                <Link :href="route('home')" class="text-xl font-bold">TrendClothes</Link>
                <nav class="space-x-4">
                    <Link :href="route('home')" class="hover:text-gray-300">Inicio</Link>
                    <Link :href="route('categories.index')" class="hover:text-gray-300">Categorías</Link>
                </nav>
            </div>
        </header>

        <!-- Contenido Principal -->
        <main class="flex-grow container mx-auto p-4">
            <slot />
        </main>

        <!-- Footer -->
        <footer class="bg-gray-800 text-white p-4">
            <div class="container mx-auto text-center">
                <p>&copy; {{ new Date().getFullYear() }} TrendClothes. Todos los derechos reservados.</p>
            </div>
        </footer>
    </div>
</template>