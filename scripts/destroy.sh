#!/usr/bin/env bash
set -euo pipefail

RG="${AZURE_RESOURCE_GROUP:-rg-eval-quiz}"

if [[ "${1:-}" != "--confirm" ]]; then
  echo "Usage: ./scripts/destroy.sh --confirm"
  echo "ATTENTION : cette commande supprime toutes les ressources du groupe $RG."
  exit 1
fi

read -r -p "Tapez '$RG' pour confirmer la suppression : " ANSWER

if [[ "$ANSWER" != "$RG" ]]; then
  echo "Suppression annulée."
  exit 1
fi

echo "Suppression du groupe de ressources $RG..."
az group delete --name "$RG" --yes

echo "Nettoyage terminé."
