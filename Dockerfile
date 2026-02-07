FROM nginx:alpine

# Nginx Konfiguration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Statische Dateien kopieren (ohne unnoetige Dateien)
COPY *.html /usr/share/nginx/html/
COPY src/ /usr/share/nginx/html/src/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/home.html || exit 1
