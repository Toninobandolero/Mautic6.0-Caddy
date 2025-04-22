# Mautic6.0-Caddy

Este proyecto te permite levantar un entorno de **Mautic 6** usando Docker Compose y Caddy como servidor web, sin Apache. Es ideal para producción y desarrollo moderno, y está mantenido por [Toninobandolero](https://github.com/Toninobandolero).

Repositorio oficial: [https://github.com/Toninobandolero/Mautic6.0-Caddy](https://github.com/Toninobandolero/Mautic6.0-Caddy)

---

## Características
- Basado en PHP-FPM y Caddy (sin Apache)
- Compatible con Mautic 6.x
- Volúmenes persistentes para configuración, medios y logs
- Fácil de actualizar y mantener
- Listo para HTTPS automático con Caddy
- Integración con red externa y servicio Caddy para servir Mautic

## Requisitos
- Docker
- Docker Compose v2+
- Una red Docker externa llamada `mautic-caddy` (usada por Caddy para exponer Mautic)

## Uso rápido

1. Clona el repositorio:
   ```bash
   git clone https://github.com/Toninobandolero/Mautic6.0-Caddy.git
   cd Mautic6.0-Caddy
   ```

2. Copia y edita las variables de entorno:
   ```bash
   cp .mautic_env.example .mautic_env
   cp .env.example .env
   # Edita los archivos para tus credenciales y preferencias
   ```

3. Si no tienes la red externa para Caddy, créala:
   ```bash
   docker network create mautic-caddy
   ```

4. Levanta el stack:
   ```bash
   docker compose up -d --build
   ```

5. Asegúrate de tener el servicio **Caddy** (puedes usar el ejemplo de Caddyfile incluido) conectado a la red `mautic-caddy` y sirviendo `/var/www/html` de Mautic vía FastCGI (PHP-FPM).

6. Accede a Mautic en https://localhost o el dominio configurado en Caddy.

---

## ¿Cómo funciona este stack?

- **mautic_web**: Servicio PHP-FPM que ejecuta Mautic 6, construido desde el Dockerfile incluido.
- **db**: Servicio MySQL 8 para la base de datos de Mautic.
- **caddy**: (No incluido en este compose, pero recomendado) Servidor web moderno que sirve archivos estáticos y aplicaciones PHP vía FastCGI, gestionando certificados SSL automáticamente. Debe estar en la red `mautic-caddy` y tener un `Caddyfile` adecuado (ver ejemplo en el repo).
- **Volúmenes**: Los directorios `config/`, `logs/` y `media/` se montan como volúmenes locales para persistencia.
- **Redes**: Todos los servicios están en la red interna por defecto y, para exponer Mautic, también en la red externa `mautic-caddy`.

## Red Docker y Caddy

Este stack asume que tienes (o vas a crear) una red Docker externa llamada `mautic-caddy`. Así, Caddy puede estar en otro contenedor (o máquina) y servir Mautic de forma segura y eficiente. Si usas otro nombre de red, ajusta el `docker-compose.yml` y el Caddyfile.

## Ejemplo de Caddyfile

```Caddyfile
mautic.tudominio.com {
    root * /var/www/html
    encode gzip
    php_fastcgi mautic_web:9000
    file_server
    log {
        output stdout
        format console
    }
}
```

Asegúrate de montar el directorio de Mautic en el contenedor de Caddy y de que ambos estén en la red `mautic-caddy`.

## Actualizar el código fuente de Mautic

Para actualizar Mautic, cambia la variable `SOFTWARE_VERSION_TAG` en `.env` y ejecuta:

```bash
docker compose build --no-cache mautic_web mautic_cron mautic_worker
```

## Volúmenes
- `config/` → Configuración persistente de Mautic
- `logs/` → Logs de la aplicación
- `media/` → Archivos subidos

## Seguridad
- No subas tus archivos de configuración real ni datos sensibles.
- El archivo `.gitignore` ya protege los directorios de datos y variables sensibles.

## Licencia
MIT

## Créditos
Basado en la comunidad Mautic y la integración moderna con Caddy. Mantenido por [Toninobandolero](https://github.com/Toninobandolero).
