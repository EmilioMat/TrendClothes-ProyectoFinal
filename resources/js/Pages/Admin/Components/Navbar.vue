<template>
    <nav
        class="bg-white border-b border-gray-200 px-4 py-2.5 dark:bg-gray-800 dark:border-gray-700 fixed left-0 right-0 top-0 z-50"
    >
        <div class="flex flex-wrap justify-between items-center">
            <div class="flex justify-start items-center">
                <button
                    data-drawer-target="drawer-navigation"
                    data-drawer-toggle="drawer-navigation"
                    aria-controls="drawer-navigation"
                    class="p-2 mr-2 text-gray-600 rounded-lg cursor-pointer md:hidden hover:text-gray-900 hover:bg-gray-100 focus:bg-gray-100 dark:focus:bg-gray-700 focus:ring-2 focus:ring-gray-100 dark:focus:ring-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white"
                >
                    <svg
                        aria-hidden="true"
                        class="w-6 h-6"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            fill-rule="evenodd"
                            d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h6a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"
                            clip-rule="evenodd"
                        ></path>
                    </svg>
                    <svg
                        aria-hidden="true"
                        class="hidden w-6 h-6"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            fill-rule="evenodd"
                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                            clip-rule="evenodd"
                        ></path>
                    </svg>
                    <span class="sr-only"
                        >Activar o desactivar la barra lateral</span
                    >
                </button>
                <Link
                    :href="route('admin.dashboard')"
                    class="flex items-center justify-between mr-4"
                >
                    <svg
                        xmlns="http://www.w3.org/2000/svg"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke-width="1.5"
                        stroke="currentColor"
                        class="w-6 h-6"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12c.07.665-.45 1.243-1.119 1.243H4.25a1.125 1.125 0 01-1.12-1.243l1.264-12A1.125 1.125 0 015.513 7.5h12.974c.576 0 1.059.435 1.119 1.007zM8.625 10.5a.375.375 0 11-.75 0 .375.375 0 01.75 0zm7.5 0a.375.375 0 11-.75 0 .375.375 0 01.75 0z"
                        />
                    </svg>
                    <span
                        class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white"
                    >
                        TrendClothes
                    </span>
                </Link>
            </div>
            <div class="flex items-center lg:order-2">
                <!-- Apps -->
                <button
                    type="button"
                    data-dropdown-toggle="apps-dropdown"
                    class="p-2 text-gray-500 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700 focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600"
                >
                    <span class="sr-only">Opciones</span>
                    <!-- Icon -->
                    <svg
                        class="w-6 h-6"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            d="M5 3a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2V5a2 2 0 00-2-2H5zM5 11a2 2 0 00-2 2v2a2 2 0 002 2h2a2 2 0 002-2v-2a2 2 0 00-2-2H5zM11 5a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V5zM11 13a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"
                        ></path>
                    </svg>
                </button>
                <!-- Dropdown menu -->
                <div
                    class="hidden overflow-hidden z-50 my-4 max-w-sm text-base list-none bg-white rounded divide-y divide-gray-100 shadow-lg dark:bg-gray-700 dark:divide-gray-600 rounded-xl"
                    id="apps-dropdown"
                >
                    <div
                        class="block py-2 px-4 text-base font-medium text-center text-gray-700 bg-gray-50 dark:bg-gray-600 dark:text-gray-300"
                    >
                        Menú de Usuario
                    </div>

                    <!-- Grid de opciones (2 columnas) -->
                    <div class="grid grid-cols-2 gap-4 p-4">
                        <!-- Perfil -->
                        <Link
                            :href="route('profile.edit')"
                            class="block p-4 text-center rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 group"
                        >
                            <svg
                                aria-hidden="true"
                                class="mx-auto mb-1 w-7 h-7 text-gray-400 group-hover:text-gray-500 dark:text-gray-400 dark:group-hover:text-gray-400"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                            >
                                <path
                                    fill-rule="evenodd"
                                    d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 0010 16a5.986 5.986 0 004.546-2.084A5 5 0 0010 11z"
                                    clip-rule="evenodd"
                                ></path>
                            </svg>
                            <div class="text-sm text-gray-900 dark:text-white">
                                Perfil
                            </div>
                        </Link>

                        <!-- Productos -->
                        <Link
                            :href="route('admin.products.index')"
                            class="block p-4 text-center rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 group"
                        >
                            <svg
                                aria-hidden="true"
                                class="mx-auto mb-1 w-7 h-7 text-gray-400 group-hover:text-gray-500 dark:text-gray-400 dark:group-hover:text-gray-400"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                            >
                                <path
                                    d="M4 3a2 2 0 100 4h12a2 2 0 100-4H4z"
                                ></path>
                                <path
                                    fill-rule="evenodd"
                                    d="M3 8h14v7a2 2 0 01-2 2H5a2 2 0 01-2-2V8zm5 3a1 1 0 011-1h2a1 1 0 110 2H9a1 1 0 01-1-1z"
                                    clip-rule="evenodd"
                                ></path>
                            </svg>
                            <div class="text-sm text-gray-900 dark:text-white">
                                Productos
                            </div>
                        </Link>

                        <!-- Usuarios (solo para admin) -->
                        <Link
                            v-if="
                                $page.props.auth.user &&
                                $page.props.auth.user.is_admin
                            "
                            :href="route('admin.users.index')"
                            class="block p-4 text-center rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 group"
                        >
                            <svg
                                aria-hidden="true"
                                class="mx-auto mb-1 w-7 h-7 text-gray-400 group-hover:text-gray-500 dark:text-gray-400 dark:group-hover:text-gray-400"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                                xmlns="http://www.w3.org/2000/svg"
                            >
                                <path
                                    d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z"
                                ></path>
                            </svg>
                            <div class="text-sm text-gray-900 dark:text-white">
                                Usuarios
                            </div>
                        </Link>
                    </div>

                    <!-- Cerrar Sesión (fuera del grid) -->
                    <div class="p-4 pt-0">
                        <li class="list-none col-span-2">
                            <Link
                                :href="route('logout')"
                                method="post"
                                as="button"
                                class="block w-full p-4 text-center rounded-lg hover:bg-gray-100 dark:hover:bg-gray-600 group"
                            >
                                <svg
                                    aria-hidden="true"
                                    class="mx-auto mb-1 w-7 h-7 text-gray-400 group-hover:text-gray-500 dark:text-gray-400 dark:group-hover:text-gray-400"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                    xmlns="http://www.w3.org/2000/svg"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"
                                    ></path>
                                </svg>
                                <div
                                    class="text-sm text-gray-900 dark:text-white"
                                >
                                    Cerrar Sesión
                                </div>
                            </Link>
                        </li>
                    </div>
                </div>

                <button
                    type="button"
                    class="flex mx-3 text-sm bg-gray-800 rounded-full md:mr-0 focus:ring-4 focus:ring-gray-300 dark:focus:ring-gray-600"
                    id="user-menu-button"
                    aria-expanded="false"
                    data-dropdown-toggle="dropdown"
                >
                    <span class="sr-only">Abrir menú de usuario</span>
                    <img
                        class="w-8 h-8 rounded-full"
                        :src="user.avatar"
                        alt="user photo"
                    />
                </button>
                <!-- Dropdown menu -->
                <div
                    class="hidden z-50 my-4 w-56 text-base list-none bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600 rounded-xl"
                    id="dropdown"
                >
                    <div class="py-3 px-4">
                        <span
                            class="block text-sm font-semibold text-gray-900 dark:text-white"
                        >
                            {{ user.name }}
                        </span>
                        <span
                            class="block text-sm text-gray-900 truncate dark:text-white"
                        >
                            {{ user.email }}
                        </span>
                    </div>
                    <ul
                        class="py-1 text-gray-700 dark:text-gray-300"
                        aria-labelledby="dropdown"
                    >
                        <li>
                            <Link
                                :href="route('profile.edit')"
                                class="block py-2 px-4 text-sm hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-400 dark:hover:text-white"
                            >
                                Mi perfil
                            </Link>
                        </li>
                    </ul>
                    <ul
                        class="py-1 text-gray-700 dark:text-gray-300"
                        aria-labelledby="dropdown"
                    >
                        <li>
                            <Link
                                :href="route('logout')"
                                method="post"
                                as="button"
                                class="block cursor-pointer py-2 px-4 text-sm hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white"
                            >
                                Cerrar sesión
                            </Link>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
</template>

<script setup>
import { Link } from "@inertiajs/vue3";
import { usePage } from "@inertiajs/vue3";
const page = usePage();
const user = page.props.auth.user;
</script>
