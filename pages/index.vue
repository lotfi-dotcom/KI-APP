<template>
    <div class="container">
      <h1 class="title">🛒 Meine Einkaufsliste</h1>
  
      <!-- Eingabeformular für neue Liste -->
      <div class="input-container">
        <input
          v-model="newListTitle"
          type="text"
          placeholder="Neue Liste für den Tag..."
          class="input"
        />
        <button @click="addList" class="button">Liste hinzufügen</button>
      </div>
  
      <!-- Listenübersicht -->
      <div v-for="(list, index) in shoppingLists" :key="index" class="list-container">
        <h2 class="list-title">{{ list.title }}</h2>
        <ul class="shopping-list">
          <li v-for="item in list.items" :key="item.id" class="list-item">
            <span class="item-name">{{ item.name }}</span>
            <div class="item-controls">
              <button @click="decreaseQuantity(list, item.id)" class="quantity-button">➖</button>
              <span class="quantity">{{ item.quantity }}</span>
              <button @click="increaseQuantity(list, item.id)" class="quantity-button">➕</button>
            </div>
            <button @click="removeItem(list, item.id)" class="delete-button">🗑️</button>
          </li>
        </ul>
  
        <!-- Erinnerung setzen -->
        <button @click="setReminder(list.title)" class="reminder-button">
          Erinnerung setzen
        </button>
      </div>
  
      <!-- Spracherkennungs-Button -->
      <button @click="startListening" class="button">🎙️ Spracherkennung starten</button>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        newListTitle: "", // Titel für neue Listen
        shoppingLists: [], // Alle Listen mit ihren Artikeln
      };
    },
    methods: {
      addList() {
        if (this.newListTitle.trim()) {
          // Neue Liste erstellen
          this.shoppingLists.push({
            title: this.newListTitle,
            items: [],
          });
          this.newListTitle = ""; // Eingabefeld leeren
        }
      },
      addItem(list, itemName) {
        if (itemName.trim()) {
          const existingItem = list.items.find(
            (item) => item.name.toLowerCase() === itemName.toLowerCase()
          );
          if (existingItem) {
            existingItem.quantity++;
          } else {
            list.items.push({
              id: Date.now(),
              name: itemName,
              quantity: 1,
            });
          }
        }
      },
      removeItem(list, id) {
        list.items = list.items.filter((item) => item.id !== id);
      },
      increaseQuantity(list, id) {
        const item = list.items.find((item) => item.id === id);
        if (item) item.quantity++;
      },
      decreaseQuantity(list, id) {
        const item = list.items.find((item) => item.id === id);
        if (item && item.quantity > 1) {
          item.quantity--;
        } else if (item) {
          this.removeItem(list, id);
        }
      },
      setReminder(listTitle) {
        const date = new Date();
        const reminderTime = new Date(date.setHours(13, 25, 0, 0)); // Beispiel: Erinnerung für 18 Uhr
  
        if (Notification.permission === "granted") {
          this.scheduleNotification(reminderTime, `Erinnerung für die Liste: ${listTitle}`);
        } else {
          Notification.requestPermission().then((permission) => {
            if (permission === "granted") {
              this.scheduleNotification(reminderTime, `Erinnerung für die Liste: ${listTitle}`);
            }
          });
        }
      },
      scheduleNotification(time, message) {
        const delay = time - new Date();
        if (delay > 0) {
          setTimeout(() => {
            new Notification(message);
          }, delay);
        } else {
          alert("Erinnerungszeit liegt in der Vergangenheit.");
        }
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
          this.addItem(this.shoppingLists[0], spokenWord); // Hinzufügen des erkannten Artikels zur ersten Liste
        };
  
        recognition.onerror = (event) => {
          console.error("Spracherkennungsfehler:", event.error);
        };
  
        recognition.start();
        console.log("Spracherkennung gestartet!");
      },
    },
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
  
  .input {
    padding: 10px;
    font-size: 1rem;
    flex: 1;
    margin-right: 10px;
    border-radius: 5px;
    border: 1px solid #ccc;
  }
  
  .button, .reminder-button {
    padding: 10px 20px;
    font-size: 1rem;
    background-color: #4caf50;
    color: white;
    border: none;
    cursor: pointer;
    border-radius: 5px;
  }
  
  .reminder-button {
    background-color: #ff9800;
    margin-top: 10px;
  }
  
  .shopping-list {
    list-style: none;
    padding: 0;
  }
  
  .list-container {
    background: #fff;
    padding: 20px;
    margin-bottom: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .list-title {
    font-size: 1.8rem;
    color: #333;
    margin-bottom: 15px;
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
  