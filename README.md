# Project Ares

This repository contains my complete Docker Compose infrastructure for automating media ingestion, managing telemetry, and enabling secure public access using Cloudflare Zero Trust tunnels. Everything runs on a Synology RS1221+ (`Ares`) and is deployed through reproducible, version-controlled Compose files.

> ✅ Docker version: `24.0.7`, deployed using `docker-compose` v2+ syntax 

---

## 🧱 Stack Overview

### `plex-stack.yml`
Automates and organizes Plex-compatible media:

| Service     | Purpose                                       |
|-------------|-----------------------------------------------|
| **Plex**    | Media playback and library organization       |
| **Radarr**  | Movie download automation                     |
| **Sonarr**  | TV show download automation                   |
| **Readarr** | Book and audiobook automation                 |
| **NZBGet**  | Usenet downloader                             |
| **Prowlarr**| Indexer and search manager for the stack      |
| **Tautulli**| Tracks Plex usage and viewing metrics         |
| **Overseerr**| Allows friends to request content securely   |
| **Watchtower**| Automatically keeps containers updated      |

All media services are containerized and isolated on a shared custom network `tds_net`. Volumes are mounted from a dedicated Synology folder structure to ensure separation between config, downloads, and permanent storage.

---

### `core-monitoring.yml`
Provides complete infrastructure and network health telemetry:

| Service         | Purpose                                                  |
|----------------|----------------------------------------------------------|
| **Grafana**     | Dashboard frontend for metrics and logs                  |
| **InfluxDB 2**  | Time-series database for system stats and monitoring     |
| **Prometheus**  | Exporter collector (optional depending on exporter needs)|
| **Cloudflared** | Tunnel service exposing dashboards securely              |
| **Watchtower**  | Auto-updates for this stack                              |
| **Git Webhook** | Enables auto-pull from GitHub main branch on push       |

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

This config is located in the `core-monitoring.yml` and requires a working tunnel token added to your `.env`.

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

## 🔁 Auto-pull Integration

A GitHub webhook is configured to call a secure endpoint exposed via Cloudflare Tunnel. When changes are pushed to the `main` branch, the webhook triggers an update on the server and automatically pulls the latest version of the repo into production.

This is powered by:
- The `git-webhook` container defined in `core-monitoring.yml`
- A custom shell script stored at `/volume1/docker/git-webhook/hooks/git-pull.sh`
- A `hooks.json` configuration mounted into `/etc/webhook/` inside the container

---

## 🧩 Stack Structure and Naming

This repository is organized into modular stack files. Each `*.yml` defines a purpose-driven group of services. For example:

- `plex-stack.yml` handles all media automation and Plex-related services
- `core-monitoring.yml` runs central observability tools like Grafana and InfluxDB
- Future `.yml` files under `pollers/` will track regional devices like UniFi or Synology metrics using Telegraf or Unifi Poller

---

## 🔧 Makefile Commands

The following commands are available via `make` to streamline development:

- `make up-core` – Start core monitoring stack using `core-monitoring.env`
- `make up-plex` – Start Plex/media stack using `plex-stack.env`
- `make down-core` – Stop core stack
- `make logs-plex` – View logs from Plex/media services
- `make rebuild-plex` – Force rebuild of Plex stack

---

## 🛡 Security Notes

- No ports are exposed to the public internet
- All access is routed through Cloudflare Zero Trust tunnels
- GitHub webhooks do not reveal sensitive data and require an authenticated tunnel
- All environment variables and secrets (tokens, passwords, IPs) are stored in a private `.env` file and excluded from version control via `.gitignore`
- No Plex accounts, tokens, IPs, or webhook secrets are hardcoded

This setup follows InfoSec best practices and would meet expectations under SOC 2 Type II and ISO 27001 controls for secure infrastructure deployment and versioning.

---

## 🗂 Folder Structure

```text
infra-docker-stacks/
├── plex-stack.yml
├── core-monitoring.yml
├── Makefile
├── .envs/
│   ├── core-monitoring.env
│   └── plex-stack.env
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
├── cloudflared/
├── git-webhook/
└── watchtower/
```

---

## 📄 Environment Variables Template

Environment variables are now stored in per-stack `.env` files located in the `.envs/` folder. Use `.env.template` as a base.

Example: `plex-stack.env`, `core-monitoring.env`

---

## 📄 Changelog

For a full list of updates, see [CHANGELOG.md](./CHANGELOG.md).

---

## 📬 Questions?

Feel free to fork, adapt, or open an issue.

This is a personal project maintained and used in production on Synology hardware.