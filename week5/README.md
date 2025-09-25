# Week 5 – CI/CD with GitHub Actions

📌 **Summary Project for Week 5**:  
👉 [week5-ci-cd Repository](https://github.com/nugusu20/week5-ci-cd)

---

## 📚 Daily Practice Tasks

---

<details>
<summary><b>Task 1 – Introduction to GitHub Actions (Q&A)</b></summary>

### 📖 Explanation
- **GitHub Actions** is GitHub’s built-in CI/CD platform for automating build, test, and deployment with YAML workflows.  
- It runs jobs on managed runners in response to repository events.  

**Job vs Step**  
- **Job**: Group of steps that runs on an isolated runner (VM/container).  
- **Step**: Single action or shell command inside a job.  

**Triggers**  
- Examples: `push`, `pull_request`, `workflow_dispatch`, `schedule`.

---

### 🛠 Steps
1. 📖 Read docs: [Intro to GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions).  
2. ▶️ Watch video: *GitHub Actions Full Course – freeCodeCamp*.  
3. ❓ Answer questions:  
   - What is GitHub Actions?  
   - What’s the difference between a Job and a Step?  
   - What triggers a workflow?  

</details>

---

<details>
<summary><b>Task 2 – Basic CI Pipeline for Testing</b></summary>

### 📖 Explanation
- First workflow pipeline: runs on every push and pull request.  
- Ensures code installs dependencies and runs tests automatically.  

---

### 🛠 Steps
1. Create workflow file:  
   ```bash
   nano .github/workflows/ci.yml
   ```
2. Configure triggers: `on: [push, pull_request]`.  
3. Add steps:  
   - Checkout repository.  
   - Setup Node.js.  
   - Install dependencies.  
   - Run tests (`npm test`).  
4. Commit + push → pipeline runs automatically.  

✔️ Confirmed green checkmark on Actions tab.  

</details>

---

<details>
<summary><b>Task 3 – Matrix Strategy</b></summary>

### 📖 Explanation
- Run pipeline across multiple Node.js versions (14, 16, 18).  
- Ensures compatibility in different environments.  

---

### 🛠 Steps
1. Modify `ci.yml` with `strategy.matrix.node-version: [14, 16, 18]`.  
2. Rerun pipeline → each version runs as a separate job.  
3. Verify success in Actions log.  

</details>

---

<details>
<summary><b>Task 4 – Artifacts and Post-job Monitoring</b></summary>

### 📖 Explanation
- Upload build/test artifacts for later inspection.  
- Add post-job validation step (e.g., `curl` mock check).  

---

### 🛠 Steps
1. Add artifact upload step:  
   ```yaml
   - name: Upload artifact
     uses: actions/upload-artifact@v4
     with:
       name: build-output
       path: package.json
   ```
2. Add post-job validation (e.g., check endpoint availability with `curl`).  
3. Commit + push → confirm artifacts available under Actions run.  

</details>

---

<details>
<summary><b>Task 5 – Slack Integration</b></summary>

### 📖 Explanation
- Slack channel receives notification on pipeline success/failure.  
- Webhook URL stored securely in GitHub Secrets.  

---

### 🛠 Steps
1. Create Slack App → enable Incoming Webhooks.  
2. Copy Webhook URL.  
3. Add to GitHub Secrets as `SLACK_WEBHOOK_URL`.  
4. Update workflow with Slack notify step:  
   ```yaml
   - name: Send Slack notification
     uses: rtCamp/action-slack-notify@v2
     env:
       SLACK_WEBHOOK: ${{ secrets.SLACK_WEBHOOK_URL }}
       SLACK_MESSAGE: "✅ Pipeline finished!"
   ```
5. Commit + push → verify Slack message received.  

</details>

---

<details>
<summary><b>Task 6 – Combined Frontend & Backend CI/CD</b></summary>

### 📖 Explanation
- Created **frontend/** and **backend/** dummy projects.  
- Each has `package.json` with test scripts (`npm test`).  
- Workflow runs jobs for both projects in parallel with matrix strategy.  
- Artifacts uploaded, Slack notified when both succeed.  

---

### 🛠 Steps
1. Create directories:  
   ```bash
   mkdir frontend backend
   ```
2. Initialize `package.json` in each:  
   ```bash
   npm init -y
   ```
   Edit `test` script:  
   - Frontend → `echo "Frontend tests passed!"`  
   - Backend → `echo "Backend tests passed!"`  
3. Update workflow (`ci-cd.yml`) with two jobs:  
   - Frontend job → `working-directory: frontend`.  
   - Backend job → `working-directory: backend`.  
   - Both run on Node.js 14, 16, 18.  
4. Add notify job with Slack integration.  
5. Commit + push → verify green runs + Slack message.  

</details>

---

## 📌 Notes
- `.gitignore` files added to exclude `node_modules/`, logs, and swap files.  
- Practiced Linux commands: `cp`, `mv`, `diff`, `grep` during exercises.  
- Final summary project is in separate repo: 👉 [week5-ci-cd](https://github.com/nugusu20/week5-ci-cd).

