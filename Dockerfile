# =============================================================================
# Stage 1: Bilder optimieren
# =============================================================================
FROM alpine:3.19 AS img-optimize

RUN apk add --no-cache imagemagick jpegoptim optipng libwebp-tools

COPY src/img/ /img/

# JPG/JPEG: auf max 1920px Breite skalieren, Qualitaet 80
RUN find /img -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) \
    -exec sh -c 'mogrify -resize "1920x1920>" -quality 80 "$1" && jpegoptim --strip-all --max=80 -q "$1"' _ {} \;

# PNG: verlustfrei optimieren
RUN find /img -type f -iname "*.png" \
    -exec optipng -o2 -quiet {} \;

# WebP-Varianten erzeugen (Logos ausschliessen)
RUN find /img -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) \
    -exec sh -c 'cwebp -q 80 "$1" -o "${1%.*}.webp"' _ {} \; && \
    find /img -type f -iname "*.png" ! -path "*/logo/*" \
    -exec sh -c 'cwebp -q 80 "$1" -o "${1%.*}.webp"' _ {} \;

# =============================================================================
# Stage 2: CSS/JS minifizieren
# =============================================================================
FROM node:22-alpine AS minify

RUN npm install -g clean-css-cli terser --no-fund --no-audit

COPY src/css/ /assets/css/
COPY src/js/ /assets/js/

RUN find /assets/css -name '*.css' -exec sh -c 'cleancss -o "$1" "$1"' _ {} \;
RUN find /assets/js -name '*.js' -exec sh -c 'terser "$1" -o "$1" --compress --mangle' _ {} \;

# =============================================================================
# Stage 3: Nginx mit optimierten Dateien
# =============================================================================
FROM nginx:alpine

# Build-Metadaten
ARG GIT_COMMIT=unknown
ARG GIT_BRANCH=unknown
ARG BUILD_TIME=unknown

# Nginx Konfiguration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Statische Dateien kopieren
COPY *.html /usr/share/nginx/html/
COPY src/ /usr/share/nginx/html/src/
COPY sitemap.xml robots.txt /usr/share/nginx/html/

# Optimierte Bilder ueber die Originale kopieren
COPY --from=img-optimize /img/ /usr/share/nginx/html/src/img/

# Minifizierte CSS/JS ueber die Originale kopieren
COPY --from=minify /assets/css/ /usr/share/nginx/html/src/css/
COPY --from=minify /assets/js/ /usr/share/nginx/html/src/js/

# Build-Info generieren
RUN printf '{"app":"rech-website","commit":"%s","branch":"%s","buildTime":"%s"}' \
    "${GIT_COMMIT}" "${GIT_BRANCH}" "${BUILD_TIME}" > /usr/share/nginx/html/info.json

# Non-root: Berechtigungen setzen und als nginx-User laufen
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown nginx:nginx /var/run/nginx.pid

USER nginx

EXPOSE 8080
