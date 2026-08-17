# Scrob — Documentation

## Overview

Scrob is an open-source, self-hosted media tracking app — your personal
Letterboxd + Trakt. This add-on runs Scrob inside Home Assistant using the
official `bellamy/scrob:latest-omnibus` image, which bundles the backend,
frontend and an embedded PostgreSQL database in a single container.

## First-time setup

1. Install the add-on and click **Start**
2. Open the Web UI via the **Open Web UI** button (or navigate to `http://YOUR-HA-IP:7330`)
3. Register your first user account — the first user automatically becomes the admin
4. Go to **Connections → Media Players** to connect Stremio, Jellyfin, Plex, Emby, Nuvio, etc.

## Configuration options

| Option | Default | Description |
|--------|---------|-------------|
| `secret_key` | — | **Required.** Generate with `openssl rand -hex 32`. Used to sign sessions. |
| `enable_registrations` | `false` | Allow additional users to register (first user is always the admin). |
| `timezone` | `America/Argentina/Buenos_Aires` | Timezone for the container. |
| `log_level` | `info` | Logging verbosity. |

## Connecting Stremio

1. In Scrob, go to **Connections → Media Players → Add Connection**
2. Choose **Stremio**, enter a connection name, and select **Connect Stremio**
3. Open the generated authorization link or scan its QR code, then approve the connection in Stremio
4. Return to Scrob — the page detects the authorization and creates the connection automatically

Scrob never asks for or stores your Stremio password. The Link flow returns an
account authorization key, stored server-side and redacted from frontend API
responses.

## Data persistence

All data (app data + embedded PostgreSQL) is stored under `/data` in the
add-on, which Home Assistant backs up automatically.

## Updating

The add-on pulls the latest `bellamy/scrob:latest-omnibus` image. To update,
click **Update** in the add-on page. Your data is preserved under `/data`.

## Troubleshooting

- **Port 7330 already in use** — change the `7330/tcp` port mapping in the add-on configuration.
- **First start is slow** — the embedded PostgreSQL initializes and runs migrations on first boot; this can take a minute or two.
- **Logs** — check the add-on log tab; Scrob logs to stdout/stderr.
