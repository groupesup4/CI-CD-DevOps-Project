#!/bin/bash

echo "--------------------------------------------------------"
echo " Rapport de déploiement pour : $AZURE_WEBAPP_NAME"
echo " Image : ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs:latest"
echo " Statut : Le déploiement a été poussé via le Publish Profile."
echo " Note : L'authentification Registry est gérée par GitHub Actions."
#echo " URL : https://$AZURE_WEBAPP_NAME.azurewebsites.net"
echo "--------------------------------------------------------"