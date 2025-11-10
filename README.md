# 🚀 Laravel CI/CD Pipeline with Docker, Security Scans & Automated Deployment

This repository demonstrates a **complete CI/CD (Continuous Integration and Deployment) pipeline** for a Laravel application using **GitHub Actions** and **Docker**.  
It automates everything — from code analysis and testing to secure image builds and deployment to AWS EC2.

---

## 🧠 Overview

The pipeline ensures every code change is:
- **Analyzed** for code quality and vulnerabilities  
- **Tested** inside a real Docker container  
- **Packaged** as a secure, versioned Docker image  
- **Deployed** automatically to production  
- **Fully auditable**, consistent, and hands-free  

This approach delivers a **reliable, secure, and production-grade** Laravel deployment process.

---

## ⚙️ Pipeline Highlights

### 🧩 1. Code Quality and Security Analysis
Every push triggers automated scans to maintain reliability and safety:
- **Laravel Pint** enforces clean and consistent code formatting.
- **PHPStan / Larastan** performs static code analysis to detect hidden bugs and type errors.
- **Composer Audit** checks PHP dependencies against known vulnerabilities.
- **Trivy** scans Docker base images for OS-level and library security issues.

✅ Only clean, safe, and secure code advances to the next stage.

---

### 🐳 2. Docker-Based Build and Testing
Using **Docker Buildx**, the pipeline builds the Laravel application image directly from your project’s Dockerfile.  
A temporary container is then created to:
- Generate an app key  
- Run migrations  
- Execute Laravel’s test suite (`php artisan test`)  

✅ Tests run in the **same environment as production**, ensuring accuracy and stability.

---

### 📦 3. Verified Image Publishing
When all tests pass:
- The image is **tagged and pushed** to Docker Hub (or another registry).  
- Each image is **versioned automatically** using the GitHub Actions run number.

✅ Guarantees every deployed image is tested, reproducible, and traceable.

---

### 🚀 4. Automated Deployment to EC2
The pipeline securely connects to your **AWS EC2** instance:
- Pulls the latest image from Docker Hub  
- Stops and removes the previous container  
- Starts a new container automatically with updated environment variables  

✅ The deployment is fully automated — no manual server steps required.

---

### 🔒 5. DevSecOps Integration
The workflow applies **DevSecOps principles** by embedding security and compliance checks into every stage:
- Continuous vulnerability scanning  
- Code and dependency audits  
- Immutable Docker image builds  
- Secure secret management through GitHub Secrets  

✅ The pipeline ensures security, stability, and compliance — before, during, and after deployment.

---

## 🧱 CI/CD Pipeline Flow (Visual Diagram)

```mermaid
flowchart TD
    A[👨‍💻 Developer pushes code] --> B[🔍 Code Quality & Security Analysis]
    B --> C[🐳 Docker Build & Containerized Testing]
    C --> D[✅ Tests Passed]
    D --> E[📦 Push Verified Docker Image to Registry]
    E --> F[🚀 Deploy to AWS EC2]
    F --> G[🌐 Laravel App Live in Production]
    
    B -.->|❌ Fails| X[⚠️ Stop Pipeline - Fix Issues]
    C -.->|❌ Tests Fail| X
