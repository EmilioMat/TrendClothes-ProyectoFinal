<script setup>
import { ref } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import InputError from '@/Components/InputError.vue';

const form = useForm({
    password: '',
});

const submit = () => {
    form.post(route('password.confirm'), {
        onFinish: () => form.reset(),
    });
};

const showPassword = ref(false);
const togglePasswordVisibility = () => {
    showPassword.value = !showPassword.value;
};
</script>

<template>
    <AppLayout>
        <Head title="Confirmar Contraseña" />

        <div class="min-h-[400px] flex pt-4 pb-12 mb-12">
            <!-- Panel izquierdo - Formulario -->
            <div class="flex-1 flex items-center justify-center bg-white">
                <div class="mx-auto w-full max-w-sm lg:w-96">
                    <div class="mb-8">
                        <h1 class="text-3xl font-bold text-gray-900 mb-2">
                            Confirmar Contraseña
                        </h1>
                        <p class="text-gray-600">
                            Esta es un área segura. Confirma tu contraseña para continuar.
                        </p>
                    </div>

                    <form @submit.prevent="submit" class="space-y-4">
                        <div class="relative">
                            <input
                                id="password"
                                :type="showPassword ? 'text' : 'password'"
                                placeholder="Contraseña"
                                class="w-full px-4 py-3 bg-gray-50 border border-gray-200 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all pr-12"
                                v-model="form.password"
                                required
                                autofocus
                                autocomplete="current-password"
                            />
                            <button
                                type="button"
                                @click="togglePasswordVisibility"
                                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                            >
                                <svg v-if="!showPassword" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                                </svg>
                                <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"></path>
                                </svg>
                            </button>
                            <InputError class="mt-2" :message="form.errors.password" />
                        </div>

                        <button
                            type="submit"
                            class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-4 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                            :class="{ 'opacity-75 cursor-not-allowed': form.processing }"
                            :disabled="form.processing"
                        >
                            Confirmar
                        </button>
                    </form>
                </div>
            </div>

            <!-- Panel derecho - Sección promocional -->
            <div class="hidden lg:flex lg:flex-1 bg-gradient-to-br from-indigo-500 to-indigo-700 relative overflow-hidden">
                <div class="absolute inset-0 opacity-10">
                    <div class="absolute top-0 left-0 w-64 h-64 bg-white rounded-full -translate-x-32 -translate-y-32"></div>
                    <div class="absolute bottom-0 right-0 w-96 h-96 bg-white rounded-full translate-x-48 translate-y-48"></div>
                    <div class="absolute top-1/2 left-1/4 w-32 h-32 bg-white rounded-full"></div>
                </div>
                <div class="relative z-10 flex flex-col justify-center px-12 xl:px-16 text-white">
                    <div class="max-w-md">
                        <h2 class="text-4xl xl:text-5xl font-bold mb-6">
                            ¡Seguridad Garantizada!
                        </h2>
                        <p class="text-lg xl:text-xl text-indigo-100 mb-8 leading-relaxed">
                            Verifica tu identidad para acceder a todas las funciones de nuestra plataforma.
                        </p>
                        <button
                            class="inline-flex items-center px-8 py-3 bg-white text-indigo-600 font-medium rounded-full hover:bg-gray-50 transition-all duration-300 shadow-lg hover:shadow-xl"
                        >
                            Más Información
                            <svg class="ml-2 w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3"></path>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>