#!/usr/bin/env bash
# This Portal-owned script updates only the HTTPS 443 root handler.
# Grafana, Office, Poker, QCC and other ports are independently managed.
set -euo pipefail

PORTAL_UPSTREAM="${PORTAL_UPSTREAM:-http://127.0.0.1:5170}"

if ! command -v tailscale >/dev/null 2>&1; then
  echo "ERROR: tailscale CLI not found" >&2
  exit 1
fi

echo "==> Funnel / → portal ${PORTAL_UPSTREAM} (preserve all other handlers)"
tailscale funnel --bg --https=443 --set-path=/ "${PORTAL_UPSTREAM}"

echo "==> status"
tailscale serve status
echo "Portal: https://agent3s-imac.taildc5084.ts.net/"
