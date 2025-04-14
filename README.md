# Project Ares

This repository contains my complete Docker Compose infrastructure for automating media ingestion, managing telemetry, and enabling secure public access using Cloudflare Zero Trust tunnels. Everything runs on a Synology RS1221+ (`Ares`) and is deployed through reproducible, version-controlled Compose files.

> ✅ Docker version: `24.0.7`, deployed using `docker-compose` v2+ syntax

---

## 🧱 Stack Overview

### `media-stack.yml`
Automates and organizes Plex-compatible media:

| Service    | Purpose                                       |
|------------|-----------------------------------------------|
| **Plex**   | Media playback and library organization       |
| **Radarr** | Movie download automation                     |
| **Sonarr** | TV show download automation                   |
| **Readarr**| Book and audiobook automation                 |
| **NZBGet** | Usenet downloader                             |
| **Prowlarr**| Indexer and search manager for the stack     |
| **Tautulli**| Tracks Plex usage and viewing metrics        |
| **Overseerr**| Allows friends to request content securely  |
| **Watchtower**| Automatically keeps containers updated     |

All media services are containerized and isolated on a shared custom network `tds_net`. Volumes are mounted from a dedicated Synology folder structure to ensure separation between config, downloads, and permanent storage.

---

### `telemetry-stack.yml`
Provides complete infrastructure and network health telemetry:

| Service         | Purpose                                                  |
|----------------|----------------------------------------------------------|
| **Grafana**     | Dashboard frontend for metrics and logs                  |
| **InfluxDB 2**  | Time-series database for system stats and monitoring     |
| **Prometheus**  | Exporter collector (optional depending on exporter needs)|
| **Telegraf**    | Agent to collect system metrics across all NAS systems   |
| **Unifi Poller**| Tracks UDM Pro and UniFi switches/APs                    |
| **Cloudflared** | Tunnel service exposing dashboards securely              |
| **Watchtower**  | Auto-updates for this stack                              |

The full telemetry suite is deployed as containers and designed to be observable from anywhere, but only via Cloudflare’s Zero Trust model.

---

## 🔒 Public Access with Cloudflare Tunnel

I use [Cloudflare Tunnels](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) to safely expose internal services like Overseerr to the public web without directly opening ports.

### Why this is better than traditional port forwarding:
- End-to-end TLS encryption (HTTPS)
- Obfuscated origin IP
- Integrated with Cloudflare Zero Trust
- No changes to home firewall or NAT rules

### Tunnel Setup Process:
1. I generated a named tunnel from the Cloudflare dashboard.
2. I installed the `cloudflared` container and passed the `CLOUDFLARE_TUNNEL_TOKEN` via `.env`.
3. I created a hostname like `media.tartarusonline.work` and routed it to `http://overseerr:5055`.
4. Overseerr is now publicly available but remains protected by Cloudflare Access policies.

This config is located in the `telemetry-stack.yml` and requires a working tunnel token added to your `.env`.

---

## ✨ Overseerr Configuration

[Overseerr](https://overseerr.dev/) is the public-facing request layer. It allows trusted users to queue media downloads to Plex.

### Configuration notes:
- Overseerr is containerized and reachable at port `5055`.
- Overseerr is linked to Plex using local container subnet IP (e.g. `172.18.0.6`).
- Tautulli is integrated with Overseerr at `http://172.18.0.8:8181`, using a custom API key.
- Overseerr user auth is handled by Plex or local user accounts.
- All Overseerr traffic is tunneled through Cloudflare to enforce zero-trust access.

---

## 🗂 Folder Structure

```text
infra-docker-stacks/
├── media-stack.yml
├── telemetry-stack.yml
├── .env.template
└── README.md

/volume1/docker/
├── plex/
├── radarr/
├── sonarr/
├── readarr/
├── prowlarr/
├── nzbget/
├── overseerr/
├── tautulli/
├── influxdb/
├── grafana/
├── prometheus/
├── telegraf/
├── unifi-poller/
├── cloudflared/
└── watchtower/

##Environment Variables Template
TZ=
PUID=
PGID=

# Plex
PLEX_CLAIM=

# InfluxDB
INFLUXDB_URL=
INFLUXDB_ORG=
INFLUXDB_BUCKET=
INFLUXDB_TOKEN=

# Unifi Poller
UP_UNIFI_DEFAULT_USER=
UP_UNIFI_DEFAULT_PASS=
UP_UNIFI_DEFAULT_URL=

# Grafana
GF_SECURITY_ADMIN_USER=
GF_SECURITY_ADMIN_PASSWORD=

# Cloudflare Tunnel
CLOUDFLARE_TUNNEL_TOKEN=

## 📄 Changelog

For a full list of updates, see [CHANGELOG.md](./CHANGELOG.md).

## 📬 Questions?

Feel free to fork, adapt, or open an issue.

This is a personal project maintained and used in production on Synology hardware.
# Test webhook trigger
