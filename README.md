# Project Ares

Project Ares is a modular Docker Compose infrastructure running on a Synology RS1221+ server (`Ares`). It is designed to automate media ingestion, enable secure remote access, and provide full-stack observability across home networks and hardware using open-source telemetry tooling.

This system acts as a self-hosted, fully Usenet-enabled Plex media server, VPN-cloaked downloader, and multi-site network observer. It collects system and network telemetry from Synology servers, Plex performance data, and UniFi Dream Machine metrics across two physical locations (NYC and VA).

> ✅ Docker Version: `24.0.7` using Compose v2 syntax  
> 🌐 Secure Access via Cloudflare Zero Trust

---

## 🧱 Stack Overview

### `plex-stack.yml`

Orchestrates automated media ingestion, Plex service delivery, and telemetry integrations.

| Service         | Purpose                                               |
|----------------|--------------------------------------------------------|
| Plex            | Media playback and library management                 |
| Radarr          | Movie automation via Usenet                           |
| Sonarr          | TV automation                                         |
| Readarr         | Audiobook and book automation                         |
| NZBGet          | Usenet downloader                                     |
| Prowlarr        | Indexer and search proxy                              |
| Tautulli        | Plex usage and performance tracking                   |
| Overseerr       | Public-facing media request frontend                  |
| Watchtower      | Container auto-updater                                |
| Gluetun (VPN)   | WireGuard proxy for anonymized Usenet traffic         |

All containers share the `tds_net` network and mount to a structured folder tree under `/volume1/docker`. Download and storage volumes are mapped for Plex compatibility and performance.

---

### `core-monitoring.yml`

Captures system metrics, network telemetry, and exposes dashboards securely via Cloudflare:

| Service         | Purpose                                                 |
|----------------|----------------------------------------------------------|
| Grafana         | Metrics dashboards and visualizations                   |
| InfluxDB v2     | Time-series DB for telemetry ingest                     |
| Prometheus      | Exporter collector (optional for Telegraf usage)        |
| Cloudflared     | Secure public access via Cloudflare Tunnel              |
| Git Webhook     | Auto-pull on GitHub `main` push                         |
| Watchtower      | Auto-update services in this stack                      |

Designed to observe and monitor infrastructure across multiple LANs with full TLS encryption and no exposed ports.

---

## 🚀 Getting Started

### Prerequisites

- Docker `24.x`
- Docker Compose v2
- Synology DSM with SSH access
- `make` installed (optional but recommended)

### Initial Setup

1. Clone this repo:
   ```bash
   git clone https://github.com/your-user/infra-docker-stacks.git
   cd infra-docker-stacks
   ```

2. Create `.env` files from templates:
   ```bash
   cp env-templates/core-monitoring.env.template envs/core-monitoring.env
   cp env-templates/plex-stack.env.template envs/plex-stack.env
   ```

3. Modify those `.env` files with your credentials, tokens, and secrets.

4. Launch the stack:
   ```bash
   make up-core
   make up-plex
   ```

5. (Optional) Add more pollers or Telegraf agents by copying and configuring `.yml` + `.conf` files.

---

## 🔒 Zero Trust Public Access

Cloudflare Tunnel allows you to expose services like Overseerr or Grafana without opening ports.

### Key Advantages:
- No port forwarding or firewall rules
- End-to-end HTTPS (TLS)
- Identity-based access via Cloudflare Access
- Obfuscated origin and IPs

Note: Cloudflare Access policies must be configured via the Zero Trust dashboard at [dash.teams.cloudflare.com](https://dash.teams.cloudflare.com).

---

## 📡 Telemetry Coverage

Metrics are collected from:

- 3 Synology NAS devices (using Telegraf)
- 1 Plex server (via Tautulli)
- 2 UniFi gateways (UDM Pro, UDM Base) using UniFi Poller
- Containerized apps and resource usage
- InfluxDB serves as a unified telemetry sink

Each Telegraf or UniFi Poller instance is defined in its own `.yml` and `.env` file for modularization and clarity.

---

## 🧩 Stack Modularity

This repo is structured for maintainability:

- `core-monitoring.yml` – Central observability services
- `plex-stack.yml` – Media ingestion and playback services
- `pollers/` – Individual telemetry collectors for remote endpoints
- `telegraf-configs/` – INI configs for Telegraf agents
- `env-templates/` – Template `.env` files for onboarding
- `envs/` – Real, git-ignored `.env` files per stack

---

## 🧰 Makefile Commands

To streamline stack orchestration:

```bash
make up-core          # Start core monitoring stack
make up-plex          # Start Plex/media services
make down-core        # Stop monitoring stack
make logs-plex        # Tail logs from Plex services
make rebuild-plex     # Rebuild Plex/media containers
```

---

## 🛡 Security Notes

- No ports are exposed
- Access requires a valid Cloudflare Tunnel token
- Secrets are stored in git-ignored `.envs/*.env` files
- API tokens are not hardcoded
- Zero-trust posture enforced across all public-facing services

This structure aligns with SOC 2 Type II and ISO 27001 practices.

---

## 🗂 File Structure

```text
infra-docker-stacks/
├── core-monitoring.yml
├── plex-stack.yml
├── pollers/
│   ├── unpoller-cronus.yml
│   └── unpoller-aphrodite.yml
├── telegraf-configs/
│   ├── telegraf-ares.conf
│   ├── telegraf-cerberus.conf
│   └── telegraf-plex.conf
├── env-templates/
│   ├── core-monitoring.env.template
│   └── plex-stack.env.template
├── envs/
│   ├── core-monitoring.env
│   └── plex-stack.env
├── Makefile
├── .gitignore
├── .env.template
├── README.md
└── CHANGELOG.md
```

---

## 📄 Changelog

See [CHANGELOG.md](./CHANGELOG.md) for detailed updates.