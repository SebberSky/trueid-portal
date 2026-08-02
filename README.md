# TrueID Portal

Landing page for TrueID internal apps on **agent3** — Funnel root `/`.

Links to:

- [TrueID Office](https://agent3s-imac.taildc5084.ts.net/office/) (`/office/`)
- [Point Poker](https://agent3s-imac.taildc5084.ts.net/poker/) (`/poker/`)

| ส่วน | ค่า |
|------|-----|
| Repo | https://github.com/SebberSky/trueid-portal |
| พอร์ต | `5170` |
| pm2 name | `trueid-portal` |
| โฟลเดอร์ถาวร | `~/apps/trueid-portal` |
| Funnel | `https://agent3s-imac.taildc5084.ts.net/` |

## Local preview

```bash
npm install
npm start
# http://localhost:5170/
```

---

## Deploy บน agent3 (ครั้งแรก)

ทำบนเครื่อง **`agent3s-imac`** (SSH / Terminal บนโฮสต์)

### 1) Clone โฟลเดอร์ถาวร

```bash
mkdir -p ~/apps
git clone https://github.com/SebberSky/trueid-portal.git ~/apps/trueid-portal
cd ~/apps/trueid-portal
git checkout main
git pull
```

### 2) ติดตั้ง + รันด้วย pm2

```bash
cd ~/apps/trueid-portal
npm ci
npx pm2 delete trueid-portal 2>/dev/null || true
npx pm2 start ecosystem.config.cjs
npx pm2 save
# (ครั้งแรกของเครื่อง) ให้ขึ้นหลังรีบูต:
# npx pm2 startup
# แล้วรันคำสั่งที่ pm2 แสดง
```

ตรวจ:

```bash
curl -sf http://127.0.0.1:5170/ | head
npx pm2 status trueid-portal
```

### 3) Funnel paths (ถ้ายังไม่ตั้ง หรือรีเซ็ต)

Portal เป็น root `/` — สคริปต์นี้อยู่ใน repo นี้:

```bash
cd ~/apps/trueid-portal
bash scripts/configure-funnel-paths.sh
```

ผลลัพธ์ที่ต้องการ:

| Path | Upstream |
|------|----------|
| `/` | `http://127.0.0.1:5170` |
| `/office` | `http://127.0.0.1:5173/office` |
| `/poker` | `http://127.0.0.1:5174/poker` |

**ห้าม** รัน `tailscale funnel --bg on` (จะพัง path)

เปิดตรวจ: https://agent3s-imac.taildc5084.ts.net/

### 4) Jenkins job (deploy อัตโนมัติตอน push `main`)

1. Jenkins → **New Item** → Pipeline → ชื่อเช่น `trueid-portal`
2. **Pipeline from SCM** → Git  
   - Repo: `https://github.com/SebberSky/trueid-portal`  
   - Branch: `*/main`  
   - Script Path: `Jenkinsfile`  
   - Agent label: `agent3`
3. กด **Build Now** ครั้งแรก (ให้ `githubPush()` จาก Jenkinsfile ติดใน job)
4. GitHub → [trueid-portal → Settings → Webhooks](https://github.com/SebberSky/trueid-portal/settings/hooks) → Add webhook:

| ช่อง | ค่า |
|------|-----|
| Payload URL | `http://<JENKINS_URL>/github-webhook/` |
| Content type | `application/json` |
| Events | Just the **push** event |

`<JENKINS_URL>` เช่น `http://agent3s-imac:8080` (URL ที่ Jenkins รับ webhook ได้)

Job จะ: checkout → `scripts/jenkins-restart.sh` → sync ไป `~/apps/trueid-portal` → `npm ci` → pm2 restart แล้วจบ

---

## Deploy รอบถัดไป

หลัง merge PR เข้า `main`:

- ถ้ามี webhook แล้ว → Jenkins build เอง  
- หรือกด **Build Now** ใน job `trueid-portal`  
- หรือมือบนโฮสต์:

```bash
cd ~/apps/trueid-portal && npm run restart:host
```

ดู URL สรุป:

```bash
cd ~/apps/trueid-portal && npm run share-info
```

## ย้ายจาก poker (ถ้าเคยรัน portal ใน trueid-point-poker)

หลัง poker ไม่มี `portal/` แล้ว ให้หยุดแอปเก่าแล้วรันจาก repo นี้แทน:

```bash
npx pm2 delete trueid-portal 2>/dev/null || true
cd ~/apps/trueid-portal
npx pm2 start ecosystem.config.cjs
npx pm2 save
```

อย่าให้ poker Jenkins รีสตาร์ท portal อีก (PR ที่ลบ portal จาก poker ควร merge แล้ว)
