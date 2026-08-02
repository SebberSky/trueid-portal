#!/usr/bin/env bash
# Sync Jenkins workspace → ~/apps/trueid-portal and restart pm2.
set -euo pipefail

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

APP_DIR="${APP_DIR:-$HOME/apps/trueid-portal}"
WORKSPACE="${WORKSPACE:-$(pwd)}"

mkdir -p "$(dirname "$APP_DIR")"

if [[ -d "$WORKSPACE/.git" ]]; then
  echo "==> sync $WORKSPACE → $APP_DIR"
  mkdir -p "$APP_DIR"
  rsync -a --delete \
    --exclude '.git' \
    --exclude 'node_modules' \
    --exclude '.DS_Store' \
    "$WORKSPACE"/ "$APP_DIR"/
else
  echo "==> manual restart from: $APP_DIR"
fi

cd "$APP_DIR"

echo "==> npm ci"
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi

PM2=(npx --no-install pm2)

echo "==> pm2 delete trueid-portal then start from $APP_DIR"
"${PM2[@]}" delete trueid-portal 2>/dev/null || true
"${PM2[@]}" start "$APP_DIR/ecosystem.config.cjs"

"${PM2[@]}" save
"${PM2[@]}" status trueid-portal

echo "==> waiting for portal on :5170..."
portal_ok=0
for _ in 1 2 3 4 5 6 7 8 9 10; do
  if curl -sf -m 2 http://127.0.0.1:5170/ >/dev/null 2>&1; then
    echo "==> portal up"
    portal_ok=1
    break
  fi
  sleep 1
done
if [[ "$portal_ok" -ne 1 ]]; then
  echo "ERROR: portal did not respond on :5170" >&2
  "${PM2[@]}" logs trueid-portal --lines 40 --nostream || true
  exit 1
fi

echo "==> done"
