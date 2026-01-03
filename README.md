# MU Online WebEngine 1.2.6 - Containerized Lab

This project provides a fully containerized environment for running the WebEngine CMS for MU Online, utilizing a modern PHP 8.2 stack and Microsoft SQL Server 2022.

## 🚀 What the App Does
This application is a Content Management System (CMS) specifically designed for MU Online private servers. It handles:
* **User Accounts:** Registration and login management (linked to `MEMB_INFO`).
* **Game Integration:** Real-time character displays and rankings (linked to `Character`).
* **News & Updates:** Admin-managed news feed for the community.
* **Control Panel:** User features like adding stats, resets, and clearing PK status.

---

## 🛠 How to Run It

### Prerequisites
* Docker and Docker Compose installed on your machine.
* Azure Data Studio (recommended) for database management.

### Deployment Steps
1. **Prepare the Source:** Ensure your WebEngine files are in the `src/` directory.
2. **Build and Start:**
   ```bash
   docker-compose up -d --build
   