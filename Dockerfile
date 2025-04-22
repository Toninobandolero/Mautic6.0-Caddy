# Usa imagen base oficial de PHP 8.2 FPM sobre Debian Bookworm
FROM php:8.2-fpm-bookworm

# Argumento para la versión de Mautic
ARG MAUTIC_VERSION=6.0.0

# Variables de entorno útiles para PHP y Composer
ENV PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_ENABLE_CLI=1 \
    PHP_MEMORY_LIMIT=512M \
    PHP_MAX_EXECUTION_TIME=300 \
    PHP_UPLOAD_MAX_FILESIZE=100M \
    PHP_POST_MAX_SIZE=100M \
    COMPOSER_ALLOW_SUPERUSER=1 \
    MAUTIC_INSTALL_DIR="/var/www/html"

# Instalar dependencias del sistema y librerías -dev para extensiones PHP
# Incluye deps para curl, fcgi, imap y AHORA para nodejs (ca-certificates, curl, gnupg)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libsodium-dev \
    libgmp-dev \
    freetds-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    libfcgi-bin \
    libc-client-dev \
    libkrb5-dev \
    ca-certificates \
    curl \
    gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar Node.js (LTS v20) y npm (necesario para `npm ci` durante composer install)
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && NODE_MAJOR=20 \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install nodejs -y \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurar e instalar extensiones PHP en PASOS SEPARADOS
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    gd \
    intl \
    zip \
    curl \
    bcmath \
    sodium \
    exif \
    opcache \
    gmp \
    pcntl \
    sockets
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) imap

# Instalar Composer globalmente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear directorio de Mautic y establecer WORKDIR
RUN mkdir -p ${MAUTIC_INSTALL_DIR} && chown www-data:www-data ${MAUTIC_INSTALL_DIR}
WORKDIR ${MAUTIC_INSTALL_DIR}

# Descargar Mautic usando Composer create-project e instalar dependencias (incluyendo npm ci)
RUN set -eux; \
    composer create-project mautic/recommended-project:"~${MAUTIC_VERSION}" temp_mautic --no-interaction --no-install; \
    # Copiar todo (incluyendo ocultos) desde temp_mautic al directorio actual (.)
    cp -a temp_mautic/. . ; \
    # Borrar la carpeta temporal
    rm -rf temp_mautic; \
    # Ajustar configuración de Composer
    composer config --no-plugins allow-plugins.mautic/core-composer-scaffold true; \
    composer config --no-plugins allow-plugins.composer/installers true; \
    composer config --no-plugins allow-plugins.phpstan/extension-installer true; \
    # Ahora el composer install que ejecuta npm ci debería funcionar
    composer install --no-dev --optimize-autoloader; \
    # Limpiar caché
    composer clear-cache; \
    # Establecer permisos
    chown -R www-data:www-data .

# Exponer puerto FPM
EXPOSE 9000

# Comando por defecto
CMD ["php-fpm", "-F"]
