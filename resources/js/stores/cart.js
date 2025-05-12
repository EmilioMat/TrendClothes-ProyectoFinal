import { defineStore } from 'pinia';

export const useCartStore = defineStore('cart', {
  state: () => ({
    items: [],
    count: 0
  }),
  actions: {
    addItem(product, size) {
      const existingItem = this.items.find(item => 
        item.product.id === product.id && item.size === size
      );
      
      if (existingItem) {
        existingItem.quantity += 1;
      } else {
        this.items.push({
          product,
          size,
          quantity: 1
        });
      }
      
      this.count = this.items.reduce((total, item) => total + item.quantity, 0);
      this.saveToLocalStorage();
    },
    removeItem(index) {
      this.items.splice(index, 1);
      this.count = this.items.reduce((total, item) => total + item.quantity, 0);
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
        this.count = this.items.reduce((total, item) => total + item.quantity, 0);
      }
    }
  },
  getters: {
    totalPrice: (state) => {
      return state.items.reduce((total, item) => {
        return total + (item.product.price * item.quantity);
      }, 0);
    }
  }
});