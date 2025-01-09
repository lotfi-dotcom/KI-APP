// Beispiel für db.js, die auf einem Node.js-Server läuft (ohne Vue-spezifischen Code)
const fs = require('fs');

function getShoppingList() {
  return JSON.parse(fs.readFileSync('./shoppingList.json', 'utf8'));
}

function saveShoppingList(list) {
  fs.writeFileSync('./shoppingList.json', JSON.stringify(list));
}

module.exports = { getShoppingList, saveShoppingList };
