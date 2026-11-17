# Déploiement Azure — Quiz App

## Architecture

L'application est déployée dans Azure Container Apps.

- Resource Group : rg-eval-quiz
- Région : France Central
- Container Apps Environment : cae-eval-quiz
- Azure Container Registry : acremanquiz2026

## Applications

### Frontend
- Nom : quiz-front-end
- Image : quiz-front-end:j4-fix2
- Serveur : Nginx
- Port : 80
- Ingress : externe (HTTPS)

### Backend
- Nom : quiz-backend
- Image : quiz-backend:j2
- Serveur : Node.js / Express
- Port : 3007
- Ingress : externe (HTTPS)
- Endpoint de santé : /health

## Communication

Le frontend utilise Nginx comme reverse proxy.

Les communications frontend → backend utilisent
HTTPS avec vérification du certificat TLS.

L'environnement Azure Container Apps Express utilisé
ne permet pas la découverte interne par nom court.

Le backend utilise donc une URL HTTPS accessible
publiquement. Cela constitue une limitation de sécurité :
l'API doit rester protégée par les mécanismes
d'authentification et d'autorisation applicatifs.

## Scripts

- scripts/deploy.sh : mise à jour des Container Apps
  existantes avec les images stockées dans ACR.
- scripts/destroy.sh : suppression du Resource Group
  après confirmation explicite.

Prérequis : Azure CLI, session az login active,
ressources Azure déjà créées et permissions nécessaires.

Le script deploy.sh ne recrée pas l'infrastructure
à partir de zéro.

## Validation J4

- Frontend accessible en HTTPS.
- Backend démarré dans Azure Container Apps.
- Reverse proxy Nginx fonctionnel.
- GET /health via le frontend : HTTP 200.
- Réponse : {"status":"ok"}.

La connexion à PostgreSQL cloud sera réalisée au J5.
