<template>
    <div class="min-h-screen bg-gray-200">
        <!-- Flash Message -->
        <div
            v-if="page.props.flash.success"
            class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-700 p-4 fixed top-0 w-full z-50"
            role="alert"
        >
            <div class="max-w-7xl mx-auto flex justify-between items-center">
                <p>{{ page.props.flash.success }}</p>
                <button
                    @click="page.props.flash.success = null"
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
        <main class="bg-white">
            <!-- Carousel -->
            <div class="relative h-screen overflow-hidden">
                <div
                    class="flex transition-transform duration-500 h-full"
                    :style="{
                        transform: `translateX(-${currentSlide * 100}%)`,
                    }"
                >
                    <div
                        v-for="(slide, index) in slides"
                        :key="index"
                        class="min-w-full h-full flex items-center justify-center relative"
                    >
                        <div class="absolute inset-0">
                            <picture>
                                <source
                                    :media="'(max-width: 767px)'"
                                    :srcset="slide.mobileImage"
                                />
                                <source
                                    :media="'(min-width: 768px)'"
                                    :srcset="slide.image"
                                />
                                <img
                                    :src="slide.image"
                                    :alt="slide.alt"
                                    class="w-full h-full object-cover"
                                />
                            </picture>
                            <div class="absolute inset-0 bg-black/40"></div>
                        </div>
                        <div
                            class="absolute text-center text-white px-4 hidden md:block"
                            style="
                                top: 50%;
                                left: 50%;
                                transform: translate(-50%, -50%);
                            "
                        >
                            <h1
                                v-if="index === 0"
                                class="text-4xl md:text-6xl font-bold text-white mb-6 animate-fade-in"
                            >
                                {{ slide.title }}
                            </h1>
                            <span
                                v-else
                                class="text-4xl md:text-6xl font-bold text-white mb-6 animate-fade-in"
                            >
                                {{ slide.title }}
                            </span>
                            <p
                                class="text-xl md:text-2xl text-white/90 max-w-2xl mx-auto mb-8 animate-fade-in delay-100"
                            >
                                {{ slide.description }}
                            </p>
                            <Link
                                :href="slide.link"
                                class="mt-4 inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 text-sm md:text-base"
                            >
                                {{ slide.cta }}
                            </Link>
                        </div>
                    </div>
                </div>
                <button
                    @click="prevSlide"
                    class="absolute top-1/2 left-4 transform -translate-y-1/2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100"
                    aria-label="Diapositiva anterior"
                >
                    <svg
                        class="h-5 w-5"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M15 19l-7-7 7-7"
                        />
                    </svg>
                </button>
                <button
                    @click="nextSlide"
                    class="absolute top-1/2 right-4 transform -translate-y-1/2 bg-white p-2 rounded-full shadow-md hover:bg-gray-100"
                    aria-label="Siguiente diapositiva"
                >
                    <svg
                        class="h-5 w-5"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M9 5l7 7-7 7"
                        />
                    </svg>
                </button>
            </div>

            <!-- Control deslizante de mensajes -->
            <div class="bg-indigo-600 text-white h-11">
                <div class="w-full overflow-hidden">
                    <div
                        class="flex transition-transform duration-500"
                        :style="{
                            transform: `translateX(-${currentMessage * 100}%)`,
                        }"
                    >
                        <div
                            v-for="(message, index) in messages"
                            :key="index"
                            class="min-w-full flex items-center justify-center h-11"
                        >
                            <p class="text-base font-semibold">
                                {{ message.text }}
                            </p>
                            <Link
                                v-if="message.link"
                                :href="message.link"
                                class="ml-4 text-sm text-white border border-white rounded-md px-2 py-1 hover:bg-indigo-700"
                            >
                                {{ message.cta }}
                            </Link>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección de Categorías -->
            <div class="w-full px-4 sm:px-6 lg:px-8 py-12">
                <div class="relative text-center">
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
                            EXPLORA
                        </h2>
                    </div>

                    <h3
                        class="text-6xl font-black text-black mb-6 leading-tight"
                    >
                        <span>Por </span>
                        <span
                            class="bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 bg-clip-text text-transparent"
                        >
                            categorias
                        </span>
                    </h3>

                    <p
                        class="mt-3 max-w-2xl mx-auto text-xl text-gray-500 sm:mt-4 text-center mb-10"
                    >
                        Descubre la moda que se adapta a tu estilo de vida
                    </p>
                    <div
                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"
                    >
                        <div
                            v-for="category in categories"
                            :key="category.id"
                            class="relative w-full h-[700px] bg-cover bg-center rounded-lg shadow-md overflow-hidden hover:shadow-lg group"
                            :style="{
                                backgroundImage: `url(${
                                    category.image ||
                                    'https://via.placeholder.com/500x700'
                                })`,
                            }"
                        >
                            <Link
                                :href="`/categories/${category.name.toLowerCase()}`"
                                class="absolute inset-0 flex flex-col items-center justify-end bg-black bg-opacity-0 group-hover:bg-opacity-30 transition duration-300 pb-12"
                            >
                                <!-- Título de la categoría -->
                                <span
                                    class="spot_cta_title text-white text-center mb-4"
                                    style="
                                        font-size: 50px;
                                        font-weight: normal;
                                        font-stretch: normal;
                                        font-style: normal;
                                        line-height: 0.79;
                                        text-align: center;
                                        color: #fff !important;
                                        margin: 0;
                                        padding: 0;
                                        margin-bottom: 20px;
                                        letter-spacing: 0px;
                                        font-family: 'Gotham Ultra';
                                        text-shadow: 1px 1px 2px #000000;
                                        text-decoration: none;
                                        display: block;
                                        text-align: center;
                                        padding: 1rem;
                                        font-weight: 900;
                                        text-transform: uppercase;
                                    "
                                >
                                    {{ category.name }}
                                </span>

                                <!-- Category Button -->
                                <span
                                    class="spot_cta"
                                    style="
                                        border-color: #fff;
                                        cursor: pointer;
                                        color: #000;
                                        background: #fff;
                                        width: calc(100% - 40px);
                                        padding: 6% 10%;
                                        margin: 0 20px;
                                        border-color: #000;
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        font-size: 16px;
                                        white-space: nowrap;
                                        font-weight: 700;
                                        max-height: 15px;
                                        transition: background-color 0.5s,
                                            color 0.5s;
                                        font-family: Gotham SSm A, Gotham SSm B,
                                            Arial, sans-serif;
                                    "
                                >
                                    Ver categoría
                                </span>
                            </Link>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección de destacados de la temporada -->
            <div class="relative overflow-hidden py-24 mb-12">
                <!-- Elementos de fondo animados -->
                <div class="absolute inset-0">
                    <div
                        class="absolute bottom-1/4 left-1/2 w-96 h-96 bg-white-500 rounded-full mix-blend-multiply filter blur-xl opacity-20 animate-pulse delay-500"
                    ></div>
                </div>

                <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <!-- Encabezado principal -->
                    <div class="text-center mb-20">
                        <div
                            class="inline-flex items-center px-6 py-3 bg-gradient-to-r from-indigo-600/20 to-emerald-500/20 backdrop-blur-lg rounded-full border border-white/10 mb-6"
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
                                TEMPORADA OTOÑO 2025
                            </h2>
                        </div>

                        <h3
                            class="text-6xl font-black text-black mb-6 leading-tight"
                        >
                            <span class="block">DEFINE TU</span>
                            <span
                                class="bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 bg-clip-text text-transparent"
                            >
                                ESTILO
                            </span>
                        </h3>

                        <p
                            class="text-xl text-gray-500 max-w-3xl mx-auto leading-relaxed"
                        >
                            Descubre las piezas más exclusivas de la temporada.
                            Cada prenda cuenta una historia, cada look marca una
                            diferencia.
                        </p>
                    </div>

                    <!-- Cuadrícula de contenido destacado -->
                    <div
                        class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center mb-20"
                    >
                        <!-- Lado izquierdo - Producto Hero -->
                        <div class="relative group">
                            <div
                                class="absolute -inset-4 bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 rounded-3xl blur-lg opacity-20 group-hover:opacity-40 transition-opacity duration-500"
                            ></div>
                            <div
                                class="relative bg-white/10 backdrop-blur-xl rounded-3xl p-8 border border-white/30"
                            >
                                <div class="absolute top-6 right-6 z-10">
                                    <span
                                        class="px-4 py-2 bg-gradient-to-r from-emerald-500 to-indigo-600 text-white text-xs font-bold rounded-full animate-pulse"
                                    >
                                        TRENDING #1
                                    </span>
                                </div>

                                <div
                                    class="aspect-square rounded-2xl overflow-hidden mb-6 bg-gradient-to-br from-gray-200 to-gray-300"
                                >
                                    <img
                                        :src="featuredProduct.image"
                                        :alt="featuredProduct.name"
                                        class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700"
                                    />
                                </div>

                                <div class="text-center">
                                    <span
                                        class="text-2xl font-bold text-black mb-2"
                                        >{{ featuredProduct.name }}</span
                                    >
                                    <p class="text-gray-500 mb-4">
                                        {{ featuredProduct.description }}
                                    </p>
                                    <div
                                        class="flex items-center justify-center space-x-3 mb-6"
                                    >
                                        <span
                                            class="text-lg text-gray-500 line-through"
                                            >{{
                                                formatPrice(
                                                    featuredProduct.originalPrice
                                                )
                                            }}</span
                                        >
                                        <span
                                            class="text-3xl font-black text-indigo-300"
                                            >{{
                                                formatPrice(
                                                    featuredProduct.discountedPrice
                                                )
                                            }}</span
                                        >
                                        <span
                                            class="px-2 py-1 bg-emerald-500 text-white text-xs font-bold rounded"
                                        >
                                            -{{
                                                Math.round(
                                                    (1 -
                                                        featuredProduct.discountedPrice /
                                                            featuredProduct.originalPrice) *
                                                        100
                                                )
                                            }}%
                                        </span>
                                    </div>
                                    <Link
                                        :href="
                                            route(
                                                'products.show',
                                                featuredProduct.slug
                                            )
                                        "
                                        class="w-full bg-gradient-to-r from-indigo-600 to-indigo-700 text-white font-bold py-4 px-6 rounded-xl hover:from-indigo-500 hover:to-indigo-600 transform hover:scale-105 transition-all duration-300 shadow-xl"
                                    >
                                        CONSEGUIR AHORA
                                    </Link>
                                </div>
                            </div>
                        </div>

                        <!-- Lado derecho - Cuadrícula de características -->
                        <div class="space-y-8">
                            <!-- Característica 1 -->
                            <div
                                class="flex items-center space-x-6 group cursor-pointer"
                            >
                                <div
                                    class="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-indigo-600 to-indigo-700 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300"
                                >
                                    <svg
                                        class="w-10 h-10 text-white"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M13 10V3L4 14h7v7l9-11h-7z"
                                        />
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <span
                                        class="text-xl font-bold text-black mb-2"
                                        >Envío Express Gratis</span
                                    >
                                    <p class="text-gray-500">
                                        Recibe tu pedido en 24h sin coste
                                        adicional
                                    </p>
                                </div>
                                <div
                                    class="opacity-0 group-hover:opacity-100 transition-opacity"
                                >
                                    <svg
                                        class="w-6 h-6 text-indigo-300"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M9 5l7 7-7 7"
                                        />
                                    </svg>
                                </div>
                            </div>

                            <!-- Característica 2 -->
                            <div
                                class="flex items-center space-x-6 group cursor-pointer"
                            >
                                <div
                                    class="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-emerald-500 to-indigo-600 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300"
                                >
                                    <svg
                                        class="w-10 h-10 text-white"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                                        />
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <span
                                        class="text-xl font-bold text-black mb-2"
                                        >Garantía Total</span
                                    >
                                    <p class="text-gray-500">
                                        30 días para cambios y devoluciones
                                    </p>
                                </div>
                                <div
                                    class="opacity-0 group-hover:opacity-100 transition-opacity"
                                >
                                    <svg
                                        class="w-6 h-6 text-emerald-500"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M9 5l7 7-7 7"
                                        />
                                    </svg>
                                </div>
                            </div>

                            <!-- Característica 3 -->
                            <div
                                class="flex items-center space-x-6 group cursor-pointer"
                            >
                                <div
                                    class="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-gray-400 to-indigo-500 rounded-2xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300"
                                >
                                    <svg
                                        class="w-10 h-10 text-white"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"
                                        />
                                    </svg>
                                </div>
                                <div class="flex-1">
                                    <span
                                        class="text-xl font-bold text-black mb-2"
                                        >Precio Justo</span
                                    >
                                    <p class="text-gray-500">
                                        La mejor calidad al precio más
                                        competitivo
                                    </p>
                                </div>
                                <div
                                    class="opacity-0 group-hover:opacity-100 transition-opacity"
                                >
                                    <svg
                                        class="w-6 h-6 text-gray-400"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M9 5l7 7-7 7"
                                        />
                                    </svg>
                                </div>
                            </div>

                            <!-- Botón de acción -->
                            <div class="pt-8">
                                <Link
                                    :href="
                                        route('categories.show', {
                                            category: 'sudaderas',
                                        })
                                    "
                                    class="inline-flex items-center px-8 py-4 bg-gradient-to-r from-indigo-600 to-indigo-700 text-white font-bold rounded-xl hover:from-indigo-500 hover:to-indigo-600 transform hover:scale-105 transition-all duration-300 shadow-2xl hover:shadow-indigo-600/25"
                                >
                                    <span>EXPLORAR COLECCIÓN</span>
                                    <svg
                                        class="ml-3 w-5 h-5"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M17 8l4 4m0 0l-4 4m4-4H3"
                                        />
                                    </svg>
                                </Link>
                            </div>
                        </div>
                    </div>

                    <!-- Estadísticas inferiores -->
                    <div
                        class="grid grid-cols-2 md:grid-cols-4 gap-8 pt-12 border-t border-white/10"
                    >
                        <div class="text-center group cursor-pointer">
                            <div
                                class="text-4xl font-black text-indigo-600 mb-2 group-hover:scale-110 transition-transform"
                            >
                                50K+
                            </div>
                            <div class="text-gray-500 text-sm">
                                Clientes Felices
                            </div>
                        </div>
                        <div class="text-center group cursor-pointer">
                            <div
                                class="text-4xl font-black text-emerald-600 mb-2 group-hover:scale-110 transition-transform"
                            >
                                1K+
                            </div>
                            <div class="text-gray-500 text-sm">
                                Productos Únicos
                            </div>
                        </div>
                        <div class="text-center group cursor-pointer">
                            <div
                                class="text-4xl font-black text-indigo-600 mb-2 group-hover:scale-110 transition-transform"
                            >
                                24/7
                            </div>
                            <div class="text-gray-500 text-sm">
                                Soporte Premium
                            </div>
                        </div>
                        <div class="text-center group cursor-pointer">
                            <div
                                class="text-4xl font-black text-gray-600 mb-2 group-hover:scale-110 transition-transform"
                            >
                                5★
                            </div>
                            <div class="text-gray-500 text-sm">
                                Valoración Media
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Control deslizante de marca -->
            <div class="w-full px-4 sm:px-6 lg:px-8 py-8">
                <div class="relative text-center">
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
                            EXPLORA
                        </h2>
                    </div>

                    <h3
                        class="text-6xl font-black text-black mb-10 leading-tight"
                    >
                        <span>Nuestras </span>
                        <span
                            class="bg-gradient-to-r from-indigo-600 via-emerald-500 to-indigo-300 bg-clip-text text-transparent"
                        >
                            marcas
                        </span>
                    </h3>

                    <div class="w-full overflow-hidden relative">
                        <div class="flex items-center justify-center">
                            <div
                                v-for="(brand, index) in visibleBrands"
                                :key="index"
                                class="flex-shrink-0 w-[150px] flex items-center justify-center px-4"
                            >
                                <a
                                    :target="brand.target"
                                    :href="brand.href"
                                    aria-label="Visitar tienda de {{ brand.name }}"
                                >
                                    <img
                                        :alt="brand.name"
                                        :title="brand.name"
                                        loading="lazy"
                                        width="77"
                                        height="50"
                                        decoding="async"
                                        class="hover:opacity-70"
                                        :src="brand.src"
                                    />
                                </a>
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
import { ref, computed, onMounted, onUnmounted } from "vue";
import { ShoppingCart } from "@element-plus/icons-vue";
import { Inertia } from "@inertiajs/inertia";

// Acceda a las propiedades de la página usando usePage()
const page = usePage();

// Definir propiedades para el producto destacado
defineProps({
    featuredProduct: {
        type: Object,
        default: () => ({
            name: "Adidas Originals Sudadera Island Club Crew",
            slug: "adidas-originals-sudadera-island-club-crew",
            image: "/images/Page-Home/DefineEstilo.webp",
            description: "Estilo urbano y comodidad premium",
            originalPrice: 79.99,
            discountedPrice: 59.99,
        }),
    },
});

// Configuración de la tienda del carrito
const cartStore = useCartStore();
const cartCount = computed(() => cartStore.count || 0);
const cartItems = computed(() => cartStore.items || []);

const mobileMenuOpen = ref(false);
const subMenuOpen = ref(false);

const formatPrice = (price) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(price || 0);
};

// Estado de desplazamiento
const isScrolled = ref(false);
const handleScroll = () => {
    isScrolled.value = window.scrollY > 50;
};

// Carrusel
const slides = ref([
    {
        image: "/images/Page-Home/Slide1.webp",
        mobileImage: "/images/Page-Home/Slide-Mobile-1.webp",
        alt: "Nueva Colección Otoño",
        title: "Nueva Colección Otoño",
        description: "Moda que inspira, diseños que perduran",
        link: route("categories.index") + "#categories",
        cta: "Comprar Ahora",
    },
    {
        image: "/images/Page-Home/Slide2.webp",
        mobileImage: "/images/Page-Home/Slide-Mobile-2.webp",
        alt: "Ofertas Exclusivas",
        title: "Ofertas Exclusivas",
        description: "Hasta 50% de descuento",
        link: route("categories.index"),
        cta: "Ver Ofertas",
    },
    {
        image: "/images/Page-Home/Slide3.webp",
        mobileImage: "/images/Page-Home/Slide-Mobile-3.webp",
        alt: "Moda Sostenible",
        title: "Moda Sostenible",
        description: "Estilo con conciencia ecológica",
        link: route("categories.index"),
        cta: "Descubrir Ahora",
    },
]);

const currentSlide = ref(0);
const nextSlide = () => {
    currentSlide.value = (currentSlide.value + 1) % slides.value.length;
};
const prevSlide = () => {
    currentSlide.value =
        (currentSlide.value - 1 + slides.value.length) % slides.value.length;
};

// Funcionalidad de deslizamiento automático
let slideInterval = null;
const startSlideShow = () => {
    slideInterval = setInterval(() => {
        nextSlide();
    }, 5000);
};
const stopSlideShow = () => {
    clearInterval(slideInterval);
};

// control deslizante de mensajes
const messages = [
    { text: "RECOGIDA EN TIENDA EL MISMO DÍA", link: null, cta: null },
    {
        text: "HAZ TU PEDIDO ANTES DE LAS 14H",
        link: route("cart.index"),
        cta: "Pedir Ahora",
    },
    {
        text: "TEMPORADA DE CHAQUETAS FINAS",
        link: route("categories.index") + "#categories",
        cta: "COMPRAR AHORA",
    },
    {
        text: "CAMISETAS THE NORTH FACE",
        link: route("categories.index") + "#categories",
        cta: "COMIENZA TU AVENTURA",
    },
];
const currentMessage = ref(0);
let messageInterval = null;
const startMessageSlider = () => {
    messageInterval = setInterval(() => {
        currentMessage.value = (currentMessage.value + 1) % messages.length;
    }, 5000);
};

// Control deslizante de marca
const brands = [
    {
        name: "Nike",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/nike.svg?w=1440&q=75",
    },
    {
        name: "adidas",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/adidas.svg?w=1440&q=75",
    },
    {
        name: "Puma",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/puma.svg?w=1440&q=75",
    },
    {
        name: "Fila",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/fila.svg?w=1440&q=75",
    },
    {
        name: "Under Armour",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/under-armour.svg?w=1440&q=75",
    },
    {
        name: "The North Face",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/tnf.svg?w=1440&q=75",
    },
    {
        name: "New Balance",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/new-balance.svg?w=1440&q=75",
    },
    {
        name: "Converse",
        target: "_self",
        label: "upper_brand",
        date: "200624",
        src: "https://resize.sprintercdn.com/s/storefront/common/logos/brands/new/converse.svg?w=1440&q=75",
    },
];
const currentBrand = ref(0);
const visibleBrands = ref([...brands]);
let brandInterval = null;

const startBrandSlider = () => {
    brandInterval = setInterval(() => {
        const first = visibleBrands.value.shift();
        visibleBrands.value.push(first);
    }, 2000);
};

// Categorías (dinámicas a partir de los accesorios)
const categories = computed(
    () =>
        page.props.categories || [
            {
                id: 1,
                name: "Pantalones",
                image: "/images/Page-Home/pantalones.webp",
            },
            {
                id: 2,
                name: "Sudaderas",
                image: "/images/Page-Home/sudaderas.webp",
            },
            {
                id: 3,
                name: "Camisetas",
                image: "/images/Page-Home/camisetas.webp",
            },
        ]
);

// Manejar el desplazamiento a los enlaces de anclaje después de la navegación por inercia
onMounted(() => {
    cartStore.loadFromLocalStorage();
    window.addEventListener("scroll", handleScroll);
    startMessageSlider();
    startBrandSlider();
    startSlideShow();

    Inertia.on("navigate", () => {
        if (window.location.hash === "#categories") {
            const categoriesSection = document.getElementById("categories");
            if (categoriesSection) {
                categoriesSection.scrollIntoView({ behavior: "smooth" });
            }
        }
    });
});

onUnmounted(() => {
    window.removeEventListener("scroll", handleScroll);
    clearInterval(messageInterval);
    clearInterval(brandInterval);
    stopSlideShow();
});
</script>

<style>
/*Animaciones*/
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

/*Efecto Marquesina*/
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

/* Estilos de encabezado para el estado desplazado */
nav {
    background-color: transparent;
}

nav.scrolled {
    background-color: rgba(243, 244, 246, 0.9);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
</style>
