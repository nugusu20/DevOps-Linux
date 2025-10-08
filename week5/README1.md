# Week 5 – CI/CD with GitHub Actions

📌 **Summary Project for Week 5**:  
👉 [week5-ci-cd Repository](https://github.com/nugusu20/week5-ci-cd)

---

## 📚 Daily Practice Tasks

---

### Task 1 – Introduction to GitHub Actions (Q&A)

**What is GitHub Actions?**  
- GitHub’s built-in CI/CD platform for automating build, test, and deployment with YAML workflows.  
- It runs jobs on managed runners in response to repository events.  

**Difference between Job and Step**  
- **Job**: A group of steps that runs on an isolated runner (VM/container). Jobs can run in parallel or depend on each other.  
- **Step**: A single action or shell command inside a job. Steps run sequentially and share the job’s workspace and environment.  

**What triggers a workflow? (examples)**  
- `push`, `pull_request`  
- Also: `workflow_dispatch` (manual run), `schedule` (cron), `release`, `tag`  

---

### Task 2 – Basic CI Pipeline for Testing

- Created a `.github/workflows/ci.yml` file.  
- Configured workflow to run on **push** and **pull_request**.  
- Steps included: checkout, Node.js setup, dependency installation, and test run.  

✔️ The workflow ran automatically on each commit and pull request.  

---

### Task 3 – Matrix Strategy

- Extended the pipeline to use **matrix builds** across Node.js versions: 14, 16, 18.  
- Verified that the workflow executed once per version.  

✔️ Ensured compatibility across multiple runtime environments.  

---

### Task 4 – Artifacts and Post-job Monitoring

- Added artifact uploads using `actions/upload-artifact`.  
- Configured a post-job step using `curl` to validate service availability (mock check).  

✔️ Pipeline now saves build outputs and verifies basic health.  

---

### Task 5 – Slack Integration

- Connected pipeline to Slack using a **Webhook** stored in GitHub Secrets.  
- Configured notifications on **success** and **failure**.  
- Message includes job name and status.  

✔️ Real-time feedback delivered to Slack channel.  

---

### Task 6 – Combined Frontend and Backend CI/CD

- Created dummy projects for **frontend** and **backend** (`package.json` with test scripts).  
- Extended workflow to run separate jobs for frontend and backend.  
- Each job installs dependencies, runs tests, and uploads artifacts.  
- Confirmed success when both flows pass.  

✔️ Both parts of the project are validated in parallel.  

---

## 📌 Notes
- Added `.gitignore` files for root, frontend, and backend to exclude `node_modules/`, logs, and editor swap files.  
- Practiced Linux commands (`cp`, `mv`, `diff`, `grep`) during file management.  
- Final project (`week5-ci-cd`) contains the **full summary pipeline, flowchart, and reflection**.  

