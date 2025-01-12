<template>
    <div :class="['container', { 'dark-mode': darkMode }]">
      <h1 class="title">🛒 Meine Einkaufsliste</h1>
  
      <!-- Dunkelmodus Button -->
      <button @click="toggleDarkMode" class="dark-mode-button">🌙</button>
  
      <!-- Eingabeformular -->
      <div class="input-container">
        <input
          v-model="newItem"
          type="text"
          placeholder="Neu Liste für den Tag..."
          class="input"
        />
        <select v-model="newItemCategory" class="category-select">
          <option value="Obst">Obst</option>
          <option value="Gemüse">Gemüse</option>
          <option value="Milchprodukte">Milchprodukte</option>
          <!-- Weitere Optionen -->
        </select>



      <!-- Artikel Auswahl abhängig von der Kategorie -->
      <select v-if="availableItems.length > 0" v-model="newItem" class="item-select">
        <option value="">Bitte wählen...</option>
        <option v-for="item in availableItems" :key="item" :value="item">{{ item }}</option>
      </select>

        <button @click="addItem" class="button">Hinzufügen</button>
        <button @click="startListening" class="button">🎙️ Spracherkennung starten</button>
      </div>
  
      <!-- Suchfeld -->
      <input v-model="searchQuery" type="text" placeholder="Artikel suchen..." class="search-input" />
  
      <!-- Warenkorb-Übersicht -->
       <!-- Warenkorb-Icon mit Artikelzähler -->
        <div class="cart-container">
        
        <div class="cart-icon">
            <span class="cart-counter">{{ totalItems }}</span>
            🛒
        </div>
        </div>
      <ul class="shopping-list">
        <li v-for="item in filteredShoppingList" :key="item.id" class="list-item">
          <span class="item-name">{{ item.name }}</span>
          <div class="item-controls">
            <button @click="decreaseQuantity(item.id)" class="quantity-button">➖</button>
            <input
              v-model="item.quantity"
              type="number"
              class="quantity-input"
              min="1"
              @change="updateQuantity(item)"
            />
            <button @click="increaseQuantity(item.id)" class="quantity-button">➕</button>
            <button @click="toggleCompleted(item.id)" class="complete-button">✅</button>
          </div>
          <button @click="removeItem(item.id)" class="delete-button">🗑️</button>
        </li>
      </ul>
  
      <!-- Erinnerung -->
      <div v-if="reminderTime" class="reminder">
        <h3>Erinnerung für {{ reminderTime.getHours() }}:{{ reminderTime.getMinutes() }}</h3>
        <button @click="setReminder" class="reminder-button">Erinnerung setzen</button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        newItem: '', // Eingabefeld für den neuen Artikel
        newItemCategory: 'Obst', // Kategorie des neuen Artikels
        shoppingList: [], // Die Liste der hinzugefügten Artikel
        reminderTime: null, // Die Zeit für die Erinnerung
        searchQuery: '', // Suchfeld
        darkMode: false, // Dunkelmodus
        categories: {
          Obst: ['Äpfel', 'Bananen', 'Kirschen', 'Erdbeeren'],
          Gemüse: ['Karotten', 'Brokkoli', 'Tomaten', 'Paprika'],
          Milchprodukte: ['Milch', 'Käse', 'Joghurt', 'Butter'],
        },
      };
    },
    computed: {
      totalItems() {
        return this.shoppingList.reduce((total, item) => total + item.quantity, 0);
      },
      filteredShoppingList() {
        return this.shoppingList.filter(item =>
          item.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
      },
      availableItems() {
        // Gibt eine Liste der Artikel zurück, die zur aktuell gewählten Kategorie passen
        return this.categories[this.newItemCategory] || [];
      }
    },
    methods: {
    addItem() {
        if (this.newItem.trim()) {
            const existingItem = this.shoppingList.find(
            (item) => item.name.toLowerCase() === this.newItem.toLowerCase()
            );
            if (existingItem) {
            existingItem.quantity++;
            } else {
            this.shoppingList.push({
                id: Date.now(),
                name: this.newItem,
                quantity: 1,
                completed: false,
                category: this.newItemCategory, // Speichern der Kategorie
            });
            }
            this.newItem = '';
        }
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
          this.removeItem(id);
        }
      },
      updateQuantity(item) {
        if (item.quantity < 1) {
          item.quantity = 1;
        }
      },
      removeItem(id) {
        this.shoppingList = this.shoppingList.filter((item) => item.id !== id);
      },
      toggleCompleted(id) {
        const item = this.shoppingList.find(item => item.id === id);
        if (item) {
          item.completed = !item.completed;
        }
      },
      setReminder() {
        const reminder = new Date();
        reminder.setHours(13, 25, 0, 0);
        this.reminderTime = reminder;
        console.log(`Erinnerung gesetzt: ${reminder.getHours()}:${reminder.getMinutes()}`);
      },
      startListening() {
        if (!("webkitSpeechRecognition" in window)) {
          alert("Spracherkennung wird auf diesem Gerät nicht unterstützt.");
          return;
        }
  
        const recognition = new webkitSpeechRecognition();
        recognition.lang = "de-DE";
        recognition.continuous = false;
        recognition.interimResults = false;
  
        recognition.onresult = (event) => {
          const spokenWord = event.results[0][0].transcript.trim();
          this.addItem(spokenWord);
        };
  
        recognition.onerror = (event) => {
          console.error("Spracherkennungsfehler:", event.error);
        };
  
        recognition.start();
        console.log("Spracherkennung gestartet!");
      },
      toggleDarkMode() {
        this.darkMode = !this.darkMode;
      },
    },
    mounted() {
      const storedList = JSON.parse(localStorage.getItem('shoppingList'));
      if (storedList) {
        this.shoppingList = storedList;
      }
    },
    watch: {
      shoppingList: {
        handler(newList) {
          localStorage.setItem('shoppingList', JSON.stringify(newList));
        },
        deep: true
      }
    }
  };
  </script>
  
  <style scoped>


.container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
  background: #f9f9f9;
  border-radius: 10px;
  transition: background-color 0.3s, color 0.3s;
}

.dark-mode {
  background-color: #2d2d2d;
  color: #fff;
}

.dark-mode-button {
  position: fixed;
  top: 10px;
  right: 10px;
  background-color: #333;
  color: #fff;
  border: none;
  padding: 10px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.5rem;
  z-index: 10;
}

.title {
  font-size: 2.5rem;
  margin-bottom: 20px;
}

.input-container {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.input, .category-select, .item-select {
  padding: 10px;
  font-size: 1rem;
  flex: 1;
  margin-right: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.button {
  padding: 10px 20px;
  font-size: 1rem;
  background-color: #23d329;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
}

.cart-container {
  position: relative;
  margin-bottom: 20px;
}

.cart-icon {
    position: relative;
  display: inline-block;
  font-size: 4rem; 
}

.cart-counter {
  position: absolute;
  top: 5px;
  right: 30px;
  background-color: #f44336;
  color: white;
  border-radius: 50%;
  padding: 5px 10px;
  font-size: 1.2rem; /* Vergrößerte Zahl */
  min-width: 25px;
  height: 25px;
  text-align: center;
  line-height: 25px;
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
  background: #f3f3f3;
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
  border-radius: 5px;
}

.quantity-input {
  width: 40px;
  text-align: center;
  margin: 0 5px;
}

.delete-button {
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1.5rem;
}

.reminder {
  margin-top: 20px;
}

.reminder-button {
  background-color: #ff9800;
  padding: 10px 20px;
}

/* Responsives Design */
@media (max-width: 768px) {
  .title {
    font-size: 2rem;
  }

  .input-container {
    flex-direction: column;
  }

  .input, .category-select, .item-select, .button {
    min-width: 100%;
  }

  .cart-icon {
    font-size: 2.5rem;
  }

  .cart-counter {
    font-size: 1.1rem;
    padding: 4px 8px;
  }

  .shopping-list {
    margin: 0;
  }

  .list-item {
    flex-direction: column;
    align-items: flex-start;
  }

  .item-controls {
    flex-direction: column;
    margin-top: 10px;
  }

  .quantity-button, .quantity-input {
    margin-bottom: 5px;
  }
}

@media (max-width: 480px) {
  .dark-mode-button {
    font-size: 1.5rem;
    padding: 10px;
  }

  .button, .quantity-button {
    padding: 10px 18px;
    font-size: 1rem;
  }

  .quantity-input {
    width: 30px;
  }
}
</style>
