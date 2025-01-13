# Build stage
FROM node:20 as build-stage

WORKDIR /usr/src/docker/ki-app
COPY ./src/package*.json ./
RUN npm install
COPY ./src ./
COPY ./docker/template.config.json ./_template/

RUN npm run build
RUN npm run generate

# Production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /usr/src/docker/SC-Maschine/.output/public /usr/share/nginx/html
COPY ./docker/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
