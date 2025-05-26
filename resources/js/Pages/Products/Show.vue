<template>
    <AppLayout>
        <div class="bg-gray-50 py-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Breadcrumb dinámico -->
                <div class="text-sm text-gray-500 mb-4">
                    <Link
                        :href="route('categories.index')"
                        class="hover:text-gray-700"
                    >
                        {{
                            product.gender === "male"
                                ? "Hombre"
                                : product.gender === "female"
                                ? "Mujer"
                                : "Unisex"
                        }}
                    </Link>
                    <span v-if="product.category"> - </span>
                    <Link
                        v-if="product.category"
                        :href="
                            route('categories.show', {
                                category: product.category
                                    .toLowerCase()
                                    .replace(/ /g, '-'),
                            })
                        "
                        class="hover:text-gray-700"
                    >
                        {{ product.category }}
                    </Link>
                    <span> - </span>
                    <span class="font-semibold">{{ product.name }}</span>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- Images Section -->
                    <div>
                        <!-- Main Image -->
                        <div
                            class="h-96 bg-gray-100 rounded-lg flex items-center justify-center mb-4"
                        >
                            <img
                                v-if="currentMainImage"
                                :src="currentMainImage"
                                :alt="product.name"
                                class="h-full w-full object-contain"
                            />
                            <div v-else class="text-gray-500">Sin imagen</div>
                        </div>

                        <!-- Thumbnails -->
                        <div
                            v-if="product.images.length"
                            class="grid grid-cols-4 gap-2"
                        >
                            <div
                                v-for="(image, index) in product.images"
                                :key="index"
                                class="h-24 bg-gray-100 rounded flex items-center justify-center cursor-pointer hover:border-2 hover:border-indigo-500"
                                @click="changeMainImage(image)"
                            >
                                <img
                                    :src="image"
                                    :alt="
                                        product.name +
                                        ' - Imagen ' +
                                        (index + 1)
                                    "
                                    class="h-full w-full object-contain"
                                />
                            </div>
                        </div>
                    </div>

                    <!-- Product Details -->
                    <div>
                        <h1 class="text-2xl font-bold text-gray-900">
                            {{ product.name }}
                        </h1>
                        <p class="text-gray-600 mt-2">
                            {{ product.type || "Zapatillas Running" }}
                            {{
                                product.gender === "male"
                                    ? "Hombre"
                                    : product.gender === "female"
                                    ? "Mujer"
                                    : "Unisex"
                            }}
                            | {{ product.brand || "Marca" }}
                        </p>

                        <!-- Price -->
                        <div class="mt-6">
                            <span class="text-3xl font-bold">{{
                                formatPrice(product.price)
                            }}</span>
                            <span
                                v-if="product.original_price"
                                class="ml-2 text-sm text-gray-500 line-through"
                                >{{ formatPrice(product.original_price) }}</span
                            >
                        </div>

                        <!-- Discount and points -->
                        <div
                            class="mt-2 text-sm"
                            v-if="product.discount || product.points"
                        >
                            <p>
                                Hasta acceso del
                                <span class="font-semibold"
                                    >{{ product.discount || 0 }}%</span
                                >
                                y reanhela
                                <span class="font-semibold">{{
                                    product.points || 0
                                }}</span>
                                puntos por esta compra.
                            </p>
                        </div>

 <!-- Sizes Section - Versión con botones -->
        <div class="mt-8">
            <h3 class="text-sm font-medium text-gray-900">
                Tallas disponibles:
            </h3>
            <div class="grid grid-cols-3 gap-2 mt-2">
                <button
                    v-for="size in availableSizes"
                    :key="size.id"
                    class="border border-gray-300 rounded-md py-2 px-3 text-sm font-medium hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500"
                    :class="{
                        'bg-indigo-100 border-indigo-500': selectedSize === size.id,
                        'opacity-50 cursor-not-allowed': size.stock <= 0
                    }"
                    @click="selectSize(size)"
                    :disabled="size.stock <= 0"
                >
                    {{ size.name }}
                    <span v-if="size.stock > 0" class="text-xs text-gray-500 block">
                        ({{ size.stock }} disponibles)
                    </span>
                    <span v-else class="text-xs text-red-500 block">
                        (Agotado)
                    </span>
                </button>
            </div>
        </div>


                        <!-- Quantity -->
                        <div class="mt-4">
                            <label
                                class="block text-sm font-medium text-gray-700"
                                >Cantidad:</label
                            >
                            <input
                                type="number"
                                v-model.number="quantity"
                                min="1"
                                :max="maxQuantity"
                                class="w-full border border-gray-300 rounded-lg p-2"
                                required
                            />
                        </div>

                        <!-- Add to cart button -->
                        <button
                            class="mt-8 w-full bg-indigo-600 border border-transparent rounded-md py-3 px-8 flex items-center justify-center text-base font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                            @click="submitAddToCart"
                            :disabled="!canAddToCart"
                        >
                            Añadir a la cesta
                        </button>

                        <!-- Shipping info -->
                        <div class="mt-6 border-t border-gray-200 pt-6">
                            <p class="text-sm text-gray-600">
                                Vendido y enviado por
                                <span class="font-semibold">{{
                                    product.seller || "Spiritier"
                                }}</span>
                            </p>
                            <p class="text-sm text-gray-600 mt-1">
                                Envío
                                <span class="font-semibold">GRATIS</span> a
                                domicilio
                            </p>
                            <p class="text-sm text-gray-600 mt-1">
                                Entrega estimada el
                                <span class="font-semibold">{{
                                    estimatedDeliveryDate
                                }}</span>
                            </p>
                            <p class="text-sm text-gray-600 mt-1">
                                - Envío domicilio en pantalla
                            </p>
                            <p class="text-sm text-gray-600 mt-1">
                                Puede ser realizado de 23,35€ en intereses con
                                PayPal.
                            </p>
                        </div>

                        <!-- Payment info -->
                        <div class="mt-4">
                            <p class="text-sm text-gray-600">Normal:</p>
                            <p class="text-xs text-gray-500">
                                Pagar n° 2 (estate de 23) 21 € en intereses
                                (90°, 100), Norma
                            </p>
                            <p class="text-xs text-gray-500">UM: Información</p>
                        </div>
                    </div>
                </div>

                <!-- Product information section -->
                <div class="mt-12 border-t border-gray-200 pt-8">
                    <h2 class="text-lg font-medium text-gray-900">
                        Información de producto
                    </h2>
                    <div class="mt-4">
                        <p class="text-gray-600">
                            {{
                                product.description ||
                                "Descripción detallada del producto no disponible."
                            }}
                        </p>
                    </div>
                </div>

                <!-- Shipping section -->
                <div class="mt-8 border-t border-gray-200 pt-8">
                    <h2 class="text-lg font-medium text-gray-900">Envío</h2>
                    <div class="mt-4">
                        <p class="text-gray-600">
                            Información sobre políticas de envío, plazos de
                            entrega y costes asociados.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import AppLayout from "@/Layouts/AppLayout.vue";
import { Link, useForm } from "@inertiajs/vue3";
import { ref, computed } from "vue";
import { useCartStore } from "@/stores/cart";
import { toast } from "vue3-toastify";
import "vue3-toastify/dist/index.css";

const props = defineProps({
    product: {
        type: Object,
        required: true,
        default: () => ({
            id: "",
            name: "",
            brand: "",
            category: "",
            gender: "",
            type: "",
            price: 0,
            original_price: null,
            description: "",
            main_image: null,
            images: [],
            sizes: [], // Formato: [{ id, name, pivot: { stock } }]
            stock: 0,
            discount: 0,
            points: 0,
            seller: "",
        }),
    },
});

const selectedSize = ref(null);
const quantity = ref(1);
const currentMainImage = ref(props.product.main_image);
const cartStore = useCartStore();


const formatPrice = (price) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(price);
};

const changeMainImage = (image) => {
    currentMainImage.value = image;
};

const availableSizes = computed(() => {
    return props.product.sizes.map(size => ({
        id: size.id,
        name: size.name,
        stock: size.pivot?.stock || 0
    }));
});

const maxQuantity = computed(() => {
    if (!selectedSize.value || !props.product.sizes) return 0;
    const size = availableSizes.value.find((s) => s.id === selectedSize.value);
    return size ? size.stock : 0;
});

const canAddToCart = computed(() => {
    return selectedSize.value !== null &&
        quantity.value > 0 &&
        quantity.value <= maxQuantity.value;
});



const estimatedDeliveryDate = computed(() => {
    const date = new Date();
    date.setDate(date.getDate() + 3);
    return date.toLocaleDateString("es-ES", { day: "numeric", month: "long" });
});

const form = useForm({
    product_id: props.product.id,
    size_id: null, // Use size_id
    quantity: 1,
});

const selectSize = (size) => {
    if (size.stock > 0) {
        selectedSize.value = size.id;
        form.size_id = size.id; // Set size_id
    }
};

const submitAddToCart = async () => {
    if (!canAddToCart.value) {
        toast.error("Por favor, selecciona una talla y una cantidad válida", {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 3000,
        });
        return;
    }

    try {
        await form.post(route("cart.add"), {
            preserveScroll: true,
            onSuccess: () => {
                const size = availableSizes.value.find((s) => s.id === selectedSize.value);
                cartStore.addItem(
                    {
                        id: props.product.id,
                        name: props.product.name,
                        price: props.product.price,
                        main_image: props.product.main_image,
                    },
                    size?.name,
                    quantity.value,
                    size?.id // Pass size_id
                );
                toast.success("Producto añadido al carrito", {
                    position: toast.POSITION.TOP_RIGHT,
                    autoClose: 2000,
                });
                selectedSize.value = null;
                quantity.value = 1;
                form.size_id = null;
            },
            onError: (errors) => {
                toast.error(
                    "Error al añadir el producto al carrito: " +
                    Object.values(errors).join(", "),
                    {
                        position: toast.POSITION.TOP_RIGHT,
                        autoClose: 3000,
                    }
                );
            },
        });
    } catch (error) {
        console.error('Error al añadir al carrito:', error);
        toast.error('Error de conexión al añadir al carrito', {
            position: toast.POSITION.TOP_RIGHT,
            autoClose: 3000,
        });
    }
};
</script>

