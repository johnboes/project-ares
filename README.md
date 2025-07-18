# Project Ares

> ✅ Docker Version: `24.0.7` using Compose v2 syntax  
> 🌐 Secure Access via Cloudflare Zero Trust

---

## 📖 Project Description

Project Ares is a modular Docker Compose infrastructure running on a Synology RS1221+ server (`Ares`). It is designed to automate media ingestion, ebook management, enable secure remote access, provide full-stack observability, and simplify infrastructure management across home networks and hardware using open-source telemetry tooling.

This system acts as a self-hosted, fully Usenet-enabled Plex media server, VPN-cloaked downloader, multi-site network observer, ebook library (Calibre, Calibre-web, Readarr), secure public access gateway (Cloudflare Tunnel), and infrastructure manager (Portainer). It collects system and network telemetry from Synology servers, Plex performance data, and UniFi Dream Machine metrics across two physical locations (NYC and VA).

---

## 🧱 Stack Overview

### `plex-stack.yml`
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
| Portainer       | Docker infrastructure management UI                   |

All containers use the `media_net` network and mount to a structured folder tree under `/volume1/docker`. Download and storage volumes are mapped for Plex compatibility and performance.

---

### `core-monitoring.yml`
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

### `calibre-stack.yml`
Orchestrates ebook management and automation services:

| Service         | Purpose                                               |
|----------------|--------------------------------------------------------|
| Calibre        | Ebook library management and conversion                |
| Calibre-web    | Web frontend for Calibre library                       |
| Readarr        | Ebook and audiobook automation (Usenet integration)    |

All containers use the `books_net` network and mount to structured folders for books, configs, and scripts. Designed for seamless ebook ingestion and integration with the rest of the media stack.

---

## 🚦 First-Time Setup

Before launching any stacks, create the required Docker networks (only needed once per host):

```sh
docker network create media_net
docker network create books_net
docker network create monitoring_net
```

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
2. Create your `.env` file from the template:
   ```bash
   cp env-templates/infra-docker-stacks.env.template .env
   ```
3. Modify `.env` with your credentials, tokens, and secrets.
4. Launch the stack(s):
   ```bash
   make up-core
   make up-plex
   make up-calibre   # (optional) Start ebook stack
   ```
5. (Optional) Add more pollers or Telegraf agents by copying and configuring `.yml` + `.conf` files.

---

## 🗂 File Structure

```text
project-ares/
├── core-monitoring.yml
├── plex-stack.yml
├── calibre-stack.yml
├── pollers/
│   ├── unpoller-cronus.yml
│   └── unpoller-aphrodite.yml
├── telegraf-configs/
│   ├── telegraf-ares.conf
│   ├── telegraf-cerberus.conf
│   ├── telegraf-plex.conf
│   └── telegraf-prometheus.conf
├── env-templates/
│   ├── infra-docker-stacks.env.template
│   └── README.md
├── infra-docker-stacks.env
├── Makefile
├── .gitignore
├── README.md
├── CHANGELOG.md
└── portainer-data/   # (if using Portainer)
```

---

## 📝 Notes & Tips

- **Customizing Volume Paths:**
  - The Compose files assume certain volume paths (e.g., `/volume1/docker/plex/config`). Adjust these as needed for your environment.
- **Multi-Network Services:**
  - If a service needs to communicate across stacks, you can attach it to multiple networks. Example:
    ```yaml
    readarr:
      networks:
        - media_net
        - books_net
    ```
- **Adding Pollers/Telegraf Agents:**
  - To add a new poller or agent, copy a `.yml` and `.conf` file from the `pollers/` or `telegraf-configs/` directories, adjust as needed, and launch with Docker Compose.
- **Environment Files:**
  - By default, the Makefile uses a single `.env` file for all stacks. For advanced setups, you can use per-stack `.env` files by updating the Makefile and Compose commands accordingly.

---

## 🛡 Security Notes

- No ports are exposed
- Access requires a valid Cloudflare Tunnel token
- Secrets are stored in git-ignored `.envs/*.env` files
- API tokens are not hardcoded
- Zero-trust posture enforced across all public-facing services

This structure aligns with SOC 2 Type II and ISO 27001 practices.

---

## 📄 Changelog

See [CHANGELOG.md](./CHANGELOG.md) for detailed updates.