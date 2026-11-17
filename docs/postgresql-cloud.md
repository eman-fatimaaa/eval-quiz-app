# J5 — PostgreSQL cloud avec Neon

## Architecture

- Frontend : Azure Container Apps (Nginx)
- Backend : Azure Container Apps (Node.js)
- Base de données : Neon PostgreSQL
- Base utilisée : neondb
- Région Neon : Frankfurt

## Initialisation

Le schéma PostgreSQL a été initialisé avec
le fichier database/init.sql.

Tables créées :
- users
- quiz_results
- answers

## Sécurité et secrets

La connexion est configurée dans le backend
via la variable d'environnement DATABASE_URL.

La valeur est stockée comme secret Azure
Container Apps sous le nom database-url.

Le dépôt Git ne contient pas la chaîne de
connexion ni le mot de passe PostgreSQL.

La chaîne de connexion Neon utilise le
paramètre sslmode=require pour TLS.

## Validation fonctionnelle

Un utilisateur de test a été enregistré
depuis l'application Azure dans Neon.

Un quiz complet a ensuite été soumis.

Résultats vérifiés dans Neon :
- Score : 17/20
- Nombre de questions : 20
- Réponses enregistrées : 20

Les résultats sont conservés dans la base
PostgreSQL distante, indépendamment du
stockage local des conteneurs.

## PostgreSQL local

La base PostgreSQL locale est conservée
dans Docker Compose pour le développement.

## Preuves

Voir preuves/J5/.
