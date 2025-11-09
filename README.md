# 🚀 Laravel Dockerized CI/CD Pipeline with GitHub Actions and AWS EC2

### Author: **Makresh Nayak**  
### Technologies: Laravel • Docker • Nginx • MySQL • GitHub Actions • AWS EC2 • DevOps Automation

---

## 🧭 Overview

This repository demonstrates a **complete DevOps workflow** for a Laravel application — from local containerization to automated deployment on AWS EC2 using GitHub Actions.

It focuses on building a **modern, production-grade Laravel environment** with CI/CD automation, environment initialization, and infrastructure orchestration.

---

## ⚙️ Core Concepts Implemented

### 🐳 **Dockerization**
- Laravel app containerized using a **multi-stage PHP-FPM image**.
- **Nginx** reverse proxy configured to serve Laravel from `/public`.
- **MySQL** database container with persistent volume storage.
- Organized **Docker Compose** stack for app, webserver, and database.

### 🔑 **Automation**
- Custom **entrypoint script** to:
  - Wait for MySQL container readiness.
  - Automatically generate `APP_KEY` (if missing).
  - Run database migrations during startup.

### 🌐 **Local Development**
- Local domain mapping via `/etc/hosts` (e.g., `http://myapp.local`).
- Clean reverse-proxy routing through Nginx (port 80 only).
- Consistent environment between local and production.

### 🧪 **CI/CD Pipeline**
- **GitHub Actions** workflow automates:
  - Composer dependency installation.
  - Application testing and migrations.
  - Docker image build process.
- Supports **continuous delivery** directly to AWS EC2.

### ☁️ **AWS EC2 Deployment**
- Automated deployment using **appleboy/ssh-action**.
- Pulls latest code, rebuilds containers, and redeploys app.
- Zero-downtime restarts using `docker-compose up -d --build`.
- Full container lifecycle managed remotely via CI/CD.

---

## 🧱 Infrastructure Highlights

| Component | Purpose |
|------------|----------|
| **Laravel App (PHP-FPM)** | Core application runtime |
| **Nginx** | Reverse proxy + static file serving |
| **MySQL** | Application database |
| **Docker Compose** | Container orchestration |
| **Volumes** | Persistent database storage |
| **GitHub Actions** | Continuous integration & deployment |
| **AWS EC2** | Production host environment |

---

## 🧩 DevOps Techniques Used

| Technique | Description |
|------------|-------------|
| **Multi-Stage Builds** | Reduced image size and faster caching |
| **Container Networking** | Internal communication between app and DB |
| **Reverse Proxy** | Portless URL access and routing control |
| **Startup Automation** | Self-configuring Laravel container |
| **Continuous Integration** | Automated testing and building |
| **Continuous Deployment** | Auto-deploy to EC2 via SSH |
| **Environment Isolation** | Consistent parity between environments |
| **Health Checks** | Ensured MySQL readiness before app start |
| **Version Control Integration** | Triggered workflows on `main` branch pushes |

---

## 🧠 DevOps Principles Applied

1. **Infrastructure as Code (IaC)** – Every service defined declaratively.  
2. **Immutable Builds** – Docker images rebuilt fresh on each deployment.  
3. **Environment Consistency** – Local, CI, and production environments identical.  
4. **Automation First** – No manual configuration needed after `git push`.  
5. **Scalability Ready** – App can be replicated or scaled horizontally.  
6. **Stateless Containers** – State stored only in persistent Docker volumes.  
7. **Zero Manual Deployment** – Fully automated GitHub → EC2 pipeline.

---

## 🧭 Deployment Flow Summary


~~~
+------------------------+
| 1️⃣ Push to main branch |
+-----------+------------+
            |
            v
+------------------------+
| 🧪 Build & Test in CI  |
| - Composer install     |
| - Laravel migrate/test |
| - Docker build         |
+-----------+------------+
            |
            v
+------------------------+
| ✅ Deploy to EC2        |
| - SSH via secrets       |
| - Git pull              |
| - docker-compose up     |
+------------------------+

~~~

---

## 📦 Achievements

✅ Fully containerized Laravel environment  
✅ Automatic environment setup (`key:generate`, `migrate`)  
✅ Clean reverse-proxy based local URL (`myapp.local`)  
✅ Continuous Integration with GitHub Actions  
✅ Continuous Deployment to AWS EC2 via SSH  
✅ Infrastructure reproducibility with Docker Compose  
✅ Developer-friendly and production-safe workflow  

---

## 🧩 Future Enhancements

- Add **phpMyAdmin** for database management  
- Add **Redis** for cache and queue support  
- Add **SSL/HTTPS** via Let’s Encrypt or Traefik  
- Push Docker images to **Docker Hub or AWS ECR**  
- Add **Blue-Green deployment** strategy for zero downtime  

---

## 🏁 Final Words

> “This project follows the modern DevOps philosophy — build once, ship anywhere, and automate everything.”  
>
> **From local Docker setup → GitHub Actions CI/CD → AWS EC2 deployment**,  
> this workflow achieves end-to-end delivery automation with Laravel.

---
