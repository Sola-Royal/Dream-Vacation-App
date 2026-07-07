## CI/CD Pipeline

This project uses **GitHub Actions** to automate build, test, and deployment of both services on every push or pull request to `main` or `dev`.

### How it works

Two independent workflows live in `.github/workflows/`:

- **`backend.yml`** — triggers only when files under `backend/` change
- **`frontend.yml`** — triggers only when files under `frontend/` change

Each workflow runs three stages in sequence:

1. **Lint** — installs dependencies and runs `npm run lint` (skipped safely if no lint script exists)
2. **Build & Test** — installs dependencies, runs `npm test`, then does a local Docker build to confirm the image compiles
3. **Push Image** — on a successful push to `main` or `dev` (not on pull requests), logs into Docker Hub and pushes the image tagged with both the commit SHA and `latest`

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

### Image tagging

Every image pushed is tagged two ways:
- `<dockerhub-username>/dream-vacation-backend:<commit-sha>` — traceable to the exact commit
- `<dockerhub-username>/dream-vacation-backend:latest` — always the newest build

(Same pattern for the frontend image.)

### Secrets required

Configured under **Settings → Secrets and variables → Actions**:

| Secret | Purpose |
|---|---|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_TOKEN` | Docker Hub access token (Read & Write) |

### Deploying locally with the pushed images

```bash
docker pull <dockerhub-username>/dream-vacation-backend:latest
docker pull <dockerhub-username>/dream-vacation-frontend:latest
docker compose up -d
```

`docker-compose.yml` orchestrates the frontend, backend, and PostgreSQL database together on the `vacation-net` bridge network, using the environment variables defined in `.env` (see `.env.example`).