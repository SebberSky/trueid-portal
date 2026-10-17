# TrueID Portal

Landing page for TrueID internal apps on **agent3** — Funnel root `/`.

Links to:

- [TrueID Office](https://agent3s-imac.taildc5084.ts.net/office/) (`/office/`)
- [Point Poker](https://agent3s-imac.taildc5084.ts.net/poker/) (`/poker/`)

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
#   /office  → http://127.0.0.1:5173/office
#   /poker   → http://127.0.0.1:5174/poker
```

### Jenkins

1. Pipeline from SCM → `https://github.com/SebberSky/trueid-portal`
2. Branch `*/main` · Script Path `Jenkinsfile` · agent `agent3`
3. GitHub webhook → `http://<JENKINS_URL>/github-webhook/` (push events)
