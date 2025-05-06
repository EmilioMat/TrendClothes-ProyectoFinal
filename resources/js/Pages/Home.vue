<template>
    <div class="container mx-auto p-4">
        <h1 class="text-3xl font-bold text-center">Bienvenido a la tienda de ropa</h1>
        <TestComponent />
    </div>
</template>

<script>
import TestComponent from '../Components/TestComponent.vue';

export default {
    name: 'Home',
    components: {
        TestComponent,
    },
};
</script>