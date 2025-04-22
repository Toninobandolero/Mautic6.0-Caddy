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

## Requisitos
- Docker
- Docker Compose v2+

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

3. Levanta el stack:
   ```bash
   docker compose up -d --build
   ```

4. Accede a Mautic en https://localhost o el dominio configurado.

---

## Variables de entorno principales

- `.mautic_env`: Configuración de la base de datos y parámetros de Mautic
- `.env`: Variables de Docker Compose (versión, migraciones, etc.)

## ¿Cómo funciona este stack?

- **mautic_web**: Servicio PHP-FPM que ejecuta Mautic 6, construido desde el Dockerfile incluido.
- **db**: Servicio MySQL 8 para la base de datos de Mautic.
- **caddy**: Servidor web moderno que sirve archivos estáticos y aplicaciones PHP vía FastCGI, gestionando certificados SSL automáticamente.
- **Volúmenes**: Los directorios `config/`, `logs/` y `media/` se montan como volúmenes locales para persistencia.
- **Redes**: Todos los servicios están en la misma red Docker, y Caddy expone los puertos 80/443.

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
