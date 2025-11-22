# Dify Deployment for dify.aimost.pl

Deployment guide for Dify on a host using Docker Compose.

## Requirements

- Docker version 20.10 or higher
- Docker Compose version 2.0 or higher
- Minimum 4GB RAM
- Minimum 20GB free disk space

## Quick Start

### 1. Clone Repository

```bash
git clone <repository-url>
cd dify.aimost.pl
```

### 2. Configure Environment Variables

Copy the example configuration file and customize it:

```bash
cp .env.example .env
```

Edit the `.env` file and replace the following values:

#### Required Security Changes

**⚠️ IMPORTANT:** Generate secure passwords for production:

```bash
# Database password
DB_PASSWORD=$(openssl rand -hex 16)

# Redis password
REDIS_PASSWORD=$(openssl rand -hex 16)

# Secret key for application (hex format recommended to avoid special characters)
SECRET_KEY=$(openssl rand -hex 32)

# Weaviate API key
WEAVIATE_API_KEY=$(openssl rand -hex 32)

# Sandbox API key
SANDBOX_API_KEY=$(openssl rand -hex 32)

# Plugin daemon key
PLUGIN_DAEMON_KEY=$(openssl rand -hex 32)

# Plugin Dify inner API key
PLUGIN_DIFY_INNER_API_KEY=$(openssl rand -hex 32)
```

#### Domain Configuration

Replace `your-domain.com` with your actual domain in:
- **NGINX_SERVER_NAME**
- **CONSOLE_API_URL**
- **CONSOLE_WEB_URL**
- **SERVICE_API_URL**
- **APP_API_URL**
- **APP_WEB_URL**
- **FILES_URL**

#### Optional Settings

- **INIT_PASSWORD** - password for the first administrator (or leave empty to set during first login)

### 3. Start Services

Start all services:

```bash
docker-compose up -d
```

Check status:

```bash
docker-compose ps
```

View logs:

```bash
docker-compose logs -f
```

### 4. Setup Cloudflare Tunnel

Cloudflare Tunnel provides secure access without exposing ports or managing SSL certificates.

**Advantages:**
- No need to expose ports 80/443
- SSL certificates managed automatically by Cloudflare
- No need for Certbot/Let's Encrypt
- Enhanced security (no direct internet access)

**Setup:**

1. Install Cloudflare Tunnel (cloudflared):
   ```bash
   # macOS
   brew install cloudflared
   
   # Linux
   wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
   chmod +x cloudflared-linux-amd64
   sudo mv cloudflared-linux-amd64 /usr/local/bin/cloudflared
   ```

2. Authenticate:
   ```bash
   cloudflared tunnel login
   ```

3. Create a tunnel:
   ```bash
   cloudflared tunnel create dify
   ```

4. Place your tunnel credentials file in `./cloudflared/`:
   - Copy your tunnel credentials file (e.g., `credentials.json`) to `./cloudflared/`
   - The configuration file `./cloudflared/config.yml` is already prepared

5. Start the tunnel using Docker Compose:
   ```bash
   docker-compose up -d cloudflared
   ```
   
   Or start all services including cloudflared:
   ```bash
   docker-compose up -d
   ```

6. Configure DNS in Cloudflare dashboard to point to your tunnel.

**Configuration:**
- Ports 80/443 don't need to be exposed (nginx works internally)
- SSL is handled automatically by Cloudflare

## Project Structure

```
.
├── docker-compose.yaml      # Main Docker Compose file
├── .env                     # Configuration file (created from .env.example)
├── .env.example             # Example configuration
├── volumes/                 # Data directories
│   ├── app/storage/         # Application files
│   ├── db/data/             # PostgreSQL data
│   ├── redis/data/          # Redis data
│   └── ...
├── nginx/                   # Nginx configuration
├── ssrf_proxy/              # SSRF proxy configuration
├── cloudflared/             # Cloudflare Tunnel configuration
│   ├── config.yml           # Tunnel configuration
│   └── README.md            # Tunnel setup instructions
└── startupscripts/          # Initialization scripts
├── clean.sh                 # Cleanup script
├── start.sh                 # Start script
├── stop.sh                  # Stop script
```

## Common Commands

### Service Management

```bash
# Start all services
./start.sh

# Stop all services
./stop.sh

# Restart services
docker-compose restart

# View logs
docker-compose logs -f [service_name]

# Check status
docker-compose ps

# Clean up (WARNING: deletes all data!)
./clean.sh
```

### Database Operations

```bash
# Connect to PostgreSQL
docker-compose exec db psql -U postgres -d dify

# Create database backup
docker-compose exec db pg_dump -U postgres dify > backup.sql

# Restore from backup
docker-compose exec -T db psql -U postgres dify < backup.sql
```

### Updating Dify

```bash
# Stop services
docker-compose down

# Update images
docker-compose pull

# Start with new images
docker-compose up -d

# Apply database migrations (runs automatically)
```

## Vector Database Configuration

By default, Weaviate is used. To use another vector database:

1. Change `VECTOR_STORE` in `.env` (e.g., `qdrant`, `pgvector`, `milvus`)
2. Start the corresponding profile:

```bash
# For Qdrant
docker-compose --profile qdrant up -d qdrant

# For pgvector
docker-compose --profile pgvector up -d pgvector

# For Milvus
docker-compose --profile milvus up -d milvus-standalone
```

## Useful Links

- **Web Interface**: https://dify.aimost.pl
- **API Documentation**: https://dify.aimost.pl/swagger-ui.html
- **Official Dify Documentation**: https://docs.dify.ai

## Troubleshooting

### Permission Issues

If you encounter permission issues with volumes:

```bash
sudo chown -R $USER:$USER volumes/
```

### Port Conflicts

**Note:** Port 80 is only needed if exposing nginx directly (not recommended with Cloudflare Tunnel).

If exposing nginx directly, make sure port 80 is available:

```bash
sudo lsof -i :80
```

For Cloudflare Tunnel, ports don't need to be exposed externally.

### View Logs for Diagnostics

```bash
# Logs for all services
docker-compose logs

# Logs for specific service
docker-compose logs api
docker-compose logs nginx
docker-compose logs db
```

### Cleanup and Restart

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: will delete all data!)
docker-compose down -v

# Clean up unused images
docker system prune -a
```

## Security

⚠️ **IMPORTANT for production:**

1. Change all default passwords in `.env`
2. Generate a new `SECRET_KEY`
3. Set a strong `INIT_PASSWORD`
4. Configure firewall to restrict access to database and Redis ports
5. Regularly update Docker images
6. Make regular database backups
7. **Recommended:** Use Cloudflare Tunnel instead of exposing ports directly

## Support

If you encounter issues, check:
- Service logs: `docker-compose logs`
- Container status: `docker-compose ps`
- Configuration in `.env`
- Dify documentation: https://docs.dify.ai
