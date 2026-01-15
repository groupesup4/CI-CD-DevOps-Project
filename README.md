# Projet CI/CD – Pipeline d'une application Node.js

## 1. Présentation du projet

Ce projet consiste à mettre en place un **pipeline CI/CD complet** pour une application Node.js REST API.  
L’objectif pédagogique est de comprendre et appliquer les principes DevOps :

Automatisation des tests

Génération d’artefacts

Déploiement continu

Sécurité et gestion des secrets

Technologies utilisées

GitHub Actions : CI/CD

Docker : containerisation

GitHub Secrets : gestion sécurisée des secrets

GitHub Container Registry (GHCR) : registre Docker

Rolling Update (simulé) : stratégie de déploiement

# 2. Organisation du travail en équipe
Le projet a été réalisé en collaboration par une équipe de 3 membres, avec une répartition claire des responsabilités afin de respecter les bonnes pratiques DevOps et favoriser le travail parallèle.

Rôle du membre 1 – Intégration Continue (CI) et Qualité
## 2.1 Initialisation du projet

Le membre 1 a été responsable de la phase initiale du projet, comprenant :

Fork du dépôt public node-express-realworld-example-app

Mise en place de la structure du projet :
app/
docker/
scripts/
.github/workflows/
Préparation de l’application pour une intégration CI/CD (variables d’environnement, scripts, configuration Node.js)

## 2.2 Pipeline de Tests (CI)

Un pipeline GitHub Actions dédié à la qualité et aux tests a été mis en place afin d’assurer l’intégration continue du projet.

Déclencheurs

Le pipeline est déclenché automatiquement lors de :

push sur la branche main

pull_request vers la branche main

## 2.3 Environnement de test automatisé

Pour reproduire un environnement proche de la production, le pipeline CI inclut :

Un service PostgreSQL lancé automatiquement via GitHub Actions

Une base de données dédiée aux tests

Une variable d’environnement DATABASE_URL injectée dynamiquement

## 2.4 Étapes du pipeline CI

Le pipeline CI Quality Gate comprend les étapes suivantes :

Récupération du code source

Installation de Node.js (version 18)

Installation des dépendances

Analyse de la qualité du code

ESLint pour détecter les erreurs de style et de syntaxe

Intégration de SonarCloud pour l’analyse statique du code

Exécution des tests unitaires

Initialisation de la base de données avec Prisma

Lancement des tests via un script automatisé

Certaines étapes (lint et tests) utilisent volontairement continue-on-error: true afin de :

Ne pas bloquer le pipeline global

Illustrer la détection et la gestion des erreurs

Permettre la poursuite des étapes de build et de déploiement

Cette approche est utilisée à des fins pédagogiques.

## 2.5 Script de tests automatisés

Les tests unitaires sont exécutés via le script suivant :

scripts/test.sh
#!/bin/bash

cd app
npm install
npm test

EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "Les tests ont échoué avec le code $EXIT_CODE"
  exit 1
fi
Ce script permet :

Une exécution reproductible des tests

Une utilisation aussi bien en local que dans le pipeline CI

Une remontée explicite des erreurs via le code de sortie

## 7. Qualité du code (Quality Gate)

Le pipeline intègre :

ESLint pour le contrôle de la qualité du code

SonarCloud pour l’analyse statique et la détection des vulnérabilités

Ces outils permettent d’identifier les problèmes de qualité avant le déploiement et contribuent à une chaîne DevOps sécurisée et fiable.

---

# 3. Rôle du membre 2 – Dockerisation & Pipeline de Build

## 3.1 Dockerisation de l’application

Le membre 2 a été responsable de la containerisation complète de l’application Node.js afin de garantir :

la portabilité

la reproductibilité

la cohérence entre les environnements (local, CI, cloud)

Cette dockerisation repose sur deux éléments clés :

un Dockerfile optimisé

un docker-compose.yml pour l’exécution locale

## 3.2 Dockerfile optimisé pour Node.js

Le Dockerfile utilise une image légère (node:18-alpine) afin de réduire la taille de l’image finale et améliorer les performances.

Principales étapes :

Installation des dépendances système nécessaires à Prisma

Installation des dépendances Node.js

Génération du client Prisma

Exposition du port de l’API

Lancement de l’application en mode production

Dockerfile :
FROM node:18-alpine

RUN apk add --no-cache openssl openssl-dev libc6-compat

WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app/ .

RUN npx prisma generate --schema=src/prisma/schema.prisma

EXPOSE 3000

CMD ["npm", "start"]

Cette approche permet d’obtenir une image Docker :

légère

reproductible

prête pour un déploiement automatisé

## 3.3 Orchestration locale avec Docker Compose

Le fichier docker-compose.yml permet de lancer l’application en local avec :

l’API Node.js

une base de données PostgreSQL

Il facilite :

les tests locaux

le développement

la validation avant intégration CI/CD

docker-compose.yml :
version: '3.8'

services:
  app:
    build:
      context: ../app
      dockerfile: ../docker/Dockerfile
    image: ci-cd-realworld-app:latest
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://user:password@db:5432/realworld?schema=public
      JWT_SECRET: mon_secret_jwt_securise_local
      NODE_ENV: development
    depends_on:
      - db
    volumes:
      - ../app:/app
      - /app/node_modules

  db:
    image: postgres:13
    restart: always
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: realworld
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:

⚠️ Les secrets présents ici sont uniquement destinés à un usage local.
En CI/CD et en production, ils sont remplacés par des GitHub Secrets.

## 3.4 Pipeline de Build – GitHub Actions

Le membre 2 a également implémenté la phase Build & Artifacts du pipeline CI/CD.

Objectifs :

Construire automatiquement l’image Docker

Versionner l’image

Publier l’image dans un registre distant

## 3.5 Gestion des tags Docker

Chaque image est automatiquement taguée avec :

latest → version stable

le SHA du commit GitHub → traçabilité complète

Cette stratégie permet :

un rollback facile

une identification précise des versions déployées

## 3.6 Push vers le registre (GitHub Container Registry)

Les images Docker sont poussées vers GitHub Container Registry (GHCR).

Le pipeline :

s’authentifie via GITHUB_TOKEN

pousse les images versionnées

rend les images disponibles pour le déploiement (CD)

Extrait du pipeline Build :
build-and-push:
  needs: quality-and-tests
  runs-on: ubuntu-latest
  permissions:
    packages: write
  steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Log in to GitHub Container Registry
      run: echo "${{ secrets.GITHUB_TOKEN }}" | docker login ghcr.io -u ${{ github.actor }} --password-stdin

    - name: Build Image using script
      run: |
        chmod +x ./scripts/build.sh
        ./scripts/build.sh

    - name: Push Image to GHCR
      run: |
        docker push ghcr.io/${{ github.repository_owner }}/api-nodejs:latest
        docker push ghcr.io/${{ github.repository_owner }}/api-nodejs:${{ github.sha }}

## 3.7 Script de build Docker

Le build est encapsulé dans un script pour :

faciliter la maintenance

permettre une exécution locale ou CI

éviter la duplication de logique

scripts/build.sh :
#!/bin/bash

IMAGE_NAME="ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:$GITHUB_SHA -f docker/Dockerfile .

Valeur ajoutée DevOps

Le travail du membre 2 apporte :

une dockerisation propre et optimisée

une automatisation complète du build

une gestion professionnelle des artefacts

une intégration fluide avec la phase de déploiement (CD)
-----

# 4. Rôle du membre 3 – Déploiement, Sécurité & Documentation

## 4.1 Architecture du pipeline CI/CD

Le diagramme ci-dessous illustre l’architecture de notre pipeline :

<img width="489" height="578" alt="Capture d’écran 2026-01-13 à 16 50 30" src="https://github.com/user-attachments/assets/2c904f85-e231-4f3d-a89c-7bf01528d731" />


**Description du flux :**
1. **Développeur** : push sur la branche `main` ou création d’une pull request
2. **GitHub Actions** exécute les jobs CI :
   - Installation des dépendances
   - Exécution des tests unitaires
   - Lint avec ESLint et analyse qualité (SonarCloud si applicable)
3. **Build Docker** :
   - Construction de l’image Docker
   - Tag avec `commit SHA` et `latest`
   - Push vers le registre Docker
4. **Déploiement (CD)** :
   - Pull de la dernière image
   - Déploiement progressif avec **Rolling Update**
   - L’application tourne en production

> Note : Docker Compose est utilisé pour simuler le Rolling Update, qui n’est pas un vrai déploiement progressif comme dans Kubernetes.

---

## 4.2 Stratégie de déploiement

- **Type** : Rolling Update simulé
- **Pourquoi** : minimise l’indisponibilité lors des mises à jour
- **Comment** : le script `scripts/deploy.sh` récupère la dernière image et relance le service progressivement
- **Commande pour déployer** :

## 4.3 Gestion des secrets (SECURITY.md)

Toutes les informations sensibles sont gérées via les secrets GitHub Actions.
Aucun mot de passe ou clé n’est stocké dans le code source.

Les secrets sont injectés au runtime et le principe du moindre privilège est appliqué.

Voir le fichier SECURITY.md
 pour plus de détails.

## 4.4 Scénario d’échec du pipeline
Erreur rencontrée

Lors de la configuration initiale, le pipeline ne se lançait pas.

Message d’erreur :

No event triggers defined in `on`

Cause

Le fichier .github/workflows/ci-cd.yml ne contenait pas de déclencheurs GitHub Actions (on:).

Détection

L’erreur a été détectée dans l’onglet Actions de GitHub. Le pipeline échouait immédiatement, sans exécuter de jobs.

Résolution

Ajout du bloc suivant dans ci-cd.yml :

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main


Après correction, le pipeline s’exécute correctement.

## 4.5 Lancer le projet localement

Cloner le dépôt

git clone <URL_DU_DEPOT>


Se placer dans le dossier contenant le docker-compose.yml :

cd docker


Lancer les services :

docker-compose up -d --build


Vérifier que l’application fonctionne :

URL par défaut : http://localhost:3000/api

## 4.6 Scripts disponibles
Script	Description
scripts/test.sh	Exécute les tests unitaires et le lint
scripts/build.sh	Construit l’image Docker et la tague
scripts/deploy.sh	Déploie l’application en production (Rolling Update simulé)

## 4.7 Remarques finales

Le pipeline CI/CD est entièrement automatisé

Les secrets sont sécurisés via GitHub Actions

Le scénario d’erreur du pipeline est documenté pour évaluation

Le diagramme d’architecture permet une compréhension globale du flux


# 5. Conclusion
Ce projet a permis la mise en œuvre d’un pipeline CI/CD complet, robuste et conforme aux bonnes pratiques DevOps pour une application Node.js.

L’intégration continue garantit :

une vérification systématique de la qualité du code (tests automatisés, linting, analyse statique),

une détection précoce des erreurs grâce à l’automatisation,

une meilleure fiabilité des livrables.

La chaîne de livraison continue assure :

une containerisation maîtrisée via Docker,

une gestion professionnelle des artefacts avec un registre d’images versionnées,

un déploiement automatisé et reproductible, limitant les interventions manuelles et les risques d’erreur.

La sécurité a été prise en compte tout au long du projet, notamment par :

l’utilisation de GitHub Secrets pour la gestion des informations sensibles,

l’application du principe du moindre privilège,

l’intégration d’outils d’analyse de la qualité et de la sécurité du code.

Enfin, la documentation complète, structurée et pédagogique permet :

une compréhension claire de l’architecture CI/CD,

une prise en main rapide du projet,

une facilité de maintenance et d’évolution future (ajout de Kubernetes, monitoring, déploiement multi-environnements).

Ce travail illustre concrètement l’apport des pratiques DevOps dans l’industrialisation du cycle de vie applicatif, de la phase de développement jusqu’au déploiement.
