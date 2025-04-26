# Build base
FROM php:8.2-fpm-alpine AS builder

# Dependencias necesarias
RUN apk --no-cache add \
    bash \
    git \
    unzip \
    libzip-dev \
    icu-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    oniguruma-dev \
    mariadb-client \
    nginx \
    supervisor \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql zip intl gd mbstring opcache

# Composer para manejar dependencias PHP
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Imagen final
FROM php:8.2-fpm-alpine

# Copiar todo lo necesario
COPY --from=builder /usr/local /usr/local
COPY --from=builder /etc/supervisord.conf /etc/supervisord.conf

# Copiamos el código fuente de Mautic
COPY . /var/www/html

WORKDIR /var/www/html

# Configurar permisos
RUN addgroup -g 1000 www-data && adduser -u 1000 -G www-data -s /bin/sh -D www-data \
    && chown -R www-data:www-data /var/www/html

USER www-data

# Exponer el puerto del PHP-FPM
EXPOSE 9000

# Lanzamos PHP-FPM y el Supervisor
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
