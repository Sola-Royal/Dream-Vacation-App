# Dream Vacation Destinations 🌍

A full-stack web application that lets users build a personal list of countries they'd like to visit, showing capital, population, and region info fetched from the REST Countries API.

## Tech Stack

| Layer     | Technology                    |
|-----------|-------------------------------|
| Frontend  | React 18, served by Nginx     |
| Backend   | Node.js + Express             |
| Database  | PostgreSQL 15                 |
| Container | Docker + Docker Compose       |


---

## Project Structure

```
Dream-Vacation-App/
├── backend/
│   ├── Dockerfile          # Node.js container
│   ├── server.js
│   └── package.json
├── frontend/
│   ├── Dockerfile          # Multi-stage build → Nginx
│   ├── nginx.conf          # Nginx configuration
│   └── src/
├── db/
│   └── init.sql            # Auto-creates the DB table on first run
├── docker-compose.yml
├── .env                    # Environment variables
└── README.md
```
`The folders and files added are as below`
![alt text](image-4.png)
---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- [Docker Compose](https://docs.docker.com/compose/install/) (v2+ recommended)

---

## Setup & Running the App

### 1. Clone the repository

```bash
git clone https://github.com/Sola-Royal/Dream-Vacation-App.git
cd Dream-Vacation-App
```

### 2. Configure environment variables

A `.env` file is already included at the root with safe defaults:

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=dreamvacations

DATABASE_URL=postgresql://postgres:postgres@db:5432/dreamvacations
PORT=3001
COUNTRIES_API_BASE_URL=https://restcountries.com/v3.1
```

> ⚠️ For production, change `POSTGRES_PASSWORD` to something strong and never commit secrets to version control.


### 3. Build and start all services

```building on the terminal
docker-compose up --build
```
![alt text](image.png)

## The frontend page
![alt text](image-2.png)

## The backend page
![alt text](image-3.png)


This single command will:
1. Build the backend Node.js image
2. Build the frontend React image (multi-stage) and serve it via Nginx
3. Pull the PostgreSQL 15 image
4. Create the `destinations` table automatically via `db/init.sql`
5. Wire all services together on the `vacation-net` bridge network

### 4. Open the app

| Service  | URL                      |
|----------|--------------------------|
| Frontend | http://localhost:8081    |
| Backend  | http://localhost:3001    |

---

## Stopping the App

```bash
docker-compose down
```

To also delete the database volume (all data):

```bash
docker-compose down -v
```

---

## How It Works (Architecture)

```
Browser
  │
  ▼
Frontend (Nginx : port 80)
  │  React app makes API calls to http://localhost:3001
  ▼
Backend (Node.js : port 3001)
  │  Connects via internal DNS name "db" (Docker bridge network)
  ▼
Database (PostgreSQL : port 5432)
```

All three services share the `vacation-net` custom bridge network. Services communicate using their **Docker service names** as hostnames — e.g., the backend connects to `db:5432`, not `localhost:5432`.

---

## Environment Variables Reference

| Variable                | Where Used | Description                                |
|-------------------------|------------|--------------------------------------------|
| `POSTGRES_USER`         | db         | PostgreSQL superuser name                  |
| `POSTGRES_PASSWORD`     | db         | PostgreSQL superuser password              |
| `POSTGRES_DB`           | db         | Database name to create on startup         |
| `DATABASE_URL`          | backend    | Full Postgres connection string            |
| `PORT`                  | backend    | Port the Express server listens on         |
| `COUNTRIES_API_BASE_URL`| backend    | Base URL for the REST Countries API        |

---

## Docker Volumes

| Volume Name     | Purpose                                    |
|-----------------|--------------------------------------------|
| `postgres_data` | Persists database data across restarts     |

---

## CI/CD Pipeline (GitHub Actions)

This project uses automated GitHub Actions workflows to build, test, and deploy both the frontend and backend services:
- **Backend Workflow**: Defined in [.github/workflows/backend.yml](file:///Ubuntu/home/solaroyal2/Dream-Vacation-App/.github/workflows/backend.yml)
- **Frontend Workflow**: Defined in [.github/workflows/frontend.yml](file:///Ubuntu/home/solaroyal2/Dream-Vacation-App/.github/workflows/frontend.yml)

### Workflow Trigger Rules
Both pipelines trigger on:
- Every push or pull request to the `main`, `dev`, or `develop` branches.
- File-path filtering is enabled so changes in `frontend/` only trigger the frontend pipeline, and changes in `backend/` only trigger the backend pipeline.

### Multi-Stage Architecture

```mermaid
graph TD
    A[Push / PR to main/dev/develop] --> B(CI: Lint & Test)
    B -->|Success| C{Is it a Push Event?}
    C -->|Yes| D(CD: Build & Push Docker Image)
    C -->|No: PR Event| E(End Pipeline)
    D --> F[Docker Hub Registry]
```

1. **CI Stage (Lint & Test)**:
   - Sets up Node.js 18 with caching of npm dependencies.
   - Installs dependencies using `npm ci`.
   - Runs code linting (`npm run lint`).
   - Runs unit tests (`npm run test` using Jest).
2. **CD Stage (Build & Push)**:
   - Dependent on the CI stage passing.
   - Only executes on **push** events to the targeted branches.
   - Sets up QEMU and Docker Buildx.
   - Logs into Docker Hub.
   - Builds the Docker image and tags it dynamically.
   - Pushes the image to the Docker Hub registry.

### Required GitHub Secrets
To authenticate and push images to your Docker Hub registry, you must configure the following Repository Secrets in GitHub (`Settings -> Secrets and variables -> Actions`):
- `DOCKER_USERNAME`: Your Docker Hub username.
- `DOCKER_TOKEN`: Your Docker Hub Personal Access Token (PAT).

### Image Tagging Strategy
Images pushed to Docker Hub are tagged automatically based on the Git context:
- `sha-<commit-sha>`: Explicit commit SHA tag for precise version tracking (e.g. `sha-4a2c71...`).
- `<branch-name>`: The active branch name (e.g. `main`, `develop`, `dev`).
- `latest`: Pushed only on the `main` branch.

### Workflows, Secrets, and Image Names (explicit)

- **Workflow files:**
  - `.github/workflows/backend.yml` (backend CI/CD)
  - `.github/workflows/frontend.yml` (frontend CI/CD)
- **Secrets required (Repository → Settings → Secrets and variables → Actions):**
  - `DOCKER_USERNAME` — Docker Hub username
  - `DOCKER_TOKEN` — Docker Hub access token (with write permissions)
- **Docker images pushed to Docker Hub:**
  - `${DOCKER_USERNAME}/dream-vacation-backend` — tags: `sha` (full commit SHA), branch name, and `latest` (when on `main`)
  - `${DOCKER_USERNAME}/dream-vacation-frontend` — same tagging strategy as backend

Example pushed image names you will see in Docker Hub:

```
yourdockeruser/dream-vacation-backend:0a1b2c3d4e...   # commit SHA tag
yourdockeruser/dream-vacation-backend:dev            # branch tag
yourdockeruser/dream-vacation-backend:latest         # main branch latest

yourdockeruser/dream-vacation-frontend:0a1b2c3d4e...
yourdockeruser/dream-vacation-frontend:dev
yourdockeruser/dream-vacation-frontend:latest
```

---

## Thank you for using this repository.