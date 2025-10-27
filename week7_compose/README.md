# 📘 Week 7 – Docker Compose & EC2 Deployment

This document covers all **Daily Tasks (1–7)**, the **Summary Project**, and additional **Tips & Useful Commands**.  
Each section follows the *actual chronological order you performed*: local setup → containers & health → EC2 → CI/CD.

---

<details>
<summary>📝 <strong>Daily Tasks (Task 1 → Task 7)</strong></summary>

## Task 1 – Local Setup & Docker Installation

### 📖 Theory
Install Docker on the local Linux machine and prepare the project directory.

### 💻 Commands
```bash
# (If needed) Install Docker Engine on Ubuntu
sudo apt update
sudo apt install -y docker.io docker-compose-plugin
sudo usermod -aG docker $USER
# re-login to apply group membership

# Verify
docker --version
docker compose version

# Project root (local)
cd /srv/DevOps-Linux/week7_compose
```

### ✅ Expected Result
- Docker installed and usable without sudo.
- Working directory: `/srv/DevOps-Linux/week7_compose`.

---

## Task 2 – Backend & Database Containers (Compose)

### 📖 Theory
Define a multi-service app with **backend** (Python HTTP server) and **db** (PostgreSQL), connected via an internal Docker network.

### 💻 Commands
```bash
# Bring up the stack locally
docker compose up -d

# List running services
docker compose ps
```

### 📸 Screenshot
![compose ps](docs/docker_compose_ps+logs.png)

### ✅ Expected Result
```
week7_compose-backend-1   Up (healthy)   0.0.0.0:8000->8000/tcp
week7_compose-db-1        Up             5432/tcp
```

---

## Task 3 – Healthcheck & Internal Communication

### 📖 Theory
Use a `healthcheck` to ensure the backend is responsive. Verify inter-container DNS and networking (backend ↔ db over `app_net`).

### 💻 Commands
```bash
# Inspect health
docker ps
docker inspect $(docker compose ps -q backend) | grep -i Health -n

# (optional) Test service over localhost
curl -I http://127.0.0.1:8000/

# Internal DNS (inside backend) – db should resolve
docker compose exec backend getent hosts db
```

### 📸 Screenshot
![healthcheck](docs/healthcheck.png)

### ✅ Expected Result
- Backend container shows `"Status": "healthy"`.
- `db` resolves to an internal IP (e.g., `172.x.x.x`).

---

## Task 4 – Network & Volume Persistence

### 📖 Theory
Compose creates an isolated network (`app_net`) and a named volume for persistent database data.

### 💻 Commands
```bash
# Networks & volumes
docker network ls
docker volume ls

# Recreate stack to prove persistence
docker compose down
docker compose up -d
```

### 📸 Screenshot
![docker images / volumes](docs/docker_images.png)

### ✅ Expected Result
- Custom network present.
- Named volume present; DB data persists across restarts.

---

## Task 5 – EC2 Instance Creation & SSH Access

### 📖 Theory
Provision an **AWS EC2 (t2.micro, Free Tier)** Ubuntu instance. Open ports **22 (SSH)** and **8000 (App)** in the Security Group. Connect via SSH.

### 💻 Commands
```bash
# Connect from local to EC2
ssh -i ~/.ssh/week7-key.pem ubuntu@<EC2_PUBLIC_IP>

# Basic health
uptime
df -h
free -m
```

### ✅ Expected Result
- SSH prompt on the EC2 host: `ubuntu@ip-...:~$`
- Instance healthy and responsive.

---

## Task 6 – Transfer Project & Run Compose on EC2

### 📖 Theory
Copy the local project to EC2, then run the same Compose stack on the remote machine.

### 💻 Commands
```bash
# From local → to EC2 home dir
scp -i ~/.ssh/week7-key.pem -r /srv/DevOps-Linux/week7_compose ubuntu@<EC2_PUBLIC_IP>:~/

# On EC2
ssh -i ~/.ssh/week7-key.pem ubuntu@<EC2_PUBLIC_IP>
cd ~/week7_compose
docker compose up -d
docker compose ps

# Browser test from your PC (Windows)
# http://<EC2_PUBLIC_IP>:8000
```

### 📸 Screenshot
![curl / ping / check](docs/ping_test.png)

### ✅ Expected Result
- Backend reachable at `http://<EC2_PUBLIC_IP>:8000`.
- Containers show `Up (healthy)` on EC2.

---

## Task 7 – CI/CD Deployment via GitHub Actions

### 📖 Theory
Automate deploys with two workflows:
- **compose-e2e** – CI: build, run, wait for health, smoke test (on GitHub runner).
- **deploy** – CD: copy project to EC2 and `docker compose up -d --build` remotely.

### 💻 Snippets
```yaml
# .github/workflows/compose-ci.yml  (CI)
name: compose-e2e
on:
  push:
    paths: ["week7_compose/**", ".github/workflows/compose-ci.yml"]
  pull_request:
    paths: ["week7_compose/**", ".github/workflows/compose-ci.yml"]
jobs:
  e2e:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: week7_compose
    steps:
      - uses: actions/checkout@v4
      - run: docker compose up -d
      - name: Wait for backend healthy
        run: |
          for i in {1..30}; do
            ID=$(docker compose ps -q backend || true)
            STATUS=$(docker inspect -f '{{.State.Health.Status}}' "$ID" 2>/dev/null || true)
            [ "$STATUS" = "healthy" ] && exit 0
            sleep 2
          done
          echo "backend not healthy"; docker compose logs backend; exit 1
      - run: curl -fsS http://localhost:8000/ -o /dev/null
      - if: always()
        run: docker compose logs --no-color | tee compose-logs.txt
      - if: always()
        uses: actions/upload-artifact@v4
        with: { name: compose-logs, path: week7_compose/compose-logs.txt }
      - if: always()
        run: docker compose down -v
```

```yaml
# .github/workflows/deploy.yml  (CD)
name: Deploy to EC2
on:
  push:
    branches: [ "main" ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Copy project to EC2
        uses: appleboy/scp-action@v0.1.4
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_SSH_KEY }}
          source: "week7_compose/"
          target: "~/week7_compose"
      - name: Run Docker Compose on EC2
        uses: appleboy/ssh-action@v1.1.0
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ubuntu
          key: ${{ secrets.EC2_SSH_KEY }}
          script: |
            cd ~/week7_compose
            docker compose down
            docker compose up -d --build
            docker compose ps
```

### ✅ Expected Result
- CI passes (green) on pushes/PRs to week7 files.
- CD deploys to EC2 on each push to `main`.

</details>

---

<details>
<summary>🚀 <strong>Summary Project – Architecture & Flow</strong></summary>

### 🧠 Overview
- **Backend**: Python HTTP server (port 8000), with Docker `healthcheck`.
- **Database**: PostgreSQL (port 5432).
- **Network**: Internal Docker network `app_net` (backend ↔ db).
- **Volume**: Persistent data at `/var/lib/postgresql/data`.
- **Host**: AWS EC2 (Ubuntu), Security Group allows 22/8000.
- **CI/CD**: GitHub Actions (`compose-e2e` → `deploy`).

### 🖼️ Architecture Diagram
![architecture](docs/diagram/architecture.png)

### 🔁 Flow (end-to-end)
1. Developer pushes to GitHub.  
2. **CI (compose-e2e)** builds & verifies health.  
3. **CD (deploy)** copies project to EC2 and runs `docker compose up -d --build`.  
4. EC2 serves `http://<EC2_PUBLIC_IP>:8000` to users.

</details>

---

<details>
<summary>🛠 <strong>Tips, Fixes & Useful Commands</strong></summary>

### Common Issues & Fixes
```bash
# SSH key permissions
chmod 400 ~/.ssh/week7-key.pem

# Open app port (if UFW enabled)
sudo ufw allow 8000/tcp
sudo ufw status

# Cleanup (dangling images/volumes)
docker system prune -a -f
docker volume prune -f
```

### Useful Docker Commands
```bash
docker compose ps
docker compose logs --tail 50
docker compose down -v
docker exec -it week7_compose-backend-1 sh
docker inspect week7_compose-backend-1
```

### Git Basics
```bash
git add .
git commit -m "docs(week7): add README with tasks & diagram"
git push origin main
```
</details>

---

✅ This completes **Week 7** – from local Docker setup to automated EC2 deployment with Docker Compose, healthchecks, volumes, and CI/CD.
