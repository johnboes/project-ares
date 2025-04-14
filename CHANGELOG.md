# 📄 Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) where applicable.

---

## [Unreleased]
- [Planned] Add read-only public dashboard view for Grafana
- [Planned] Enable multi-region WireGuard failover with dynamic Gluetun config
- [Planned] Replace `.env` secret loading with dynamic vault-sourced injection

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
- Added `Auto-pull Integration` and `Security Notes` sections to `README.md`

### Security
- Webhook endpoint is protected via Cloudflare Zero Trust and does not expose ports publicly
- Verified webhook execution is limited to shell scope within mounted Git repo
- Ensured no credentials, tokens, or SSH secrets are included in the public repo

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

## 📌 Notes
- All configurations run on `Ares`, a Synology RS1221+ NAS.
- Environment variables, tokens, and API keys are excluded from Git via `.gitignore`.
- All public access is encrypted via HTTPS and routed through Cloudflare tunnels.