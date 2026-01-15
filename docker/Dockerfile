FROM node:18-alpine

# Installation des dépendances système pour Prisma
RUN apk add --no-cache openssl openssl-dev libc6-compat

WORKDIR /app

# 1. Copier les fichiers depuis le dossier 'app' de ton dépôt
# On suppose ici que tu lances le build depuis la racine du projet
COPY app/package*.json ./

# 2. Installer les dépendances
RUN npm install

# 3. Copier tout le code source du dossier 'app'
COPY app/ .

# 4. Générer le client Prisma (précise le chemin si nécessaire)
RUN npx prisma generate --schema=src/prisma/schema.prisma

# 5. Exposer le port utilisé par l'API
EXPOSE 3000

# 6. Lancer l'application
# Note : Pour la production, on évite souvent 'nx serve'. 
# Si tu as un script 'start' dans ton package.json, utilise-le :
CMD ["npm", "start"]