#!/bin/sh
set -e

# Read user options from /data/options.json (written by HA Supervisor)
SECRET_KEY=$(jq -r '.secret_key // ""' /data/options.json)
ENABLE_REGISTRATIONS=$(jq -r '.enable_registrations // false' /data/options.json)
TZ_VALUE=$(jq -r '.timezone // "America/Argentina/Buenos_Aires"' /data/options.json)

# ── Persistencia en /data (HA lo respalda) ────────────────────────────────
# La imagen omnibus declara VOLUME en /app/backend/data y /app/postgres/data,
# por lo que el Supervisor monta volumenes Docker anonimos ahi que se PIERDEN
# al recrear el contenedor. Para que los datos sobrevivan, parcheamos el
# entrypoint para que use /data directamente (sin mount --bind, que falla
# porque esos puntos ya son mounts del host).
mkdir -p /data/backend /data/postgres
# Reescribir las rutas hardcodeadas del entrypoint y supervisord hacia /data
sed -i 's|PGDATA=/app/postgres/data|PGDATA=/data/postgres|g' /entrypoint.omnibus.sh
sed -i 's|/app/backend/data|/data/backend|g' /entrypoint.omnibus.sh
sed -i 's|/app/postgres/data|/data/postgres|g' /entrypoint.omnibus.sh
sed -i 's|/app/postgres/data|/data/postgres|g' /etc/supervisor/supervisord.omnibus.conf
sed -i 's|/app/backend/data|/data/backend|g' /etc/supervisor/supervisord.omnibus.conf

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
