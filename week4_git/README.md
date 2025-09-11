# 📘 Week 4 – Git & GitHub

This document covers all **Daily Tasks (1–5)**, the **Summary Project**, and additional **Tips & Useful Commands**.  
Each section includes theory, use cases, commands, expected outputs, and professional notes.

---

<details>
<summary>📝 Daily Tasks (Task 1 → Task 5)</summary>

## Task 1 – Branching & Switching

### 📖 Theory
- Git allows working with **branches** to manage features in parallel.  
- `main` is the primary branch.  
- Each new feature should be developed in its own branch.

### 🛠️ Use Case
- Developing a new feature without breaking the stable code.  
- Testing experiments safely.

### 💻 Commands
```bash
# Create a new branch and switch to it
git switch -c feature-a

# Switch back to main
git switch main

# List all branches (local + remote)
git branch -a
```

### ✅ Expected Output
```
* feature-a
  main
  remotes/origin/main
```

---

## Task 2 – Merge & Conflict Resolution

### 📖 Theory
- **Merge** combines changes from one branch into another.  
- If both branches modify the same lines → a **conflict** occurs.

### 🛠️ Use Case
- Integrating a feature branch into `main`.  
- Team collaboration when multiple developers touch the same files.

### 💻 Commands
```bash
# Merge feature-a into main
git switch main
git merge feature-a
```

### ⚠️ Conflict Example
```
<<<<<<< HEAD
version: base
=======
version: A
>>>>>>> feature-a
```

### ✅ Resolution
Keep a clean final version, e.g.:
```
version: A2 + B2 merged
```

Then:
```bash
git add shared.txt
git commit -m "merge: resolve conflict in shared.txt"
```

---

## Task 3 – Rebase & Cherry-pick

### 📖 Theory
- **Rebase** reapplies commits on top of another branch, creating a linear history.  
- **Cherry-pick** applies a single commit from one branch to another.

### 🛠️ Use Case
- Keeping history clean.  
- Copying only specific changes without merging an entire branch.

### 💻 Commands
```bash
# Rebase feature-a onto main
git switch feature-a
git rebase main

# Cherry-pick a specific commit into main
git switch main
git cherry-pick <commit-hash>
```

### ⚠️ Note
Conflicts can also happen during rebase or cherry-pick.  
Resolve them the same way as in merge.

---

## Task 4 – Pull Requests & Review

### 📖 Theory
- A Pull Request (PR) lets you propose merging changes into another branch.  
- PRs enable **code review** and **collaboration** in GitHub/GitLab/Bitbucket.

### 🛠️ Use Case
- Professional team workflows.  
- Ensuring code quality before merging to `main`.

### 💻 Workflow
1. Push feature branches to GitHub:  
   ```bash
   git push -u origin feature-a
   git push -u origin feature-b
   ```

2. Open a PR:  
   - **base** = `main`  
   - **compare** = `feature-a`  

3. If conflict → click **Resolve conflicts**, edit the file, remove `<<<<<<<`, `=======`, `>>>>>>>`, and leave clean content.  

4. **Mark as resolved → Commit merge → Merge pull request → Confirm merge**.

---

## Task 5 – Stash, Amend & Cleanup

### 📖 Theory
- **Stash** temporarily stores uncommitted changes.  
- **Amend** modifies the last commit (message or content).  
- **Cleanup** removes old branches after merging.

### 🛠️ Use Case
- Stash: switch branches quickly without committing unfinished work.  
- Amend: fix the last commit without polluting history.  
- Cleanup: keep repository clean after merges.

### 💻 Commands
```bash
# Stash workflow
git stash
git stash list
git stash pop

# Amend last commit
git commit --amend -m "fix: updated notes with amend test"

# Cleanup old branches
git branch -d old-branch
git push origin --delete old-branch
```

</details>

---

<details>
<summary>🚀 Summary Project – Collaboration Workflow</summary>

## Step 1 – Repo Setup
```bash
cd /srv
mkdir week4-collaboration
cd week4-collaboration
git init
git remote add origin https://github.com/<user>/week4-collaboration.git
echo "# Week 4 Collaboration Project" > README.md
git add README.md
git commit -m "chore: init clean repo with README"
git branch -M main
git push -u origin main
```

---

## Step 2 – Dev Branches
```bash
# Developer 1 branch
git switch -c dev1
git push -u origin dev1

# Developer 2 branch
git switch main
git switch -c dev2
git push -u origin dev2
```

---

## Step 3 – Changes
Each developer adds their own line to `collaboration.md`.

```bash
# dev1
git switch dev1
echo "Change from dev1" >> collaboration.md
git add collaboration.md
git commit -m "feat(dev1): add change"
git push

# dev2
git switch dev2
echo "Change from dev2" >> collaboration.md
git add collaboration.md
git commit -m "feat(dev2): add change"
git push
```

---

## Step 4 – Pull Requests & Conflict Resolution
- Open PR: `dev1 → main`.  
- Open PR: `dev2 → main`.  
- GitHub detects conflict in `collaboration.md`:  

```
<<<<<<< dev1
Change from dev1
=======
Change from dev2
>>>>>>> main
```

### ✅ Resolution
Edit file → remove conflict markers → keep final content, e.g.:  
```
Change from dev1 + Change from dev2
```

Click: **Mark as resolved → Commit merge → Merge pull request**.

---

## Step 5 – Cleanup
- After merge → click **Delete branch** in GitHub.  
- Locally cleanup:  
```bash
git switch main
git pull origin main
git branch -d dev1
git branch -d dev2
git fetch --prune
```

</details>

---

<details>
<summary>🛠️ Tips, Fixes & Useful Commands</summary>

### Common Issues & Fixes

- **Case: branch tip is behind remote (non-fast-forward)**
```bash
git pull origin main --rebase
git push origin main
```

- **Case: unmerged files during rebase**
```bash
git add <file>
git rebase --continue
```

- **Case: cancel rebase in progress**
```bash
git rebase --abort
```

- **Case: cancel cherry-pick in progress**
```bash
git cherry-pick --abort
```

### Cleanup Commands
```bash
git branch -d old-branch         # delete local branch (if merged)
git branch -D force-branch       # force delete local branch
git push origin --delete branch  # delete remote branch
git fetch --prune                # clean up deleted remotes
```

### Useful Logging
```bash
git log --oneline --graph --decorate --all -n 10
```

### Stash & Amend Reminders
```bash
git stash
git stash pop
git commit --amend -m "new commit message"
```

</details>

---

✅ This completes **Week 4**: branching, merging, rebasing, cherry-picking, pull requests, conflict resolution, stash, amend, cleanup, tips, fixes, and a full collaboration simulation project.
