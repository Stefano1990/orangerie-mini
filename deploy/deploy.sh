#!/usr/bin/env bash
# Build an x86_64 release, ship it to the server, migrate, restart.
set -euo pipefail

SERVER="ubuntu@159.100.251.138"
cd "$(dirname "$0")/.."

echo "==> Building x86_64 release"
docker build --platform linux/amd64 -f deploy/Dockerfile -o deploy/_out .

echo "==> Uploading"
scp deploy/_out/orangerie.tar.gz "$SERVER:/tmp/orangerie.tar.gz"

echo "==> Installing, migrating, restarting"
ssh "$SERVER" bash -s <<'EOF'
set -euo pipefail
sudo systemctl stop orangerie || true
rm -rf /opt/orangerie/current
mkdir -p /opt/orangerie/current
tar -xzf /tmp/orangerie.tar.gz -C /opt/orangerie/current
rm /tmp/orangerie.tar.gz
set -a; source /opt/orangerie/orangerie.env; set +a
/opt/orangerie/current/bin/orangerie eval "Orangerie.Release.migrate()"
sudo systemctl start orangerie
EOF

echo "==> Deployed: https://stage2.orangerie.eu"
