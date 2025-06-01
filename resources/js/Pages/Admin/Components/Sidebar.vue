<script setup>
import { Link } from "@inertiajs/vue3";
</script>

<template>
    <aside
        class="fixed top-0 left-0 z-40 w-64 h-screen pt-14 transition-transform -translate-x-full bg-white border-r border-gray-200 md:translate-x-0 dark:bg-gray-800 dark:border-gray-700"
        aria-label="Sidenav"
        id="drawer-navigation"
    >
        <div class="overflow-y-auto py-5 px-3 h-full bg-white dark:bg-gray-800">
            <ul class="space-y-2">
                <li>
                    <Link
                        :href="route('admin.dashboard')"
                        class="flex items-center p-2 text-base font-medium text-gray-900 rounded-lg dark:text-white hover:bg-gray-100 dark:hover:bg-gray-700 group"
                    >
                        <svg
                            aria-hidden="true"
                            class="w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white"
                            fill="currentColor"
                            viewBox="0 0 20 20"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                d="M2 10a8 8 0 018-8v8h8a8 8 0 11-16 0z"
                            ></path>
                            <path
                                d="M12 2.252A8.014 8.014 0 0117.748 8H12V2.252z"
                            ></path>
                        </svg>
                        <span class="ml-3">Dashbaord</span>
                    </Link>
                </li>
                <li>
                    <button
                        type="button"
                        class="flex items-center p-2 w-full text-base font-medium text-gray-900 rounded-lg transition duration-75 group hover:bg-gray-100 dark:text-white dark:hover:bg-gray-700"
                        aria-controls="dropdown-pages"
                        data-collapse-toggle="dropdown-pages"
                    >
                        <svg
                            aria-hidden="true"
                            class="flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white"
                            fill="currentColor"
                            viewBox="0 0 20 20"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path
                                fill-rule="evenodd"
                                d="M4 4a2 2 0 012-2h4.586A2 2 0 0112 2.586L15.414 6A2 2 0 0116 7.414V16a2 2 0 01-2 2H6a2 2 0 01-2-2V4zm2 6a1 1 0 011-1h6a1 1 0 110 2H7a1 1 0 01-1-1zm1 3a1 1 0 100 2h6a1 1 0 100-2H7z"
                                clip-rule="evenodd"
                            ></path>
                        </svg>
                        <span class="flex-1 ml-3 text-left whitespace-nowrap"
                            >Catálogo</span
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
                                d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                                clip-rule="evenodd"
                            ></path>
                        </svg>
                    </button>
                    <ul id="dropdown-pages" class="hidden py-2 space-y-2">
                        <li>
                            <Link
                                :href="route('admin.products.index')"
                                class="flex items-center p-2 pl-11 w-full text-base font-medium text-gray-900 rounded-lg transition duration-75 group hover:bg-gray-100 dark:text-white dark:hover:bg-gray-700"
                                >Productos</Link
                            >
                        </li>
                        <li>
                            <Link
                                :href="route('admin.categories.index')"
                                class="flex items-center p-2 pl-11 w-full text-base font-medium text-gray-900 rounded-lg transition duration-75 group hover:bg-gray-100 dark:text-white dark:hover:bg-gray-700"
                                >Categorias</Link
                            >
                        </li>
                        <li>
                            <Link
                                :href="route('admin.sizes.index')"
                                class="flex items-center p-2 pl-11 w-full text-base font-medium text-gray-900 rounded-lg transition duration-75 group hover:bg-gray-100 dark:text-white dark:hover:bg-gray-700"
                                >Tallas</Link
                            >
                        </li>
                    </ul>
                </li>
            </ul>
            <ul
                class="pt-5 mt-5 space-y-2 border-t border-gray-200 dark:border-gray-700"
            >
                <li>
                    <Link
                        :href="route('admin.informes.index')"
                        class="flex items-center p-2 text-base font-medium text-gray-900 rounded-lg transition duration-75 hover:bg-gray-100 dark:hover:bg-gray-700 dark:text-white group"
                    >
                        <svg
                            aria-hidden="true"
                            class="flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 dark:text-gray-400 group-hover:text-gray-900 dark:group-hover:text-white"
                            fill="currentColor"
                            viewBox="0 0 20 20"
                            xmlns="http://www.w3.org/2000/svg"
                        >
                            <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z"></path>
                            <path
                                fill-rule="evenodd"
                                d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z"
                                clip-rule="evenodd"
                            ></path>
                        </svg>
                        <span class="ml-3">Informes de Venta</span>
                    </Link>
                </li>
            </ul>
        </div>
        <div
            class="hidden absolute bottom-0 left-0 justify-center p-4 space-x-4 w-full lg:flex bg-white dark:bg-gray-800 z-20"
        >
            <a
                href="#"
                data-tooltip-target="tooltip-under-construction-1"
                class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:text-gray-400 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100 dark:hover:bg-gray-600"
            >
                <svg
                    aria-hidden="true"
                    class="w-6 h-6"
                    fill="currentColor"
                    viewBox="0 0 20 20"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                        d="M5 4a1 1 0 00-2 0v7.268a2 2 0 000 3.464V16a1 1 0 102 0v-1.268a2 2 0 000-3.464V4zM11 4a1 1 0 10-2 0v1.268a2 2 0 000 3.464V16a1 1 0 102 0V8.732a2 2 0 000-3.464V4zM16 3a1 1 0 011 1v7.268a2 2 0 010 3.464V16a1 1 0 11-2 0v-1.268a2 2 0 010-3.464V4a1 1 0 011-1z"
                    ></path>
                </svg>
            </a>
            <div
                id="tooltip-under-construction-1"
                role="tooltip"
                class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip"
            >
                Página en construcción
                <div class="tooltip-arrow" data-popper-arrow></div>
            </div>
            <a
                href="#"
                data-tooltip-target="tooltip-under-construction-2"
                class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:text-gray-400 dark:hover:text-white hover:text-gray-900 hover:bg-gray-100 dark:hover:bg-gray-600"
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
                        d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z"
                        clip-rule="evenodd"
                    ></path>
                </svg>
            </a>
            <div
                id="tooltip-under-construction-2"
                role="tooltip"
                class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip"
            >
                Página en construcción
                <div class="tooltip-arrow" data-popper-arrow></div>
            </div>
            <button
                type="button"
                data-dropdown-toggle="language-dropdown"
                class="inline-flex justify-center p-2 text-gray-500 rounded cursor-pointer dark:hover:text-white dark:text-gray-400 hover:text-gray-900 hover:bg-gray-100 dark:hover:bg-gray-600"
            >
                <svg
                    aria-hidden="true"
                    class="h-5 w-5 rounded-full mt-0.5"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 512 512"
                >
                    <path fill="#FFC107" d="M0 0h512v341.3H0z" />
                    <path fill="#D81B60" d="M0 341.3h512v170.7H0z" />
                </svg>
            </button>
            <!-- Dropdown -->
            <div
                class="hidden z-50 my-4 text-base list-none bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700"
                id="language-dropdown"
            >
                <ul class="py-1" role="none">
                    <li>
                        <a
                            href="#"
                            data-tooltip-target="tooltip-language-es"
                            class="block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:text-white dark:text-gray-300 dark:hover:bg-gray-600"
                            role="menuitem"
                        >
                            <div class="inline-flex items-center">
                                <svg
                                    aria-hidden="true"
                                    class="h-3.5 w-3.5 rounded-full mr-2"
                                    xmlns="http://www.w3.org/2000/svg"
                                    id="flag-icon-css-es"
                                    viewBox="0 0 512 512"
                                >
                                    <path
                                        fill="#FFC107"
                                        d="M0 0h512v341.3H0z"
                                    />
                                    <path
                                        fill="#D81B60"
                                        d="M0 341.3h512v170.7H0z"
                                    />
                                </svg>
                                Español
                            </div>
                        </a>
                        <div
                            id="tooltip-language-es"
                            role="tooltip"
                            class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip"
                        >
                            Función no implementada
                            <div class="tooltip-arrow" data-popper-arrow></div>
                        </div>
                    </li>
                    <li>
                        <a
                            href="#"
                            data-tooltip-target="tooltip-language-en"
                            class="block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:text-white dark:text-gray-300 dark:hover:bg-gray-600"
                            role="menuitem"
                        >
                            <div class="inline-flex items-center">
                                <svg
                                    aria-hidden="true"
                                    class="h-3.5 w-3.5 rounded-full mr-2"
                                    xmlns="http://www.w3.org/2000/svg"
                                    id="flag-icon-css-gb"
                                    viewBox="0 0 512 512"
                                >
                                    <path fill="#012169" d="M0 0h512v512H0z" />
                                    <path
                                        fill="#FFF"
                                        d="M512 0v45.7L277.3 256 512 466.3V512H466.3L256 277.3 45.7 512H0v-45.7L234.7 256 0 45.7V0h45.7L256 234.7 466.3 0z"
                                    />
                                    <path
                                        fill="#C8102E"
                                        d="M256 0v234.7L512 0h-45.7zM256 277.3L512 512h-45.7zM0 512l256-234.7V512H0zm256-277.3L0 0h45.7z"
                                    />
                                    <path
                                        fill="#FFF"
                                        d="M147.4 0H192v211.2h320v89.6H192V512h-44.6V300.8H0v-89.6h147.4z"
                                    />
                                    <path
                                        fill="#C8102E"
                                        d="M170.7 0H192v512h-21.3zM0 234.7h512v42.6H0z"
                                    />
                                </svg>
                                Inglés
                            </div>
                        </a>
                        <div
                            id="tooltip-language-en"
                            role="tooltip"
                            class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip"
                        >
                            Función no implementada
                            <div class="tooltip-arrow" data-popper-arrow></div>
                        </div>
                    </li>
                    <li>
                        <a
                            href="#"
                            data-tooltip-target="tooltip-language-fr"
                            class="block py-2 px-4 text-sm text-gray-700 hover:bg-gray-100 dark:hover:text-white dark:text-gray-300 dark:hover:bg-gray-600"
                            role="menuitem"
                        >
                            <div class="inline-flex items-center">
                                <svg
                                    aria-hidden="true"
                                    class="h-3.5 w-3.5 rounded-full mr-2"
                                    xmlns="http://www.w3.org/2000/svg"
                                    id="flag-icon-css-fr"
                                    viewBox="0 0 512 512"
                                >
                                    <path
                                        fill="#0052B4"
                                        d="M0 0h170.7v512H0z"
                                    />
                                    <path
                                        fill="#FFF"
                                        d="M170.7 0h170.6v512H170.7z"
                                    />
                                    <path
                                        fill="#F00000"
                                        d="M341.3 0H512v512H341.3z"
                                    />
                                </svg>
                                Francés
                            </div>
                        </a>
                        <div
                            id="tooltip-language-fr"
                            role="tooltip"
                            class="inline-block absolute invisible z-10 py-2 px-3 text-sm font-medium text-white bg-gray-900 rounded-lg shadow-sm opacity-0 transition-opacity duration-300 tooltip"
                        >
                            Función no implementada
                            <div class="tooltip-arrow" data-popper-arrow></div>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </aside>
</template>
