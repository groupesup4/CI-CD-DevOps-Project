#!/bin/bash
# Étudiant B & C - Build de l'image
IMAGE_NAME="ghcr.io/${GITHUB_REPOSITORY_OWNER,,}/api-nodejs"

echo " Building Docker image..."
# Construction avec le SHA pour la traçabilité et latest pour la prod
docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:$GITHUB_SHA -f docker/Dockerfile .