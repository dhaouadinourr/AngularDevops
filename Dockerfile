### ÉTAPE 1 : CONSTRUIRE ###
# Définir une image de nœud à utiliser en lui donnant un alias "build"
# La version de l'image Node à utiliser dépend des dépendances du projet
# Ceci est nécessaire pour construire et compiler notre code
# lors de la génération de l'image docker
FROM node:16.16-alpine AS build
# Create a Virtual directory inside the docker image
WORKDIR /dist/src/app
# Run command in Virtual directory
RUN npm cache clean --force
# Copy files from local machine to virtual directory in docker image
COPY . .
RUN npm install --force
RUN npm run build --prod


### STAGE 2:RUN ###
# Defining nginx image to be used
FROM nginx:latest AS ngi
# Copie du code compilé et de la configuration nginx dans un autre dossier
# REMARQUE : Ce chemin peut changer en fonction du dossier de sortie de votre projet
COPY --from=build /dist/src/app/dist/crudtuto-Front /usr/share/nginx/html
COPY /nginx.conf /etc/nginx/conf.d/default.conf
# Exposer un port, ici cela signifie qu'à l'intérieur du conteneur
# l'application utilisera le port 80 lors de son exécution
EXPOSE 80
#NGINX est utilisé ici pour servir les fichiers statiques de l'application Angular, fournissant un serveur web léger, rapide et efficace pour servir ces fichiers au navigateur des utilisateurs finaux. 