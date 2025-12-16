#!/usr/bin/env bash
set -euo pipefail
IMAGE="$1"
TAG="$2"
# update docker-compose.yml to use specific tag (simple sed replace)
# This assumes docker-compose.yml uses image: yourdockerhubusername/myapp:latest
sed -i.bak "s|image:.*|image: ${IMAGE}:${TAG}|" docker-compose.yml
docker-compose pull || true
docker-compose up -d --remove-orphans
docker-compose ps
