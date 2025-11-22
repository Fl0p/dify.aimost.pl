# Cloudflare Tunnel Configuration

This directory contains the configuration for Cloudflare Tunnel.

## Files

- `config.yml` - Tunnel configuration file
- `credentials.json` - Tunnel credentials file (not in git, add manually)

## Setup

1. Update the `tunnel` ID in `config.yml` with your own tunnel ID.

2. Place your tunnel credentials file (`credentials.json`) in this directory.

3. The `credentials-file` path in `config.yml` is already configured for Docker (`/etc/cloudflared/credentials.json`).

4. Start the tunnel using Docker Compose:
   ```bash
   docker-compose up -d cloudflared
   ```

   Or start all services including cloudflared:
   ```bash
   docker-compose up -d
   ```
## Configuration

The tunnel is configured to:
- Route `dify.aimost.pl` → `http://nginx:80` (Dify application running in Docker)
- Return 404 for all other requests

**Note:** The configuration is set up for Docker Compose deployment. Cloudflared runs in the same Docker network as nginx, so it can access nginx by service name.

Make sure your DNS in Cloudflare points to the tunnel.

