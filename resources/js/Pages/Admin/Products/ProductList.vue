<script setup>
import { router, usePage } from "@inertiajs/vue3";
import { ref, computed, onMounted, onUnmounted, watch } from "vue";
import { Plus } from "@element-plus/icons-vue";
import { debounce } from "lodash";

// Props
const props = defineProps({
    products: Object,
    categories: Array,
    sizes: Array,
});

// State
const isAddProduct = ref(false);
const editMode = ref(false);
const dialogVisible = ref(false);
const productImages = ref([]);
const validationModalVisible = ref(false); // Modal para validación
const validationErrors = ref([]); // Errores de validación
const activeDropdown = ref(null); // Para rastrear el dropdown abierto

// Form data
const id = ref("");
const name = ref("");
const description = ref("");
const price = ref("");
const category_id = ref("");
const gender = ref("");
const color = ref("");
const brand = ref("");
const main_image = ref(null);
const images = ref([]); // Cambiado a 'images' para coincidir con el controlador

// Image previews
const mainImagePreview = ref(null);
const additionalImagesPreviews = ref([]);

// Bulk delete state
const selectedProducts = ref([]);
const selectAll = ref(false);
const showCheckboxes = ref(false);
const showDeleteModal = ref(false);
const showSuccessMessage = ref(false);
const deleteAllMode = ref(false);
const searchQuery = ref("");
const selectedSizeIds = ref([]);
const sizesWithStock = ref([]);

// Reset form data
const resetFormData = () => {
    id.value = "";
    name.value = "";
    description.value = "";
    price.value = "";
    category_id.value = "";
    gender.value = "";
    color.value = "";
    brand.value = "";
    main_image.value = null;
    images.value = [];
    productImages.value = [];
    mainImagePreview.value = null;
    additionalImagesPreviews.value = [];
    sizesWithStock.value = [];
    selectedSizeIds.value = []; // Añade esto
};

// Toggle dropdown
const toggleDropdown = (productId) => {
    activeDropdown.value =
        activeDropdown.value === productId ? null : productId;
};

// Open edit modal
const openEditModal = (product) => {
    id.value = product.id;
    name.value = product.name;
    description.value = product.description;
    price.value = product.price;
    category_id.value = product.category_id;
    gender.value = product.gender;
    color.value = product.color;
    brand.value = product.brand;

    // Cargar tallas seleccionadas y su stock
    selectedSizeIds.value = product.sizes.map((size) => size.id);
    sizesWithStock.value = product.sizes.map((size) => ({
        size_id: size.id,
        stock: size.pivot.stock,
    }));

    productImages.value = product.product_images.map((img) => ({
        id: img.id,
        url: `/storage/${img.image_path}`,
        raw: null,
    }));

    editMode.value = true;
    dialogVisible.value = true;
    activeDropdown.value = null;
};

// Open add modal
const openAddModal = () => {
    isAddProduct.value = true;
    dialogVisible.value = true;
    editMode.value = false;
    resetFormData();
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
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
    images.value = files;
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

// Validate form before submission
const validateForm = () => {
    validationErrors.value = [];
    if (!name.value) validationErrors.value.push("El nombre es requerido");
    if (!description.value)
        validationErrors.value.push("La descripción es requerida");
    if (!price.value) validationErrors.value.push("El precio es requerido");
    if (!category_id.value)
        validationErrors.value.push("La categoría es requerida");
    if (!gender.value) validationErrors.value.push("El género es requerido");
    if (!main_image.value && !editMode.value)
        validationErrors.value.push("La imagen principal es requerida");

    // Validación de tallas
    if (sizesWithStock.value.length === 0) {
        validationErrors.value.push("Selecciona al menos una talla");
    } else {
        for (const size of sizesWithStock.value) {
            if (size.stock === "" || size.stock === null) {
                validationErrors.value.push(
                    `El stock para la talla ${getSizeName(
                        size.size_id
                    )} es requerido`
                );
                break;
            }
            if (size.stock < 0) {
                validationErrors.value.push(
                    `El stock para la talla ${getSizeName(
                        size.size_id
                    )} no puede ser negativo`
                );
                break;
            }
        }
    }

    if (validationErrors.value.length > 0) {
        validationModalVisible.value = true;
        return false;
    }
    return true;
};

// Add product
const addProduct = async () => {
    if (!validateForm()) return;

    const formData = new FormData();
    formData.append("name", name.value);
    formData.append("description", description.value);
    formData.append("price", price.value);
    formData.append("category_id", category_id.value);
    formData.append("gender", gender.value);
    formData.append("color", color.value);
    formData.append("brand", brand.value);

    // Añadir tallas con stock
    sizesWithStock.value.forEach((size, index) => {
        formData.append(`sizes[${index}][size_id]`, size.size_id);
        formData.append(`sizes[${index}][stock]`, size.stock);
    });

    if (main_image.value) {
        formData.append("main_image", main_image.value);
    }

    if (images.value.length > 0) {
        images.value.forEach((image, index) => {
            formData.append(`product_images[${index}]`, image);
        });
    }

    try {
        await router.post(route("admin.products.store"), formData, {
            onSuccess: () => {
                dialogVisible.value = false;
                resetFormData();
                activeDropdown.value = null;
            },
            headers: { "Content-Type": "multipart/form-data" },
        });
    } catch (error) {
        console.error("Error creating product:", error);
    }
};

// Update product
const updateProduct = async () => {
    if (!validateForm()) return;

    const formData = new FormData();
    formData.append("name", name.value);
    formData.append("description", description.value);
    formData.append("price", price.value);
    formData.append("category_id", category_id.value);
    formData.append("gender", gender.value);
    formData.append("color", color.value);
    formData.append("brand", brand.value);
    formData.append("_method", "POST"); // Cambiado a PUT

    // Añadir tallas con stock
    sizesWithStock.value.forEach((size, index) => {
        formData.append(`sizes[${index}][size_id]`, size.size_id);
        formData.append(`sizes[${index}][stock]`, size.stock);
    });

    if (main_image.value) {
        formData.append("main_image", main_image.value);
    }

    if (images.value.length > 0) {
        images.value.forEach((image, index) => {
            formData.append(`product_images[${index}]`, image);
        });
    }

    try {
        await router.post(route("admin.products.update", id.value), formData, {
            headers: { "Content-Type": "multipart/form-data" },
            onSuccess: () => {
                dialogVisible.value = false;
                resetFormData();
                activeDropdown.value = null;
            },
        });
    } catch (error) {
        console.error("Error updating product:", error);
    }
};

// Delete image
const deleteImage = async (imageId) => {
    await router.delete(route("admin.products.image.delete", imageId));
    activeDropdown.value = null; // Cerrar dropdown después de eliminar imagen
};

// Delete product
const deleteProduct = async (productId) => {
    showDeleteModal.value = true;
    deleteAllMode.value = false;
    selectedProducts.value = [productId];
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal de eliminación
};

// Toggle checkboxes visibility
const toggleCheckboxes = () => {
    showCheckboxes.value = !showCheckboxes.value;
    if (!showCheckboxes.value) {
        selectedProducts.value = [];
        selectAll.value = false;
    }
    activeDropdown.value = null; // Cerrar dropdown al alternar checkboxes
};

// Toggle select all products
const toggleSelectAll = () => {
    if (selectAll.value) {
        selectedProducts.value = productList.value.map((product) => product.id);
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
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
};

// Open delete all modal
const openDeleteAllModal = () => {
    deleteAllMode.value = true;
    showDeleteModal.value = true;
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
};

// Confirm deletion
const confirmDelete = async () => {
    if (deleteAllMode.value) {
        await router.post(
            route("admin.products.delete-all"),
            {},
            {
                onSuccess: () => {
                    selectedProducts.value = [];
                    selectAll.value = false;
                    showCheckboxes.value = false;
                    showDeleteModal.value = false;
                    deleteAllMode.value = false;
                    showSuccessMessage.value = true;
                    setTimeout(() => (showSuccessMessage.value = false), 3000);
                    router.reload({ only: ["products"] });
                    activeDropdown.value = null; // Cerrar dropdown después de eliminar
                },
            }
        );
    } else {
        if (selectedProducts.value.length === 0) {
            showDeleteModal.value = false;
            return;
        }
        await router.post(
            route("admin.products.delete-multiple"),
            { ids: selectedProducts.value },
            {
                onSuccess: () => {
                    selectedProducts.value = [];
                    selectAll.value = false;
                    showCheckboxes.value = false;
                    showDeleteModal.value = false;
                    showSuccessMessage.value = true;
                    setTimeout(() => (showSuccessMessage.value = false), 3000);
                    router.reload({ only: ["products"] });
                    activeDropdown.value = null; // Cerrar dropdown después de eliminar
                },
            }
        );
    }
};

// Toggle publish status
const togglePublish = async (productId) => {
    await router.post(
        route("admin.products.toggle-publish", productId),
        {},
        {
            onSuccess: () => {
                router.reload({ only: ["products"] });
                activeDropdown.value = null; // Cerrar dropdown después de cambiar el estado
            },
        }
    );
};

// Search
const debouncedSearch = debounce(() => {
    router.get(
        route("admin.products.index"),
        { search: searchQuery.value },
        { preserveState: true, replace: true }
    );
}, 300);

const handleClose = (done) => {
    done();
    activeDropdown.value = null; // Cerrar dropdown al cerrar el modal
};

// Product list and pagination
const productList = computed(() => props.products?.data || []);

const currentPage = computed(() => props.products.current_page || 1);
const lastPage = computed(() => props.products.last_page || 1);
const from = computed(() => props.products.from || 0);
const to = computed(() => props.products.to || 0);
const total = computed(() => props.products.total || 0);

const pages = computed(() => {
    if (!props.products) return [];

    const range = [];
    const maxVisible = 5;
    let start = Math.max(1, currentPage.value - Math.floor(maxVisible / 2));
    let end = Math.min(lastPage.value, start + maxVisible - 1);

    if (end - start + 1 < maxVisible) {
        start = Math.max(1, end - maxVisible + 1);
    }

    for (let i = start; i <= end; i++) {
        range.push(i);
    }

    return range;
});

function goToPage(page) {
    router.get(
        route("admin.products.index"),
        { page },
        { preserveState: true, replace: true }
    );
    activeDropdown.value = null; // Cerrar dropdown al cambiar de página
}

function nextPage() {
    if (currentPage.value < lastPage.value) {
        goToPage(currentPage.value + 1);
    }
}

function previousPage() {
    if (currentPage.value > 1) {
        goToPage(currentPage.value - 1);
    }
}

// Lifecycle hooks for dropdown management
onMounted(() => {
    document.addEventListener("click", closeDropdownsOnOutsideClick);
});

onUnmounted(() => {
    document.removeEventListener("click", closeDropdownsOnOutsideClick);
});

watch(
    () => props.products.current_page,
    () => {
        activeDropdown.value = null; // Cerrar dropdown al cambiar de página
    }
);

watch(
    () => searchQuery.value,
    () => {
        activeDropdown.value = null; // Cerrar dropdown al buscar
    }
);

// Cerrar dropdowns al hacer clic fuera
const closeDropdownsOnOutsideClick = (e) => {
    if (
        !e.target.closest('[id^="action-button-"]') &&
        !e.target.closest('[id^="dropdown-"]')
    ) {
        activeDropdown.value = null;
    }
};

// Lifecycle hooks
onMounted(() => {
    document.addEventListener("click", closeDropdownsOnOutsideClick);
});

onUnmounted(() => {
    document.removeEventListener("click", closeDropdownsOnOutsideClick);
});

// Resetear dropdown al cambiar de página o buscar
watch(
    () => props.products.current_page,
    () => {
        activeDropdown.value = null;
    }
);

watch(
    () => searchQuery.value,
    () => {
        activeDropdown.value = null;
    }
);

const handleSizeSelectionChange = (selectedIds) => {
    sizesWithStock.value = selectedIds.map((id) => {
        const existing = sizesWithStock.value.find((s) => s.size_id === id);
        return existing || { size_id: id, stock: "" };
    });
};

const getSizeName = (id) => {
    const size = props.sizes.find((s) => s.id === id);
    return size ? size.name : "Desconocido";
};
</script>

<template>
    <section class="p-3 sm:p-5">
        <!-- Validation Modal -->
        <el-dialog
            v-model="validationModalVisible"
            title="Errores de Validación"
            width="30%"
        >
            <div class="text-sm text-gray-600 dark:text-gray-400">
                <p>Por favor complete todos los campos requeridos:</p>
                <ul class="mt-2">
                    <li
                        v-for="error in validationErrors"
                        :key="error"
                        class="list-disc ml-5"
                    >
                        {{ error }}
                    </li>
                </ul>
            </div>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="validationModalVisible = false"
                        >Cerrar</el-button
                    >
                </span>
            </template>
        </el-dialog>

        <!-- Dialog for adding/editing product -->
        <el-dialog
            v-model="dialogVisible"
            :title="editMode ? 'Edit Product' : 'Add Product'"
            width="50%"
            :before-close="handleClose"
        >
            <form
                @submit.prevent="editMode ? updateProduct() : addProduct()"
                class="grid grid-cols-2 gap-6"
            >
                <!-- Left Column -->
                <div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Name *</label
                        >
                        <input
                            v-model="name"
                            type="text"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            required
                        />
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Description *</label
                        >
                        <textarea
                            v-model="description"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 h-24"
                            required
                        ></textarea>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Price *</label
                        >
                        <input
                            v-model.number="price"
                            type="number"
                            step="0.01"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            required
                        />
                    </div>
                    <!-- <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1">Stock *</label>
                        <input
                            v-model.number="stock"
                            type="number"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            required
                        />
                    </div> -->
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Category *</label
                        >
                        <select
                            v-model.number="category_id"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
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
                </div>

                <!-- Right Column -->
                <div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Tallas y stock *</label
                        >
                        <el-form-item>
                            <el-select
                                v-model="selectedSizeIds"
                                multiple
                                filterable
                                placeholder="Selecciona tallas"
                                class="w-full"
                                @change="handleSizeSelectionChange"
                            >
                                <el-option
                                    v-for="size in sizes"
                                    :key="size.id"
                                    :label="size.name"
                                    :value="size.id"
                                />
                            </el-select>

                            <div
                                v-for="item in sizesWithStock"
                                :key="item.size_id"
                                class="flex items-center gap-4 mt-2"
                            >
                                <el-input
                                    v-model.number="item.stock"
                                    type="number"
                                    class="flex-1"
                                    placeholder="Stock para la talla"
                                    :prefix-icon="Plus"
                                />
                                <small class="text-gray-600">{{
                                    getSizeName(item.size_id)
                                }}</small>
                            </div>
                        </el-form-item>
                    </div>

                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Gender *</label
                        >
                        <select
                            v-model="gender"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            required
                        >
                            <option value="">Seleccionar género</option>
                            <option value="male">Masculino</option>
                            <option value="female">Femenino</option>
                            <option value="unisex">Unisex</option>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Color</label
                        >
                        <input
                            v-model="color"
                            type="text"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            placeholder="e.g., Black, Blue"
                        />
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Brand</label
                        >
                        <input
                            v-model="brand"
                            type="text"
                            class="w-full border border-gray-300 rounded-lg p-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                            placeholder="e.g., Nike, Adidas"
                        />
                    </div>
                    <div class="mb-4">
                        <label class="block text-gray-700 font-medium mb-1"
                            >Main Image *</label
                        >
                        <label
                            class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-blue-300 rounded-lg bg-white hover:bg-gray-50 transition-colors cursor-pointer"
                        >
                            <div
                                class="flex flex-col items-center justify-center pt-5 pb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-blue-500"
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
                                <p class="mt-2 text-sm text-gray-600">
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
                                class="w-32 h-32 object-cover rounded-lg shadow-md"
                            />
                        </div>
                    </div>
                </div>

                <!-- Additional Images (spanning both columns) -->
                <div class="col-span-2 mb-4">
                    <label class="block text-gray-700 font-medium mb-1"
                        >Additional Images</label
                    >
                    <label
                        class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-blue-300 rounded-lg bg-white hover:bg-gray-50 transition-colors cursor-pointer"
                    >
                        <div
                            class="flex flex-col items-center justify-center pt-5 pb-6"
                        >
                            <svg
                                class="w-8 h-8 text-blue-500"
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
                            <p class="mt-2 text-sm text-gray-600">
                                Click to upload or drag and drop
                            </p>
                            <p class="text-xs text-gray-500">
                                PNG, JPG (MAX. 2MB)
                            </p>
                        </div>
                        <input
                            type="file"
                            name="product_images[]"
                            accept="image/*"
                            multiple
                            @change="handleAdditionalImagesChange"
                            class="hidden"
                        />
                    </label>
                    <div
                        v-if="additionalImagesPreviews.length"
                        class="mt-2 flex flex-wrap gap-4"
                    >
                        <div
                            v-for="(preview, index) in additionalImagesPreviews"
                            :key="index"
                            class="relative"
                        >
                            <img
                                :src="preview"
                                alt="Additional Image Preview"
                                class="w-32 h-32 object-cover rounded-lg shadow-md"
                            />
                            <button
                                type="button"
                                @click="
                                    additionalImagesPreviews.splice(index, 1);
                                    images.value.splice(index, 1);
                                "
                                class="absolute top-2 right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center hover:bg-red-600"
                            >
                                ×
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Existing Images (for edit mode) -->
                <div
                    class="col-span-2 mb-4"
                    v-if="editMode && productImages.length"
                >
                    <label class="block text-gray-700 font-medium mb-1"
                        >Current Images</label
                    >
                    <div class="flex flex-wrap gap-4">
                        <div
                            v-for="(image, index) in productImages"
                            :key="index"
                            class="relative"
                        >
                            <img
                                :src="image.url"
                                class="w-32 h-32 object-cover rounded-lg shadow-md"
                            />
                            <button
                                type="button"
                                @click="handleRemove(image, productImages)"
                                class="absolute top-2 right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center hover:bg-red-600"
                            >
                                ×
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Submit Button (spanning both columns) -->
                <div class="col-span-2 flex justify-end">
                    <button
                        type="submit"
                        class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 focus:ring-4 focus:ring-blue-300 font-medium transition-colors"
                    >
                        {{ editMode ? "Update Product" : "Create Product" }}
                    </button>
                </div>
            </form>
        </el-dialog>

        <!-- Delete Confirmation Modal -->
        <el-dialog
            v-model="showDeleteModal"
            :title="
                deleteAllMode
                    ? 'Eliminar todos los productos'
                    : `Eliminar ${selectedProducts.length} producto${
                          selectedProducts.length > 1 ? 's' : ''
                      }`
            "
            width="30%"
        >
            <p class="text-sm text-gray-600 dark:text-gray-400">
                ¿Estás seguro de que deseas eliminar
                {{
                    deleteAllMode
                        ? "todos los productos"
                        : "los productos seleccionados"
                }}? Esta acción no se puede deshacer.
            </p>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="showDeleteModal = false"
                        >Cancelar</el-button
                    >
                    <el-button type="danger" @click="confirmDelete"
                        >Eliminar</el-button
                    >
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
                    <transition name="fade">
                        <button
                            v-if="selectedProducts.length > 0 && showCheckboxes"
                            @click="openDeleteModal"
                            class="fixed bottom-4 right-4 px-4 py-2 bg-red-600 text-white rounded-full shadow-lg hover:bg-red-700 focus:outline-none focus:ring-4 focus:ring-red-300 flex items-center space-x-2 z-50"
                        >
                            <span
                                >Eliminar
                                {{ selectedProducts.length }} seleccionado{{
                                    selectedProducts.length > 1 ? "s" : ""
                                }}</span
                            >
                        </button>
                    </transition>

                    <div class="w-full md:w-1/2">
                        <div class="relative w-full">
                            <div
                                class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
                            >
                                <svg
                                    aria-hidden="true"
                                    class="w-5 h-5 text-gray-500 dark:text-gray-400"
                                    fill="currentColor"
                                    viewBox="0 0 20 20"
                                    xmlns="http://www.w3.org/2000/svg"
                                >
                                    <path
                                        fill-rule="evenodd"
                                        d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
                                        clip-rule="evenodd"
                                    />
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
                                        {{
                                            showCheckboxes
                                                ? "Ocultar selección"
                                                : "Eliminar seleccionados"
                                        }}
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
                                <th
                                    scope="col"
                                    class="px-4 py-3"
                                    v-if="showCheckboxes"
                                >
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
                                v-for="(product, index) in productList"
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
                                    <div class="flex flex-wrap gap-1">
                                        <span
                                            v-for="size in product.sizes"
                                            :key="size.id"
                                            class="text-xs px-2 py-1 bg-gray-100 rounded"
                                        >
                                            {{ size.name }}:
                                            {{ size.pivot.stock }}
                                        </span>
                                    </div>
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
                                    class="px-4 py-3 flex items-center justify-end relative"
                                >
                                    <button
                                        :id="`action-button-${product.id}`"
                                        class="flex items-center justify-center w-8 h-8 text-gray-500 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-100 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors duration-200 focus:outline-none"
                                        @click.stop="toggleDropdown(product.id)"
                                        type="button"
                                    >
                                        <svg
                                            class="w-5 h-5"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M12 6v.01M12 12v.01M12 18v.01"
                                            />
                                        </svg>
                                    </button>

                                    <div
                                        :id="`dropdown-${product.id}`"
                                        class="dropdown-menu absolute right-0 top-10 z-10 w-40 bg-white rounded-xl shadow-lg dark:bg-gray-800 dark:shadow-gray-900 overflow-hidden"
                                        :class="{
                                            hidden:
                                                activeDropdown !== product.id,
                                        }"
                                    >
                                        <ul class="text-sm">
                                            <li>
                                                <a
                                                    href="#"
                                                    @click.prevent="
                                                        openEditModal(product)
                                                    "
                                                    class="block px-4 py-2 text-gray-700 hover:bg-blue-50 hover:text-blue-600 dark:text-gray-200 dark:hover:bg-gray-700 dark:hover:text-blue-400 transition-colors duration-150"
                                                >
                                                    Editar
                                                </a>
                                            </li>
                                            <li>
                                                <a
                                                    href="#"
                                                    @click.prevent="
                                                        deleteProduct(
                                                            product.id
                                                        )
                                                    "
                                                    class="block px-4 py-2 text-gray-700 hover:bg-red-50 hover:text-red-600 dark:text-gray-200 dark:hover:bg-gray-700 dark:hover:text-red-400 transition-colors duration-150"
                                                >
                                                    Eliminar
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <nav
                    class="flex flex-col md:flex-row justify-between items-start md:items-center space-y-3 md:space-y-0 p-4"
                    aria-label="Navegación de tabla"
                >
                    <span
                        class="text-sm font-normal text-gray-500 dark:text-gray-400"
                    >
                        Mostrando
                        <span
                            class="font-semibold text-gray-900 dark:text-white"
                            >{{ from }}-{{ to }}</span
                        >
                        de
                        <span
                            class="font-semibold text-gray-900 dark:text-white"
                            >{{ total }}</span
                        >
                    </span>
                    <ul class="inline-flex items-stretch -space-x-px">
                        <li>
                            <button
                                @click="previousPage"
                                :disabled="currentPage === 1"
                                class="flex items-center justify-center h-full py-1.5 px-3 ml-0 text-gray-500 bg-white rounded-l-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white disabled:opacity-50"
                            >
                                <span class="sr-only">Anterior</span>
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
                            </button>
                        </li>
                        <li v-for="page in pages" :key="page">
                            <button
                                @click="goToPage(page)"
                                :class="{
                                    'flex items-center justify-center text-sm py-2 px-3 leading-tight': true,
                                    'text-primary-600 bg-primary-50 border border-primary-300 hover:bg-primary-100 hover:text-primary-700 dark:border-gray-700 dark:bg-gray-700 dark:text-white':
                                        currentPage === page,
                                    'text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white':
                                        currentPage !== page,
                                }"
                            >
                                {{ page }}
                            </button>
                        </li>
                        <li>
                            <button
                                @click="nextPage"
                                :disabled="currentPage === lastPage"
                                class="flex items-center justify-center h-full py-1.5 px-3 leading-tight text-gray-500 bg-white rounded-r-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white disabled:opacity-50"
                            >
                                <span class="sr-only">Siguiente</span>
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
                            </button>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </section>
</template>

<style scoped>
/* Estilo para el dropdown */
.dropdown-menu {
    opacity: 0;
    transform: scale(0.95);
    transition: opacity 0.2s ease, transform 0.2s ease;
}

.dropdown-menu:not(.hidden) {
    opacity: 1;
    transform: scale(1);
}

.dropdown-menu.hidden {
    opacity: 0;
    transform: scale(0.95);
    pointer-events: none;
}

/* Transiciones suaves para el fondo y texto */
.transition-colors {
    transition: background-color 0.15s ease, color 0.15s ease;
}
</style>
