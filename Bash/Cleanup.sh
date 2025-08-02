#!/bin/bash

set -e

# Check Docker availability
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed."
  exit 1
fi

echo "Checking Docker status..."

# Remove stopped containers
echo "Removing stopped containers..."
docker container prune -f

# Remove dangling images (none:<none>)
echo "Removing dangling images..."
docker image prune -f

# Remove unused volumes
echo "Removing unused volumes..."
docker volume prune -f

# Remove unused networks
echo "Removing unused networks..."
docker network prune -f

echo "Docker cleanup complete — running containers and active images are untouched."