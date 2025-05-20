<script setup>
import { router, usePage } from "@inertiajs/vue3";
import { ref, computed, onMounted, onUnmounted, watch } from "vue";
import { debounce } from "lodash";
import { View, Hide } from "@element-plus/icons-vue";

const props = defineProps({
    users: Object,
});

const page = usePage();
const editMode = ref(false);
const dialogVisible = ref(false);
const selectedUsers = ref([]);
const selectAll = ref(false);
const showCheckboxes = ref(false);
const showDeleteModal = ref(false);
const showSuccessMessage = ref(false);
const deleteAllMode = ref(false);
const searchQuery = ref("");
const activeDropdown = ref(null);
const roles = ref([
    { value: "admin", label: "Administrador" },
    { value: "client", label: "Cliente" },
]);
const avatarInput = ref(null);
const showPassword = ref(false);
const showConfirmPassword = ref(false);

// Form data for submission
const form = ref({
    id: "",
    name: "",
    email: "",
    password: "",
    password_confirmation: "",
    role: "client",
    avatar: null, // Only for new file input, not display
});

// Separate reactive variable for displaying the current avatar URL
const currentAvatarUrl = ref(null);

// Access errors from usePage
const errors = computed(() => page.props.errors || {});
console.log("Errors:", errors.value);

const currentPage = computed(() => props.users.current_page || 1);
const lastPage = computed(() => props.users.last_page || 1);
const from = computed(() => props.users.from || 0);
const to = computed(() => props.users.to || 0);
const total = computed(() => props.users.total || 0);
const userList = computed(() => props.users?.data || []);

// Generar array de páginas para mostrar
const pages = computed(() => {
    if (!props.users) return [];

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
    router.get(
        route("admin.users.index"),
        { page, search: searchQuery.value },
        {
            preserveState: true,
            replace: true,
        }
    );
    activeDropdown.value = null;
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
const toggleDropdown = (userId) => {
    activeDropdown.value = activeDropdown.value === userId ? null : userId;
};

// Reset form data
const resetForm = () => {
    form.value = {
        id: "",
        name: "",
        email: "",
        password: "",
        password_confirmation: "",
        role: "client",
        avatar: null,
    };
    currentAvatarUrl.value = null; // Reset display URL
    if (avatarInput.value) {
        avatarInput.value.value = "";
    }
};

// Abrir modal para añadir usuario
const openAddModal = () => {
    resetForm();
    editMode.value = false;
    dialogVisible.value = true;
    activeDropdown.value = null;
};

// Abrir modal para editar
const openEditModal = (user) => {
    form.value = {
        id: user.id,
        name: user.name,
        email: user.email,
        password: "",
        password_confirmation: "",
        role: user.role || "client",
        avatar: null, // Keep avatar null unless a new file is selected
    };
    currentAvatarUrl.value = user.avatar_url || null; // Set display URL from user data
    editMode.value = true;
    dialogVisible.value = true;
    activeDropdown.value = null;
};

// Manejar cierre del modal
const handleClose = (done) => {
    resetForm();
    done();
    activeDropdown.value = null;
};

// Guardar usuario
const saveUser = async () => {
    const formData = new FormData();
    formData.append("name", form.value.name);
    formData.append("email", form.value.email);
    formData.append("role", form.value.role);
    if (form.value.password) {
        formData.append("password", form.value.password);
        formData.append(
            "password_confirmation",
            form.value.password_confirmation
        );
    }
    if (form.value.avatar instanceof File) {
        formData.append("avatar", form.value.avatar);
    }
    if (editMode.value) {
        formData.append("_method", "POST"); // Corrected to PUT for updates
    }
    try {
        await router.post(
            editMode.value
                ? route("admin.users.update", form.value.id)
                : route("admin.users.store"),
            formData,
            {
                preserveScroll: true,
                onSuccess: () => {
                    dialogVisible.value = false;
                    resetForm();
                    showSuccessMessage.value = true;
                    setTimeout(() => (showSuccessMessage.value = false), 3000);
                },
                onError: (errors) => {
                    console.log("Validation errors:", errors);
                },
            }
        );
    } catch (error) {
        console.error("Error saving user:", error);
    }
};

// Handle file input for avatar
const handleAvatarChange = (event) => {
    form.value.avatar = event.target.files[0];
    console.log("Selected avatar:", form.value.avatar);
};

// Eliminar usuario
const deleteUser = async (userId) => {
    try {
        await router.delete(route("admin.users.destroy", userId), {
            onSuccess: () => {
                showSuccessMessage.value = true;
                setTimeout(() => (showSuccessMessage.value = false), 3000);
                activeDropdown.value = null;
            },
            onError: (errors) => {
                console.error("Error deleting user:", errors);
            },
        });
    } catch (error) {
        console.error("Error deleting user:", error);
    }
};

// Toggle checkboxes visibility
const toggleCheckboxes = () => {
    showCheckboxes.value = !showCheckboxes.value;
    if (!showCheckboxes.value) {
        selectedUsers.value = [];
        selectAll.value = false;
    }
    activeDropdown.value = null;
};

// Toggle select all users
const toggleSelectAll = () => {
    if (selectAll.value) {
        selectedUsers.value = userList.value.map((user) => user.id);
    } else {
        selectedUsers.value = [];
    }
};

// Abrir modal de eliminación
const openDeleteModal = () => {
    if (selectedUsers.value.length === 0 && !deleteAllMode.value) {
        return;
    }
    showDeleteModal.value = true;
    activeDropdown.value = null;
};

// Abrir modal para eliminar todo
const openDeleteAllModal = () => {
    deleteAllMode.value = true;
    showDeleteModal.value = true;
    activeDropdown.value = null;
};

const isDeleting = ref(false);

// Confirmar eliminación
const confirmDelete = async () => {
    isDeleting.value = true;
    try {
        if (deleteAllMode.value) {
            await router.delete(
                route("admin.users.delete-all"),
                {},
                {
                    onSuccess: () => {
                        selectedUsers.value = [];
                        selectAll.value = false;
                        showCheckboxes.value = false;
                        showSuccessMessage.value = true;
                        setTimeout(
                            () => (showSuccessMessage.value = false),
                            3000
                        );
                        activeDropdown.value = null;
                    },
                    onError: (errors) => {
                        console.error("Error deleting all users:", errors);
                    },
                }
            );
        } else {
            if (selectedUsers.value.length === 0) {
                return;
            }
            await router.delete(route("admin.users.delete-multiple"), {
                data: { ids: selectedUsers.value },
                onSuccess: () => {
                    selectedUsers.value = [];
                    selectAll.value = false;
                    showCheckboxes.value = false;
                    showSuccessMessage.value = true;
                    setTimeout(() => (showSuccessMessage.value = false), 3000);
                    activeDropdown.value = null;
                },
                onError: (errors) => {
                    console.error("Error deleting multiple users:", errors);
                },
            });
        }
    } catch (error) {
        console.error("Error deleting users:", error);
    } finally {
        showDeleteModal.value = false;
        deleteAllMode.value = false;
        isDeleting.value = false;
    }
};

// Búsqueda con debounce
const performSearch = debounce(() => {
    router.get(
        route("admin.users.index"),
        { search: searchQuery.value },
        {
            preserveState: true,
            replace: true,
        }
    );
    activeDropdown.value = null;
}, 300);

// Lifecycle hooks for dropdown management
onMounted(() => {
    document.addEventListener("click", closeDropdownsOnOutsideClick);
});

onUnmounted(() => {
    document.removeEventListener("click", closeDropdownsOnOutsideClick);
});

watch(
    () => props.users.current_page,
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

// Cerrar dropdowns al hacer clic fuera
const closeDropdownsOnOutsideClick = (e) => {
    if (
        !e.target.closest('[id^="action-button-"]') &&
        !e.target.closest('[id^="dropdown-"]')
    ) {
        activeDropdown.value = null;
    }
};

// Mostrar rol del usuario
const getUserRole = (user) => {
    return user.role === "admin" ? "Administrador" : "Cliente";
};

// Estilo para el rol
const getRoleClass = (role) => {
    return role === "admin"
        ? "bg-blue-100 text-blue-800"
        : "bg-gray-100 text-gray-800";
};
</script>

<template>
    <section class="p-3 sm:p-5">
        <!-- Dialog para añadir/editar usuario -->
        <el-dialog
            v-model="dialogVisible"
            :title="editMode ? 'Editar Usuario' : 'Añadir Usuario'"
            width="30%"
            :before-close="handleClose"
        >
            <form @submit.prevent="saveUser" class="max-w-md mx-auto space-y-6">
                <!-- Nombre -->
                <div>
                    <label
                        for="name"
                        class="block mb-1 text-sm font-medium text-gray-700"
                        >Nombre</label
                    >
                    <input
                        id="name"
                        v-model="form.name"
                        type="text"
                        placeholder="Tu nombre"
                        class="block w-full rounded-md border px-3 py-2 text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition disabled:bg-gray-100"
                        :class="
                            errors.name
                                ? 'border-red-500 ring-red-500'
                                : 'border-gray-300'
                        "
                    />
                    <p v-if="errors.name" class="mt-1 text-xs text-red-600">
                        {{ errors.name }}
                    </p>
                </div>

                <!-- Email con icono -->
                <div>
                    <label
                        for="email"
                        class="block mb-1 text-sm font-medium text-gray-700"
                        >Email</label
                    >
                    <div class="relative">
                        <div
                            class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3"
                        >
                            <svg
                                class="h-4 w-4 text-gray-400"
                                fill="currentColor"
                                viewBox="0 0 20 16"
                                xmlns="http://www.w3.org/2000/svg"
                            >
                                <path
                                    d="m10.036 8.278 9.258-7.79A1.979 1.979 0 0 0 18 0H2A1.987 1.987 0 0 0 .641.541l9.395 7.737Z"
                                />
                                <path
                                    d="M11.241 9.817c-.36.275-.801.425-1.255.427-.428 0-.845-.138-1.187-.395L0 2.6V14a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V2.5l-8.759 7.317Z"
                                />
                            </svg>
                        </div>
                        <input
                            id="email"
                            v-model="form.email"
                            type="text"
                            :disabled="editMode"
                            placeholder="correo@ejemplo.com"
                            class="block w-full rounded-md border px-10 py-2 text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition disabled:bg-gray-100"
                            :class="
                                errors.email
                                    ? 'border-red-500 ring-red-500'
                                    : 'border-gray-300'
                            "
                        />
                    </div>
                    <p v-if="errors.email" class="mt-1 text-xs text-red-600">
                        {{ errors.email }}
                    </p>
                </div>

                <!-- Contraseña -->
                <div v-if="!editMode">
                    <label
                        for="password"
                        class="block mb-1 text-sm font-medium text-gray-700"
                        >Contraseña</label
                    >
                    <div class="relative">
                        <input
                            id="password"
                            v-model="form.password"
                            :type="showPassword ? 'text' : 'password'"
                            placeholder="••••••••"
                            class="block w-full rounded-md border px-3 py-2 pr-10 text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
                            :class="
                                errors.password
                                    ? 'border-red-500 ring-red-500'
                                    : 'border-gray-300'
                            "
                        />
                        <button
                            type="button"
                            class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-gray-600"
                            @click="showPassword = !showPassword"
                            tabindex="-1"
                        >
                            <component
                                :is="showPassword ? Hide : View"
                                class="w-5 h-5"
                            />
                        </button>
                    </div>
                    <p v-if="errors.password" class="mt-1 text-xs text-red-600">
                        {{ errors.password }}
                    </p>
                </div>

                <!-- Confirmar contraseña -->
                <div v-if="!editMode">
                    <label
                        for="password_confirmation"
                        class="block mb-1 text-sm font-medium text-gray-700"
                        >Confirmar Contraseña</label
                    >
                    <div class="relative">
                        <input
                            id="password_confirmation"
                            v-model="form.password_confirmation"
                            :type="showConfirmPassword ? 'text' : 'password'"
                            placeholder="••••••••"
                            class="block w-full rounded-md border px-3 py-2 pr-10 text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
                            :class="
                                errors.password_confirmation
                                    ? 'border-red-500 ring-red-500'
                                    : 'border-gray-300'
                            "
                        />
                        <button
                            type="button"
                            class="absolute inset-y-0 right-0 flex items-center pr-3 text-gray-400 hover:text-gray-600"
                            @click="showConfirmPassword = !showConfirmPassword"
                            tabindex="-1"
                        >
                            <component
                                :is="showConfirmPassword ? Hide : View"
                                class="w-5 h-5"
                            />
                        </button>
                    </div>
                    <p
                        v-if="errors.password_confirmation"
                        class="mt-1 text-xs text-red-600"
                    >
                        {{ errors.password_confirmation }}
                    </p>
                </div>

                <!-- Rol -->
                <div>
                    <label
                        for="role"
                        class="block mb-1 text-sm font-medium text-gray-700"
                        >Rol</label
                    >
                    <select
                        id="role"
                        v-model="form.role"
                        class="block w-full rounded-md border border-gray-300 px-3 py-2 text-gray-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
                        :class="
                            errors.role ? 'border-red-500 ring-red-500' : ''
                        "
                    >
                        <option
                            v-for="role in roles"
                            :key="role.value"
                            :value="role.value"
                        >
                            {{ role.label }}
                        </option>
                    </select>
                    <p v-if="errors.role" class="mt-1 text-xs text-red-600">
                        {{ errors.role }}
                    </p>
                </div>

                <!-- Avatar -->
                <div>
                    <label
                        for="avatar"
                        class="block mb-1 text-sm font-medium text-gray-700"
                        >Avatar</label
                    >
                    <input
                        id="avatar"
                        type="file"
                        accept="image/*"
                        @change="handleAvatarChange"
                        ref="avatarInput"
                        class="block w-full rounded-md border border-gray-300 px-3 py-2 text-gray-900 cursor-pointer focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition"
                        :class="
                            errors.avatar ? 'border-red-500 ring-red-500' : ''
                        "
                    />
                    <p v-if="errors.avatar" class="mt-1 text-xs text-red-600">
                        {{ errors.avatar }}
                    </p>
                    <img
                        v-if="currentAvatarUrl"
                        :src="currentAvatarUrl"
                        alt="Current Avatar"
                        class="mt-2 h-20 w-20 rounded-full object-cover"
                    />
                </div>

                <!-- Botón -->
                <button
                    type="submit"
                    class="w-full rounded-md bg-blue-600 py-2 text-white font-semibold hover:bg-blue-700 transition"
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
                    ? 'Eliminar todos los usuarios clientes'
                    : `Eliminar ${selectedUsers.length} usuario${
                          selectedUsers.length > 1 ? 's' : ''
                      }`
            "
            width="30%"
        >
            <p class="text-sm text-gray-600 dark:text-gray-400">
                ¿Estás seguro de que deseas eliminar
                {{
                    deleteAllMode
                        ? "todos los usuarios clientes"
                        : "los usuarios seleccionados"
                }}? Esta acción no se puede deshacer.
            </p>
            <template #footer>
                <span class="dialog-footer">
                    <el-button @click="showDeleteModal = false"
                        >Cancelar</el-button
                    >
                    <el-button
                        type="danger"
                        @click="confirmDelete"
                        :loading="isDeleting"
                    >
                        Eliminar
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
                            v-if="selectedUsers.length > 0 && showCheckboxes"
                            @click="openDeleteModal"
                            class="fixed bottom-4 right-4 px-4 py-2 bg-red-600 text-white rounded-full shadow-lg hover:bg-red-700 focus:outline-none focus:ring-4 focus:ring-red-300 flex items-center space-x-2 z-50"
                        >
                            <span
                                >Eliminar
                                {{ selectedUsers.length }} seleccionado{{
                                    selectedUsers.length > 1 ? "s" : ""
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
                                placeholder="Buscar por nombre o email..."
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
                            Añadir usuario
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
                                        Eliminar todos los clientes
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
                                <th scope="col" class="px-4 py-3">Avatar</th>
                                <th scope="col" class="px-4 py-3">Nombre</th>
                                <th scope="col" class="px-4 py-3">Email</th>
                                <th scope="col" class="px-4 py-3">Rol</th>
                                <th scope="col" class="px-4 py-3">
                                    <span class="sr-only">Acciones</span>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr
                                v-for="user in userList"
                                :key="user.id"
                                class="border-b dark:border-gray-700"
                            >
                                <td class="px-4 py-3" v-if="showCheckboxes">
                                    <input
                                        type="checkbox"
                                        :value="user.id"
                                        v-model="selectedUsers"
                                        class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600"
                                    />
                                </td>
                                <td class="px-4 py-3">
                                    <img
                                        :src="user.avatar_url"
                                        alt="Avatar"
                                        class="h-10 w-10 rounded-full object-cover"
                                    />
                                </td>
                                <th
                                    scope="row"
                                    class="px-4 py-3 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                >
                                    {{ user.name }}
                                </th>
                                <td class="px-4 py-3">
                                    {{ user.email }}
                                </td>
                                <td class="px-4 py-3">
                                    <span
                                        :class="getRoleClass(user.role)"
                                        class="inline-block px-2 py-1 rounded-full text-xs font-semibold"
                                    >
                                        {{ getUserRole(user) }}
                                    </span>
                                </td>
                                <td
                                    class="px-4 py-3 flex items-center justify-end relative"
                                >
                                    <button
                                        :id="`action-button-${user.id}`"
                                        class="flex items-center justify-center w-8 h-8 text-gray-500 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-100 rounded-full hover:bg-gray-100 dark:hover:bg-gray-600 transition-colors duration-200 focus:outline-none"
                                        @click.stop="toggleDropdown(user.id)"
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
                                        :id="`dropdown-${user.id}`"
                                        class="dropdown-menu absolute right-0 top-10 z-10 w-40 bg-white rounded-xl shadow-lg dark:bg-gray-800 dark:shadow-gray-900 overflow-hidden"
                                        :class="{
                                            hidden: activeDropdown !== user.id,
                                        }"
                                    >
                                        <ul class="text-sm">
                                            <li>
                                                <a
                                                    href="#"
                                                    @click.prevent="
                                                        openEditModal(user)
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
                                                        deleteUser(user.id)
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
