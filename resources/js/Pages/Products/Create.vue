<template>
    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">Create Product</h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6">
                        <form @submit.prevent="submit">
                            <div class="mb-4">
                                <label class="block text-gray-700">Name</label>
                                <input v-model="form.name" type="text" class="w-full border-gray-300 rounded-md" required />
                                <div v-if="form.errors.name" class="text-red-500 text-sm mt-1">{{ form.errors.name }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Description</label>
                                <textarea v-model="form.description" class="w-full border-gray-300 rounded-md"></textarea>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Price</label>
                                <input v-model="form.price" type="number" step="0.01" class="w-full border-gray-300 rounded-md" required />
                                <div v-if="form.errors.price" class="text-red-500 text-sm mt-1">{{ form.errors.price }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Stock</label>
                                <input v-model="form.stock" type="number" class="w-full border-gray-300 rounded-md" required />
                                <div v-if="form.errors.stock" class="text-red-500 text-sm mt-1">{{ form.errors.stock }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Category</label>
                                <select v-model="form.category_id" class="w-full border-gray-300 rounded-md" required>
                                    <option value="">Select a category</option>
                                    <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
                                </select>
                                <div v-if="form.errors.category_id" class="text-red-500 text-sm mt-1">{{ form.errors.category_id }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Size</label>
                                <select v-model="form.size_id" class="w-full border-gray-300 rounded-md" required>
                                    <option value="">Select a size</option>
                                    <option v-for="size in sizes" :key="size.id" :value="size.id">{{ size.name }}</option>
                                </select>
                                <div v-if="form.errors.size_id" class="text-red-500 text-sm mt-1">{{ form.errors.size_id }}</div>
                            </div>
                            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">Create Product</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>

<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { useForm } from '@inertiajs/vue3';

defineProps({
    categories: Array,
    sizes: Array,
});

const form = useForm({
    name: '',
    description: '',
    price: 0,
    stock: 0,
    category_id: '',
    size_id: '',
});

function submit() {
    form.post(route('admin.products.store'), {
        onSuccess: () => form.reset(),
    });
}
</script>