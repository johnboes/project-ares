# Makefile for Docker Compose stack management

# --- Core Monitoring Stack ---
up-core:
	docker compose --env-file .envs/core-monitoring.env -f core-monitoring.yml up -d

down-core:
	docker compose --env-file .envs/core-monitoring.env -f core-monitoring.yml down

logs-core:
	docker compose --env-file .envs/core-monitoring.env -f core-monitoring.yml logs -f

# --- Plex Media Stack ---
up-plex:
	docker compose --env-file .envs/plex-stack.env -f plex-stack.yml up -d

down-plex:
	docker compose --env-file .envs/plex-stack.env -f plex-stack.yml down

logs-plex:
	docker compose --env-file .envs/plex-stack.env -f plex-stack.yml logs -f

rebuild-plex:
	docker compose --env-file .envs/plex-stack.env -f plex-stack.yml up -d --build --force-recreate

# --- Calibre Stack ---
up-calibre:
	docker compose --env-file .env -f calibre-stack.yml up -d

down-calibre:
	docker compose --env-file .env -f calibre-stack.yml down

logs-calibre:
	docker compose --env-file .env -f calibre-stack.yml logs -f

rebuild-calibre:
	docker compose --env-file .env -f calibre-stack.yml up -d --build --force-recreate