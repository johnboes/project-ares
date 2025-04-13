# 📄 Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html) when applicable.

---

## [Unreleased]
- [Planned] Add read-only public dashboard for Grafana
- [Planned] Enable multi-region WireGuard failover support
- [Planned] Harden .env secrets with automated vault sourcing

---

## [v1.1.0] – 2025-04-13
### Added
- Gluetun VPN container to route NZBGet through Mullvad WireGuard
- WireGuard variables added to `.env.template`
- Full documentation for VPN integration and private IP verification
- `README.md` enhancements for VPN section and public tunneling via Cloudflare

### Changed
- NZBGet `ports` section removed in favor of `network_mode: service:gluetun`
- Minor cleanup of network section in `media-stack.yml`

---

## [v1.0.0] – 2025-04-12
### Added
- Full media stack: Plex, Radarr, Sonarr, Readarr, NZBGet, Prowlarr, Tautulli
- Full telemetry stack: Grafana, Prometheus, Telegraf, InfluxDB, Unifi Poller
- Overseerr configuration for public-facing content requests
- Cloudflare Tunnel (Zero Trust) to expose Overseerr securely
- Watchtower auto-update container across both stacks
- `.env.template` and full stack documentation in `README.md`

---

## 📌 Notes
- All configs are run on `Ares`, a Synology RS1221+ unit.
- All IPs and tokens are handled via `.env` and excluded from commits.