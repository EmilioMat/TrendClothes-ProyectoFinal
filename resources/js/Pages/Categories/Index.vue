<template>
    <div class="min-h-screen bg-gray-50">
        <!-- Mensaje Flash -->
        <div
            v-if="$page.props.flash.success"
            class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-700 p-4 fixed top-0 w-full z-50"
            role="alert"
        >
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <p>{{ $page.props.flash.success }}</p>
                <button
                    @click="$page.props.flash.success = null"
                    class="text-emerald-700 hover:text-emerald-900"
                    aria-label="Cerrar mensaje"
                >
                    <svg
                        class="h-5 w-5"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                    >
                        <path
                            fill-rule="evenodd"
                            d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                            clip-rule="evenodd"
                        />
                    </svg>
                </button>
            </div>
        </div>

        <!-- Navegación -->
        <nav
            :class="{ scrolled: isScrolled }"
            class="fixed top-0 left-0 w-full z-10 transition-all duration-300"
        >
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div
                    class="flex justify-between h-20 items-center"
                    :class="isScrolled ? 'h-16' : 'h-20'"
                >
                    <!-- Logo -->
                    <div class="flex items-center">
                        <Link
                            :href="route('home')"
                            class="text-2xl font-bold"
                            :class="
                                isScrolled ? 'text-indigo-600' : 'text-white'
                            "
                            aria-label="Ir a la página principal de TrendClothes"
                            >TrendClothes</Link
                        >
                    </div>

                    <!-- Menú de escritorio -->
                    <div
                        class="hidden md:flex md:items-center md:ml-6 md:space-x-8"
                    >
                        <Link
                            :href="route('home')"
                            class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                            :class="[
                                route().current('home')
                                    ? 'border-indigo-500'
                                    : 'border-transparent hover:border-gray-300',
                                isScrolled
                                    ? 'text-gray-900 hover:text-indigo-600'
                                    : 'text-white hover:text-gray-200',
                            ]"
                            aria-label="Ir a la página de inicio"
                        >
                            Inicio
                        </Link>
                        <Link
                            :href="route('categories.index')"
                            class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                            :class="[
                                route().current('categories.*')
                                    ? 'border-indigo-500'
                                    : 'border-transparent hover:border-gray-300',
                                isScrolled
                                    ? 'text-gray-900 hover:text-indigo-600'
                                    : 'text-white hover:text-gray-200',
                            ]"
                            aria-label="Ver todas las categorías"
                        >
                            Categorías
                        </Link>
                        <Link
                            :href="route('about')"
                            class="inline-flex items-center px-1 pt-1 border-b-2 text-sm font-medium"
                            :class="[
                                route().current('about')
                                    ? 'border-indigo-500'
                                    : 'border-transparent hover:border-gray-300',
                                isScrolled
                                    ? 'text-gray-900 hover:text-indigo-600'
                                    : 'text-white hover:text-gray-200',
                            ]"
                            aria-label="Conocer más sobre nosotros"
                        >
                            Nosotros
                        </Link>
                    </div>

                    <!-- Menú derecho (Carrito y Usuario) -->
                    <div class="flex items-center space-x-4">
                        <!-- Carrito con vista previa al pasar el mouse -->
                        <div class="relative group">
                            <Link
                                :href="route('cart.index')"
                                class="flex items-center"
                                :class="
                                    isScrolled
                                        ? 'text-gray-900 hover:text-indigo-600'
                                        : 'text-white hover:text-indigo-300'
                                "
                                aria-label="Ir al carrito de compras"
                            >
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    class="h-6 w-6"
                                    fill="none"
                                    viewBox="0 0 24 24"
                                    stroke="currentColor"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"
                                    />
                                </svg>
                                <span
                                    v-if="cartCount > 0"
                                    class="absolute -top-2 -right-2 bg-indigo-600 text-white text-xs font-bold rounded-full h-5 w-5 flex items-center justify-center"
                                >
                                    {{ cartCount }}
                                </span>
                            </Link>
                            <!-- Vista previa del carrito desplegable -->
                            <div
                                class="fixed md:absolute left-0 md:left-auto right-0 md:right-auto mt-2 w-full md:w-80 bg-white rounded-lg shadow-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none group-hover:pointer-events-auto z-10"
                                style="
                                    max-width: 95vw;
                                    margin: 0 auto;
                                    transform: translateX(-50%);
                                    left: 50%;
                                "
                            >
                                <div class="p-4">
                                    <span
                                        class="text-sm font-semibold text-gray-900"
                                        >Carrito</span
                                    >
                                    <div
                                        v-if="cartItems.length > 0"
                                        class="mt-2 space-y-2"
                                    >
                                        <div
                                            v-for="item in cartItems"
                                            :key="item.id"
                                            class="flex items-center space-x-4"
                                        >
                                            <img
                                                v-if="item.product.main_image"
                                                :src="item.product.main_image"
                                                :alt="item.product.name"
                                                class="h-12 w-12 object-cover rounded"
                                            />
                                            <div>
                                                <p
                                                    class="text-sm text-gray-700"
                                                >
                                                    {{ item.product.name }}
                                                </p>
                                                <p
                                                    class="text-xs text-gray-500"
                                                >
                                                    Cantidad:
                                                    {{ item.quantity }}
                                                </p>
                                                <p
                                                    class="text-sm font-semibold text-indigo-600"
                                                >
                                                    {{
                                                        formatPrice(
                                                            item.product.price *
                                                                item.quantity
                                                        )
                                                    }}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <p v-else class="text-sm text-gray-500">
                                        Tu carrito está vacío
                                    </p>
                                    <Link
                                        :href="route('cart.index')"
                                        class="mt-4 block text-center text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 rounded-md py-2"
                                        aria-label="Ver detalles del carrito"
                                    >
                                        Ver Carrito
                                    </Link>
                                </div>
                            </div>
                        </div>

                        <!-- Menú de usuario -->
                        <template v-if="page.props.auth.user">
                            <div class="hidden md:block">
                                <Dropdown align="right" width="48">
                                    <template #trigger>
                                        <button
                                            class="flex items-center text-sm font-medium focus:outline-none"
                                            :class="
                                                isScrolled
                                                    ? 'text-gray-900 hover:text-indigo-600'
                                                    : 'text-white hover:text-gray-200'
                                            "
                                            aria-label="Abrir menú de usuario"
                                        >
                                            <svg
                                                xmlns="http://www.w3.org/2000/svg"
                                                class="h-6 w-6"
                                                fill="none"
                                                viewBox="0 0 24 24"
                                                stroke="currentColor"
                                            >
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-linejoin="round"
                                                    stroke-width="2"
                                                    d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                                                />
                                            </svg>
                                            <span class="sr-only"
                                                >Menú de usuario</span
                                            >
                                        </button>
                                    </template>
                                    <template #content>
                                        <DropdownLink
                                            :href="route('profile.edit')"
                                            aria-label="Editar perfil"
                                            >Perfil</DropdownLink
                                        >
                                        <DropdownLink
                                            v-if="page.props.auth.user.is_admin"
                                            :href="route('admin.dashboard')"
                                            aria-label="Ir al panel de administración"
                                        >
                                            Panel de Administración
                                        </DropdownLink>
                                        <DropdownLink
                                            :href="route('logout')"
                                            method="post"
                                            as="button"
                                            aria-label="Cerrar sesión"
                                        >
                                            Cerrar Sesión
                                        </DropdownLink>
                                    </template>
                                </Dropdown>
                            </div>
                        </template>
                        <template v-else>
                            <Link
                                :href="route('login')"
                                class="text-sm font-medium mr-4 hidden md:block"
                                :class="
                                    isScrolled
                                        ? 'text-gray-900 hover:text-indigo-600'
                                        : 'text-white hover:text-gray-200'
                                "
                                aria-label="Iniciar sesión"
                            >
                                Iniciar Sesión
                            </Link>
                            <Link
                                v-if="page.props.canRegister"
                                :href="route('register')"
                                class="text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 px-4 py-2 rounded-md hidden md:block"
                                aria-label="Registrarse"
                            >
                                Registrarse
                            </Link>
                        </template>

                        <!-- Botón de menú móvil -->
                        <div class="md:hidden">
                            <button
                                @click="mobileMenuOpen = !mobileMenuOpen"
                                class="focus:outline-none"
                                :class="
                                    isScrolled
                                        ? 'text-gray-500 hover:text-gray-700'
                                        : 'text-white hover:text-gray-200'
                                "
                                aria-label="Abrir menú móvil"
                            >
                                <svg
                                    v-if="!mobileMenuOpen"
                                    class="h-6 w-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M4 6h16M4 12h16M4 18h16"
                                    />
                                </svg>
                                <svg
                                    v-else
                                    class="h-6 w-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M6 18L18 6M6 6l12 12"
                                    />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Contenido del menú móvil -->
            <div v-if="mobileMenuOpen" class="md:hidden fixed inset-0 z-50">
                <div
                    class="absolute inset-0 overflow-y-auto bg-gray-900 bg-opacity-80 backdrop-blur-md"
                    style="
                        border: 0;
                        bottom: 0;
                        height: 100%;
                        left: 0;
                        overflow-y: scroll;
                        padding: 0;
                        right: 20px;
                        width: calc(100% - 20px);
                    "
                >
                    <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
                        <div class="flex justify-end p-4">
                            <button
                                @click="mobileMenuOpen = false"
                                class="text-white hover:text-gray-300 focus:outline-none"
                                aria-label="Cerrar menú móvil"
                            >
                                <svg
                                    class="h-8 w-8"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M6 18L18 6M6 6l12 12"
                                    />
                                </svg>
                            </button>
                        </div>

                        <div class="flex flex-col items-center mt-8">
                            <Link
                                :href="route('home')"
                                class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                                :class="
                                    route().current('home')
                                        ? 'text-indigo-300'
                                        : 'hover:text-gray-300'
                                "
                                @click="mobileMenuOpen = false"
                                aria-label="Ir a la página de inicio"
                            >
                                Inicio
                            </Link>
                            <Link
                                :href="route('categories.index')"
                                class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                                :class="
                                    route().current('categories.*')
                                        ? 'text-indigo-300'
                                        : 'hover:text-gray-300'
                                "
                                @click="mobileMenuOpen = false"
                                aria-label="Ver todas las categorías"
                            >
                                Categorías
                            </Link>
                            <Link
                                :href="route('about')"
                                class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center"
                                :class="
                                    route().current('about')
                                        ? 'text-indigo-300'
                                        : 'hover:text-gray-300'
                                "
                                @click="mobileMenuOpen = false"
                                aria-label="Conocer más sobre nosotros"
                            >
                                Sobre Nosotros
                            </Link>

                            <template v-if="page.props.auth.user">
                                <div class="w-full">
                                    <button
                                        @click="subMenuOpen = !subMenuOpen"
                                        class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                        aria-label="Abrir menú de mi TrendClothes"
                                    >
                                        MI TRENDCLOTHES
                                    </button>
                                    <div
                                        v-if="subMenuOpen"
                                        class="pl-6 space-y-2"
                                    >
                                        <Link
                                            :href="route('profile.edit')"
                                            class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                            @click="
                                                mobileMenuOpen = false;
                                                subMenuOpen = false;
                                            "
                                            aria-label="Editar perfil"
                                        >
                                            Mi Perfil
                                        </Link>
                                        <Link
                                            v-if="page.props.auth.user.is_admin"
                                            :href="route('admin.dashboard')"
                                            class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                            @click="
                                                mobileMenuOpen = false;
                                                subMenuOpen = false;
                                            "
                                            aria-label="Ir al panel de administración"
                                        >
                                            Panel de Administración
                                        </Link>
                                        <Link
                                            :href="route('logout')"
                                            method="post"
                                            as="button"
                                            class="block px-3 py-2 text-lg font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                            @click="
                                                mobileMenuOpen = false;
                                                subMenuOpen = false;
                                            "
                                            aria-label="Cerrar sesión"
                                        >
                                            Cerrar Sesión
                                        </Link>
                                    </div>
                                </div>
                            </template>
                            <template v-else>
                                <Link
                                    :href="route('login')"
                                    class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                    @click="mobileMenuOpen = false"
                                    aria-label="Iniciar sesión"
                                >
                                    Iniciar Sesión
                                </Link>
                                <Link
                                    v-if="page.props.canRegister"
                                    :href="route('register')"
                                    class="block px-3 py-4 text-xl font-medium text-white border-b border-gray-700 w-full text-center hover:text-gray-300"
                                    @click="mobileMenuOpen = false"
                                    aria-label="Registrarse"
                                >
                                    Registrarse
                                </Link>
                            </template>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main>
            <!-- Sección Hero -->
            <div class="relative h-screen overflow-hidden">
                <div class="absolute inset-0">
                    <img
                        src="/images/Page-Shop/Hero.webp"
                        alt="Fondo de moda"
                        class="w-full h-full object-cover"
                    />
                    <div class="absolute inset-0 bg-black/40"></div>
                </div>
                <div class="relative h-full flex items-center justify-center">
                    <div class="text-center px-4 max-w-7xl mx-auto">
                        <h1
                            class="text-4xl md:text-6xl font-bold text-white mb-6 animate-fade-in"
                        >
                            Descubre Nuestra Colección
                        </h1>
                        <p
                            class="text-xl md:text-2xl text-white/90 max-w-2xl mx-auto mb-8 animate-fade-in delay-100"
                        >
                            Moda que inspira, diseños que perduran
                        </p>
                        <a
                            href="#categories"
                            class="inline-block px-8 py-3 bg-white text-gray-900 font-semibold rounded-full hover:bg-gray-100 transition-all duration-300 animate-fade-in delay-200"
                            aria-label="Explorar categorías"
                        >
                            Explorar
                        </a>
                    </div>
                </div>
                <!-- Scroll indicator -->
                <div
                    class="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce"
                >
                    <div
                        class="w-6 h-10 border-2 border-white rounded-full p-1"
                    >
                        <div
                            class="w-1 h-3 bg-white rounded-full mx-auto animate-pulse"
                        ></div>
                    </div>
                </div>
            </div>

            <!-- Marquee -->
            <div class="bg-black py-6 overflow-hidden">
                <div class="marquee-container">
                    <div class="marquee-content">
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ NUEVA COLECCIÓN ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ ENVÍO GRATIS ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ 30% DE DESCUENTO ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ CALIDAD PREMIUM ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ NUEVA COLECCIÓN ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ ENVÍO GRATIS ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ 30% DE DESCUENTO ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ CALIDAD PREMIUM ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ NUEVA COLECCIÓN ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ ENVÍO GRATIS ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ 30% DE DESCUENTO ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ CALIDAD PREMIUM ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ NUEVA COLECCIÓN ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ ENVÍO GRATIS ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ 30% DE DESCUENTO ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ CALIDAD PREMIUM ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ NUEVA COLECCIÓN ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ ENVÍO GRATIS ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ 30% DE DESCUENTO ✦</span
                        >
                        <span
                            class="marquee-item text-white text-xl md:text-2xl font-bold mx-8"
                            >✦ CALIDAD PREMIUM ✦</span
                        >
                    </div>
                </div>
            </div>

            <!-- Sección de Hero con Texto + Dos Imágenes -->
            <div class="w-full min-h-[50vh] grid grid-cols-1 md:grid-cols-3">
                <!-- Columna izquierda con fondo gris claro y texto centrado -->
                <div
                    class="bg-[#ECECEC] text-gray-900 flex flex-col justify-center items-center px-4 sm:px-6 py-6 sm:py-8 md:py-16 text-center"
                >
                    <div
                        class="flex justify-center items-center px-4 py-2 sm:px-6 sm:py-3 bg-gradient-to-r from-indigo-600/20 to-emerald-500/20 backdrop-blur-lg rounded-full border border-white/10 mb-4 sm:mb-6 mx-auto w-max"
                    >
                        <svg
                            class="w-4 sm:w-5 h-4 sm:h-5 text-indigo-600 mr-1 sm:mr-2"
                            fill="currentColor"
                            viewBox="0 0 20 20"
                        >
                            <path
                                d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                            />
                        </svg>
                        <h2
                            class="text-indigo-600 font-semibold text-xs sm:text-sm tracking-wider"
                        >
                            DESTACA
                        </h2>
                    </div>

                    <h3
                        class="text-3xl sm:text-4xl md:text-6xl font-black text-black mb-4 sm:mb-6 leading-tight"
                    >
                        <span>Este invierno, </span>
                        <span
                            class="bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 bg-clip-text text-transparent"
                        >
                            no te abrígues...
                        </span>
                    </h3>

                    <p
                        class="mt-2 sm:mt-3 max-w-xs sm:max-w-2xl mx-auto text-base sm:text-xl text-gray-600 text-center mb-4 sm:mb-10"
                    >
                        Descubre la moda que se adapta a tu estilo de vida
                    </p>
                </div>

                <!-- Imagen central -->
                <div class="relative h-full">
                    <img
                        src="/images/Page-Shop/Modelo1.jpeg"
                        alt="Modelo central"
                        class="w-full h-full object-cover object-center"
                    />
                </div>

                <!-- Imagen derecha -->
                <div class="relative h-full">
                    <img
                        src="/images/Page-Shop/Modelo2.jpeg"
                        alt="Modelo derecho"
                        class="w-full h-full object-cover object-center"
                    />
                </div>
            </div>

            <!-- Sección de Beneficios Mejorada -->
            <div
                class="w-full pt-6 sm:pt-10 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 px-4 sm:px-6 py-4 sm:py-6 bg-white border-t border-gray-200"
            >
                <!-- Envío gratis - Mejorado -->
                <div
                    class="flex items-center space-x-3 sm:space-x-4 justify-center order-1 p-4 rounded-xl hover:bg-white hover:shadow-md transition-all duration-300 group"
                >
                    <div
                        class="p-2 bg-indigo-100 rounded-full group-hover:bg-indigo-200 transition-colors duration-300"
                    >
                        <ShoppingCart
                            class="w-6 sm:w-8 h-6 sm:h-8 text-indigo-600 group-hover:text-indigo-700 transition-colors duration-300"
                        />
                    </div>
                    <div class="text-left">
                        <p
                            class="font-bold text-gray-900 text-lg sm:text-xl leading-snug"
                        >
                            Envío gratis
                        </p>
                        <p
                            class="text-xs sm:text-sm text-gray-600 leading-snug"
                        >
                            En todos los pedidos
                        </p>
                    </div>
                </div>

                <!-- Devolución 30 días - Mejorado -->
                <div
                    class="flex items-center space-x-3 sm:space-x-4 justify-center order-2 p-4 rounded-xl hover:bg-white hover:shadow-md transition-all duration-300 group"
                >
                    <div
                        class="p-2 bg-emerald-100 rounded-full group-hover:bg-emerald-200 transition-colors duration-300"
                    >
                        <RefreshLeft
                            class="w-6 sm:w-8 h-6 sm:h-8 text-emerald-600 group-hover:text-emerald-700 transition-colors duration-300"
                        />
                    </div>
                    <div class="text-left">
                        <p
                            class="font-bold text-gray-900 text-lg sm:text-xl leading-snug"
                        >
                            Devolución 30 días
                        </p>
                        <p
                            class="text-xs sm:text-sm text-gray-600 leading-snug"
                        >
                            Satisfacción garantizada
                        </p>
                    </div>
                </div>

                <!-- Soporte 24/7 - Mejorado -->
                <div
                    class="flex items-center space-x-3 sm:space-x-4 justify-center order-3 p-4 rounded-xl hover:bg-white hover:shadow-md transition-all duration-300 group"
                >
                    <div
                        class="p-2 bg-amber-100 rounded-full group-hover:bg-amber-200 transition-colors duration-300"
                    >
                        <ChatLineRound
                            class="w-6 sm:w-8 h-6 sm:h-8 text-amber-600 group-hover:text-amber-700 transition-colors duration-300"
                        />
                    </div>
                    <div class="text-left">
                        <p
                            class="font-bold text-gray-900 text-lg sm:text-xl leading-snug"
                        >
                            Soporte 24/7
                        </p>
                        <p
                            class="text-xs sm:text-sm text-gray-600 leading-snug"
                        >
                            Chatea con nosotros
                        </p>
                    </div>
                </div>

                <!-- Compromiso sostenible - Mejorado -->
                <div
                    class="flex items-center justify-center order-4 p-4 rounded-xl hover:bg-white hover:shadow-md transition-all duration-300 group"
                >
                    <Link
                        :href="route('about') + '#compromiso'"
                        class="px-4 sm:px-5 py-2 border-2 border-gray-900 rounded-full hover:bg-gray-900 hover:text-white transition-all duration-300 font-semibold text-sm sm:text-base flex items-center space-x-2"
                        aria-label="Nuestro compromiso sostenible"
                    >
                        <span>Nuestro compromiso</span>
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            class="h-4 w-4"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M14 5l7 7m0 0l-7 7m7-7H3"
                            />
                        </svg>
                    </Link>
                </div>
            </div>

            <!-- Sección de Categorías -->
            <div id="categories" class="bg-white py-8 sm:py-16 pt-4 sm:pt-8">
                <div
                    class="mx-auto px-2 sm:px-4 lg:px-8"
                    style="max-width: 1440px; width: 100%"
                >
                    <div class="text-center mb-6 sm:mb-12">
                        <div
                            class="flex justify-center items-center px-4 py-2 sm:px-6 sm:py-3 bg-gradient-to-r from-indigo-600/20 to-emerald-500/20 backdrop-blur-lg rounded-full border border-white/10 mb-4 sm:mb-6 mx-auto w-max"
                        >
                            <svg
                                class="w-4 sm:w-5 h-4 sm:h-5 text-indigo-600 mr-1 sm:mr-2"
                                fill="currentColor"
                                viewBox="0 0 20 20"
                            >
                                <path
                                    d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                                />
                            </svg>
                            <h2
                                class="text-indigo-600 font-semibold text-xs sm:text-sm tracking-wider"
                            >
                                EXPLORA
                            </h2>
                        </div>

                        <h3
                            class="text-3xl sm:text-4xl md:text-6xl font-black text-black mb-4 sm:mb-6 leading-tight"
                        >
                            <span>Por </span>
                            <span
                                class="bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 bg-clip-text text-transparent"
                            >
                                categorias
                            </span>
                        </h3>

                        <p
                            class="mt-2 sm:mt-3 max-w-xs sm:max-w-2xl mx-auto text-base sm:text-xl text-gray-700 text-center mb-4 sm:mb-10"
                        >
                            Descubre la moda que se adapta a tu estilo de vida
                        </p>
                    </div>

                    <div class="flex justify-between items-center mb-4 sm:mb-6">
                        <div class="flex space-x-2 sm:space-x-3">
                            <button
                                @click="prevSlide"
                                class="p-2 sm:p-3 rounded-full bg-gray-100 hover:bg-gray-200 transition-colors text-gray-700 hover:text-gray-900 shadow-md"
                                aria-label="Diapositiva anterior"
                            >
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    class="h-4 sm:h-6 w-4 sm:w-6"
                                    viewBox="0 0 20 20"
                                    fill="currentColor"
                                >
                                    <path
                                        fill-rule="evenodd"
                                        d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
                                        clip-rule="evenodd"
                                    />
                                </svg>
                            </button>
                            <button
                                @click="nextSlide"
                                class="p-2 sm:p-3 rounded-full bg-gray-100 hover:bg-gray-200 transition-colors text-gray-700 hover:text-gray-900 shadow-md"
                                aria-label="Siguiente diapositiva"
                            >
                                <svg
                                    xmlns="http://www.w3.org/2000/svg"
                                    class="h-4 sm:h-6 w-4 sm:w-6"
                                    viewBox="0 0 20 20"
                                    fill="currentColor"
                                >
                                    <path
                                        fill-rule="evenodd"
                                        d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z"
                                        clip-rule="evenodd"
                                    />
                                </svg>
                            </button>
                        </div>
                    </div>

                    <!-- Contenedor del Carrusel -->
                    <div class="relative overflow-hidden">
                        <div
                            ref="carouselTrack"
                            class="flex transition-transform duration-500 ease-in-out gap-2 sm:gap-6"
                            :style="{
                                transform: `translateX(${currentTranslateX}px)`,
                            }"
                        >
                            <div
                                v-for="(category, index) in props.categories"
                                :key="`category-${category.id}-${index}`"
                                class="flex-shrink-0 carousel-card"
                                :style="{ width: `${cardWidth}px` }"
                            >
                                <Link
                                    :href="
                                        route('categories.show', {
                                            category: category.slug,
                                        })
                                    "
                                    class="group relative overflow-hidden rounded-none shadow-md hover:shadow-lg transition-all duration-500 h-full block"
                                >
                                    <div class="h-full overflow-hidden">
                                        <img
                                            :src="category.image_url"
                                            :alt="category.name"
                                            class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                                        />
                                    </div>
                                    <div
                                        class="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-30 transition duration-300 flex flex-col justify-end p-2 sm:p-8"
                                    >
                                        <h4
                                            class="spot_cta_title text-white text-center mb-2 sm:mb-4 text-2xl sm:text-5xl font-black uppercase font-['Gotham_Ultra'] tracking-tight text-shadow-sm"
                                        >
                                            {{ category.name }}
                                        </h4>
                                        <p
                                            class="text-gray-200 mb-2 sm:mb-6 text-xs sm:text-sm"
                                        >
                                            {{ category.description }}
                                        </p>
                                        <span
                                            class="spot_cta inline-flex items-center bg-white text-gray-900 transition-colors border border-black w-[calc(100%-10px)] sm:w-[calc(100%-40px)] py-2 sm:py-4 mx-2 sm:mx-5 justify-center text-xs sm:text-base font-bold font-['Gotham_SSm_A','Gotham_SSm_B','Arial',sans-serif] max-h-6 sm:max-h-8"
                                        >
                                            Ver productos
                                            <svg
                                                class="ml-1 sm:ml-2 h-3 sm:h-5 w-3 sm:w-5"
                                                fill="none"
                                                stroke="currentColor"
                                                viewBox="0 0 24 24"
                                            >
                                                <path
                                                    stroke-linecap="round"
                                                    stroke-width="2"
                                                    d="M14 5l7 7m0 0l-7 7m7-7H3"
                                                />
                                            </svg>
                                        </span>
                                    </div>
                                </Link>
                            </div>
                        </div>
                    </div>

                    <!-- Indicadores del Carrusel -->
                    <div
                        class="flex justify-center mt-4 sm:mt-8 space-x-1 sm:space-x-2"
                    >
                        <button
                            v-for="(slide, index) in totalSlides"
                            :key="index"
                            @click="goToSlide(index)"
                            class="w-2 sm:w-3 h-2 sm:h-3 rounded-full transition-colors"
                            :class="
                                currentSlide === index
                                    ? 'bg-indigo-600'
                                    : 'bg-gray-300'
                            "
                            :aria-label="`Ir a diapositiva ${index + 1}`"
                        ></button>
                    </div>
                </div>
            </div>

            <!-- Sección Diagonal Impactante -->
            <div class="relative w-full overflow-hidden bg-white py-16">
                <!-- Contenedor principal con clip-path diagonal -->
                <div class="relative flex flex-col lg:flex-row">
                    <!-- Columna izquierda con imagen de fondo -->
                    <div
                        class="w-full lg:w-1/2 h-96 lg:h-auto relative bg-white"
                    >
                        <!-- Imagen con clip-path -->
                        <div
                            class="absolute inset-0 bg-cover bg-center z-0"
                            style="
                                background-image: url('/images/Page-Shop/Modelo4.jpeg');
                                background-position: center top;
                                clip-path: polygon(
                                    0 0,
                                    100% 0,
                                    85% 100%,
                                    0% 100%
                                );
                            "
                        ></div>

                        <!-- Superposición negra para legibilidad -->
                        <div
                            class="absolute inset-0 bg-black/20 z-10"
                            style="
                                clip-path: polygon(
                                    0 0,
                                    100% 0,
                                    85% 100%,
                                    0% 100%
                                );
                            "
                        ></div>

                        <!-- Texto superpuesto en versión móvil -->
                        <div class="lg:hidden relative z-20 p-8 text-white">
                            <span class="text-4xl font-bold mb-4"
                                >Nueva Colección</span
                            >
                            <p class="text-xl mb-6">
                                Descubre las prendas que están definiendo esta
                                temporada
                            </p>
                            <a
                                href="#"
                                class="inline-block px-8 py-3 bg-white text-black font-bold rounded-full hover:bg-gray-100 transition"
                                aria-label="Ver Nueva Colección"
                                >Ver Colección</a
                            >
                        </div>
                    </div>

                    <!-- Columna derecha con texto -->
                    <div
                        class="w-full lg:w-1/2 bg-white py-16 px-8 lg:px-16 flex items-center"
                    >
                        <div class="max-w-lg mx-auto ml-4">
                            <div class="text-center mb-12">
                                <div
                                    class="flex justify-center items-center px-6 py-3 bg-gradient-to-r from-indigo-600/20 to-emerald-500/20 backdrop-blur-lg rounded-full border border-white/10 mb-6 mx-auto w-max"
                                >
                                    <svg
                                        class="w-5 h-5 text-indigo-600 mr-2"
                                        fill="currentColor"
                                        viewBox="0 0 20 20"
                                    >
                                        <path
                                            d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                                        />
                                    </svg>
                                    <h2
                                        class="text-indigo-600 font-semibold text-sm tracking-wider"
                                    >
                                        TrendClothes Exclusive
                                    </h2>
                                </div>

                                <h3
                                    class="text-6xl font-black text-black mb-6 leading-tight"
                                >
                                    <span>Redefine </span>
                                    <span
                                        class="bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 bg-clip-text text-transparent"
                                    >
                                        tu estilo
                                    </span>
                                </h3>

                                <p
                                    class="mt-3 max-w-2xl mx-auto text-xl text-gray-600 sm:mt-4 text-center mb-10"
                                >
                                    En TrendClothes no solo vendemos ropa,
                                    creamos tendencias. Nuestra nueva colección
                                    fusiona el streetwear urbano con elegancia
                                    contemporánea para ofrecerte piezas únicas
                                    que harán destacar tu estilo personal. Cada
                                    prenda está diseñada pensando en tu
                                    comodidad y en hacer una declaración de
                                    moda.
                                </p>
                            </div>
                            <div class="flex flex-col sm:flex-row gap-4">
                                <Link
                                    :href="
                                        route('categories.show', {
                                            category: 'sudaderas',
                                        })
                                    "
                                    class="inline-flex items-center px-8 py-4 bg-gradient-to-r from-indigo-600 to-indigo-700 text-white font-bold rounded-xl hover:from-indigo-500 hover:to-indigo-600 transform hover:scale-105 transition-all duration-300 shadow-2xl hover:shadow-indigo-600/25"
                                >
                                    <span>Descubrir coleccion</span>
                                </Link>

                                <Link
                                    :href="
                                        route('categories.show', {
                                            category: 'camisetas',
                                        })
                                    "
                                    class="inline-flex items-center px-8 py-4 border-2 border-indigo-600 text-indigo-600 font-bold rounded-xl hover:bg-indigo-50 transform hover:scale-105 transition-all duration-300 shadow-sm hover:shadow-md"
                                >
                                    <span>Renueva tu estilo</span>
                                </Link>
                            </div>
                            <div class="mt-8 flex items-center space-x-4">
                                <div class="flex -space-x-2">
                                    <img
                                        class="w-10 h-10 rounded-full border-2 border-white"
                                        src="https://randomuser.me/api/portraits/women/44.jpg"
                                        alt="Cliente satisfecha"
                                    />
                                    <img
                                        class="w-10 h-10 rounded-full border-2 border-white"
                                        src="https://randomuser.me/api/portraits/men/32.jpg"
                                        alt="Cliente satisfecho"
                                    />
                                    <img
                                        class="w-10 h-10 rounded-full border-2 border-white"
                                        src="https://randomuser.me/api/portraits/women/68.jpg"
                                        alt="Cliente satisfecha"
                                    />
                                </div>
                                <div>
                                    <p
                                        class="text-sm font-medium text-gray-900"
                                    >
                                        +5,000 clientes
                                    </p>
                                    <p class="text-sm text-gray-600">
                                        confían en nosotros
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Pie de Página -->
        <footer class="bg-gray-800 text-white py-12">
            <div class="mx-auto px-4 sm:px-6 lg:px-8 max-w-7xl">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                    <!-- Sección TrendClothes (sin cambios) -->
                    <div>
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >TrendClothes</span
                        >
                        <p class="text-gray-400">
                            La mejor selección de moda para todos los estilos.
                        </p>
                    </div>
                    <!-- Sección Mapa del Sitio (sin cambios) -->
                    <div class="ml-8">
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >Mapa del Sitio</span
                        >
                        <ul class="space-y-2">
                            <li>
                                <Link
                                    :href="'/'"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Ir a la página de Inicio"
                                    >Inicio</Link
                                >
                            </li>
                            <li>
                                <Link
                                    :href="'/categories'"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Ir a la página de Categorías"
                                    >Categorías</Link
                                >
                            </li>
                            <li>
                                <Link
                                    :href="'/about'"
                                    class="text-gray-400 hover:text-white"
                                    aria-label="Ir a la página de Nosotros"
                                    >Nosotros</Link
                                >
                            </li>
                        </ul>
                    </div>
                    <!-- Sección Ayuda (con cambios) -->
                    <div>
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >Ayuda</span
                        >
                        <ul class="space-y-2">
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white underline hover:no-underline"
                                    aria-label="Página de Contacto (en construcción)"
                                    >Contacto</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white underline hover:no-underline"
                                    aria-label="Página de Envíos (en construcción)"
                                    >Envíos</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white underline hover:no-underline"
                                    aria-label="Página de Devoluciones (en construcción)"
                                    >Devoluciones</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                        </ul>
                    </div>
                    <!-- Sección Legal (con cambios) -->
                    <div>
                        <span class="text-lg font-semibold mb-4 inline-block"
                            >Legal</span
                        >
                        <ul class="space-y-2">
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white underline hover:no-underline"
                                    aria-label="Página de Términos y Condiciones (en construcción)"
                                    >Términos y condiciones</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                            <li class="relative group">
                                <a
                                    href="#"
                                    class="text-gray-400 hover:text-white underline hover:no-underline"
                                    aria-label="Página de Política de Privacidad (en construcción)"
                                    >Política de privacidad</a
                                >
                                <span
                                    class="absolute left-0 mt-1 w-max px-2 py-1 text-xs text-white bg-gray-600 rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200"
                                    >Página en construcción</span
                                >
                            </li>
                        </ul>
                    </div>
                </div>
                <div
                    class="border-t border-gray-700 mt-8 pt-8 text-center text-gray-400"
                >
                    <p>© 2025 TrendClothes. Todos los derechos reservados.</p>
                </div>
            </div>
        </footer>
    </div>
</template>

<script setup>
import { Link, usePage } from "@inertiajs/vue3";
import Dropdown from "@/Components/Dropdown.vue";
import DropdownLink from "@/Components/DropdownLink.vue";
import { useCartStore } from "@/stores/cart";
import { computed, onMounted, onUnmounted, ref } from "vue";
import {
    ShoppingCart,
    RefreshLeft,
    ChatLineRound,
} from "@element-plus/icons-vue";

// Definir la propiedad de categorías para recibir datos del backend
const props = defineProps({
    categories: {
        type: Array,
        default: () => [], // Valor por defecto: un arreglo vacío si no se proporcionan datos
    },
});

const page = usePage();

// Almacén del carrito
const cartStore = useCartStore();
const cartCount = computed(() => cartStore.count);
const cartItems = computed(() => cartStore.items);

const mobileMenuOpen = ref(false);
const subMenuOpen = ref(false);

const formatPrice = (price) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(price);
};

// Estado de desplazamiento
const isScrolled = ref(false);
const handleScroll = () => {
    isScrolled.value = window.scrollY > 50;
};

// Estados para el carrusel
const carouselTrack = ref(null);
const currentSlide = ref(0);
const slideGap = 24;
const autoScrollInterval = ref(null);

// Número de diapositivas por vista según el tamaño de la pantalla
const slidesPerView = ref(3);
const updateSlidesPerView = () => {
    const width = window.innerWidth;
    if (width < 640) {
        slidesPerView.value = 1; // Móvil: 1 elemento
    } else if (width >= 640 && width < 1024) {
        slidesPerView.value = 2; // Tableta: 2 elementos
    } else {
        slidesPerView.value = 3; // Escritorio: 3 elementos
    }
    updateContainerWidth(); // Recalcular anchos después de cambiar diapositivas por vista
};

// Calcular dimensiones
const containerWidth = ref(0);
const cardWidth = computed(() => {
    if (containerWidth.value === 0) return 400; // Ancho de respaldo
    return Math.floor(
        (containerWidth.value - slideGap * (slidesPerView.value - 1)) /
            slidesPerView.value
    );
});

const totalSlides = computed(() => props.categories.length);
const currentTranslateX = computed(() => {
    const slideWidth = cardWidth.value + slideGap;
    return -(currentSlide.value * slideWidth);
});

// Funciones del carrusel
const nextSlide = () => {
    if (currentSlide.value < totalSlides.value - slidesPerView.value) {
        currentSlide.value++;
    } else {
        currentSlide.value = 0;
    }
};

const prevSlide = () => {
    if (currentSlide.value > 0) {
        currentSlide.value--;
    } else {
        currentSlide.value = totalSlides.value - slidesPerView.value;
    }
};

const goToSlide = (index) => {
    currentSlide.value = index;
};

// Iniciar auto-scroll
const startAutoScroll = () => {
    autoScrollInterval.value = setInterval(() => {
        nextSlide();
    }, 5000);
};

// Detener auto-scroll
const stopAutoScroll = () => {
    if (autoScrollInterval.value) {
        clearInterval(autoScrollInterval.value);
        autoScrollInterval.value = null;
    }
};

// Actualizar ancho del contenedor
const updateContainerWidth = () => {
    if (carouselTrack.value && carouselTrack.value.parentElement) {
        containerWidth.value = carouselTrack.value.parentElement.offsetWidth;
    }
};

// Inicialización
onMounted(() => {
    cartStore.loadFromLocalStorage();
    window.addEventListener("scroll", handleScroll);
    window.addEventListener("resize", updateContainerWidth);
    window.addEventListener("resize", updateSlidesPerView);
    updateContainerWidth();
    updateSlidesPerView();
    startAutoScroll();
});

onUnmounted(() => {
    window.removeEventListener("scroll", handleScroll);
    window.removeEventListener("resize", updateContainerWidth);
    window.removeEventListener("resize", updateSlidesPerView);
    stopAutoScroll();
});
</script>

<style>
/* Animaciones */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-fade-in {
    animation: fadeIn 1s ease-out forwards;
}

.delay-100 {
    animation-delay: 100ms;
}

.delay-200 {
    animation-delay: 200ms;
}

/* Efecto Marquee */
.marquee-container {
    width: 100%;
    overflow: hidden;
    white-space: nowrap;
}

.marquee-content {
    display: inline-flex;
    animation: marquee 40s linear infinite;
}

.marquee-item {
    margin-right: 20px;
}

@keyframes marquee {
    0% {
        transform: translateX(0);
    }
    100% {
        transform: translateX(-100%);
    }
}

/* Estilos del encabezado para estado desplazado */
nav {
    background-color: transparent;
}

nav.scrolled {
    background-color: rgba(243, 244, 246, 0.9);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Estilos del carrusel */
.carousel-card {
    height: 600px;
}
</style>
