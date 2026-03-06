# =============================================================================
# Stage 1: Bilder optimieren
# =============================================================================
FROM alpine:3.23@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS img-optimize

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
FROM node:22-alpine@sha256:8094c002d08262dba12645a3b4a15cd6cd627d30bc782f53229a2ec13ee22a00 AS minify

# renovate: datasource=npm depName=clean-css-cli
ARG CLEAN_CSS_VERSION=5.6.3
# renovate: datasource=npm depName=terser
ARG TERSER_VERSION=5.46.0

RUN npm install -g clean-css-cli@${CLEAN_CSS_VERSION} terser@${TERSER_VERSION} --no-fund --no-audit

COPY src/css/ /assets/css/
COPY src/js/ /assets/js/

RUN find /assets/css -name '*.css' -exec sh -c 'cleancss -o "$1" "$1"' _ {} \;
RUN find /assets/js -name '*.js' -exec sh -c 'terser "$1" -o "$1" --compress --mangle' _ {} \;

# =============================================================================
# Stage 3: Nginx mit optimierten Dateien
# =============================================================================
FROM nginx:alpine@sha256:1d13701a5f9f3fb01aaa88cef2344d65b6b5bf6b7d9fa4cf0dca557a8d7702ba

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
