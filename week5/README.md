```markdown
## Task 1 – Intro to GitHub Actions (Q&A)

**What is GitHub Actions?**  
- GitHub’s built-in CI/CD platform for automating build, test, and deployment with YAML workflows.  
- It runs your jobs on managed runners in response to repository events.

**What’s the difference between a Job and a Step?**  
- **Job**: A group of steps that runs on an isolated runner (VM/container). Jobs can run in parallel or depend on other jobs.  
- **Step**: A single action or shell command inside a job. Steps run sequentially and share the job’s workspace and environment.

**Which events can trigger a workflow (name ≥2)?**  
- `push`, `pull_request`.  
- Also: `workflow_dispatch` (manual run), `schedule` (cron), `release`, `tag`.
```

