<template>
    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">Create Product</h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg">
                    <div class="p-6">
                        <form @submit.prevent="submit" enctype="multipart/form-data">
                            <div class="mb-4">
                                <label class="block text-gray-700">Name</label>
                                <input v-model="form.name" type="text" class="w-full border-gray-300 rounded-md" required />
                                <div v-if="form.errors.name" class="text-red-500 text-sm mt-1">{{ form.errors.name }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Description</label>
                                <textarea v-model="form.description" class="w-full border-gray-300 rounded-md"></textarea>
                                <div v-if="form.errors.description" class="text-red-500 text-sm mt-1">{{ form.errors.description }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Price</label>
                                <input v-model.number="form.price" type="number" step="0.01" class="w-full border-gray-300 rounded-md" required />
                                <div v-if="form.errors.price" class="text-red-500 text-sm mt-1">{{ form.errors.price }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Stock</label>
                                <input v-model.number="form.stock" type="number" class="w-full border-gray-300 rounded-md" required />
                                <div v-if="form.errors.stock" class="text-red-500 text-sm mt-1">{{ form.errors.stock }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Category</label>
                                <select v-model.number="form.category_id" class="w-full border-gray-300 rounded-md" required>
                                    <option value="">Select a category</option>
                                    <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
                                </select>
                                <div v-if="form.errors.category_id" class="text-red-500 text-sm mt-1">{{ form.errors.category_id }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Size</label>
                                <select v-model.number="form.size_id" class="w-full border-gray-300 rounded-md" required>
                                    <option value="">Select a size</option>
                                    <option v-for="size in sizes" :key="size.id" :value="size.id">{{ size.name }}</option>
                                </select>
                                <div v-if="form.errors.size_id" class="text-red-500 text-sm mt-1">{{ form.errors.size_id }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Gender</label>
                                <select v-model="form.gender" class="w-full border-gray-300 rounded-md" required>
                                    <option value="">Select gender</option>
                                    <option value="male">Male</option>
                                    <option value="female">Female</option>
                                    <option value="unisex">Unisex</option>
                                </select>
                                <div v-if="form.errors.gender" class="text-red-500 text-sm mt-1">{{ form.errors.gender }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Main Image</label>
                                <input type="file" @change="form.main_image = $event.target.files[0]" class="w-full border-gray-300 rounded-md" />
                                <div v-if="form.errors.main_image" class="text-red-500 text-sm mt-1">{{ form.errors.main_image }}</div>
                            </div>
                            <div class="mb-4">
                                <label class="block text-gray-700">Additional Images</label>
                                <input type="file" multiple @change="form.images = $event.target.files" class="w-full border-gray-300 rounded-md" />
                                <div v-if="form.errors.images" class="text-red-500 text-sm mt-1">{{ form.errors.images }}</div>
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
    price: null,
    stock: null,
    category_id: null,
    size_id: null,
    gender: '',
    main_image: null,
    images: [],
});

function submit() {
    form.post(route('admin.products.store'), {
        onSuccess: () => form.reset(),
        forceFormData: true,
    });
}
</script>