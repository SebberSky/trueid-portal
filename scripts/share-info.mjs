/**
 * Share URLs for TrueID Portal on the agent3 host.
 */
const PORTAL_PORT = process.env.PORTAL_PORT || '5170'
const HOST = process.env.HOST_IP || '100.84.246.127'
const FUNNEL_HOST = process.env.FUNNEL_HOST || 'agent3s-imac.taildc5084.ts.net'

console.log(`
TrueID Portal — โฮสต์ (agent3)

Funnel (คนนอก):     https://${FUNNEL_HOST}/
เครื่องโฮสต์ portal: http://localhost:${PORTAL_PORT}/
Tailscale IP:        http://${HOST}:${PORTAL_PORT}/

pm2: trueid-portal (:${PORTAL_PORT})
Funnel paths (จาก repo นี้):
  npm run funnel:paths
  #   /        → :${PORTAL_PORT} portal
  #   /office  → :5173/office
  #   /poker   → :5174/poker
`)
