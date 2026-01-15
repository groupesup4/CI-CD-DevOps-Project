#!/bin/bash
echo " Mise à jour de l'image sur Azure App Service..."

# Mise à jour de la configuration container
az webapp config container set \
  --name "$AZURE_WEBAPP_NAME" \
  --resource-group "rg-groupesup4-api" \
  --container-image-name "ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs:latest" \
  --container-registry-url "https://ghcr.io" \
  --container-registry-user "$GITHUB_ACTOR" \
  --container-registry-password "$GITHUB_TOKEN"