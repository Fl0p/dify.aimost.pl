#!/bin/bash

# Stop and clean all services including volumes
echo "Stopping all services and removing volumes..."
docker-compose down -v

echo "Cleaning local volumes data..."
read -p "Are you sure you want to delete all data? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    # Function to clean directory preserving .gitkeep and config files
    clean_dir() {
        local dir=$1
        if [ -d "$dir" ]; then
            find "$dir" -mindepth 1 -maxdepth 1 ! -name '.gitkeep' ! -name '*.example' ! -name 'config.yaml' -exec rm -rf {} +
        fi
    }
    
    # Clean database data (preserve .gitkeep)
    clean_dir "volumes/db/data"
    clean_dir "volumes/pgvector/data"
    
    # Clean vector databases (preserve .gitkeep)
    clean_dir "volumes/chroma"
    clean_dir "volumes/milvus"
    clean_dir "volumes/qdrant"
    clean_dir "volumes/weaviate"
    
    # Clean search data (preserve .gitkeep)
    clean_dir "volumes/opensearch/data"
    
    # Clean Redis data (preserve .gitkeep)
    clean_dir "volumes/redis/data"
    
    # Clean app storage (preserve .gitkeep)
    clean_dir "volumes/app/storage"
    
    # Clean plugin data (preserve .gitkeep)
    clean_dir "volumes/plugin_daemon/cwd"
    clean_dir "volumes/plugin_daemon/plugin"
    clean_dir "volumes/plugin_daemon/plugin_packages"
    clean_dir "volumes/plugin_daemon/assets"
    
    # Clean sandbox dependencies (preserve .gitkeep and config.yaml)
    clean_dir "volumes/sandbox/dependencies"
    
    echo "Local volumes data cleaned! (.gitkeep and config files preserved)"
else
    echo "Skipped cleaning local volumes"
fi

echo "Cleanup completed!"

