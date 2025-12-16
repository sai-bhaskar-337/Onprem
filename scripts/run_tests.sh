#!/usr/bin/env bash
set -euo pipefail
# start the app in background for tests (on ephemeral port)
docker-compose up -d --build
# wait for health to be OK (max 30s)
for i in {1..30}; do
  if docker-compose exec -T web wget -qO- http://localhost:3000/health >/dev/null 2>&1; then
    echo "health ok"
    break
  fi
  echo "waiting..."
  sleep 1
done

# run node tests (inside container)
docker-compose exec -T web node tests.js
# cleanup
docker-compose down
