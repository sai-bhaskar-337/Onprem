#!/usr/bin/env bash
set -euo pipefail
IMAGE="$1"   # e.g. yourdockerhubusername/myapp
TAG="$2"     # e.g. gitsha
docker build -t "${IMAGE}:${TAG}" .
docker tag "${IMAGE}:${TAG}" "${IMAGE}:latest"
