# Security Policy

## Gestion des secrets

Toutes les informations sensibles du projet sont gérées de manière sécurisée à l’aide des GitHub Actions Secrets.

Aucun secret (mot de passe, token, clé API ou chaîne de connexion) n’est :

stocké en clair dans le code source,

versionné dans le dépôt Git,

exposé dans les logs du pipeline.

Les secrets sont injectés dynamiquement au moment de l’exécution du pipeline CI/CD.

## Secrets gérés

| Secret Name | Description |
|------------|------------|
| DOCKER_USERNAME | Nom d’utilisateur pour l’authentification au registre Docker |
| DOCKER_PASSWORD | Mot de passe ou jeton d'authentification du registre Docker |
| DB_PASSWORD | Mot de passe de la base de données utilisé par l'application |
| SONAR_TOKEN | Jeton utilisé pour l'analyse de la qualité du code SonarCloud |
| DATABASE_URL | URL de connexion à la base de données |    
| AZURE_WEBAPP_PUBLISH_PROFILE | Profil de publication sécurisé pour le déploiement Azure Web App |
| AZURE_WEBAPP_NAME | Nom de l’application Azure Web App cible |

## Bonnes pratiques de sécurité appliquées

- Secrets are injected at runtime via CI/CD pipeline
- No plaintext credentials in the repository
- Principle of least privilege is applied
- Secrets are managed centrally via GitHub Actions

## Objectif sécurité

Cette politique de sécurité vise à :
réduire les risques de fuite d’informations sensibles,
garantir la conformité aux bonnes pratiques DevOps,
assurer un déploiement automatisé sécurisé et traçable.


