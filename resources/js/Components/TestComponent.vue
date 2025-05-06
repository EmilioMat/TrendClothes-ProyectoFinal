<template>
    <div class="bg-blue-100 p-4 rounded-lg shadow-md">
        <h2 class="text-xl font-semibold text-blue-800">Componente de Prueba</h2>
        <p class="mt-2 text-gray-600">Este es un componente de prueba para tu tienda de ropa.</p>
        <button
            @click="increment"
            class="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        >
            Contador: {{ count }}
        </button>
    </div>
</template>

<script>
export default {
    name: 'TestComponent',
    data() {
        return {
            count: 0,
        };
    },
    methods: {
        increment() {
            this.count++;
        },
    },
};
</script>