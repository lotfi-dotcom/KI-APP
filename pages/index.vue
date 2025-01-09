<template>


    <div class="container">
      <h1 class="title">🛒 Meine Einkaufsliste</h1>
  
      <!-- Eingabeformular -->
      <div class="input-container">
        <input
          v-model="newItem"
          type="text"
          placeholder="Lebensmittel hinzufügen..."
          class="input"
        />
        <button @click="addItem" class="button">Hinzufügen</button>
        <!-- Button für Spracherkennung -->
        <button @click="startListening" class="button">🎙️ Spracherkennung starten</button>
      </div>
  
      <!-- Warenkorb-Übersicht -->
      <h2 class="subtitle">Warenkorb ({{ totalItems }} Artikel)</h2>
      <ul class="shopping-list">
        <li v-for="item in shoppingList" :key="item.id" class="list-item">
          <span class="item-name">{{ item.name }}</span>
          <div class="item-controls">
            <button @click="decreaseQuantity(item.id)" class="quantity-button">➖</button>
            <span class="quantity">{{ item.quantity }}</span>
            <button @click="increaseQuantity(item.id)" class="quantity-button">➕</button>
          </div>
          <button @click="removeItem(item.id)" class="delete-button">🗑️</button>
        </li>
      </ul>
    </div>



  </template>
  
  <script>
  export default {
    data() {
      return {
        newItem: '', // Für die Eingabe neuer Artikel
        shoppingList: [], // Die Einkaufsliste
      };
    },
    computed: {
      totalItems() {
        // Gesamtzahl aller Artikel berechnen
        return this.shoppingList.reduce((total, item) => total + item.quantity, 0);
      },
    },
    methods: {
      addItem() {
        if (this.newItem.trim()) {
          const existingItem = this.shoppingList.find(
            (item) => item.name.toLowerCase() === this.newItem.toLowerCase()
          );
          if (existingItem) {
            // Wenn der Artikel bereits existiert, erhöhe die Menge
            existingItem.quantity++;
          } else {
            // Neues Item hinzufügen
            this.shoppingList.push({
              id: Date.now(),
              name: this.newItem,
              quantity: 1, // Standardmäßig 1
            });
          }
          this.newItem = '';
        }
      },
      removeItem(id) {
        this.shoppingList = this.shoppingList.filter((item) => item.id !== id);
      },
      increaseQuantity(id) {
        const item = this.shoppingList.find((item) => item.id === id);
        if (item) {
          item.quantity++;
        }
      },
      decreaseQuantity(id) {
        const item = this.shoppingList.find((item) => item.id === id);
        if (item && item.quantity > 1) {
          item.quantity--;
        } else if (item) {
          // Wenn die Menge auf 0 sinkt, entferne den Artikel
          this.removeItem(id);
        }
      },
      startListening() {
        if (!('webkitSpeechRecognition' in window)) {
          alert('Spracherkennung wird auf diesem Gerät nicht unterstützt.');
          return;
        }
  
        const recognition = new webkitSpeechRecognition();
        recognition.lang = 'de-DE'; // Setze die Sprache auf Deutsch
        recognition.continuous = false;
        recognition.interimResults = false;
  
        recognition.onresult = (event) => {
          const spokenWord = event.results[0][0].transcript.trim();
          console.log('Erkanntes Wort:', spokenWord);
  
          // Füge das erkannte Wort zur Einkaufsliste hinzu
          const existingItem = this.shoppingList.find(
            (item) => item.name.toLowerCase() === spokenWord.toLowerCase()
          );
          if (existingItem) {
            existingItem.quantity++;
          } else {
            this.shoppingList.push({
              id: Date.now(),
              name: spokenWord,
              quantity: 1,
            });
          }
        };
  
        recognition.onerror = (event) => {
          console.error('Spracherkennungsfehler:', event.error);
        };
  
        recognition.start();
        console.log('Spracherkennung gestartet!');
      },
    },
  };
  </script>
  
  <style scoped>
  .container {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    text-align: center;
    background: #f9f9f9;
  }
  
  .title {
    font-size: 2rem;
    margin-bottom: 20px;
  }
  
  .subtitle {
    font-size: 1.5rem;
    margin: 20px 0;
  }
  
  .input-container {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
  }
  
  .input {
    padding: 10px;
    font-size: 1rem;
    flex: 1;
    margin-right: 10px;
  }
  
  .button {
    padding: 10px 20px;
    font-size: 1rem;
    background-color: #4caf50;
    color: white;
    border: none;
    cursor: pointer;
  }
  
  .shopping-list {
    list-style: none;
    padding: 0;
  }
  
  .list-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 10px;
    background: #fff;
    padding: 10px;
    border-radius: 5px;
  }
  
  .item-controls {
    display: flex;
    align-items: center;
  }
  
  .quantity-button {
    padding: 5px 10px;
    font-size: 1rem;
    margin: 0 5px;
    background-color: #2196f3;
    color: white;
    border: none;
    cursor: pointer;
  }
  
  .quantity {
    font-size: 1rem;
    width: 30px;
    text-align: center;
  }
  
  .delete-button {
    background: none;
    border: none;
    cursor: pointer;
    font-size: 1.5rem;
  }
  </style>
  