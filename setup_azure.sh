#!/bin/bash

# Variables - À PERSONNALISER
RESOURCE_GROUP="rg-realworld-devops"
LOCATION="westeurope"
ACR_NAME="acrrealworld$(date +%s | tail -c 5)" # Nom unique pour l'ACR
SERVICE_PRINCIPAL_NAME="sp-github-actions-realworld"

echo "1. Création du Groupe de Ressources..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "2. Création de l'Azure Container Registry (ACR)..."
az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true

echo "3. Récupération de l'ID de l'ACR..."
ACR_ID=$(az acr show --name $ACR_NAME --query id --output tsv)

echo "4. Création du Service Principal pour GitHub Actions..."
# Cette commande génère le JSON à mettre dans GITHUB_CREDENTIALS
az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME \
                         --role contributor \
                         --scopes /subscriptions/$(az account show --query id --output tsv)/resourceGroups/$RESOURCE_GROUP \
                         --sdk-auth

echo "---------------------------------------------------"
echo "ACR Name: $ACR_NAME"
echo "Resource Group: $RESOURCE_GROUP"
echo "---------------------------------------------------"
echo "IMPORTANT: Copiez le JSON ci-dessus dans un secret GitHub nommé AZURE_CREDENTIALS"
