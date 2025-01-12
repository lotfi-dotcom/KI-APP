# Verwenden Sie ein offizielles Node.js-Image als Basis
FROM node:14

# Erstellen Sie das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopieren Sie package.json und installieren Sie die Abhängigkeiten
COPY package.json /app
RUN npm install

# Kopieren Sie den gesamten Code
COPY . /app

# Exponieren Sie den Port, auf dem Ihre App läuft (z.B. 3000)
EXPOSE 3000

# Starten Sie die Anwendung
CMD ["npm", "start"]
