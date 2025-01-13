# Verwenden Sie das offizielle Node.js-Image (aktualisierte Version für Nuxt 3)
FROM node:16

# Erstellen Sie das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopieren Sie package.json und installieren Sie die Abhängigkeiten
COPY package.json /app
COPY package-lock.json /app  
RUN npm install

# Kopiere den gesamten Code ins Containerverzeichnis
COPY . /app

# Exponieren Sie den Port, auf dem Ihre App läuft (z.B. 3000 für Nuxt 3)
EXPOSE 3000

# Starten Sie die Anwendung im Entwicklungsmodus (Optional: für Entwicklungsmodus)
CMD ["npm", "run", "dev"]
