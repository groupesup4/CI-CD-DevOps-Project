# Security Policy

## Secrets Management

Toutes les données sensibles sont gérées de manière sécurisée grâce aux secrets de GitHub Actions.

Aucun secret n'est stocké dans le code source ni enregistré dans le dépôt.

## Managed Secrets

| Secret Name | Description |
|------------|------------|
| DOCKER_USERNAME | Docker registry authentication username |
| DOCKER_PASSWORD | Docker registry authentication password or token |
| DB_PASSWORD | Database password used by the application |
| SONAR_TOKEN | Token used for SonarCloud code quality analysis |

## Security Best Practices

- Secrets are injected at runtime via CI/CD pipeline
- No plaintext credentials in the repository
- Principle of least privilege is applied
- Secrets are managed centrally via GitHub Actions
