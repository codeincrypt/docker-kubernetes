#!/bin/bash

set -e  # Exit on error

TAG="latest"
IMAGE_NAME="docker-app" # Your docker image name
CONTAINER_NAME="docker-app" # Your docker container name
PORT=5000 # Port to expose the app

echo "👉 Checking for running container..."
if docker ps -q -f name="$CONTAINER_NAME" | grep -q .; then
  echo "🛑 Stopping running container..."
  docker stop "$CONTAINER_NAME"
fi

echo "🧹 Removing old container if it exists..."
if docker ps -a -q -f name="$CONTAINER_NAME" | grep -q .; then
  docker rm -f "$CONTAINER_NAME"
fi

echo "🧼 Removing old image if it exists..."
if docker images -q "$IMAGE_NAME:$TAG" | grep -q .; then
  docker rmi "$IMAGE_NAME:$TAG"
fi

echo "🚧 Building Docker image [$IMAGE_NAME:$TAG]..."
docker build --no-cache -t "$IMAGE_NAME:$TAG" .

echo "📦 Running container [$CONTAINER_NAME] on port $PORT..."
docker run -d -p "$PORT:80" --name "$CONTAINER_NAME" "$IMAGE_NAME:$TAG"

# Wait a bit and show status
sleep 2
echo ""
echo "🔍 Container Status:"
docker ps -f name="$CONTAINER_NAME"

echo ""
echo "📸 Image List:"
docker images | grep "$IMAGE_NAME"

echo ""
echo "✅ Done. App should be live at: http://localhost:$PORT"
