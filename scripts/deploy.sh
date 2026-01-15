#!/bin/bash
echo "--------------------------------------------------------"
echo "🚀 Rapport de déploiement pour : $AZURE_WEBAPP_NAME"
echo "📦 Image déployée : ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs:latest"
echo "✅ Statut : Déploiement validé via Publish Profile"
echo "🔗 URL : https://$AZURE_WEBAPP_NAME.azurewebsites.net"
echo "--------------------------------------------------------"