# 🚀 Week 1 – Intro to DevOps & Linux
_A starter guide for Linux and DevOps basics: filesystem, navigation, users & groups, permissions_

---

## 📂 Linux Filesystem (Quick Map)

```bash
# --- Linux Filesystem (Quick Map) ---
/       → root of the filesystem
/etc    → system configuration files
/var    → variable data (e.g., logs)
/home   → user directories
```

---

## 🧭 Basic Navigation

```bash
ls          # list files in the current directory
ls -l       # list with details
pwd         # show current directory
cd /etc     # change directory
cd ~        # return to home
mkdir testdir
rm -rf testdir   # remove directory with contents
```

---

## 📄 File Viewing

```bash
head file1.txt   # show first lines of a file
tail file1.txt   # show last lines of a file
cat file1.txt    # print entire file
less file1.txt   # scroll through a file
```

---

## 👥 User & Group Management

```bash
sudo adduser david
sudo adduser danny
sudo addgroup devops
sudo usermod -aG devops david
sudo usermod -aG devops danny
groups david
groups danny
```

---

## 🔐 File Ownership & Permissions

```bash
touch file1.txt
sudo chgrp devops file1.txt
sudo chown david file1.txt
chmod g+w file1.txt   # give write to group
chmod o-r file1.txt   # remove read from others
ls -l file1.txt
```

---

## 📊 Understanding Permissions (Visual Guide)

| Bit | Meaning  | Symbol | Value |
| ---- | -------- | ------ | ----- |
| r    | Read     | `r`    | 4     |
| w    | Write    | `w`    | 2     |
| x    | Execute  | `x`    | 1     |

**Quick Examples:**

| Role   | Value | Permissions          | Symbol |
| ------ | ----- | -------------------- | ------ |
| Owner  | 7     | Read, write, execute | rwx    |
| Group  | 5     | Read, execute        | r-x    |
| Others | 0     | No access            | ---    |

```bash
chmod 750 file1.txt    # Owner: rwx, Group: r-x, Others: ---
chmod 644 /srv/project1/docs/readme.md
chmod 770 /srv/project1
```

---

## 📁 Project Structure

```bash
sudo mkdir -p /srv/project1/{scripts,docs}
sudo chgrp devops /srv/project1
sudo chmod 770 /srv/project1
ls -ld /srv/project1
```

---

## 🖥️ System Information

```bash
whoami    # current user
who       # logged-in users
id        # UID and GIDs
date      # current date/time
df -h     # disk usage
free -h   # memory usage
```

---

## 🔍 Search & History

```bash
grep "text" file1.txt
find / -name "file1.txt" 2>/dev/null
history        # show past commands
# Press CTRL+R in the shell to reverse-search your history
```

---

## 📦 Week 1 Deliverables

**Directory Structure:**
```
/srv/project1/scripts
/srv/project1/docs
```

**Markdown Summary:**
```
/srv/project1/docs/README.md
```

**Push to GitHub:**
```
Repository → README.md
```
