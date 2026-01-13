#!/bin/bash
# Se déplacer dans le dossier de l'application
cd app
# Installer les dépendances
npm install
# Lancer les tests unitaires
npm test
# Récupérer le code de sortie (exit code)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "Les tests ont échoué avec le code $EXIT_CODE"
  exit 1
fi