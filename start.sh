#!/bin/bash
# Without this, a failing compose call is followed by a successful echo and the
# script still exits 0 - the deploy workflow then reports green on a deployment
# that never happened.
set -e

# Start all services
echo "Starting all services..."
docker compose up -d

echo "Services started successfully!"
echo "Run 'docker compose ps' to check status"

