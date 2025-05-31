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

                    <!-- Menú de Escritorio -->
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

                    <!-- Menú Derecho (Carrito y Usuario) -->
                    <div class="flex items-center space-x-4">
                        <!-- Carrito con Vista Previa al Pasar el Ratón -->
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
                                    aria-hidden="true"
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
                            <!-- Vista Previa del Carrito -->
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

                        <!-- Menú de Usuario -->
                        <template v-if="$page.props.auth.user">
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
                                                aria-hidden="true"
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
                                            v-if="
                                                $page.props.auth.user.is_admin
                                            "
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
                                v-if="$page.props.canRegister"
                                :href="route('register')"
                                class="text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 px-4 py-2 rounded-md hidden md:block"
                                aria-label="Registrarse"
                            >
                                Registrarse
                            </Link>
                        </template>

                        <!-- Botón de Menú Móvil -->
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
                                    aria-hidden="true"
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
                                    aria-hidden="true"
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

                <!-- Contenido del Menú Móvil -->
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
                            position: absolute;
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
                                        aria-hidden="true"
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

                                <template v-if="$page.props.auth.user">
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
                                                v-if="
                                                    $page.props.auth.user
                                                        .is_admin
                                                "
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
                                        v-if="$page.props.canRegister"
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
            </div>
        </nav>

        <!-- Contenido principal -->
        <main>
            <!-- Hero Section - Diseño exclusivo -->
            <div class="relative h-screen overflow-hidden">
                <!-- Video o imagen de fondo con overlay dinámico -->
                <div class="absolute inset-0">
                    <img
                        src="/images/Page-About/Hero.jpg"
                        alt="TrendClothes Atelier"
                        class="w-full h-full object-cover"
                    />
                    <div
                        class="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-transparent"
                    ></div>
                    <div
                        class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-black/20"
                    ></div>
                </div>

                <!-- Contenido del Hero -->
                <div class="relative h-full flex items-center justify-center">
                    <div
                        class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center"
                    >
                        <h1
                            class="text-4xl md:text-6xl font-bold text-white mb-6 animate-fade-in"
                        >
                            TRENDCLOTHES
                        </h1>
                        <p
                            class="text-xl md:text-2xl text-white/90 max-w-2xl mx-auto mb-8 animate-fade-in delay-100"
                        >
                            Donde cada hilo cuenta una historia, cada diseño
                            desafía lo convencional y cada prenda redefine tu
                            identidad.
                        </p>
                        <div
                            class="flex flex-col sm:flex-row gap-6 justify-center animate-fade-in-up delay-600"
                        >
                            <a
                                href="#our-journey"
                                class="px-10 py-4 bg-white text-gray-900 font-bold rounded-full hover:bg-gray-100 transition-all duration-300 transform hover:scale-105 hover:shadow-2xl"
                                aria-label="Descubre nuestra historia"
                            >
                                Descubre Nuestra Historia
                            </a>
                            <a
                                href="#manifesto"
                                class="px-10 py-4 bg-transparent border-2 border-white text-white font-bold rounded-full hover:bg-white hover:text-gray-900 transition-all duration-300 transform hover:scale-105"
                                aria-label="Lee nuestro manifiesto"
                            >
                                Nuestro Manifiesto
                            </a>
                        </div>
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
            <!-- Manifesto Section -->
            <section
                id="manifesto"
                class="py-24 bg-black text-white relative overflow-hidden"
            >
                <div class="absolute inset-0 opacity-10">
                    <div
                        class="absolute top-20 left-20 w-64 h-64 bg-indigo-500 rounded-full blur-3xl"
                    ></div>
                    <div
                        class="absolute bottom-20 right-20 w-96 h-96 bg-purple-500 rounded-full blur-3xl"
                    ></div>
                </div>

                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative">
                    <div class="text-center mb-20">
                        <h2
                            class="text-4xl md:text-6xl font-black mb-8 animate-fade-in-up"
                        >
                            NUESTRO
                            <span class="gradient-text-hero">MANIFIESTO</span>
                        </h2>
                        <div
                            class="w-24 h-1 bg-gradient-to-r from-indigo-500 to-purple-500 mx-auto mb-12 animate-scale-in delay-300"
                        ></div>
                    </div>

                    <div class="grid lg:grid-cols-2 gap-16 items-center">
                        <div class="space-y-8 animate-fade-in-left delay-400">
                            <div
                                class="text-lg md:text-xl leading-relaxed space-y-6"
                            >
                                <p class="text-gray-300">
                                    <span class="text-2xl font-bold text-white"
                                        >"</span
                                    >
                                    La moda no es solo lo que llevas puesto. Es
                                    una declaración, una revolución silenciosa,
                                    una forma de arte que camina por las calles.
                                    <span class="text-2xl font-bold text-white"
                                        >"</span
                                    >
                                </p>
                                <p class="text-gray-300">
                                    En TrendClothes creemos que cada persona
                                    merece vestir piezas que no solo luzcan
                                    extraordinarias, sino que cuenten su
                                    historia única. No seguimos tendencias, las
                                    creamos. No copiamos estilos, los
                                    reimaginamos.
                                </p>
                                <p class="text-gray-300">
                                    Nuestro compromiso va más allá de la
                                    estética: es un compromiso con la calidad,
                                    la sostenibilidad y la innovación que
                                    respeta tanto a quien lo lleva como al
                                    planeta que habitamos.
                                </p>
                            </div>

                            <div class="flex space-x-4 pt-8">
                                <div class="text-center">
                                    <div
                                        class="text-3xl font-black text-indigo-400"
                                    >
                                        5+
                                    </div>
                                    <div
                                        class="text-sm text-gray-400 uppercase tracking-wide"
                                    >
                                        Años Innovando
                                    </div>
                                </div>
                                <div class="w-px bg-gray-700"></div>
                                <div class="text-center">
                                    <div
                                        class="text-3xl font-black text-purple-400"
                                    >
                                        15K+
                                    </div>
                                    <div
                                        class="text-sm text-gray-400 uppercase tracking-wide"
                                    >
                                        Clientes Únicos
                                    </div>
                                </div>
                                <div class="w-px bg-gray-700"></div>
                                <div class="text-center">
                                    <div
                                        class="text-3xl font-black text-pink-400"
                                    >
                                        ∞
                                    </div>
                                    <div
                                        class="text-sm text-gray-400 uppercase tracking-wide"
                                    >
                                        Posibilidades
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="relative animate-fade-in-right delay-600">
                            <div
                                class="aspect-square rounded-3xl overflow-hidden relative group"
                            >
                                <img
                                    src="/images/Page-About/manifiesto.jpeg"
                                    alt="TrendClothes Philosophy"
                                    class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700"
                                />
                                <div
                                    class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent group-hover:from-black/70 transition-all duration-700"
                                ></div>
                                <div class="absolute bottom-8 left-8 right-8">
                                    <p class="text-white font-bold text-lg">
                                        Cada pieza, una obra de arte
                                    </p>
                                </div>
                            </div>
                            <div
                                class="absolute -top-6 -right-6 w-24 h-24 bg-gradient-to-r from-indigo-500 to-purple-500 rounded-full animate-pulse-glow"
                            ></div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Journey Section -->
            <section id="our-journey" class="py-24 bg-white relative">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="text-center mb-20">
                        <span
                            class="text-sm font-bold tracking-widest text-indigo-600 uppercase animate-fade-in-up"
                            >Nuestra Historia</span
                        >
                        <h2
                            class="text-4xl md:text-5xl font-black text-gray-900 mt-4 mb-8 animate-fade-in-up delay-200"
                        >
                            Más que ropa,
                            <span class="gradient-text">una revolución</span>
                        </h2>
                        <p
                            class="text-xl text-gray-600 max-w-3xl mx-auto animate-fade-in-up delay-400"
                        >
                            TrendClothes nace con la misión de transformar la
                            forma en que entendemos y vivimos la moda.
                        </p>
                    </div>

                    <!-- Timeline -->
                    <div class="relative">
                        <div
                            class="absolute left-1/2 transform -translate-x-1/2 w-1 h-full bg-gradient-to-b from-indigo-500 to-purple-500"
                        ></div>

                        <div class="space-y-24">
                            <!-- 2020 -->
                            <div
                                class="relative flex items-center animate-fade-in-left delay-500"
                            >
                                <div class="flex-1 pr-8 text-right">
                                    <div
                                        class="bg-white p-8 rounded-2xl shadow-xl border-l-4 border-indigo-500"
                                    >
                                        <h3
                                            class="text-2xl font-bold text-gray-900 mb-4"
                                        >
                                            2020 – La Idea
                                        </h3>
                                        <p class="text-gray-600 mb-4">
                                            En plena pandemia, tres jóvenes
                                            diseñadores decidieron apostar por
                                            una moda que combinara estilo,
                                            conciencia y cercanía digital.
                                        </p>
                                        <div
                                            class="text-sm text-indigo-600 font-semibold"
                                        >
                                            Proyecto incubado en casa | 100%
                                            digital desde el día uno
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="absolute left-1/2 transform -translate-x-1/2 w-6 h-6 bg-indigo-500 rounded-full border-4 border-white shadow-lg"
                                ></div>
                                <div class="flex-1 pl-8">
                                    <img
                                        src="/images/Page-About/Hero5.jpeg"
                                        alt="Fundación TrendClothes"
                                        class="rounded-2xl shadow-xl object-cover w-[576px] h-[384px]"
                                    />
                                </div>
                            </div>

                            <!-- 2022 -->
                            <div
                                class="relative flex items-center animate-fade-in-right delay-600"
                            >
                                <div class="flex-1 pr-8">
                                    <img
                                        src="/images/Page-About/tienda.jpeg"
                                        alt="Lanzamiento tienda TrendClothes"
                                        class="rounded-2xl shadow-xl object-cover w-[576px] h-[384px]"
                                    />
                                </div>
                                <div
                                    class="absolute left-1/2 transform -translate-x-1/2 w-6 h-6 bg-purple-500 rounded-full border-4 border-white shadow-lg"
                                ></div>
                                <div class="flex-1 pl-8">
                                    <div
                                        class="bg-white p-8 rounded-2xl shadow-xl border-l-4 border-purple-500"
                                    >
                                        <h3
                                            class="text-2xl font-bold text-gray-900 mb-4"
                                        >
                                            2022 – Primer salto
                                        </h3>
                                        <p class="text-gray-600 mb-4">
                                            Abrimos nuestra tienda online, con
                                            envíos en 24h y una experiencia de
                                            usuario centrada en el detalle. La
                                            comunidad crece y se consolida.
                                        </p>
                                        <div
                                            class="text-sm text-purple-600 font-semibold"
                                        >
                                            +3.000 pedidos en 6 meses | 200
                                            productos únicos
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 2024 -->
                            <div
                                class="relative flex items-center animate-fade-in-left delay-700"
                            >
                                <div class="flex-1 pr-8 text-right">
                                    <div
                                        class="bg-white p-8 rounded-2xl shadow-xl border-l-4 border-green-500"
                                    >
                                        <h3
                                            class="text-2xl font-bold text-gray-900 mb-4"
                                        >
                                            2024 – Moda consciente
                                        </h3>
                                        <p class="text-gray-600 mb-4">
                                            Lanzamos colecciones eco con algodón
                                            orgánico y poliéster reciclado.
                                            Colaboramos con artistas locales
                                            para impulsar el talento emergente.
                                        </p>
                                        <div
                                            class="text-sm text-green-800 font-semibold"
                                        >
                                            +12.000 prendas sostenibles vendidas
                                        </div>
                                    </div>
                                </div>
                                <div
                                    class="absolute left-1/2 transform -translate-x-1/2 w-6 h-6 bg-green-500 rounded-full border-4 border-white shadow-lg"
                                ></div>
                                <div class="flex-1 pl-8">
                                    <img
                                        src="/images/Page-About/Artista.jpeg"
                                        alt="Colección sostenible TrendClothes"
                                        class="rounded-2xl shadow-xl object-cover w-[576px] h-[384px]"
                                    />
                                </div>
                            </div>

                            <!-- 2025 -->
                            <div
                                class="relative flex items-center animate-fade-in-right delay-800"
                            >
                                <div class="flex-1 pr-8">
                                    <img
                                        src="/images/Page-About/Comunidad.jpg"
                                        alt="Tienda física TrendClothes"
                                        class="rounded-2xl shadow-xl object-cover w-[576px] h-[384px]"
                                    />
                                </div>
                                <div
                                    class="absolute left-1/2 transform -translate-x-1/2 w-6 h-6 bg-indigo-500 rounded-full border-4 border-white shadow-lg"
                                ></div>
                                <div class="flex-1 pl-8">
                                    <div
                                        class="bg-white p-8 rounded-2xl shadow-xl border-l-4 border-indigo-500"
                                    >
                                        <h3
                                            class="text-2xl font-bold text-gray-900 mb-4"
                                        >
                                            2025 – Comunidad global
                                        </h3>
                                        <p class="text-gray-600 mb-4">
                                            Presentamos nuestra primera flagship
                                            store en Barcelona y la app oficial
                                            de TrendClothes. Más cerca de
                                            nuestra comunidad, más allá de
                                            fronteras.
                                        </p>
                                        <div
                                            class="text-sm text-indigo-600 font-semibold"
                                        >
                                            +18.000 clientes | 12 países | 1
                                            visión: vestir con propósito
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Values Section -->
            <section class="py-24 bg-gray-50">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="text-center mb-20" id="compromiso">
                        <span
                            class="text-sm font-bold tracking-widest text-indigo-600 uppercase animate-fade-in-up"
                            >Nuestros Valores</span
                        >
                        <h2
                            class="text-4xl md:text-5xl font-black text-gray-900 mt-4 mb-8 animate-fade-in-up delay-200"
                        >
                            Lo que nos
                            <span class="gradient-text">Impulsa</span>
                        </h2>
                    </div>

                    <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
                        <!-- Innovación -->
                        <div
                            class="bg-white p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 animate-fade-in-up delay-300"
                        >
                            <div
                                class="w-16 h-16 bg-gradient-to-r from-indigo-500 to-purple-500 rounded-2xl flex items-center justify-center mb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M13 10V3L4 14h7v7l9-11h-7z"
                                    ></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                Innovación
                            </h3>
                            <p class="text-gray-600 leading-relaxed">
                                Constantemente exploramos nuevas fronteras en
                                diseño, materiales y tecnología para ofrecer
                                experiencias únicas y revolucionarias.
                            </p>
                        </div>

                        <!-- Sostenibilidad -->
                        <div
                            class="bg-white p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 animate-fade-in-up delay-400"
                        >
                            <div
                                class="w-16 h-16 bg-gradient-to-r from-green-500 to-emerald-500 rounded-2xl flex items-center justify-center mb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"
                                    ></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                Sostenibilidad
                            </h3>
                            <p class="text-gray-600 leading-relaxed">
                                Nuestro compromiso con el planeta es
                                inquebrantable. Cada decisión que tomamos
                                considera su impacto ambiental y social.
                            </p>
                        </div>

                        <!-- Autenticidad -->
                        <div
                            class="bg-white p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 animate-fade-in-up delay-500"
                        >
                            <div
                                class="w-16 h-16 bg-gradient-to-r from-yellow-500 to-orange-500 rounded-2xl flex items-center justify-center mb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M11.049 2.927c.3-.921 1.603-.921 1.902 0l1.519 4.674a1 1 0 00.95.69h4.915c.969 0 1.371 1.24.588 1.81l-3.976 2.888a1 1 0 00-.363 1.118l1.518 4.674c.3.922-.755 1.688-1.538 1.118l-3.976-2.888a1 1 0 00-1.176 0l-3.976 2.888c-.783.57-1.838-.197-1.538-1.118l1.518-4.674a1 1 0 00-.363-1.118l-3.976-2.888c-.784-.57-.38-1.81.588-1.81h4.914a1 1 0 00.951-.69l1.519-4.674z"
                                    ></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                Autenticidad
                            </h3>
                            <p class="text-gray-600 leading-relaxed">
                                Celebramos la individualidad y creamos piezas
                                que permiten a cada persona expresar su
                                verdadera esencia sin compromisos.
                            </p>
                        </div>

                        <!-- Calidad -->
                        <div
                            class="bg-white p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 animate-fade-in-up delay-600"
                        >
                            <div
                                class="w-16 h-16 bg-gradient-to-r from-rose-500 to-pink-500 rounded-2xl flex items-center justify-center mb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                                    ></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                Calidad
                            </h3>
                            <p class="text-gray-600 leading-relaxed">
                                Cada hilo, cada costura, cada detalle es
                                cuidadosamente elaborado para crear piezas que
                                trascienden el tiempo y las tendencias.
                            </p>
                        </div>

                        <!-- Comunidad -->
                        <div
                            class="bg-white p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 animate-fade-in-up delay-700"
                        >
                            <div
                                class="w-16 h-16 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-2xl flex items-center justify-center mb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                                    ></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                Comunidad
                            </h3>
                            <p class="text-gray-600 leading-relaxed">
                                Construimos más que productos, construimos
                                conexiones. Nuestra comunidad es el corazón de
                                todo lo que hacemos.
                            </p>
                        </div>

                        <!-- Creatividad -->
                        <div
                            class="bg-white p-8 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2 animate-fade-in-up delay-800"
                        >
                            <div
                                class="w-16 h-16 bg-gradient-to-r from-purple-500 to-violet-500 rounded-2xl flex items-center justify-center mb-6"
                            >
                                <svg
                                    class="w-8 h-8 text-white"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zM21 5a2 2 0 00-2-2h-4a2 2 0 00-2 2v12a4 4 0 004 4h4a2 2 0 002-2V5z"
                                    ></path>
                                </svg>
                            </div>
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                Creatividad
                            </h3>
                            <p class="text-gray-600 leading-relaxed">
                                La creatividad sin límites es nuestro motor.
                                Cada colección es una nueva oportunidad de
                                sorprender y emocionar.
                            </p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Call to Action -->
            <section class="py-24 relative overflow-hidden">
                <div class="absolute inset-0">
                    <img
                        src="/images/Page-About/Revolucion.webp"
                        alt="Comunidad Background"
                        class="w-full h-full object-cover"
                    />
                    <div class="absolute inset-0 bg-black/40"></div>
                </div>
                <div class="absolute inset-0">
                    <div
                        class="absolute top-10 left-10 w-72 h-72 bg-white/10 rounded-full blur-3xl animate-pulse"
                    ></div>
                    <div
                        class="absolute bottom-10 right-10 w-96 h-96 bg-white/5 rounded-full blur-3xl animate-pulse delay-1000"
                    ></div>
                </div>

                <div
                    class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center relative"
                >
                    <h2
                        class="text-4xl md:text-6xl font-black text-white mb-8 animate-fade-in-up"
                    >
                        ¿Listo para ser parte de la
                        <span class="text-yellow-300">Revolución</span>?
                    </h2>
                    <p
                        class="text-xl md:text-2xl text-gray-200 max-w-4xl mx-auto mb-12 animate-fade-in-up delay-200"
                    >
                        Únete a miles de personas que ya han descubierto que la
                        moda puede ser mucho más que ropa. Es identidad, es
                        arte, es revolución.
                    </p>

                    <div
                        class="flex flex-col sm:flex-row gap-6 justify-center animate-fade-in-up delay-400"
                    >
                        <Link
                            :href="route('categories.index')"
                            class="px-10 py-4 bg-white text-gray-900 font-bold rounded-full hover:bg-gray-100 transition-all duration-300 transform hover:scale-105 hover:shadow-2xl"
                            aria-label="Explorar colecciones"
                        >
                            Explorar Colecciones
                        </Link>
                        <Link
                            :href="route('home')"
                            class="px-10 py-4 bg-transparent border-2 border-white text-white font-bold rounded-full hover:bg-white hover:text-gray-900 transition-all duration-300 transform hover:scale-105"
                            aria-label="Volver al inicio"
                        >
                            Volver al Inicio
                        </Link>
                    </div>

                    <!-- Social Proof -->
                    <div
                        class="mt-16 flex flex-wrap justify-center items-center gap-8 text-white/80 animate-fade-in-up delay-600"
                    >
                        <div class="text-center">
                            <div class="text-3xl font-black">15K+</div>
                            <div class="text-sm uppercase tracking-wide">
                                Clientes Felices
                            </div>
                        </div>
                        <div
                            class="hidden sm:block w-px h-12 bg-white/30"
                        ></div>
                        <div class="text-center">
                            <div class="text-3xl font-black">50+</div>
                            <div class="text-sm uppercase tracking-wide">
                                Diseños Únicos
                            </div>
                        </div>
                        <div
                            class="hidden sm:block w-px h-12 bg-white/30"
                        ></div>
                        <div class="text-center">
                            <div class="text-3xl font-black">5+</div>
                            <div class="text-sm uppercase tracking-wide">
                                Años Innovando
                            </div>
                        </div>
                        <div
                            class="hidden sm:block w-px h-12 bg-white/30"
                        ></div>
                        <div class="text-center">
                            <div class="text-3xl font-black">100%</div>
                            <div class="text-sm uppercase tracking-wide">
                                Pasión
                            </div>
                        </div>
                    </div>
                </div>
            </section>
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
import { computed, ref, onMounted, onUnmounted } from "vue";

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

// Inicialización
onMounted(() => {
    cartStore.loadFromLocalStorage();
    window.addEventListener("scroll", handleScroll);
});

onUnmounted(() => {
    window.removeEventListener("scroll", handleScroll);
});
</script>

<style>
/* Animaciones */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes scaleIn {
    from {
        transform: scale(0);
        opacity: 0;
    }
    to {
        transform: scale(1);
        opacity: 1;
    }
}

@keyframes pulseGlow {
    0%,
    100% {
        transform: scale(1);
        opacity: 0.5;
    }
    50% {
        transform: scale(1.2);
        opacity: 1;
    }
}

.animate-fade-in-up {
    animation: fadeInUp 1s ease-out forwards;
}

.animate-scale-in {
    animation: scaleIn 0.8s ease-out forwards;
}

.animate-pulse-glow {
    animation: pulseGlow 2s infinite;
}

.animate-bounce {
    animation: bounce 2s infinite;
}

@keyframes bounce {
    0%,
    100% {
        transform: translateY(0);
    }
    50% {
        transform: translateY(-10px);
    }
}

/* Gradient Text */
.gradient-text-hero {
    background: linear-gradient(90deg, #4f46e5, #9333ea);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
}

.gradient-text {
    background: linear-gradient(90deg, #4f46e5, #10b981);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
}

/* Estilos del encabezado para estado desplazado */
nav {
    background-color: transparent;
}

nav.scrolled {
    background-color: rgba(243, 244, 246, 0.9);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Responsive Adjustments */
@media (max-width: 640px) {
    .hero h1 {
        font-size: 3.5rem;
    }
    .hero p {
        font-size: 1rem;
    }
    .hero a {
        width: 100%;
        text-align: center;
    }
    .manifesto h2 {
        font-size: 2.5rem;
    }
    .journey .flex {
        flex-direction: column;
        text-align: center;
    }
    .journey img {
        margin-top: 1rem;
    }
    .team .md:grid-cols-3 {
        grid-template-columns: 1fr;
    }
}
</style>
