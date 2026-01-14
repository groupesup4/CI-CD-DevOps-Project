FROM node:18-alpine

# Installation des dépendances système pour Prisma
RUN apk add --no-cache openssl openssl-dev libc6-compat

WORKDIR /app

# 1. Copier les fichiers de dépendances
COPY package*.json ./

# 2. Installer les dépendances
RUN npm install

# 3. Copier tout le code source
COPY . .

# 4. Générer le client Prisma
RUN npx prisma generate

# 5. Exposer le port
EXPOSE 3000

# 6. Lancer l'application via Nx
CMD ["npx", "nx", "serve", "api", "--host=0.0.0.0"]
