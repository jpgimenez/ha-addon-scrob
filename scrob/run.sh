#!/bin/sh
set -e

# Read user options from /data/options.json (written by HA Supervisor)
SECRET_KEY=$(jq -r '.secret_key // ""' /data/options.json)
ENABLE_REGISTRATIONS=$(jq -r '.enable_registrations // false' /data/options.json)
TZ_VALUE=$(jq -r '.timezone // "America/Argentina/Buenos_Aires"' /data/options.json)

# Persistent storage — all under /data (HA backs this up automatically)
# The omnibus image stores app data and embedded Postgres under /app/backend/data
# and /app/postgres/data. Symlink both to /data so HA backs them up.
mkdir -p /data/backend /data/postgres
ln -sfn /data/backend /app/backend/data
ln -sfn /data/postgres /app/postgres/data

export PUID=1000
export PGID=1000
export TZ="$TZ_VALUE"

# Security
[ -n "$SECRET_KEY" ] && export SECRET_KEY

# Registrations
if [ "$ENABLE_REGISTRATIONS" = "true" ]; then
    export ENABLE_REGISTRATIONS="true"
fi

# Hand off to the upstream entrypoint (starts embedded Postgres + migrations + supervisord)
exec /entrypoint.omnibus.sh
