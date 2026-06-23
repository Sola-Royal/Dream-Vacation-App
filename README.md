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

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- [Docker Compose](https://docs.docker.com/compose/install/) (v2+ recommended)

---

## Setup & Running the App

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/Dream-Vacation-App.git
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

```bash
docker-compose up --build
```

This single command will:
1. Build the backend Node.js image
2. Build the frontend React image (multi-stage) and serve it via Nginx
3. Pull the PostgreSQL 15 image
4. Create the `destinations` table automatically via `db/init.sql`
5. Wire all services together on the `vacation-net` bridge network

### 4. Open the app

| Service  | URL                      |
|----------|--------------------------|
| Frontend | http://localhost         |
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

## Submission Checklist

- [x] `backend/Dockerfile` — Node.js container with dependency install
- [x] `frontend/Dockerfile` — Multi-stage build (Node build → Nginx serve)
- [x] `docker-compose.yml` — Orchestrates frontend, backend, and database
- [x] `.env` — Central environment variable configuration
- [x] Custom bridge network (`vacation-net`)
- [x] Named volume for database persistence (`postgres_data`)
- [x] DB healthcheck ensures backend waits for Postgres to be ready
- [x] `README.md` — This file
