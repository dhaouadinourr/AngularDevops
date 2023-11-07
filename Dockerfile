# Stage 1: Build the Angular app
FROM node:14 AS builder

WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app for production
RUN npm run build --prod

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy the built app from the builder stage to the Nginx directory
COPY --from=builder /app/dist/crudtuto-Front /usr/share/nginx/html

# Expose the port that Nginx will listen on (usually 80)
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]