# Scrob — Home Assistant Add-on

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)

A Home Assistant add-on for [Scrob](https://github.com/ellite/scrob) — an
open-source, self-hosted media tracking app. Your personal Letterboxd + Trakt.

## Features

- **Multi-source sync** — import libraries, watched status and playback progress from Jellyfin, Plex, Emby, Nuvio, ARVIO and **Stremio**
- **Stremio integration** — sync your watch history, ratings and personal lists automatically
- **Real-time scrobbling** — webhooks from Jellyfin, Plex, Emby and Kodi update your watch state as you play
- **Trakt / Simkl / MDBList** — sync history, ratings and lists
- **Watch history & ratings** — track every movie and episode, rate on a 10-point scale with reviews
- **Personal lists, comments, social** — curate lists, follow other users
- **TMDB metadata** — posters, backdrops, cast, crew, trailers, collections
- **PWA** — installs as an app on any device

## Installation

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**
2. Click the **⋮** menu (top right) → **Repositories**
3. Add: `https://github.com/jpgimenez/ha-addon-scrob`
4. Find **Scrob** in the store and click **Install**

## First-time setup

1. Install the add-on and click **Start**
2. Open the Web UI via the **Open Web UI** button (or navigate to `http://YOUR-HA-IP:7330`)
3. Register your first user account — the first user automatically becomes the admin
4. Go to **Connections → Media Players** to connect Stremio, Jellyfin, Plex, etc.

See [DOCS.md](scrob/DOCS.md) for full documentation.

## Attribution

Powered by [Scrob](https://github.com/ellite/scrob) by ellite — [GPL-3.0 License](https://github.com/ellite/scrob/blob/main/LICENSE.md).

This add-on packages Scrob for Home Assistant. It is not affiliated with the
Scrob project or its maintainers.
