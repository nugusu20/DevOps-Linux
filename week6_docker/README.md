# Week 6 – Docker & Containers
**Version:** v1.0.7  
**Based on Week 5 (CI/CD):** [../week5](../week5)

> Goal: Run a Flask app together with nginx using Docker Compose, with health checks (`/health`), logs, internal networking, and image tagging. All commands are copy-paste ready.

---

## 🚀 Quickstart
```bash
docker compose up -d --build      # Build + start all services
docker compose ps                 # Show services known to this Compose project
docker compose ps -a              # Include previously stopped containers (very useful)
curl -I http://localhost:5002     # app (Flask) → 200 OK
curl -I http://localhost:8080     # db  (nginx) → 200 OK
```

### Useful during runtime
```bash
docker compose logs -f --tail=100 app   # live logs
docker compose logs -f --tail=100 db
docker compose top                      # processes in each service
docker compose ls                       # local Compose projects
```

---

## 🗂 Minimal layout (as we used)
```
week6_docker/
├─ Dockerfile
├─ requirements.txt
├─ src/
│  └─ app.py                 # exposes GET /health → 200
├─ docker-compose.yml        # services: app, db; ports; network
└─ diagram/
   └─ architecture.png
```

## 🧭 Diagram
![Architecture](diagram/architecture.png)

---

<details>
<summary><strong>Practice 1 – Core Docker CLI (click to expand)</strong></summary>

**Goal:** Understand Images vs Containers and the basic lifecycle.  
**Commands:**
```bash
docker run hello-world                        # sanity check
docker ps                                      # running containers
docker ps -a                                   # include stopped (history)
docker images                                  # local images
docker stop <NAME|ID> && docker rm <NAME|ID>   # stop & remove
docker rmi <IMAGE_ID|NAME:TAG>                 # remove image
```
**Why it matters:** Solid CLI fundamentals save debug time later.
</details>

---

<details>
<summary><strong>Practice 2 – Images & Ports (nginx)</strong></summary>

**Goal:** Pull and run images; expose host↔container ports.  
**Commands:**
```bash
docker pull nginx:latest
docker run -d --name web1 -p 8080:80 nginx:latest
curl -I http://localhost:8080

docker pull nginx:alpine
docker run -d --name web2 -p 8081:80 nginx:alpine

docker image ls nginx --format 'table {{.Repository}}	{{.Tag}}	{{.Size}}'
```
**Why it matters:** Learn port mapping and image size differences (alpine is smaller).
</details>

---

<details>
<summary><strong>Practice 3 – Dockerfile (lean Flask + cache-friendly)</strong></summary>

**Goal:** Create a lean Dockerfile with proper layer order and a healthcheck.  
**Dockerfile template used:**
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ /app/
EXPOSE 5000
HEALTHCHECK --interval=10s --timeout=2s --retries=3   CMD curl -fsS http://127.0.0.1:5000/health || exit 1
CMD ["python", "app.py"]
```
**Local build & run:**
```bash
docker build -t myflask:dev .
docker run -d --name app1 -p 5000:5000 myflask:dev
curl -I http://localhost:5000
```
**`.dockerignore` example:**
```
__pycache__/
*.pyc
.git
```
**Why it matters:** Correct layer order preserves cache; `slim` base keeps images small.
</details>

---

<details>
<summary><strong>Practice 4 – Compose & internal network (app ↔ db)</strong></summary>

**Goal:** Connect services on a user-defined network (DNS by service name).  
**`docker-compose.yml` (concise, as used):**
```yaml
services:
  app:
    build: .
    image: myflask:1.0.1
    ports: ["5002:5000"]
    networks: ["app_net"]
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://localhost:5000/health"]
      interval: 10s
      timeout: 2s
      retries: 3

  db:
    image: nginx:alpine
    ports: ["8080:80"]
    networks: ["app_net"]

networks:
  app_net: {}
```
**Commands:**
```bash
docker compose up -d --build
docker compose ps -a
docker compose exec app sh -lc 'wget -qS -O- http://db | head -n 3'  # DNS check
docker compose down
```
**Why it matters:** No hardcoded IPs; Compose provides DNS for service names.
</details>

---

<details>
<summary><strong>Practice 5 – Health & Logs (observability)</strong></summary>

**Goal:** Verify readiness and read meaningful logs.  
**Commands:**
```bash
curl -i http://localhost:5002/health
docker inspect -f 'Health={{.State.Health.Status}}' $(docker compose ps -q app)

docker compose logs --tail=100 app
docker compose logs --tail=100 db
docker compose logs -f --tail=100 app
docker compose top
```
**Why it matters:** Know when the app is ready; shorten time-to-root-cause.
</details>

---

<details>
<summary><strong>Practice 6 – Image tagging (SemVer, not <code>latest</code>)</strong></summary>

**Goal:** Use explicit version tags.  
**Commands:**
```bash
docker build -t myflask:1.0.1 .
docker tag myflask:1.0.1 myflask:latest
docker images myflask
```
**Why it matters:** Predictable promotions and safe rollbacks.
</details>

---

<details>
<summary><strong>Practice 7 – Handy Compose commands</strong></summary>

**Goal:** Operate the stack throughout its lifecycle.  
**Commands:**
```bash
docker compose up -d --build           # build & start
docker compose ps                      # status
docker compose ps -a                   # include stopped
docker compose logs -f --tail=100 app  # live logs
docker compose exec app sh             # shell into service
docker compose stop && docker compose rm -f   # stop & remove
docker compose down -v                 # remove also volumes (⚠ data loss)
docker compose ls                      # local compose projects
```
**Why it matters:** Full control of the stack, including clean-ups when needed.
</details>

---

<details>
<summary><strong>Summary (separate clip) – with link to Week 5 CI/CD</strong></summary>

### What we built
- Two services: **app** (Flask) 5000 internal (published 5002), **db** (nginx) 80 (published 8080).  
- Network `app_net` between services; use service names (DNS).  
- Health endpoint `/health` + `HEALTHCHECK` in Dockerfile.  
- Image tags: `myflask:1.0.1` (avoid `latest`).  
- Diagram: `diagram/architecture.png`.  
- **CI/CD** continues from Week 5: see [../week5](../week5).

### Exact steps to reproduce (end‑to‑end)
1) **Clone / update repo** and switch to the week folder:  
   ```bash
   git pull && cd week6_docker
   ```
2) **Create/verify app layout** (`Dockerfile`, `requirements.txt`, `src/app.py`, `docker-compose.yml`, `diagram/architecture.png`).  
3) **Build & run with Compose**:  
   ```bash
   docker compose up -d --build
   ```
4) **Verify service status**:  
   ```bash
   docker compose ps
   docker compose ps -a
   ```
5) **Probe endpoints**:  
   ```bash
   curl -I http://localhost:5002      # app → 200
   curl -I http://localhost:8080      # db  → 200
   ```
6) **Check health**:  
   ```bash
   curl -i http://localhost:5002/health
   docker inspect -f 'Health={{.State.Health.Status}}' $(docker compose ps -q app)
   ```
7) **Tag the image** (explicit version):  
   ```bash
   docker build -t myflask:1.0.1 .
   docker tag myflask:1.0.1 myflask:latest
   ```
8) **Review logs if needed**:  
   ```bash
   docker compose logs --tail=100 app
   docker compose logs --tail=100 db
   ```
9) **Wire up CI/CD (from Week 5)** – in your workflow: build → run → probe `http://localhost:5002/health`.  
10) **Submit via PR** (Week 6 Summary), ensure CI is green, and merge to `main`.

### Submission checklist
- [x] `docker-compose.yml` with `app` + `db`, ports `5002:5000` and `8080:80`.
- [x] `Dockerfile` is lean and includes a working `/health`.
- [x] Tags applied: `myflask:1.0.1` (no reliance on `latest`).
- [x] Diagram embedded (`diagram/architecture.png`).
- [x] CI/CD probes `/health` (see Week 5).
- [x] PR opened and merged.
</details>

---

<details>
<summary><strong>🧪 Quick Troubleshooting</strong></summary>

```bash
# What is running?
docker ps
docker compose ps
docker compose ps -a

# Logs
docker compose logs -f --tail=100 app
docker compose logs -f --tail=100 db

# Health
curl -i http://localhost:5002/health
docker inspect -f 'Health={{.State.Health.Status}}' $(docker compose ps -q app)

# Networking
docker network ls
docker compose exec app ping -c 1 db

# Host ports
ss -tuln | grep -E '5002|8080'
```
**Tips:**
- Health stuck at `starting`? Check ports, env, dependencies between services.
- Inter-service comm failing? Ensure both are on the same Compose network and you use the **service name**.
- Aggressive cleanup? `docker compose down -v` (⚠ removes volumes).
</details>
