# J2 — Rapport de sécurité des images Docker

## 1. Objectif

Analyser les images Docker du frontend et du backend avec Trivy, corriger les vulnérabilités pertinentes et documenter les risques résiduels.

## 2. Résultats des scans Trivy

Scans réalisés le 17 novembre 2026.

| Image | Vulnérabilités avant | Vulnérabilités après | HIGH après | CRITICAL après |
|---|---:|---:|---:|---:|
| Frontend | 5 | 0 | 0 | 0 |
| Backend | 22 | 2 | 0 | 0 |
| **Total** | **27** | **2** | **0** | **0** |

La réduction est d'environ **93 %** des vulnérabilités détectées par Trivy.

Les 9 vulnérabilités HIGH initiales ont été éliminées.

## 3. Corrections appliquées

**Frontend**

- Mise à jour du paquet Alpine `libxslt` pour corriger trois vulnérabilités HIGH.
- Mise à jour de `zlib` pour corriger une vulnérabilité MEDIUM.
- Reconstruction de l'image et nouveau scan Trivy.

**Backend**

- Suppression de npm et de ses dépendances intégrées de l'image d'exécution après installation des dépendances applicatives.
- Élimination de six vulnérabilités HIGH associées aux paquets `brace-expansion` et `undici` embarqués avec npm.
- Mise à jour du paquet Alpine `zlib`.
- Conservation de l'exécution du serveur Node.js avec un utilisateur non-root.

## 4. Vulnérabilités résiduelles

Deux vulnérabilités MEDIUM subsistent dans le backend :

| Paquet | CVE | Version installée | Version corrigée indiquée |
|---|---|---|---|
| glob | CVE-2026-118773 | 10.5.0 | 14.0.2 |
| minimatch | CVE-2026-118764 | 9.0.9 | 11.0.1 |

Ces dépendances sont transitives et proviennent de la chaîne `resend → @react-email/render → pretty → js-beautify`.

Les versions corrigées indiquées impliquent des changements majeurs. Une mise à jour forcée pourrait entraîner des incompatibilités et nécessiter des tests supplémentaires.

Les deux vulnérabilités sont conservées temporairement comme risques résiduels documentés. Leur exploitabilité dans les fonctionnalités exposées de Quiz App n'a pas été démontrée.

Une mise à jour contrôlée de la chaîne de dépendances devra être étudiée ultérieurement.

## 5. Vérification fonctionnelle

Après reconstruction et redémarrage avec Docker Compose :

- Les conteneurs frontend, backend et PostgreSQL démarrent.
- PostgreSQL est en état healthy.
- La route `/health` répond `{"status":"ok"}`.
- Le backend fonctionne avec l'utilisateur `node` (UID 1000).

## 6. Commandes principales

```bash
trivy image --scanners vuln quiz-front-end:j1
trivy image --scanners vuln quiz-backend:j1

docker compose build --pull
docker compose up -d
docker compose ps

trivy image --scanners vuln quiz-front-end:j2
trivy image --scanners vuln quiz-backend:j2

docker compose exec backend id
curl -fsS http://localhost:8087/health
```

Les rapports détaillés sont conservés dans `preuves/J2/` sous les noms `frontend-before.txt`, `backend-before.txt`, `frontend-after.txt` et `backend-after.txt`.

## 7. Conclusion

La sécurisation a réduit le nombre de vulnérabilités identifiées de 27 à 2, sans vulnérabilité HIGH ou CRITICAL détectée dans les images finales.

Les deux vulnérabilités MEDIUM restantes sont documentées. Le système reste soumis à des scans réguliers et à une gestion contrôlée des dépendances.