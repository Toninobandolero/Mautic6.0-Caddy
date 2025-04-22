# Mautic6.0-Caddy
Este proyecto te permite levantar un entorno de Mautic 6 usando Docker Compose y Caddy como servidor web, sin Apache, ideal para producción y desarrollo moderno.
=======
# Mautic 6 + Docker Compose + Caddy (sin Apache)

Este proyecto te permite levantar un entorno de Mautic 6 usando Docker Compose y Caddy como servidor web, sin Apache, ideal para producción y desarrollo moderno.

## Características
- Basado en PHP-FPM y Caddy (sin Apache)
- Compatible con Mautic 6.x
- Volúmenes persistentes para configuración, medios y logs
- Fácil de actualizar y mantener
- Listo para HTTPS automático con Caddy

## Requisitos
- Docker
- Docker Compose v2+

## Uso rápido

1. Clona el repositorio:
   ```bash
   git clone https://github.com/TU_USUARIO/TU_REPO.git
   cd TU_REPO
   ```

2. Copia y edita las variables de entorno:
   ```bash
   cp .mautic_env.example .mautic_env
   cp .env.example .env
   # Edita los archivos para tus credenciales y preferencias
   ```

3. Levanta el stack:
   ```bash
   docker compose up -d --build
   ```

4. Accede a Mautic en https://localhost o el dominio configurado.

## Variables de entorno principales

- `.mautic_env`: Configuración de la base de datos y parámetros de Mautic
- `.env`: Variables de Docker Compose (versión, migraciones, etc.)

## Actualizar el código fuente de Mautic

Para actualizar Mautic, puedes reconstruir la imagen cambiando la variable `SOFTWARE_VERSION_TAG` en `.env` y ejecutando:

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
Basado en la comunidad Mautic y la integración moderna con Caddy.
>>>>>>> 76c5327 (Initial commit: Mautic 6 + Docker Compose + Caddy)
