<script setup>
import { router, usePage } from "@inertiajs/vue3";
import { ref, computed } from "vue";
import { Plus } from "@element-plus/icons-vue";

defineProps({
    products: Array,
    categories: Array,
    sizes: Array,
});

const isAddProduct = ref(false);
const editMode = ref(false);
const dialogVisible = ref(false);
const productImages = ref([]);

// Form data
const id = ref("");
const name = ref("");
const description = ref("");
const price = ref("");
const stock = ref("");
const category_id = ref("");
const size_id = ref("");
const gender = ref("");
const color = ref("");
const brand = ref("");
const main_image = ref(null);
const additional_images = ref([]);

// Image previews
const mainImagePreview = ref(null);
const additionalImagesPreviews = ref([]);

// Image preview dialog for el-upload
const previewDialogVisible = ref(false);
const previewImageUrl = ref("");

// Bulk delete state
const selectedProducts = ref([]);
const selectAll = ref(false);
const showCheckboxes = ref(false);
const showDeleteModal = ref(false);
const showSuccessMessage = ref(false);
const deleteAllMode = ref(false);

// Reset form data
const resetFormData = () => {
    id.value = "";
    name.value = "";
    description.value = "";
    price.value = "";
    stock.value = "";
    category_id.value = "";
    size_id.value = "";
    gender.value = "";
    color.value = "";
    brand.value = "";
    main_image.value = null;
    additional_images.value = [];
    productImages.value = [];
    mainImagePreview.value = null;
    additionalImagesPreviews.value = [];
};

// Open edit modal
const openEditModal = (product) => {
    id.value = product.id;
    name.value = product.name;
    description.value = product.description;
    price.value = product.price;
    stock.value = product.stock;
    category_id.value = product.category_id;
    size_id.value = product.size_id;
    gender.value = product.gender;
    color.value = product.color;
    brand.value = product.brand;
    productImages.value = product.product_images.map((img) => ({
        id: img.id,
        url: `/storage/${img.image_path}`,
        raw: null,
    }));
    editMode.value = true;
    dialogVisible.value = true;
};

// Open add modal
const openAddModal = () => {
    isAddProduct.value = true;
    dialogVisible.value = true;
    editMode.value = false;
    resetFormData();
};

// Handle main image change with preview
const handleMainImageChange = (event) => {
    const file = event.target.files[0];
    main_image.value = file;
    if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            mainImagePreview.value = e.target.result;
        };
        reader.readAsDataURL(file);
    } else {
        mainImagePreview.value = null;
    }
};

// Handle additional images change with previews
const handleAdditionalImagesChange = (event) => {
    const files = Array.from(event.target.files);
    additional_images.value = files;
    additionalImagesPreviews.value = [];
    files.forEach((file) => {
        const reader = new FileReader();
        reader.onload = (e) => {
            additionalImagesPreviews.value.push(e.target.result);
        };
        reader.readAsDataURL(file);
    });
};

// Handle image preview for el-upload
const handlePictureCardPreview = (file) => {
    previewImageUrl.value = file.url;
    previewDialogVisible.value = true;
};

// Handle image removal for el-upload
const handleRemove = (file, fileList) => {
    if (file.id) {
        deleteImage(file.id);
    }
    productImages.value = fileList;
};



// Add product
const addProduct = async () => {
    const formData = new FormData();
    formData.append("name", name.value);
    formData.append("description", description.value);
    formData.append("price", price.value);
    formData.append("stock", stock.value);
    formData.append("category_id", category_id.value);
    formData.append("size_id", size_id.value);
    formData.append("gender", gender.value);
    formData.append("color", color.value);
    formData.append("brand", brand.value);

    if (main_image.value) {
        formData.append("main_image", main_image.value);
    }

    if (additional_images.value && additional_images.value.length > 0) {
        Array.from(additional_images.value).forEach((image, index) => {
            formData.append(`product_images[${index}]`, image);
        });
    }

    await router.post(route("admin.products.store"), formData, {
        onSuccess: () => {
            dialogVisible.value = false;
            resetFormData();
        },
        headers: {
            "Content-Type": "multipart/form-data",
        },
    });
};

// Update product
const updateProduct = async () => {
    const formData = new FormData();
    formData.append("name", name.value);
    formData.append("description", description.value);
    formData.append("price", price.value);
    formData.append("stock", stock.value);
    formData.append("category_id", category_id.value);
    formData.append("size_id", size_id.value);
    formData.append("gender", gender.value);
    formData.append("color", color.value);
    formData.append("brand", brand.value);
    formData.append("_method", "POST");

    if (main_image.value) {
        formData.append("main_image", main_image.value);
    }

    if (additional_images.value && additional_images.value.length > 0) {
        Array.from(additional_images.value).forEach((image, index) => {
            formData.append(`product_images[${index}]`, image);
        });
    }

    try {
        await router.post(route("admin.products.update", id.value), formData, {
            headers: {
                "Content-Type": "multipart/form-data",
            },
            onSuccess: () => {
                dialogVisible.value = false;
                resetFormData();
            },
        });
    } catch (error) {
        console.error("Error updating product:", error);
    }
};

// Delete image
const deleteImage = async (imageId) => {
    await router.delete(route("admin.products.image.delete", imageId));
};

// Delete product
const deleteProduct = async (productId) => {
    showDeleteModal.value = true;
    deleteAllMode.value = false;
    selectedProducts.value = [productId];
};

// Toggle checkboxes visibility
const toggleCheckboxes = () => {
    showCheckboxes.value = !showCheckboxes.value;
    if (!showCheckboxes.value) {
        selectedProducts.value = [];
        selectAll.value = false;
    }
};

// Toggle select all products
const toggleSelectAll = () => {
    if (selectAll.value) {
        selectedProducts.value = products.value.map(product => product.id);
    } else {
        selectedProducts.value = [];
    }
};

// Open delete modal
const openDeleteModal = () => {
    if (selectedProducts.value.length === 0 && !deleteAllMode.value) {
        showDeleteModal.value = true;
        return;
    }
    showDeleteModal.value = true;
};

// Open delete all modal
const openDeleteAllModal = () => {
    deleteAllMode.value = true;
    showDeleteModal.value = true;
};

// Confirm deletion
const confirmDelete = async () => {
    if (deleteAllMode.value) {
        await router.post(route('admin.products.delete-all'), {}, {
            onSuccess: () => {
                selectedProducts.value = [];
                selectAll.value = false;
                showCheckboxes.value = false;
                showDeleteModal.value = false;
                deleteAllMode.value = false;
                showSuccessMessage.value = true;
                setTimeout(() => showSuccessMessage.value = false, 3000);
                router.reload({ only: ['products'] });
            },
        });
    } else {
        if (selectedProducts.value.length === 0) {
            showDeleteModal.value = false;
            return;
        }
        await router.post(route('admin.products.delete-multiple'), { ids: selectedProducts.value }, {
            onSuccess: () => {
                selectedProducts.value = [];
                selectAll.value = false;
                showCheckboxes.value = false;
                showDeleteModal.value = false;
                showSuccessMessage.value = true;
                setTimeout(() => showSuccessMessage.value = false, 3000);
                router.reload({ only: ['products'] });
            },
        });
    }
};

// Toggle publish status
const togglePublish = async (productId) => {
    await router.post(route("admin.products.toggle-publish", productId), {}, {
        onSuccess: () => {
            router.reload({ only: ["products"] });
        },
    });
};

// En tu script setup, añade:
const searchQuery = ref('');

// Función para manejar la búsqueda
const performSearch = () => {
  router.get(route('admin.products.index'), 
    { search: searchQuery.value },
    {
      preserveState: true,
      replace: true
    }
  );
};

// Opcional: Búsqueda en tiempo real con debounce
import { debounce } from 'lodash';
const debouncedSearch = debounce(performSearch, 300);
</script>

<template>
    <section class="p-3 sm:p-5">
        <!-- Dialog for adding/editing product -->
        <el-dialog
            v-model="dialogVisible"
            :title="editMode ? 'Edit Product' : 'Add Product'"
            width="30%"
            :before-close="handleClose"
        >
            <form @submit.prevent="editMode ? updateProduct() : addProduct()">
                <!-- Name -->
                <div class="mb-4">
                    <label class="block text-gray-700">Name</label>
                    <input
                        v-model="name"
                        type="text"
                        class="w-full border-gray-300 rounded-md"
                        required
                    />
                </div>

                <!-- Description -->
                <div class="mb-4">
                    <label class="block text-gray-700">Description</label>
                    <textarea
                        v-model="description"
                        class="w-full border-gray-300 rounded-md"
                    ></textarea>
                </div>

                <!-- Price -->
                <div class="mb-4">
                    <label class="block text-gray-700">Price</label>
                    <input
                        v-model.number="price"
                        type="number"
                        step="0.01"
                        class="w-full border-gray-300 rounded-md"
                        required
                    />
                </div>

                <!-- Stock -->
                <div class="mb-4">
                    <label class="block text-gray-700">Stock</label>
                    <input
                        v-model.number="stock"
                        type="number"
                        class="w-full border-gray-300 rounded-md"
                        required
                    />
                </div>

                <!-- Category -->
                <div class="mb-4">
                    <label class="block text-gray-700">Category</label>
                    <select
                        v-model.number="category_id"
                        class="w-full border-gray-300 rounded-md"
                        required
                    >
                        <option value="">Select a category</option>
                        <option
                            v-for="category in categories"
                            :key="category.id"
                            :value="category.id"
                        >
                            {{ category.name }}
                        </option>
                    </select>
                </div>

                <!-- Size -->
                <div class="mb-4">
                    <label class="block text-gray-700">Size</label>
                    <select
                        v-model.number="size_id"
                        class="w-full border-gray-300 rounded-md"
                        required
                    >
                        <option value="">Select a size</option>
                        <option
                            v-for="size in sizes"
                            :key="size.id"
                            :value="size.id"
                        >
                            {{ size.name }}
                        </option>
                    </select>
                </div>

                <!-- Gender -->
                <div class="mb-4">
                    <label class="block text-gray-700">Gender</label>
                    <select
                        v-model="gender"
                        class="w-full border-gray-300 rounded-md"
                        required
                    >
                        <option value="">Select gender</option>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                        <option value="unisex">Unisex</option>
                    </select>
                </div>

                <!-- Color -->
                <div class="mb-4">
                    <label class="block text-gray-700">Color</label>
                    <input
                        v-model="color"
                        type="text"
                        class="w-full border-gray-300 rounded-md"
                        placeholder="e.g., Black, Blue"
                    />
                </div>

                <!-- Brand -->
                <div class="mb-4">
                    <label class="block text-gray-700">Brand</label>
                    <input
                        v-model="brand"
                        type="text"
                        class="w-full border-gray-300 rounded-md"
                        placeholder="e.g., Nike, Adidas"
                    />
                </div>

                <!-- Main Image -->
                <div class="mb-4">
                    <label class="block text-gray-700 mb-2">Main Image</label>
                    <label
                        class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100"
                    >
                        <div
                            class="flex flex-col items-center justify-center pt-5 pb-6"
                        >
                            <svg
                                class="w-8 h-8 mb-4 text-gray-500"
                                aria-hidden="true"
                                xmlns="http://www.w3.org/2000/svg"
                                fill="none"
                                viewBox="0 0 20 16"
                            >
                                <path
                                    stroke="currentColor"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
                                />
                            </svg>
                            <p class="mb-2 text-sm text-gray-500">
                                Click to upload or drag and drop
                            </p>
                            <p class="text-xs text-gray-500">
                                PNG, JPG (MAX. 2MB)
                            </p>
                        </div>
                        <input
                            type="file"
                            accept="image/*"
                            @change="handleMainImageChange"
                            class="hidden"
                        />
                    </label>
                    <div v-if="mainImagePreview" class="mt-2">
                        <img
                            :src="mainImagePreview"
                            alt="Main Image Preview"
                            class="w-32 h-32 object-cover rounded"
                        />
                    </div>
                </div>

                <!-- Additional Images -->
                <div class="mb-4">
                    <label class="block text-gray-700 mb-2"
                        >Additional Images</label
                    >
                    <label
                        class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100"
                    >
                        <div
                            class="flex flex-col items-center justify-center pt-5 pb-6"
                        >
                            <svg
                                class="w-8 h-8 mb-4 text-gray-500"
                                aria-hidden="true"
                                xmlns="http://www.w3.org/2000/svg"
                                fill="none"
                                viewBox="0 0 20 16"
                            >
                                <path
                                    stroke="currentColor"
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"
                                />
                            </svg>
                            <p class="mb-2 text-sm text-gray-500">
                                Click to upload or drag and drop
                            </p>
                            <p class="text-xs text-gray-500">
                                PNG, JPG (MAX. 2MB)
                            </p>
                        </div>
                        <input
                            type="file"
                            accept="image/*"
                            multiple
                            @change="handleAdditionalImagesChange"
                            class="hidden"
                        />
                    </label>
                    <div
                        v-if="additionalImagesPreviews.length"
                        class="mt-2 flex flex-wrap gap-2"
                    >
                        <div
                            v-for="(preview, index) in additionalImagesPreviews"
                            :key="index"
                            class="relative"
                        >
                            <img
                                :src="preview"
                                alt="Additional Image Preview"
                                class="w-32 h-32 object-cover rounded"
                            />
                            <button
                                type="button"
                                @click="
                                    additionalImagesPreviews.splice(index, 1);
                                    additional_images.value.splice(index, 1);
                                "
                                class="absolute top-0 right-0 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center"
                            >
                                ×
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Existing Images (for edit mode) -->
                <div class="mb-4" v-if="editMode && productImages.length">
                    <label class="block text-gray-700 mb-2"
                        >Current Images</label
                    >
                    <div class="flex flex-wrap gap-2">
                        <div
                            v-for="(image, index) in productImages"
                            :key="index"
                            class="relative"
                        >
                            <img
                                :src="image.url"
                                class="w-32 h-32 object-cover rounded"
                            />
                            <button
                                type="button"
                                @click="handleRemove(image, productImages)"
                                class="absolute top-0 right-0 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center"
                            >
                                ×
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <button
                    type="submit"
                    class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600"
                >
                    {{ editMode ? "Update Product" : "Create Product" }}
                </button>
            </form>
        </el-dialog>

        <!-- Delete Confirmation Modal -->
        <el-dialog
            v-model="showDeleteModal"
            :title="deleteAllMode ? 'Eliminar todos los productos' : `Eliminar ${selectedProducts.length} producto${selectedProducts.length > 1 ? 's' : ''}`"
            width="30%"
        >
            <p class="text-sm text-gray-600 dark:text-gray-400">
                ¿Estás seguro de que deseas eliminar {{ deleteAllMode ? 'todos los productos' : 'los productos seleccionados' }}? Esta acción no se puede deshacer.
            </p>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="showDeleteModal = false">Cancelar</el-button>
                    <el-button type="danger" @click="confirmDelete">Eliminar</el-button>
                </span>
            </template>
        </el-dialog>

        <!-- Success Message -->
        <transition name="fade">
            <div
                v-if="showSuccessMessage"
                class="fixed top-4 right-4 bg-green-100 text-green-800 text-sm font-medium px-4 py-2 rounded-md shadow-md"
            >
                Productos eliminados correctamente
            </div>
        </transition>

        <!-- Main Content -->
        <div class="mx-auto max-w-screen-xl px-4 lg:px-12">
            <div
                class="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden"
            >
                <div
                    class="flex flex-col md:flex-row items-center justify-between space-y-3 md:space-y-0 md:space-x-4 p-4"
                >
                    <!-- Floating Delete Button -->
                    <transition name="fade">
                        <button
                            v-if="selectedProducts.length > 0 && showCheckboxes"
                            @click="openDeleteModal"
                            class="fixed bottom-4 right-4 px-4 py-2 bg-red-600 text-white rounded-full shadow-lg hover:bg-red-700 focus:outline-none focus:ring-4 focus:ring-red-300 flex items-center space-x-2 z-50"
                        >
                            <span>Eliminar {{ selectedProducts.length }} seleccionado{{ selectedProducts.length > 1 ? 's' : '' }}</span>
                        </button>
                    </transition>

<!-- Search Bar -->
<div class="w-full md:w-1/2">
    <div class="relative w-full">
        <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <svg aria-hidden="true" class="w-5 h-5 text-gray-500 dark:text-gray-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd"/>
            </svg>
        </div>
        <input
            type="text"
            v-model="searchQuery"
            @input="debouncedSearch"
            class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
            placeholder="Buscar por nombre..."
        />
    </div>
</div>

                    <!-- Actions and Buttons -->
                    <div
                        class="w-full md:w-auto flex flex-col md:flex-row space-y-2 md:space-y-0 items-stretch md:items-center justify-end md:space-x-3 flex-shrink-0"
                    >
                        <button
                            type="button"
                            @click="openAddModal"
                            class="flex items-center justify-center text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800"
                        >
                            <svg
                                class="h-3.5 w-3.5 mr-2"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg"
                                aria-hidden="true"
                            >
                                <path
                                    clip-rule="evenodd"
                                    fill-rule="evenodd"
                                    d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z"
                                />
                            </svg>
                            Add product
                        </button>
                        <div
                            class="flex items-center space-x-3 w-full md:w-auto"
                        >
                            <button
                                id="actionsDropdownButton"
                                data-dropdown-toggle="actionsDropdown"
                                class="w-full md:w-auto flex items-center justify-center py-2 px-4 text-sm font-medium text-gray-900 focus:outline-none bg-white rounded-lg border border-gray-200 hover:bg-gray-100 hover:text-primary-700 focus:z-10 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-600 dark:hover:text-white dark:hover:bg-gray-700"
                                type="button"
                            >
                                <svg
                                    class="-ml-1 mr-1.5 w-5 h-5"
                                    fill="currentColor"
                                    viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg"
                                    aria-hidden="true"
                                >
                                    <path
                                        clip-rule="evenodd"
                                        fill-rule="evenodd"
                                        d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                    />
                                </svg>
                                Acciones
                            </button>
                            <div
                                id="actionsDropdown"
                                class="hidden z-10 w-44 bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600"
                            >
                                <div class="py-1">
                                    <a
                                        href="#"
                                        @click.prevent="toggleCheckboxes"
                                        class="block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
                                    >
                                        {{ showCheckboxes ? 'Ocultar selección' : 'Eliminar seleccionados' }}
                                    </a>
                                    <a
                                        href="#"
                                        @click.prevent="openDeleteAllModal"
                                        class="block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
                                    >
                                        Eliminar todos
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="overflow-x-auto">
                    <table
                        class="w-full text-sm text-left text-gray-500 dark:text-gray-400"
                    >
                        <thead
                            class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
                        >
                            <tr>
                                <th scope="col" class="px-4 py-3" v-if="showCheckboxes">
                                    <input
                                        type="checkbox"
                                        v-model="selectAll"
                                        @change="toggleSelectAll"
                                        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                                    />
                                </th>
                                <th scope="col" class="px-4 py-3">Nombre</th>
                                <th scope="col" class="px-4 py-3">Categoría</th>
                                <th scope="col" class="px-4 py-3">Marca</th>
                                <th scope="col" class="px-4 py-3">Cantidad</th>
                                <th scope="col" class="px-4 py-3">Precio</th>
                                <th scope="col" class="px-4 py-3">Stock</th>
                                <th scope="col" class="px-4 py-3">Publicado</th>
                                <th scope="col" class="px-4 py-3">
                                    <span class="sr-only">Acciones</span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="(product, index) in products"
                                :key="product.id"
                                class="border-b dark:border-gray-700"
                            >
                                <td class="px-4 py-3" v-if="showCheckboxes">
                                    <input
                                        type="checkbox"
                                        :value="product.id"
                                        v-model="selectedProducts"
                                        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                                    />
                                </td>
                                <th
                                    scope="row"
                                    class="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                >
                                    {{ product.name }}
                                </th>
                                <td class="px-4 py-3">
                                    {{ product.category?.name || "N/A" }}
                                </td>
                                <td class="px-4 py-3">{{ product.brand }}</td>
                                <td class="px-4 py-3">{{ product.stock }}</td>
                                <td class="px-4 py-3">{{ product.price }} €</td>
                                <td class="px-4 py-3">
                                    <span
                                        v-if="product.stock > 0"
                                        class="bg-green-100 text-green-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-green-900 dark:text-green-300"
                                    >
                                        En stock
                                    </span>
                                    <span
                                        v-else
                                        class="bg-red-100 text-red-800 text-xs font-medium mr-2 px-2.5 py-0.5 rounded dark:bg-red-900 dark:text-red-300"
                                    >
                                        Sin stock
                                    </span>
                                </td>
                                <td class="px-4 py-3">
                                    <button
                                        @click="togglePublish(product.id)"
                                        type="button"
                                        :class="{
                                            'px-3 py-2 text-xs font-medium text-center text-white bg-green-700 rounded-lg hover:bg-green-800 focus:ring-4 focus:outline-none focus:ring-green-300 dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800':
                                                product.published,
                                            'px-3 py-2 text-xs font-medium text-center text-white bg-red-700 rounded-lg hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-800':
                                                !product.published,
                                        }"
                                    >
                                        {{
                                            product.published
                                                ? "Publicado"
                                                : "No publicado"
                                        }}
                                    </button>
                                </td>
                                <td
                                    class="px-4 py-3 flex items-center justify-end"
                                >
                                    <button
                                        :id="`${product.id}-button`"
                                        :data-dropdown-toggle="`${product.id}`"
                                        class="inline-flex items-center p-0.5 text-sm font-medium text-center text-gray-500 hover:text-gray-800 rounded-lg focus:outline-none dark:text-gray-400 dark:hover:text-gray-100"
                                        type="button"
                                    >
                                        <svg
                                            class="w-5 h-5"
                                            aria-hidden="true"
                                            fill="currentColor"
                                            viewBox="0 0 20 20"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z"
                                            />
                                        </svg>
                                    </button>
                                    <div
                                        :id="`${product.id}`"
                                        class="hidden z-10 w-44 bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600"
                                    >
                                        <ul
                                            class="py-1 text-sm text-gray-700 dark:text-gray-200"
                                            :aria-labelledby="`${product.id}-button`"
                                        >
                                            <li>
                                                <a
                                                    href="#"
                                                    @click.prevent="
                                                        openEditModal(product)
                                                    "
                                                    class="block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                                                    >Edit</a
                                                >
                                            </li>
                                        </ul>
                                        <div class="py-1">
                                            <a
                                                href="#"
                                                @click.prevent="
                                                    deleteProduct(product.id)
                                                "
                                                class="block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white"
                                                >Delete</a
                                            >
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <nav
                    class="flex flex-col md:flex-row justify-between items-start md:items-center space-y-3 md:space-y-0 p-4"
                    aria-label="Table navigation"
                >
                    <span
                        class="text-sm font-normal text-gray-500 dark:text-gray-400"
                    >
                        Showing
                        <span
                            class="font-semibold text-gray-900 dark:text-white"
                            >1-10</span
                        >
                        of
                        <span
                            class="font-semibold text-gray-900 dark:text-white"
                            >1000</span
                        >
                    </span>
                    <ul class="inline-flex items-stretch -space-x-px">
                        <li>
                            <a
                                href="#"
                                class="flex items-center justify-center h-full py-1.5 px-3 ml-0 text-gray-500 bg-white rounded-l-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                            >
                                <span class="sr-only">Previous</span>
                                <svg
                                    class="w-5 h-5"
                                    aria-hidden="true"
                                    fill="currentColor"
                                    viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg"
                                >
                                    <path
                                        fill-rule="evenodd"
                                        d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
                                        clip-rule="evenodd"
                                    />
                                </svg>
                            </a>
                        </li>
                        <li>
                            <a
                                href="#"
                                class="flex items-center justify-center text-sm py-2 px-3 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                                >1</a
                            >
                        </li>
                        <li>
                            <a
                                href="#"
                                class="flex items-center justify-center text-sm py-2 px-3 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                                >2</a
                            >
                        </li>
                        <li>
                            <a
                                href="#"
                                aria-current="page"
                                class="flex items-center justify-center text-sm z-10 py-2 px-3 leading-tight text-primary-600 bg-primary-50 border border-primary-300 hover:bg-primary-100 hover:text-primary-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white"
                                >3</a
                            >
                        </li>
                        <li>
                            <a
                                href="#"
                                class="flex items-center justify-center text-sm py-2 px-3 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                                >...</a
                            >
                        </li>
                        <li>
                            <a
                                href="#"
                                class="flex items-center justify-center text-sm py-2 px-3 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                                >100</a
                            >
                        </li>
                        <li>
                            <a
                                href="#"
                                class="flex items-center justify-center h-full py-1.5 px-3 leading-tight text-gray-500 bg-white rounded-r-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                            >
                                <span class="sr-only">Next</span>
                                <svg
                                    class="w-5 h-5"
                                    aria-hidden="true"
                                    fill="currentColor"
                                    viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg"
                                >
                                    <path
                                        fill-rule="evenodd"
                                        d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                                        clip-rule="evenodd"
                                    />
                                </svg>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </section>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>