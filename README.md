# 🚀 Laravel CI/CD Pipeline with Docker, EC2 Deployment, Rollback & Notifications

A fully automated **CI/CD pipeline** for Laravel applications using **GitHub Actions**, **Docker**, and **AWS EC2**, featuring:

- 🧠 Code Quality & Security Analysis  
- 🐳 Containerized Build & Testing  
- 🚀 Automated Deployment with Zero Downtime  
- 🔁 Automatic & Manual Rollback System  
- 🧹 Release Cleanup (Keep last 5 versions)  
- 🔔 Slack & Telegram Notifications  

---

## 🧭 Overview

This pipeline ensures:
- Every push to the **`master`** branch goes through **analyze → build → test → deploy**.  
- Deployment failures **automatically rollback** to the last stable version.  
- You can **manually rollback** from GitHub Actions anytime.  
- Slack and Telegram send real-time deployment alerts.

---

## 🧱 Folder Structure on EC2

After deployment, your Laravel app will be organized as follows:

/var/www/<APP_DIR>/
├── releases/
│ ├── 20251106_204501/
│ ├── 20251107_132314/
│ ├── 20251108_191845/
│ ├── 20251109_183305/
│ └── 20251110_130212/ ← current deployment
└── current → releases/20251110_130212/



✅ `current` → symlink to active release  
🧩 Keeps previous versions for rollback  
🧹 Cleans old releases (retains latest 5)

---

## ⚙️ Pipeline Workflow

### Triggers:
- **Push to `master`** → Full CI/CD process
- **Manual Trigger (rollback=true)** → Performs rollback only

---

## 🧩 Pipeline Stages

### **1️⃣ Code Analysis & Security Scans**
- **Laravel Pint** → code formatting  
- **PHPStan** → static analysis  
- **Composer Audit** → security vulnerabilities  
- **Trivy** → Docker image scan  

### **2️⃣ Build & Test (Docker)**
- Builds Laravel image (`php:8.2-fpm`)  
- Spins up temporary MySQL container  
- Generates `.env` dynamically for tests  
- Runs migrations and unit tests  
- Destroys test containers afterward  

### **3️⃣ Deploy to AWS EC2**
- SSH into EC2 instance  
- Clones repo → installs dependencies  
- Copies `.env` from previous release  
- Runs migrations  
- Updates `current` symlink  
- Reloads Nginx + PHP-FPM (zero downtime)  

### **4️⃣ Rollback Mechanism**
- **Automatic rollback** → on deployment/migration failure  
- **Manual rollback** → trigger from GitHub Actions  

### **5️⃣ Notifications**
- Real-time alerts via **Slack** and **Telegram** for:
  - Success ✅  
  - Failure ❌  
  - Rollback ⚠️  

### **6️⃣ Cleanup**
- Automatically removes old deployments, keeping 5 recent ones.

---

## 🧩 CI/CD Pipeline Flow

```mermaid
flowchart TD

A[Developer Pushes to Master] --> B[GitHub Actions Trigger]

subgraph CI["🧠 Continuous Integration"]
B --> C[🎨 Laravel Pint]
C --> D[🔍 PHPStan Static Analysis]
D --> E[🧩 Composer Audit]
E --> F[🐳 Trivy Security Scan]
F --> G[✅ CI Checks Passed?]
G -->|No| X1[❌ Notify Slack & Telegram - Fail]
G -->|Yes| H[🏗️ Build Docker Image]
end

subgraph TEST["🧪 Docker Test Stage"]
H --> I[🗂️ Start MySQL Container]
I --> J[🗝️ Generate App Key]
J --> K[📜 Run Migrations]
K --> L[🧪 Execute Tests]
L --> M[🧹 Cleanup Containers]
end

M --> N[✅ Tests Passed?]
N -->|No| X2[❌ Notify Slack & Telegram - Fail]
N -->|Yes| O[🚀 Deploy to AWS EC2]

subgraph DEPLOY["🚀 Deployment"]
O --> P[📦 Create New Release]
P --> Q[⚙️ Composer Install]
Q --> R[🔑 Key Generate & Migrate]
R -->|Fail| RB1[⚠️ Auto Rollback → Previous Release]
R -->|Success| S[🔁 Update Symlink to Current]
S --> T[🧹 Cleanup Old Releases (Keep 5)]
T --> U[✅ Reload PHP-FPM & Nginx]
end

U --> V[📣 Notify Slack/Telegram: Success]
RB1 --> V2[📣 Notify Slack/Telegram: Rollback]




flowchart TD

A[Deployment Starts] --> B[Composer Install]
B --> C[Key Generate + Migrate]
C --> D{Successful?}

D -->|Yes| E[✅ Mark as Latest Release]
E --> F[🔗 Update 'current' Symlink]
F --> G[♻️ Reload PHP-FPM + Nginx]
G --> H[📣 Notify Slack/Telegram: Success]

D -->|No| I[⚠️ Auto Rollback Triggered]
I --> J[Find Previous Release]
J --> K[Revert Symlink]
K --> L[♻️ Reload Services]
L --> M[📣 Notify Slack/Telegram: Rollback Done]

subgraph MANUAL["🕓 Manual Rollback Trigger"]
X[User Runs Workflow rollback=true] --> Y[SSH into EC2]
Y --> J
end
