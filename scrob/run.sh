#!/bin/sh
set -e

# Read user options from /data/options.json (written by HA Supervisor)
SECRET_KEY=$(jq -r '.secret_key // ""' /data/options.json)
ENABLE_REGISTRATIONS=$(jq -r '.enable_registrations // false' /data/options.json)
TZ_VALUE=$(jq -r '.timezone // "America/Argentina/Buenos_Aires"' /data/options.json)

# ── Persistencia en /data (HA lo respalda) ────────────────────────────────
# La imagen omnibus declara VOLUME en /app/backend/data y /app/postgres/data,
# por lo que el Supervisor monta volumenes Docker anonimos ahi que se PIERDEN
# al recrear el contenedor. Para que los datos sobrevivan, desmontamos esos
# volumenes anonimos y bind-mounteamos nuestros directorios de /data sobre
# esos puntos (requiere SYS_ADMIN).
mkdir -p /data/backend /data/postgres
# Desmontar los volumenes anonimos (ignorar si no estan montados)
umount /app/backend/data 2>/dev/null || true
umount /app/postgres/data 2>/dev/null || true
# Bind-mountear /data sobre los puntos de la imagen
mount --bind /data/backend /app/backend/data
mount --bind /data/postgres /app/postgres/data

export PUID=1000
export PGID=1000
export TZ="$TZ_VALUE"

# Security
[ -n "$SECRET_KEY" ] && export SECRET_KEY

# Registrations
if [ "$ENABLE_REGISTRATIONS" = "true" ]; then
    export ENABLE_REGISTRATIONS="true"
fi

# Hand off to the upstream entrypoint (starts embedded Postgres + migrations + supervisord).
exec /entrypoint.omnibus.sh
