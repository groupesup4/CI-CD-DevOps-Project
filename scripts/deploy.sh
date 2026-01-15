#!/bin/bash
# Étudiant C - Connexion sécurisée Registry <-> Azure

echo "Configuration des accès au registre pour Azure..."

# Cette commande dit à Azure comment s'identifier sur GHCR
az webapp config container set \
  --name "$AZURE_WEBAPP_NAME" \
  --resource-group "rg-groupesup4-api" \
  --docker-custom-image-name "ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs:latest" \
  --docker-registry-server-url "https://ghcr.io" \
  --docker-registry-server-user "$GITHUB_ACTOR" \
  --docker-registry-server-password "$GITHUB_TOKEN"

echo "Image mise à jour et accès autorisé !"