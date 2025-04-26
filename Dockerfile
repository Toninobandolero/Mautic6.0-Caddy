FROM php:8.2-fpm-alpine

# Instala todo lo necesario directamente
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
    libpng \
    libzip \
    icu-libs \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql zip intl gd mbstring opcache

# Instalar composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar código de Mautic
WORKDIR /var/www/html
COPY . /var/www/html

# Permisos
RUN chown -R www-data:www-data /var/www/html

USER www-data

EXPOSE 9000

CMD ["php-fpm"]
