#!/usr/bin/env bash
set -euo pipefail

# Configuration Azure
RG="${AZURE_RESOURCE_GROUP:-rg-eval-quiz}"
ACR="${AZURE_ACR_NAME:-acremanquiz2026}"
FRONT_TAG="${FRONTEND_IMAGE_TAG:-}"
BACK_TAG="${BACKEND_IMAGE_TAG:-}"

FRONT_APP="quiz-front-end"
BACK_APP="quiz-backend"

echo "=== Déploiement Quiz App ==="

# Vérifier la connexion Azure
az account show --output none

# Récupérer le registre
ACR_SERVER=$(az acr show \
  --name "$ACR" \
  --resource-group "$RG" \
  --query loginServer -o tsv)

# Vérifier les applications existantes
az containerapp show -n "$BACK_APP" -g "$RG" -o none
az containerapp show -n "$FRONT_APP" -g "$RG" -o none

# Use currently deployed tags unless explicitly overridden
CURRENT_FRONT=$(az containerapp show -n "$FRONT_APP" -g "$RG"   --query "properties.template.containers[0].image" -o tsv)
CURRENT_BACK=$(az containerapp show -n "$BACK_APP" -g "$RG"   --query "properties.template.containers[0].image" -o tsv)

FRONT_TAG="${FRONT_TAG:-${CURRENT_FRONT##*:}}"
BACK_TAG="${BACK_TAG:-${CURRENT_BACK##*:}}"

echo "Frontend tag: $FRONT_TAG"
echo "Backend tag: $BACK_TAG"

# Récupérer l'adresse HTTPS du backend
BACKEND_FQDN=$(az containerapp show \
  --name "$BACK_APP" \
  --resource-group "$RG" \
  --query properties.configuration.ingress.fqdn -o tsv)

if [[ -z "$BACKEND_FQDN" ]]; then
  echo "Erreur : adresse backend introuvable."
  exit 1
fi

# Déployer le backend
echo "Mise à jour du backend..."
az containerapp update \
  --name "$BACK_APP" \
  --resource-group "$RG" \
  --image "$ACR_SERVER/quiz-backend:$BACK_TAG" \
  --output none

# Déployer le frontend
echo "Mise à jour du frontend..."
az containerapp update \
  --name "$FRONT_APP" \
  --resource-group "$RG" \
  --image "$ACR_SERVER/quiz-front-end:$FRONT_TAG" \
  --set-env-vars "BACKEND_FQDN=$BACKEND_FQDN" \
  --output none

FRONTEND_FQDN=$(az containerapp show \
  --name "$FRONT_APP" \
  --resource-group "$RG" \
  --query properties.configuration.ingress.fqdn -o tsv)

echo "Déploiement demandé avec succès."
echo "Frontend : https://$FRONTEND_FQDN"
echo "Health : https://$FRONTEND_FQDN/health"
