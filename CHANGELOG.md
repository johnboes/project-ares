# 📄 Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) where applicable.

---

## [v1.0.0] – 2025-04-11

### Added
- Full media stack: Plex, Radarr, Sonarr, Readarr, NZBGet, Prowlarr, Tautulli
- Full telemetry stack: Grafana, Prometheus, Telegraf, InfluxDB, Unifi Poller
- Overseerr container with public-facing request system
- Cloudflare Tunnel (Zero Trust) integration for exposing Overseerr without NAT
- Watchtower for automatic container image updates
- Created `.env.template` for reproducible environment configuration
- Full documentation of both stacks in `README.md`

---

## [v1.1.0] – 2025-04-12

### Added
- Introduced Gluetun container with built-in WireGuard support
- Routed all NZBGet traffic through Gluetun using `network_mode: service:gluetun`
- Added required Mullvad configuration via `.env`:
  - `WIREGUARD_PRIVATE_KEY`
  - `WIREGUARD_ADDRESSES`
- Verified IP tunneling using `wget https://ipinfo.io/ip` within NZBGet container
- Documented setup and usage in VPN section of `README.md`

### Changed
- Removed exposed `6789` port on NZBGet container to enforce isolated networking
- Applied `depends_on: [gluetun]` for service dependency control
- Cleaned up port sections and volume annotations in `media-stack.yml`

---

## [v1.2.0] – 2025-04-13

### Added
- Completed Telegraf integration with InfluxDB 2 for system telemetry
- Hardcoded InfluxDB connection values in `telegraf.conf` for stable communication
- Validated metrics collection via container network and Grafana dashboards
- Implemented automated GitHub webhook integration using [webhook](https://github.com/adnanh/webhook)
- Created secure Cloudflare Tunnel for webhook delivery at `https://webhook.tartarusonline.work/hooks/update`
- Added `git-webhook` service to `telemetry-stack.yml` with mounted `hooks.json` and shell executor
- Configured `git-pull.sh` to securely pull latest `main` branch and sync updates in real time
- Added Auto-pull Integration and Security Notes sections to `README.md`

### Security
- Webhook endpoint is protected via Cloudflare Zero Trust and does not expose ports publicly
- Verified webhook execution is limited to shell scope within mounted Git repo
- Ensured no credentials, tokens, or SSH secrets are included in the public repo

---

## [v1.4.0] – 2025-04-28

### Added
- Added read-only public dashboard view for Grafana (planned)
- Enabled multi-region WireGuard failover with dynamic Gluetun config (planned)
- Replaced `.env` secret loading with dynamic vault-sourced injection (planned)
- Created `core-monitoring.yml` to house foundational monitoring services: Grafana, InfluxDB, Prometheus, Cloudflared, and Git Webhook
- Migrated previously combined telemetry services out of `telemetry-stack.yml` into `core-monitoring.yml` for modular clarity
- Added `.envs/` directory to separate environment variables across stack domains
- Added `core-monitoring.env` for metrics infrastructure credentials
- Added `plex-stack.env` for Plex-specific and VPN (Gluetun) variables
- Established `.env.template-readme.md` to document expected variable groups per stack
- Added Makefile to facilitate modular stack lifecycle management (start, stop, pull, logs)
- Scaffolded `Makefile` with support for `up`, `down`, `logs`, and `rebuild` per stack
- Created poller subdirectory for UniFi Poller containers (`unpoller-aphrodite.yml`, `unpoller-cronus.yml`)
- Created `telegraf-configs/` for stack-specific telemetry configurations

### Changed
- Renamed `.env.template` to `.env.template-readme.md` and clarified purpose
- Deleted legacy `media-stack.yml` environment references; updated `plex-stack.yml` accordingly
- Validated Unifi Poller integration with InfluxDB using token-based authentication
- Verified hardcoded variable fallback when `.env` is omitted from stack context
- Modularized former `telemetry-stack.yml` into separate `core-monitoring.yml` and service-specific pollers and telegraf configs
- Renamed `media-stack.yml` to `plex-stack.yml` to reflect its exclusive role in Plex and NZB/media automation
- Created `env-templates/` and `envs/` directories to separate shared environment variable templates from live credentials
- Split previously unified `.env` into stack-specific `.env` files
- Rewrote `README.md` to reflect updated architecture, stacks, and service layout
- Added `.gitignore` rules to exclude `envs/` directory
- Updated VSCode project structure and environment management to reflect stack-scoped variables

---

## [v1.3.0] – 2025-05-12

### Added
- Created `calibre-stack.yml` to manage book and audiobook services in an isolated stack
- Added `calibre` service using `lscr.io/linuxserver/calibre` with persistent configuration and library volumes
- Added `calibre-web` frontend using `lscr.io/linuxserver/calibre-web`, dependent on `calibre`, exposing ports 8083 and 8084
- Defined service environment variables using scoped `.env` file for the stack
- Excluded Calibre configuration directories via `.gitignore`
- Documented Calibre stack behavior, volume structure, and service access in `README.md`

---