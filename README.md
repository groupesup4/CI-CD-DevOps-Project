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

---

## 2. Architecture du pipeline CI/CD

Le diagramme ci-dessous illustre l’architecture de notre pipeline :

![CI/CD Pipeline](./docs/ci-cd-diagram.png)

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

```bash
./scripts/deploy.sh
