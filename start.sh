#!/bin/bash

# Start all services
echo "Starting all services..."
docker-compose up -d

echo "Services started successfully!"
echo "Run 'docker-compose ps' to check status"

