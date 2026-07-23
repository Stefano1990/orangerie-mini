#!/usr/bin/env bash
# One-time server bootstrap: db + caddy via docker compose, systemd unit,
# generated secrets. Safe to re-run.
set -euo pipefail

SERVER="ubuntu@159.100.251.138"
cd "$(dirname "$0")"

ssh "$SERVER" 'sudo mkdir -p /opt/orangerie && sudo chown ubuntu:ubuntu /opt/orangerie'
scp server/docker-compose.yml server/Caddyfile "$SERVER:/opt/orangerie/"
scp server/orangerie.service "$SERVER:/tmp/orangerie.service"

ssh "$SERVER" bash -s <<'EOF'
set -euo pipefail
cd /opt/orangerie

if [ ! -f .env ]; then
  echo "POSTGRES_PASSWORD=$(openssl rand -hex 16)" > .env
  chmod 600 .env
fi

if [ ! -f orangerie.env ]; then
  source .env
  cat > orangerie.env <<ENV
PHX_SERVER=true
PHX_HOST=stage2.orangerie.eu
PORT=4000
DATABASE_URL=ecto://orangerie:${POSTGRES_PASSWORD}@127.0.0.1/orangerie
SECRET_KEY_BASE=$(openssl rand -base64 64 | tr -d '\n')
TOKEN_SIGNING_SECRET=$(openssl rand -base64 64 | tr -d '\n')
ENV
  chmod 600 orangerie.env
fi

docker compose up -d

sudo mv /tmp/orangerie.service /etc/systemd/system/orangerie.service
sudo systemctl daemon-reload
sudo systemctl enable orangerie
EOF

echo "Server ready. Run deploy/deploy.sh to deploy the app."
