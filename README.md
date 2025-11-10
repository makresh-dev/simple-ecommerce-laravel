# 🚀 Laravel CI/CD Pipeline with Docker, EC2 Deployment, Rollback & Notifications

A fully automated **CI/CD pipeline** for Laravel applications using **GitHub Actions**, **Docker**, and **AWS EC2**.

It features:
- 🧠 Code Quality & Security Analysis  
- 🐳 Containerized Build & Testing  
- 🚀 Automated Deployment with Zero Downtime  
- 🔁 Automatic & Manual Rollback System  
- 🔔 Slack & Telegram Notifications  
- 🧹 Release Cleanup (Keep last 5 versions)

---

## 🧭 Overview

Every push to the **`master`** branch triggers:
1. Code quality and security checks  
2. Docker image build and tests  
3. Deployment to EC2  
4. Automatic rollback on failure  
5. Slack & Telegram notifications  

You can also **manually trigger rollback** if needed from the GitHub Actions UI.

---

## 🧱 Folder Structure on EC2

After deployment, your Laravel project will be structured like this:

~~~
/var/www/<APP_DIR>/
├── releases/
│ ├── 20251106_204501/
│ ├── 20251107_132314/
│ ├── 20251108_191845/
│ ├── 20251109_183305/
│ └── 20251110_130212/ ← current deployment
└── current → releases/20251110_130212/
~~~


✅ `current` → symbolic link to the latest release  
🧩 Keeps older releases for rollback  
🧹 Cleans older releases (keeps latest 5)

---

## ⚙️ Workflow Stages

### 1️⃣ Code Analysis & Security Checks
Performs linting and static analysis before building:

| Tool | Purpose |
|------|----------|
| Laravel Pint | Code style consistency |
| PHPStan | Static analysis |
| Composer Audit | Vulnerability check |
| Trivy | Dockerfile security scan |

---

### 2️⃣ Build & Test (Dockerized)
- Builds Laravel Docker image (`php:8.2-fpm`)
- Starts a temporary MySQL container
- Generates `.env` dynamically
- Runs migrations & test suite
- Cleans containers post-test

---

### 3️⃣ Deployment (AWS EC2)
- SSHs into EC2 instance  
- Clones repo and installs dependencies  
- Copies `.env` file from previous release  
- Runs migrations & optimization commands  
- Updates `current` symlink  
- Reloads PHP-FPM & Nginx (zero downtime)  

---

### 4️⃣ Rollback Mechanism
- **Automatic rollback:** Triggered on any deployment/migration failure  
- **Manual rollback:** Triggered manually through GitHub workflow dispatch  

---

### 5️⃣ Notifications
Sends updates via:
- 💬 **Slack** – team channel updates  
- 📱 **Telegram** – private or group notifications  

Alerts include:
- ✅ Successful Deployment  
- ❌ Failed Deployment (with auto rollback)  
- ⚠️ Rollback completed  
- 🕓 Manual rollback executed  

---

### 6️⃣ Cleanup System
After every successful deployment, older releases are cleaned up automatically:
```bash
cd /var/www/<APP_DIR>/releases
ls -1t | tail -n +6 | xargs sudo rm -rf



```mermaid
    flowchart TD

A[👨‍💻 Push to Master Branch] --> B[⚙️ GitHub Actions Triggered]

subgraph CI["🧠 Continuous Integration"]
B --> C[🎨 Laravel Pint - Code Style]
C --> D[🔍 PHPStan - Static Analysis]
D --> E[🧩 Composer Audit - Security]
E --> F[🐳 Trivy - Dockerfile Security Scan]
F --> G{✅ All Checks Passed?}
G -->|❌| X1[❌ Fail → Notify Slack/Telegram]
G -->|✅| H[🏗️ Build Docker Image]
end

subgraph TEST["🧪 Containerized Testing"]
H --> I[🗂️ Start MySQL Container]
I --> J[🗝️ Generate .env and App Key]
J --> K[📜 Run Migrations]
K --> L[🧪 Execute Unit/Feature Tests]
L --> M[🧹 Clean Test Containers]
end

M --> N{✅ Tests Successful?}
N -->|❌| X2[❌ Fail → Notify Slack/Telegram]
N -->|✅| O[🚀 Deploy to AWS EC2]

subgraph DEPLOY["🚀 Deployment Stage"]
O --> P[📦 Create New Release Directory]
P --> Q[⚙️ Install Dependencies]
Q --> R[🔑 Run Key Generate + Migrations]
R -->|❌| RB1[⚠️ Auto Rollback → Previous Release]
R -->|✅| S[🔁 Update Symlink to Current]
S --> T[🧹 Remove Old Releases (>5)]
T --> U[♻️ Reload PHP-FPM + Nginx]
end

U --> V[📣 Notify Slack/Telegram: Success]
RB1 --> V2[📣 Notify Slack/Telegram: Rollback Completed]



flowchart TD

A[⚙️ Deployment Starts] --> B[🏗️ Composer Install]
B --> C[🔑 Key Generate + Migrate]
C --> D{✅ Deployment Successful?}

D -->|✅ Yes| E[Update 'current' Symlink]
E --> F[♻️ Reload Services]
F --> G[📣 Notify Slack/Telegram: Success]

D -->|❌ No| H[⚠️ Auto Rollback Triggered]
H --> I[Find Previous Release]
I --> J[Revert Symlink to Previous]
J --> K[♻️ Reload Services]
K --> L[📣 Notify Slack/Telegram: Rollback Completed]

subgraph MANUAL["🕓 Manual Rollback Trigger"]
X[User Triggers rollback=true in GitHub Actions]
X --> I
end
