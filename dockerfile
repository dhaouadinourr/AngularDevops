# Étape de build
FROM node:16.16.0 AS build
WORKDIR /app
COPY . .
RUN npm install --legacy-peer-deps
RUN npm run build --prod
# Étape de production
FROM nginx:alpine
COPY --from=build /app/dist/crudtuto-Front /usr/share/nginx/html/

