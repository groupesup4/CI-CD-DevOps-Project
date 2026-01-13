# Security Policy

## Secrets Management

All sensitive data is handled securely using GitHub Actions secrets.

No secrets are stored in the source code or committed to the repository.

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
