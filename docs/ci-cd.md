# J6 — Pipeline CI/CD GitHub Actions

## Objectif

Automatiser la validation, la sécurité et le déploiement
de Quiz App avec GitHub Actions.

## Intégration continue (CI)

Déclenchement : Pull Request vers main.

Étapes :
1. Récupération du code.
2. Installation des dépendances.
3. Compilation du frontend.
4. Vérification du backend.
5. Construction des images Docker.
6. Analyse de sécurité avec Trivy.
7. Échec du pipeline si une vulnérabilité CRITICAL est détectée.

Une règle GitHub "Protect main" impose le passage
des contrôles CI avant la fusion.

## Déploiement continu (CD)

Déclenchement : push sur main après une fusion.

Étapes :
1. Validation CI.
2. Authentification Azure avec OIDC.
3. Construction des images Docker linux/amd64.
4. Analyse Trivy.
5. Publication dans Azure Container Registry.
6. Déploiement du backend dans Azure Container Apps.
7. Déploiement du frontend dans Azure Container Apps.
8. Vérification automatique de /health.

## Sécurité

- Aucun mot de passe Azure dans le dépôt.
- Authentification GitHub vers Azure avec OIDC.
- Permissions Azure limitées aux ressources nécessaires.
- Images identifiées par le SHA du commit.
- Secrets PostgreSQL conservés dans Azure Container Apps.

## Résultat

Pipeline CI : SUCCESS.
Pipeline CD : SUCCESS.

Commit déployé :
5f741fc8d04f86ceabaf5f6fac7497235a07b842

Frontend et backend : même commit.

Test /health : HTTP 200.
Réponse : {"status":"ok"}.

## Preuves

Voir preuves/J6/.
