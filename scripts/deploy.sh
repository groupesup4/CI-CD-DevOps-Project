#!/bin/bash
set -e

echo "Starting deployment..."

echo "Pulling latest images..."
docker-compose pull

echo "Rebuilding and updating services..."
docker-compose up -d --build

echo "Deployment completed successfully."
