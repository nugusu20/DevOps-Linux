# 📦 Week 8 – Flask App Deployment on AWS EC2 (with Nginx & Healthcheck)

This document covers all setup steps for deploying a simple Flask app on an AWS EC2 instance using Nginx as a reverse proxy and a Bash script for internal & external health checks.

---

## ▶️ Daily Tasks (Step-by-step)

<details>
<summary>🛠️ Task 1 – EC2 Setup & AWS CLI</summary>

### ✅ Actions Performed:
- Created free-tier EC2 instance (`Ubuntu Server`, `t2.micro`, `eu-central-1`)
- Installed AWS CLI inside WSL2
- Created SSH key pair: `devops-key.pem`
- Configured security group: `devops-sg` (port 22, 80, 5000)

### 💻 Commands:
```bash
aws ec2 create-key-pair --key-name devops-key --query 'KeyMaterial' --output text > devops-key.pem
chmod 400 devops-key.pem   # secure the private key for SSH
```

```bash
aws ec2 run-instances --image-id ami-XXXXXXXXXXXX --count 1   --instance-type t2.micro   --key-name devops-key   --security-groups devops-sg   --region eu-central-1
```

</details>

---

<details>
<summary>🌐 Task 2 – Install Nginx + Flask</summary>

### ✅ Actions Performed:
- Installed Python3, pip and Flask
- Created basic Flask server running on port 5000
- Installed and configured Nginx to proxy HTTP requests from port 80 → 5000

### 💻 Commands:
```bash
sudo apt update && sudo apt install python3 python3-pip nginx -y
pip install flask
```

**Flask App (app.py):**
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "ברוך הבא לשרת Flask מ-AWS!"

app.run(host='0.0.0.0', port=5000)
```

**Nginx Config (`/etc/nginx/sites-available/flask-app`):**
```nginx
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enable config:
```bash
sudo ln -s /etc/nginx/sites-available/flask-app /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

</details>

---

<details>
<summary>🔍 Task 3 – Healthcheck Script</summary>

### ✅ Actions Performed:
- Created Bash script `healthcheck.sh` to test Flask internally + externally.

### 💻 Script:
```bash
#!/bin/bash

echo "📡 Health Check Started..."

for URL in "http://localhost" "http://<PUBLIC-IP>"
do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)
  if [ "$STATUS" -eq 200 ]; then
    echo "✅ [$URL] OK (HTTP $STATUS)"
  else
    echo "❌ [$URL] Not OK (HTTP $STATUS)"
  fi
done
```

Make it executable:
```bash
chmod +x healthcheck.sh
```

</details>

---

<details>
<summary>⚙️ Auto-Start Flask on Reboot using systemd</summary>

### ✅ Service file (`/etc/systemd/system/flask-app.service`):
```ini
[Unit]
Description=Flask App
After=network.target

[Service]
User=devouser
ExecStart=/usr/bin/python3 /home/devouser/app.py
WorkingDirectory=/home/devouser/
Restart=always

[Install]
WantedBy=multi-user.target
```

### 💻 Commands to enable:
```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable flask-app   # enable Flask app to start on boot
sudo systemctl start flask-app    # start Flask app service now
```

</details>

---

<details>
<summary>🧪 Debugging & Validation Tools</summary>

### 🔎 Useful Commands:
```bash
curl http://localhost   # test the app locally from the server
curl -I http://<PUBLIC-IP>
ps aux | grep app.py
sudo ss -tuln | grep ':80'
```

### ✅ Nginx Status:
```bash
sudo systemctl status nginx
```

</details>

---

<details>
<summary>🔐 Permissions & Security</summary>

### ✅ Key Permissions:
```bash
chmod 400 devops-key.pem   # secure the private key for SSH
```

### ✅ `.gitignore`:
```bash
# Ignore SSH private keys and envs
*.pem
.env
```

</details>

---

<details>
<summary>📈 Persistence & Reboot Test</summary>

### ✅ Validations After Reboot:
- Flask service starts via systemd
- Nginx responds with `HTTP 200 OK`
- `curl` works internally and externally
- Healthcheck returns ✅

</details>

---

<details>
<summary>🖼️ Summary Project – Architecture & Flow</summary>

### ✅ Diagram
Shows full communication flow from user → EC2 → Nginx → Flask App  
🖼️ `diagram_flask_architecture.png`  
📸 `screenshot_flask_app.png`

![Architecture](diagram_flask_architecture.png)
![Screenshot](screenshot_flask_app.png)

</details>

---

## ✅ Project Complete – Week 8 Checklist

- [x] EC2 instance created and SSH working
- [x] Flask app deployed and accessible
- [x] Reverse proxy configured with nginx
- [x] Systemd service created for persistence
- [x] Healthcheck validates app is up
- [x] Diagram and screenshot included
- [x] Project pushed to GitHub

🎉 Well done!


---

## ℹ️ Introduction

> This project demonstrates how to deploy a simple Flask web app on AWS EC2 using NGINX as a reverse proxy.  
> All steps are performed using the AWS Free Tier, via CLI only, and are suitable for DevOps beginners.

---

## 🧭 AMI Selection – Important!

> ⚠️ Make sure you choose a valid AMI ID for your **region** (e.g., `eu-central-1`).  
> Recommended: Ubuntu Server 22.04 LTS.  
> You can find the latest AMI ID via AWS Console → EC2 → AMIs  
> [🔗 AMI Catalog – Frankfurt](https://eu-central-1.console.aws.amazon.com/ec2/home?region=eu-central-1#AMIs:)

---

<details>
<summary>👤 Add EC2 User (devouser)</summary>

Create a dedicated user for running the Flask app:

```bash
sudo adduser devouser   # create a new user named devouser
sudo usermod -aG sudo devouser   # give devouser sudo permissions
```

Switch to the user:
```bash
su - devouser   # switch to devouser user account
```

</details>

---

<details>
<summary>🧪 Validate systemd Status</summary>

After enabling the Flask service, check that it is active:

```bash
sudo systemctl status flask-app   # check status of Flask app service
```

If there are issues, use:

```bash
journalctl -xe
```

</details>

---

<details>
<summary>📁 .gitignore Reminder</summary>

Ensure the following is included in your project root `.gitignore`:

```gitignore
# Sensitive files
*.pem
.env
```

> 💡 This prevents private keys from being uploaded to GitHub.
</details>

---

<details>
<summary>♻️ Shutdown Checklist (Avoid Charges)</summary>

> ✅ Done working? Don’t forget to clean up.

- [x] Stop your EC2 instance
- [x] Clean up unused storage or snapshots
- [x] Remove old AMIs or volumes (if not needed)

```bash
aws ec2 stop-instances --instance-ids <your-instance-id>   # stop EC2 instance to avoid charges
```

</details>

---

<details>
<summary>🐞 Troubleshooting</summary>

| Problem | Solution |
|--------|----------|
| 🔒 `Permission denied (publickey)` | Ensure `.pem` file is 400 and correct SSH user |
| 🌐 App not showing in browser | Check if port 80 is open in Security Group |
| 🚫 Flask not running | Verify `ps aux | grep app.py` or systemd |
| 🔁 Rebooted and app is down | Check systemd is `enabled` and working |

</details>
