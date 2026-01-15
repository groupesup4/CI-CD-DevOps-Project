#!/bin/bash
# Étudiant C - CD & SecOps

# On s'assure que le nom est en minuscules
IMAGE_NAME="ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs:latest"

echo "🚀 Démarrage du déploiement sur Azure Container Instances..."

az container create \
  --resource-group "$AZURE_RESOURCE_GROUP" \
  --name app-nodejs \
  --image "$IMAGE_NAME" \
  --cpu 1 \
  --memory 1.5 \
  --registry-login-server ghcr.io \
  --registry-username "$GITHUB_ACTOR" \
  --registry-password "$GITHUB_TOKEN" \
  --dns-name-label "conduit-api-group4" \
  --ports 3000 \
  --location "West Europe" \
  --environment-variables DATABASE_URL="$DATABASE_URL" \
  --restart-policy OnFailure

echo "✅ Déploiement terminé avec succès !"