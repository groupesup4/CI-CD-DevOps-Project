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
