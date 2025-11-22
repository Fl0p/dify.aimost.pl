# Cloudflare Tunnel Configuration

This directory contains the configuration for Cloudflare Tunnel.

## Files

- `config.yml` - Tunnel configuration file
- `f8484957-8d98-4160-b207-6a3f9f9db5cf.json` - Tunnel credentials file (not in git, add manually)

## Setup

1. Place your tunnel credentials file (`f8484957-8d98-4160-b207-6a3f9f9db5cf.json`) in this directory.

2. The `credentials-file` path in `config.yml` is already configured for Docker (`/etc/cloudflared/f8484957-8d98-4160-b207-6a3f9f9db5cf.json`).

3. Start the tunnel using Docker Compose:
   ```bash
   docker-compose up -d cloudflared
   ```

   Or start all services including cloudflared:
   ```bash
   docker-compose up -d
   ```

## Running on Host (Alternative)

If you prefer to run cloudflared on the host instead of Docker:

1. Change `service: http://nginx:80` to `service: http://localhost:80` in `config.yml`
2. Change `credentials-file` to absolute path: `/Users/flop/Work/flop/dify.aimost.pl/cloudflared/f8484957-8d98-4160-b207-6a3f9f9db5cf.json`
3. Run:
   ```bash
   cloudflared tunnel --config ./cloudflared/config.yml run
   ```

## Configuration

The tunnel is configured to:
- Route `dify.aimost.pl` → `http://nginx:80` (Dify application running in Docker)
- Return 404 for all other requests

**Note:** The configuration is set up for Docker Compose deployment. Cloudflared runs in the same Docker network as nginx, so it can access nginx by service name.

Make sure your DNS in Cloudflare points to the tunnel.

