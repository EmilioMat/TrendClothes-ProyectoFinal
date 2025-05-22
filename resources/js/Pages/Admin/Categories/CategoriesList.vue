<script setup>
import { router, usePage } from "@inertiajs/vue3";
import { ref, computed, onMounted, onUnmounted, watch } from "vue";
import { debounce } from "lodash";

const props = defineProps({
    categories: Object,
});

// Estado del componente
const isAddCategory = ref(false);
const editMode = ref(false);
const dialogVisible = ref(false);
const selectedCategories = ref([]);
const selectAll = ref(false);
const showCheckboxes = ref(false);
const showDeleteModal = ref(false);
const showSuccessMessage = ref(false);
const showErrorModal = ref(false);
const errorMessage = ref('');
const deleteAllMode = ref(false);
const searchQuery = ref('');
const activeDropdown = ref(null); // Para rastrear el dropdown abierto

// Acceder a los mensajes flash
const flash = computed(() => usePage().props.flash);

// Mostrar mensajes flash al cargar la página
watch(flash, (newFlash) => {
    if (newFlash.success) {
        showSuccessMessage.value = true;
        setTimeout(() => showSuccessMessage.value = false, 3000);
    }
    if (newFlash.error) {
        errorMessage.value = newFlash.error;
        showErrorModal.value = true;
    }
});

// Form data
const form = ref({
    id: "",
    name: "",
    description: "",
});

// Computadas para la paginación
const currentPage = computed(() => props.categories.current_page || 1);
const lastPage = computed(() => props.categories.last_page || 1);
const from = computed(() => props.categories.from || 0);
const to = computed(() => props.categories.to || 0);
const total = computed(() => props.categories.total || 0);

// Lista de categorías
const categoryList = computed(() => props.categories?.data || []);

// Generar array de páginas para mostrar
const pages = computed(() => {
    if (!props.categories) return [];
    
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

// Métodos de paginación
function goToPage(page) {
    router.get(route('admin.categories.index'), { page }, {
        preserveState: true,
        replace: true,
    });
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

// Toggle dropdown
const toggleDropdown = (categoryId) => {
    activeDropdown.value = activeDropdown.value === categoryId ? null : categoryId;
};

// Reset form data
const resetForm = () => {
    form.value = {
        id: "",
        name: "",
        description: "",
    };
};

// Abrir modal para editar
const openEditModal = (category) => {
    form.value = {
        id: category.id,
        name: category.name,
        description: category.description,
    };
    editMode.value = true;
    dialogVisible.value = true;
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
};

// Abrir modal para añadir
const openAddModal = () => {
    resetForm();
    editMode.value = false;
    dialogVisible.value = true;
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
};

// Manejar cierre del modal
const handleClose = (done) => {
    done();
    activeDropdown.value = null; // Cerrar dropdown al cerrar el modal
};

// Guardar categoría
const saveCategory = () => {
    if (editMode.value) {
        router.post(route('admin.categories.update', form.value.id), form.value, {
            onSuccess: () => {
                dialogVisible.value = false;
                activeDropdown.value = null; // Cerrar dropdown después de actualizar
            },
        });
    } else {
        router.post(route('admin.categories.store'), form.value, {
            onSuccess: () => {
                dialogVisible.value = false;
                activeDropdown.value = null; // Cerrar dropdown después de agregar
            },
        });
    }
};

// Eliminar categoría
const deleteCategory = (categoryId) => {
    showDeleteModal.value = true;
    deleteAllMode.value = false;
    selectedCategories.value = [categoryId];
    activeDropdown.value = null;
};

// Toggle checkboxes visibility
const toggleCheckboxes = () => {
    showCheckboxes.value = !showCheckboxes.value;
    if (!showCheckboxes.value) {
        selectedCategories.value = [];
        selectAll.value = false;
    }
    activeDropdown.value = null; // Cerrar dropdown al alternar checkboxes
};

// Toggle select all categories
const toggleSelectAll = () => {
    if (selectAll.value) {
        selectedCategories.value = categoryList.value.map(category => category.id);
    } else {
        selectedCategories.value = [];
    }
};

// Abrir modal de eliminación
const openDeleteModal = () => {
    if (selectedCategories.value.length === 0 && !deleteAllMode.value) {
        showDeleteModal.value = true;
        return;
    }
    showDeleteModal.value = true;
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
};

// Abrir modal para eliminar todo
const openDeleteAllModal = () => {
    deleteAllMode.value = true;
    showDeleteModal.value = true;
    activeDropdown.value = null; // Cerrar dropdown al abrir el modal
};

// Confirmar eliminación
const confirmDelete = () => {
    if (deleteAllMode.value) {
        router.post(route('admin.categories.delete-all'), {}, {
            onSuccess: () => {
                selectedCategories.value = [];
                selectAll.value = false;
                showCheckboxes.value = false;
                showDeleteModal.value = false;
                deleteAllMode.value = false;
                activeDropdown.value = null;
            },
        });
    } else {
        if (selectedCategories.value.length === 0) {
            showDeleteModal.value = false;
            return;
        }
        
        router.post(route('admin.categories.delete-multiple'), 
            { ids: selectedCategories.value }, 
            {
                onSuccess: () => {
                    selectedCategories.value = [];
                    selectAll.value = false;
                    showCheckboxes.value = false;
                    showDeleteModal.value = false;
                    activeDropdown.value = null;
                },
            }
        );
    }
};

// Búsqueda con debounce
const performSearch = debounce(() => {
    router.get(route('admin.categories.index'), 
        { search: searchQuery.value },
        {
            preserveState: true,
            replace: true
        });
    activeDropdown.value = null; // Cerrar dropdown al buscar
}, 300);

// Lifecycle hooks for dropdown management
onMounted(() => {
    document.addEventListener("click", closeDropdownsOnOutsideClick);
});

onUnmounted(() => {
    document.removeEventListener("click", closeDropdownsOnOutsideClick);
});

watch(() => props.categories.current_page, () => {
    activeDropdown.value = null; // Cerrar dropdown al cambiar de página
});

watch(() => searchQuery.value, () => {
    activeDropdown.value = null; // Cerrar dropdown al buscar
});

// Cerrar dropdowns al hacer clic fuera
const closeDropdownsOnOutsideClick = (e) => {
    if (!e.target.closest('[id^="action-button-"]') && !e.target.closest('[id^="dropdown-"]')) {
        activeDropdown.value = null;
    }
};
</script>

<template>
    <section class="p-3 sm:p-5">
        <!-- Dialog para añadir/editar categoría -->
        <el-dialog
            v-model="dialogVisible"
            :title="editMode ? 'Editar Categoría' : 'Añadir Categoría'"
            width="30%"
            :before-close="handleClose"
        >
            <form @submit.prevent="saveCategory">
                <!-- Nombre -->
                <div class="mb-4">
                    <label class="block text-gray-700">Nombre</label>
                    <input
                        v-model="form.name"
                        type="text"
                        class="w-full border-gray-300 rounded-md"
                        required
                    />
                </div>

                <!-- Descripción -->
                <div class="mb-4">
                    <label class="block text-gray-700">Descripción</label>
                    <textarea
                        v-model="form.description"
                        class="w-full border-gray-300 rounded-md"
                    ></textarea>
                </div>

                <!-- Botón de enviar -->
                <button
                    type="submit"
                    class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600"
                >
                    {{ editMode ? "Actualizar" : "Guardar" }}
                </button>
            </form>
        </el-dialog>

        <!-- Modal de confirmación para eliminar -->
        <el-dialog
            v-model="showDeleteModal"
            :title="
                deleteAllMode
                    ? 'Eliminar todas las categorías'
                    : `Eliminar ${selectedCategories.length} categoría${
                          selectedCategories.length > 1 ? 's' : ''
                      }`
            "
            width="30%"
        >
            <p class="text-sm text-gray-600 dark:text-gray-400">
                ¿Estás seguro de que deseas eliminar
                {{
                    deleteAllMode
                        ? "todas las categorías"
                        : "las categorías seleccionadas"
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

        <!-- Modal de error -->
        <el-dialog
            v-model="showErrorModal"
            title="Error al eliminar"
            width="30%"
        >
            <p class="text-sm text-gray-600 dark:text-gray-400">
                {{ errorMessage }}
            </p>
            <template #footer>
                <span class="dialog-footer">
                    <el-button 
                        type="primary" 
                        @click="showErrorModal = false"
                    >
                        Entendido
                    </el-button>
                </span>
            </template>
        </el-dialog>

        <!-- Mensaje de éxito -->
        <transition name="fade">
            <div
                v-if="showSuccessMessage"
                class="fixed top-4 right-4 bg-green-100 text-green-800 text-sm font-medium px-4 py-2 rounded-md shadow-md"
            >
                Operación realizada correctamente
            </div>
        </transition>

        <!-- Contenido principal -->
        <div class="mx-auto max-w-screen-xl px-4 lg:px-12">
            <div
                class="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden"
            >
                <div
                    class="flex flex-col md:flex-row items-center justify-between space-y-3 md:space-y-0 md:space-x-4 p-4"
                >
                    <!-- Botón flotante para eliminar -->
                    <transition name="fade">
                        <button
                            v-if="
                                selectedCategories.length > 0 && showCheckboxes
                            "
                            @click="openDeleteModal"
                            class="fixed bottom-4 right-4 px-4 py-2 bg-red-600 text-white rounded-full shadow-lg hover:bg-red-700 focus:outline-none focus:ring-4 focus:ring-red-300 flex items-center space-x-2 z-50"
                        >
                            <span
                                >Eliminar
                                {{ selectedCategories.length }} seleccionado{{
                                    selectedCategories.length > 1 ? "s" : ""
                                }}</span
                            >
                        </button>
                    </transition>

                    <!-- Barra de búsqueda -->
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
                                @input="performSearch"
                                class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-500 focus:border-primary-500 block w-full pl-10 p-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
                                placeholder="Buscar por nombre..."
                            />
                        </div>
                    </div>

                    <!-- Acciones y botones -->
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
                            Añadir categoría
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
                                        Eliminar todas
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
                                <th scope="col" class="px-4 py-3">
                                    Descripción
                                </th>
                                <th scope="col" class="px-4 py-3">
                                    Total Productos
                                </th>
                                <th scope="col" class="px-4 py-3">
                                    <span class="sr-only">Acciones</span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="category in categoryList"
                                :key="category.id"
                                class="border-b dark:border-gray-700"
                            >
                                <td class="px-4 py-3" v-if="showCheckboxes">
                                    <input
                                        type="checkbox"
                                        :value="category.id"
                                        v-model="selectedCategories"
                                        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                                    />
                                </td>
                                <th
                                    scope="row"
                                    class="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                >
                                    {{ category.name }}
                                </th>
                                <td class="px-4 py-3">
                                    {{ category.description || "N/A" }}
                                </td>
                                <td class="px-4 py-3">
                                    {{ category.products_count }}
                                </td>
                                <td
                                    class="px-4 py-3 flex items-center justify-end relative"
                                >
                                    <button
                                        :id="`action-button-${category.id}`"
                                        class="flex items-center justify-center w-8 h-8 text-gray-500 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-100 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors duration-200 focus:outline-none"
                                        @click.stop="
                                            toggleDropdown(category.id)
                                        "
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
                                        :id="`dropdown-${category.id}`"
                                        class="dropdown-menu absolute right-0 top-10 z-10 w-40 bg-white rounded-xl shadow-lg dark:bg-gray-800 dark:shadow-gray-900 overflow-hidden"
                                        :class="{
                                            hidden:
                                                activeDropdown !== category.id,
                                        }"
                                    >
                                        <ul class="text-sm">
                                            <li>
                                                <a
                                                    href="#"
                                                    @click.prevent="
                                                        openEditModal(category)
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
                                                        deleteCategory(
                                                            category.id
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
                        >
                            {{ from }}-{{ to }}
                        </span>
                        de
                        <span
                            class="font-semibold text-gray-900 dark:text-white"
                        >
                            {{ total }}
                        </span>
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

                        <!-- Botones de páginas -->
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

/* Estilos existentes */
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}
</style>