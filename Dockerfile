# Development stage
FROM node:20

# Set the working directory inside the container
WORKDIR /usr/src/docker/ki-app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . ./

# Expose the development server port (meist 3000 oder ähnlich, je nach Framework)
EXPOSE 3000

# Start the development server with Nginx in the background
CMD ["sh", "-c", "npm run dev & nginx -g 'daemon off;'"]
