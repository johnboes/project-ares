# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Environment Templates**: Renamed `env-templates/infra-docker-stacks.env.template` to `.env.template` following industry standards
- **Documentation**: Updated README.md to reflect new template structure and simplified setup instructions

### Planned
- Read-only public dashboard view for Grafana
- Multi-region WireGuard failover with dynamic Gluetun configuration

## [1.4.0] - 2025-04-28

### Added
- **Core Monitoring Stack**: Created `core-monitoring.yml` for foundational monitoring services
  - Grafana, InfluxDB, Prometheus, Cloudflared, and Git Webhook
- **Environment Management**: Modular environment variable organization
  - Added `.envs/` directory for stack-specific environment files
  - Created `core-monitoring.env` for metrics infrastructure credentials
  - Created `plex-stack.env` for Plex-specific and VPN variables
  - Established `.env.template-readme.md` for variable documentation
- **Automation**: Added Makefile for modular stack lifecycle management
  - Support for `up`, `down`, `logs`, and `rebuild` operations per stack
- **Monitoring Infrastructure**: Enhanced telemetry and polling capabilities
  - Created `poller/` subdirectory for UniFi Poller containers
  - Added `unpoller-aphrodite.yml` and `unpoller-cronus.yml`
  - Created `telegraf-configs/` for stack-specific telemetry configurations

### Changed
- **Architecture**: Modularized telemetry stack for improved organization
  - Migrated services from `telemetry-stack.yml` to `core-monitoring.yml`
  - Renamed `media-stack.yml` to `plex-stack.yml` for clarity
- **Environment Management**: Improved security and organization
  - Split unified `.env` into stack-specific files
  - Created `env-templates/` and `envs/` directories
  - Added `.gitignore` rules to exclude `envs/` directory
- **Documentation**: Updated `README.md` to reflect new architecture and service layout
- **Validation**: Verified Unifi Poller integration with InfluxDB using token-based authentication

## [1.3.0] - 2025-05-12

### Added
- **Calibre Stack**: New isolated stack for book and audiobook management
  - `calibre` service using `lscr.io/linuxserver/calibre` with persistent volumes
  - `calibre-web` frontend using `lscr.io/linuxserver/calibre-web`
  - Service dependency management and port exposure (8083, 8084)
  - Scoped environment variables for the stack
- **Documentation**: Comprehensive Calibre stack documentation in `README.md`
- **Security**: Excluded Calibre configuration directories via `.gitignore`

## [1.2.0] - 2025-04-13

### Added
- **Telegraf Integration**: Complete system telemetry with InfluxDB 2
  - Hardcoded InfluxDB connection values for stable communication
  - Metrics collection validation via container network and Grafana dashboards
- **Automated Deployment**: GitHub webhook integration for real-time updates
  - Implemented using [webhook](https://github.com/adnanh/webhook)
  - Secure Cloudflare Tunnel delivery at `https://webhook.tartarusonline.work/hooks/update`
  - `git-webhook` service with mounted `hooks.json` and shell executor
  - `git-pull.sh` for secure main branch synchronization

### Security
- **Webhook Protection**: Cloudflare Zero Trust integration without public port exposure
- **Execution Scope**: Limited webhook execution to shell scope within mounted Git repo
- **Credential Security**: Verified no credentials, tokens, or SSH secrets in public repo

## [1.1.0] - 2025-04-12

### Added
- **VPN Integration**: Gluetun container with WireGuard support
  - Mullvad VPN configuration via environment variables
  - Required keys: `WIREGUARD_PRIVATE_KEY`, `WIREGUARD_ADDRESSES`
  - NZBGet traffic routing through Gluetun using `network_mode: service:gluetun`
  - IP tunneling verification using `wget https://ipinfo.io/ip`
- **Documentation**: VPN setup and usage documentation in `README.md`

### Changed
- **Network Security**: Removed exposed port 6789 on NZBGet container
- **Service Dependencies**: Applied `depends_on: [gluetun]` for proper startup order
- **Configuration**: Cleaned up port sections and volume annotations in `media-stack.yml`

## [1.0.0] - 2025-04-11

### Added
- **Media Stack**: Complete media management solution
  - Plex, Radarr, Sonarr, Readarr, NZBGet, Prowlarr, Tautulli
  - Overseerr container with public-facing request system
- **Telemetry Stack**: Comprehensive monitoring and metrics
  - Grafana, Prometheus, Telegraf, InfluxDB, Unifi Poller
- **Infrastructure**: Production-ready deployment features
  - Cloudflare Tunnel (Zero Trust) integration for Overseerr exposure
  - Watchtower for automatic container image updates
  - `.env.template` for reproducible environment configuration
- **Documentation**: Complete stack documentation in `README.md`