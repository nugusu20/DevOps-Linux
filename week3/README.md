# 🚀 Week 3 – Remote Log Monitoring & Analyzer

This week covers **networking basics, SSH, remote file transfer, and automation**.  
It ends with a **full project**: a Bash script that connects to a remote VM, pulls logs, analyzes keywords, and generates professional reports.

---

## 📌 Daily Practice Tasks

### ✅ Task 1: Basic IP & Port Exploration
```bash
# Show local IP addresses
ip a

# Show listening ports
ss -tuln
```
**Example output:**
```
127.0.0.1:22 → SSH listening locally
```

---

### ✅ Task 2: Generate SSH Key & Connect
```bash
# Generate new SSH key pair
ssh-keygen -t ed25519 -C "student@week3"

# Copy public key to VM
ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@<VM_IP>

# Connect without password
ssh ubuntu@<VM_IP>
```

---

### ✅ Task 3: Create a VM (AWS Free Tier)
- Instance type: `t2.micro`  
- Inbound rule: **port 22 (SSH)** open for your IP  
- Download `.pem` key and set permissions:
```bash
chmod 400 ~/.ssh/mykey.pem
```

---

### ✅ Task 4: Remote File Transfer with SCP
```bash
# Upload
scp -i ~/.ssh/mykey.pem hello.txt ubuntu@<VM_IP>:/home/ubuntu/

# Download
scp -i ~/.ssh/mykey.pem ubuntu@<VM_IP>:/var/log/syslog ./logs_remote/
```

---

### ✅ Task 5: Run Remote Commands via SSH
```bash
ssh -i ~/.ssh/mykey.pem ubuntu@<VM_IP> "date"
ssh -i ~/.ssh/mykey.pem ubuntu@<VM_IP> "df -h"
ssh -i ~/.ssh/mykey.pem ubuntu@<VM_IP> "ls -l /home/ubuntu"
```

---

## 📌 Summary Project – `remote_log_analyzer.sh`

### 🎯 Objective
Automate:
1. Connect to remote VM via SSH.  
2. Pull logs with `scp`.  
3. Extract archives (`.zip`, `.tar`, `.gz`).  
4. Analyze keywords (ERROR, WARNING, CRITICAL).  
5. Generate reports:
   - `remote_report.txt` (human-readable)  
   - `remote_report.csv` (Excel-ready)  

---

### 📂 Script Overview

```bash
./remote_log_analyzer.sh <user@host> <remote_log_dir> "ERROR,WARNING,CRITICAL"
```

**Example:**
```bash
./remote_log_analyzer.sh ubuntu@35.181.39.60 /var/log "ERROR,WARNING,CRITICAL"
```

---

### 🔧 Features Implemented
- `pull_logs()` → copy logs from remote.  
- `extract_archives()` → unzip/untar if needed.  
- `analyze_keywords()` → grep/zgrep with word boundaries.  
- Execution time measurement.  

---

### 📊 Example Report (TXT)

```
Remote Server: ubuntu@35.181.39.60
Analyzed Directory: /var/log

| File Name | Keyword  | Count |
|-----------|----------|-------|
| auth.log  | ERROR    | 0     |
| auth.log  | WARNING  | 0     |
| kern.log  | ERROR    | 0     |
| kern.log  | WARNING  | 2     |
| syslog    | ERROR    | 51    |
| syslog    | WARNING  | 2     |

Total Execution Time: 13.23 seconds
```

---

### 📊 Example Report (CSV)
```csv
File Name,Keyword,Count
auth.log,ERROR,0
auth.log,WARNING,0
kern.log,ERROR,0
kern.log,WARNING,2
syslog,ERROR,51
syslog,WARNING,2
```

---

## 🗂️ Flow Diagram (Mermaid)

```mermaid
flowchart TD
  A[Start: ./remote_log_analyzer.sh user@host logdir keywords] --> B{Args valid?}
  B -- No --> H[Show Usage & Exit]
  B -- Yes --> C[Init: Parse Params & Create Folders]
  C --> D[pull_logs(): scp logs from VM]
  D --> D1{Logs copied?}
  D1 -- No --> DX[Error & Exit]
  D1 -- Yes --> E[extract_archives(): unzip/tar if needed]
  E --> F[analyze_keywords(): grep/zgrep counts per keyword]
  F --> G[Generate TXT + CSV Reports]
  G --> I[Show Execution Time & Exit]
```

---

## ✅ Summary of Week 3
In this week we learned:
- How to explore IP and ports on Linux.  
- How to generate SSH keys and connect securely.  
- How to create a VM in the cloud (AWS Free Tier).  
- How to upload/download files with SCP.  
- How to run remote commands with SSH.  
- How to build a full **automation project** in Bash:
  - Pull remote logs  
  - Extract archives  
  - Analyze keywords  
  - Generate professional reports  

This knowledge is the foundation for deeper **Cloud & DevOps** practices in the next weeks.
