# TrueID Portal

Landing page for TrueID internal apps on **agent3** — Funnel root `/`.

Links to:

- [TrueID Office](https://agent3s-imac.taildc5084.ts.net/office/) (`/office/`)
- [Point Poker](https://agent3s-imac.taildc5084.ts.net/poker/) (`/poker/`)
- [Grafana](https://agent3s-imac.taildc5084.ts.net/grafana/) (`/grafana/`)

## Quick start

```bash
npm install
npm start
```

Open http://localhost:5170/

## Run on agent3

```bash
mkdir -p ~/apps
git clone https://github.com/SebberSky/trueid-portal.git ~/apps/trueid-portal
cd ~/apps/trueid-portal
npm ci
npx pm2 start ecosystem.config.cjs
npx pm2 save
```

### Tailscale Funnel paths

```bash
cd ~/apps/trueid-portal
bash scripts/configure-funnel-paths.sh
#   /        → http://127.0.0.1:5170
# Updates only the root handler on HTTPS 443; preserves all other routes/ports.
```

Grafana at `/grafana/` is managed by `~/fitness-monitoring`; its Funnel upstream is `http://127.0.0.1:3000/grafana` because Funnel strips the mount prefix. Office, Poker, QCC Pushgateway and port 8443 remain independently managed. Never reset the shared Serve/Funnel configuration.

### Jenkins

1. Pipeline from SCM → `https://github.com/SebberSky/trueid-portal`
2. Branch `*/main` · Script Path `Jenkinsfile` · agent `agent3`
3. GitHub webhook → `http://<JENKINS_URL>/github-webhook/` (push events)

Jenkins syncs its workspace into this checkout with `rsync --delete`. Local uncommitted changes can be overwritten by a later build; runtime changes are not a durable SCM deployment.
