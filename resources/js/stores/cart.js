import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: [],
    count: 0,
  }),
  actions: { 

addItem(product, size = null) {
  if (!product || !product.id || !product.name || !product.price) {
    console.error('Producto inválido:', product);
    throw new Error('El producto no tiene la información requerida');
  }

  const existingItem = this.items.find(
    item => item.product.id === product.id && item.size === size
  );

  if (existingItem) {
    existingItem.quantity += 1;
  } else {
    this.items.push({
      product: {
        id: product.id,
        name: product.name,
        price: product.price,
        main_image: product.main_image || null,
      },
      size,
      quantity: 1,
    });
  }
  
  this.updateCount();
  this.saveToLocalStorage();
},
    removeItem(index) {
      this.items.splice(index, 1);
      this.updateCount();
      this.saveToLocalStorage();
    },
    clearCart() {
      this.items = [];
      this.count = 0;
      this.saveToLocalStorage();
    },
    saveToLocalStorage() {
      localStorage.setItem('cart', JSON.stringify(this.items));
    },
    loadFromLocalStorage() {
      const savedCart = localStorage.getItem('cart');
      if (savedCart) {
        this.items = JSON.parse(savedCart);
        this.updateCount();
      }
    },
    updateCount() {
      this.count = this.items.reduce((total, item) => total + item.quantity, 0);
    },
    syncWithBackend(items = []) {
      this.items = items.map(item => ({
        product: {
          id: item.product.id,
          name: item.product.name,
          price: item.product.price, // Ensure price is included
          main_image: item.product.main_image,
        },
        size: item.size,
        quantity: item.quantity,
      }));
      this.updateCount();
      this.saveToLocalStorage();
    },
  },
  getters: {
    totalPrice: (state) => {
      return state.items.reduce((total, item) => {
        return total + (item.product.price * item.quantity);
      }, 0);
    },
  },
});