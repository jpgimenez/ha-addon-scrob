#!/bin/sh
set -e

# Read user options from /data/options.json (written by HA Supervisor)
SECRET_KEY=$(jq -r '.secret_key // ""' /data/options.json)
ENABLE_REGISTRATIONS=$(jq -r '.enable_registrations // false' /data/options.json)
TZ_VALUE=$(jq -r '.timezone // "America/Argentina/Buenos_Aires"' /data/options.json)

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
# Data persists in the Docker volumes the Supervisor mounts on /app/backend/data
# and /app/postgres/data (declared as VOLUME in the upstream image).
exec /entrypoint.omnibus.sh
