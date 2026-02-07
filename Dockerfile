FROM nginx:alpine

# Nginx Konfiguration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Statische Dateien kopieren (ohne unnoetige Dateien)
COPY *.html /usr/share/nginx/html/
COPY src/ /usr/share/nginx/html/src/

EXPOSE 80
