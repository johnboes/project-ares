# Infra Docker Stacks

This repository contains the Docker Compose configurations for my centralized media and telemetry platform.  
Services include Plex, Radarr, Sonarr, Readarr, NZBGet, Prowlarr, Tautulli, **Overseerr**, InfluxDB, Grafana, Prometheus, Telegraf, Unifi Poller, and Speedtest Exporter.

**Stacks:**
- `media-stack.yml`: Media automation and Plex ecosystem
- `telemetry-stack.yml`: Infrastructure and network monitoring

All sensitive credentials are stored in a separate `.env` file excluded from version control.