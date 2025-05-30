import { defineStore } from "pinia";
import { ref, computed } from "vue";

export const useCartStore = defineStore("cart", {
    state: () => ({
        items: [],
        count: 0,
    }),
    actions: {
        addItem(product, size = null, quantity = 1, sizeId = null) {
            if (!product || !product.id || !product.name || !product.price) {
                console.error("Producto inválido:", product);
                throw new Error(
                    "El producto no tiene la información requerida"
                );
            }

            const existingItem = this.items.find(
                (item) =>
                    item.product.id === product.id && item.size_id === sizeId
            );

            if (existingItem) {
                existingItem.quantity += quantity;
            } else {
                this.items.push({
                    product: {
                        id: product.id,
                        name: product.name,
                        price: product.price,
                        main_image: product.main_image || null,
                        main_image_url: product.main_image
                            ? `/storage/${product.main_image}`
                            : null,
                    },
                    size,
                    size_id: sizeId,
                    quantity,
                });
            }

            this.updateCount();
            this.saveToLocalStorage();
        },
        removeItem(itemId) {
            const [productId, sizeId] = itemId.split("-");
            const index = this.items.findIndex(
                (item) => item.product.id == productId && item.size_id == sizeId
            );
            if (index !== -1) {
                this.items.splice(index, 1);
                this.updateCount();
                this.saveToLocalStorage();
            }
        },
        updateQuantity(itemId, quantity) {
            const [productId, sizeId] = itemId.split("-");
            const item = this.items.find(
                (item) => item.product.id == productId && item.size_id == sizeId
            );
            if (item) {
                if (quantity <= 0) {
                    const index = this.items.indexOf(item);
                    this.items.splice(index, 1);
                } else {
                    item.quantity = quantity;
                }
                this.updateCount();
                this.saveToLocalStorage();
            }
        },
        // En stores/cart.js
        clearCart() {
            this.items = [];
            this.count = 0;
            localStorage.removeItem("cart");
            sessionStorage.removeItem("cart");
        },
        saveToLocalStorage() {
            localStorage.setItem("cart", JSON.stringify(this.items));
        },
        loadFromLocalStorage() {
            const savedCart = localStorage.getItem("cart");
            if (savedCart) {
                this.items = JSON.parse(savedCart);
                this.updateCount();
            }
        },
        updateCount() {
            this.count = this.items.reduce(
                (total, item) => total + item.quantity,
                0
            );
        },
        syncWithBackend(items = []) {
            // Limpiar primero para evitar duplicados
            this.items = [];

            // Sincronizar con los nuevos items
            this.items = items.map((item) => ({
                product: {
                    id: item.product.id,
                    name: item.product.name,
                    price: item.product.price,
                    main_image: item.product.main_image,
                    main_image_url:
                        item.product.main_image_url ||
                        (item.product.main_image
                            ? `/storage/${item.product.main_image}`
                            : null),
                },
                size: item.size,
                size_id: item.size_id,
                quantity: item.quantity,
            }));

            this.updateCount();
            this.saveToLocalStorage();
        },
    },
    getters: {
        totalPrice: (state) => {
            return state.items.reduce((total, item) => {
                return total + item.product.price * item.quantity;
            }, 0);
        },
    },
});
