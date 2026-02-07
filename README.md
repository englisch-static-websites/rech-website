# rech-website

Statische Website fuer den Obstbaubetrieb Rech.

## Environments

| Environment | URL | Branch |
|-------------|-----|--------|
| Production | https://obstbau-rech.de | `main` |
| Development | https://dev.obstbau-rech.de | `develop` |

## Lokale Entwicklung

Voraussetzung: Docker

```bash
docker compose up
```

Die Seite ist dann unter http://localhost:8080 erreichbar. HTML-Dateien und die nginx-Config werden per Volume gemountet, Aenderungen sind nach einem Browser-Refresh sichtbar.

## Deployment

Das Deployment laeuft automatisch ueber GitHub Actions:

1. Push auf `develop` oder `main` triggert den **Build & Push** Workflow (Docker Image nach GHCR)
2. Nach erfolgreichem Push wird automatisch ein `repository_dispatch` an [static-sites-deployment](https://github.com/englisch-static-websites/static-sites-deployment) gesendet
3. Dort wird der passende Container auf dem Server aktualisiert

Manuell kann der Build auch ueber `workflow_dispatch` in der GitHub Actions UI getriggert werden.

## Projektstruktur

```
*.html              Seiten (home, contact, apple, pear, ...)
src/                CSS, JS, Bilder
nginx.conf          Webserver-Konfiguration
Dockerfile          Production Image (nginx:alpine)
docker-compose.yml  Lokale Entwicklung
```
