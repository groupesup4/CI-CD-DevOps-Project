# Projet CI/CD – Pipeline d'une application Node.js

## 1. Présentation du projet

Ce projet consiste à mettre en place un **pipeline CI/CD complet** pour une application Node.js REST API.  
L’objectif pédagogique est de comprendre les principes DevOps, automatiser les tests, la génération d’artefacts, le déploiement, et appliquer les bonnes pratiques de sécurité.

Le projet utilise :
- **GitHub Actions** pour la CI/CD
- **Docker** pour la containerisation
- **GitHub Secrets** pour la gestion sécurisée des informations sensibles
- **Docker Hub / GHCR** comme registre d’images Docker
- **Rolling Update** comme stratégie de déploiement simulée

Organisation du travail en équipe

Le projet a été réalisé en collaboration par une équipe de 3 membres, avec une répartition claire des responsabilités afin de respecter les bonnes pratiques DevOps et favoriser le travail parallèle.

Rôle du membre 1 – Intégration Continue (CI) et Qualité
1. Initialisation du projet

Le membre 1 a été responsable de la phase initiale du projet, comprenant :

Fork du dépôt public node-express-realworld-example-app

Mise en place de la structure du projet :
app/
docker/
scripts/
.github/workflows/
Préparation de l’application pour une intégration CI/CD (variables d’environnement, scripts, configuration Node.js)

2. Pipeline de Tests (CI)

Un pipeline GitHub Actions dédié à la qualité et aux tests a été mis en place afin d’assurer l’intégration continue du projet.

Déclencheurs

Le pipeline est déclenché automatiquement lors de :

push sur la branche main

pull_request vers la branche main

3. Environnement de test automatisé

Pour reproduire un environnement proche de la production, le pipeline CI inclut :

Un service PostgreSQL lancé automatiquement via GitHub Actions

Une base de données dédiée aux tests

Une variable d’environnement DATABASE_URL injectée dynamiquement

4. Étapes du pipeline CI

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

5. Script de tests automatisés

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

6. Qualité du code (Quality Gate)

Le pipeline intègre :

ESLint pour le contrôle de la qualité du code

SonarCloud pour l’analyse statique et la détection des vulnérabilités

Ces outils permettent d’identifier les problèmes de qualité avant le déploiement et contribuent à une chaîne DevOps sécurisée et fiable.

---

## 2. Architecture du pipeline CI/CD

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

## 3. Stratégie de déploiement

- **Type** : Rolling Update simulé
- **Pourquoi** : minimise l’indisponibilité lors des mises à jour
- **Comment** : le script `scripts/deploy.sh` récupère la dernière image et relance le service progressivement
- **Commande pour déployer** :

4. Gestion des secrets (SECURITY.md)

Toutes les informations sensibles sont gérées via les secrets GitHub Actions.
Aucun mot de passe ou clé n’est stocké dans le code source.

Secret	Description
DOCKER_USERNAME	Nom d’utilisateur pour le registre Docker
DOCKER_PASSWORD	Mot de passe / token du registre Docker
DB_PASSWORD	Mot de passe de la base de données MongoDB
SONAR_TOKEN	Token pour SonarCloud (analyse qualité)

Les secrets sont injectés au runtime et le principe du moindre privilège est appliqué.

Voir le fichier SECURITY.md
 pour plus de détails.

5. Scénario d’échec du pipeline
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

6. Lancer le projet localement

Cloner le dépôt

git clone <URL_DU_DEPOT>


Se placer dans le dossier contenant le docker-compose.yml :

cd docker


Lancer les services :

docker-compose up -d --build


Vérifier que l’application fonctionne :

URL par défaut : http://localhost:3000/api

7. Scripts disponibles
Script	Description
scripts/test.sh	Exécute les tests unitaires et le lint
scripts/build.sh	Construit l’image Docker et la tague
scripts/deploy.sh	Déploie l’application en production (Rolling Update simulé)
8. Remarques finales

Le pipeline CI/CD est entièrement automatisé

Les secrets sont sécurisés via GitHub Actions

Le scénario d’erreur du pipeline est documenté pour évaluation

Le diagramme d’architecture permet une compréhension globale du flux


```bash
./scripts/deploy.sh
