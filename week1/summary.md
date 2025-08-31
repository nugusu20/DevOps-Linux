
````markdown
# Week 1 Summary – DevOps & Linux Basics

---

## 1. Create Project Directory Structure
```bash
sudo mkdir -p /srv/project1/{scripts,docs}
````

* `-p` → Creates parent directories if they don’t exist.
* `{scripts,docs}` → Creates both directories in one command.

---

## 2. Set Permissions for Directories

### Scripts Folder

```bash
sudo chmod 755 /srv/project1/scripts
```

* Owner (7) → Read, write, execute (rwx)
* Group (5) → Read & execute (r-x)
* Others (5) → Read & execute (r-x)

### Docs Folder

```bash
sudo chmod 777 /srv/project1/docs
```

* All users (7) → Read, write, execute (rwx)

---

## 3. Create User and Group

```bash
sudo adduser devuser
sudo addgroup devteam
sudo usermod -aG devteam devuser
```

---

## 4. Set Group Ownership and Permissions on Project Folder

```bash
sudo chgrp devteam /srv/project1
sudo chmod 750 /srv/project1
```

* Owner (7) → Read, write, execute (rwx)
* Group (5) → Read & execute (r-x)
* Others (0) → No access (---)

