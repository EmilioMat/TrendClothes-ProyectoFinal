<script setup>
import { computed } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    status: {
        type: String,
    },
});

const form = useForm({});

const submit = () => {
    form.post(route('verification.send'));
};

const verificationLinkSent = computed(
    () => props.status === 'verification-link-sent',
);
</script>

<template>
    <AppLayout>
        <Head title="Verificación de Email" />

        <div class="min-h-[400px] flex pt-4 pb-12 mb-12">
            <!-- Panel izquierdo - Formulario -->
            <div class="flex-1 flex items-center justify-center bg-white">
                <div class="mx-auto w-full max-w-sm lg:w-96">
                    <div class="mb-8">
                        <h1 class="text-3xl font-bold text-gray-900 mb-2">
                            Verificación de Email
                        </h1>
                        <p class="text-gray-600">
                            ¡Gracias por registrarte! Verifica tu email haciendo clic en el enlace que te enviamos. Si no lo recibiste, enviaremos otro.
                        </p>
                    </div>

                    <div v-if="verificationLinkSent" class="mb-4 p-3 text-sm font-medium text-indigo-600 bg-indigo-50 rounded-lg">
                        Se ha enviado un nuevo enlace de verificación al correo que proporcionaste.
                    </div>

                    <form @submit.prevent="submit" class="space-y-4">
                        <div class="mt-4 flex items-center justify-between">
                            <button
                                type="submit"
                                class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-4 rounded-lg transition-colors focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                                :class="{ 'opacity-75 cursor-not-allowed': form.processing }"
                                :disabled="form.processing"
                            >
                                Reenviar Email de Verificación
                            </button>
                            <Link
                                :href="route('logout')"
                                method="post"
                                as="button"
                                class="rounded-md text-sm text-indigo-600 underline hover:text-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                            >
                                Cerrar Sesión
                            </Link>
                        </div>
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
                            ¡Activa tu Cuenta!
                        </h2>
                        <p class="text-lg xl:text-xl text-indigo-100 mb-8 leading-relaxed">
                            Verifica tu email para desbloquear todas las funciones de TrendClothes.
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