# Dust-Workspace

A custom local environment designed to develop and contribute to the [Dust](https://github.com/dust-tt/dust) open-source AI platform.

This workspace uses `docker-compose`, `Taskfile`, and `k3d` to provide a robust and reproducible development environment, with a clear separation between infrastructure services and application code.

The goals of this project include:

* Running Dust locally with ease
* Understanding its architecture in depth
* Exploring and contributing to the codebase (bugfixes, docs, features)
* Preparing for potential collaboration or contributions to the Dust project


## Prerequisites

To run this project locally, only the following tools are required:

- [Docker](https://docs.docker.com/engine/install/)
- [Taskfile](https://taskfile.dev/installation/)
- [k3d](https://k3d.io/stable/#releases)


## Project Structure

```text
.
├── doc/                          # Project documentation (notes, references, etc.)
├── env/                          # Environment config and state data
│   ├── backup/                     # backups of env files or state
│   ├── ${DEPLOY_ENV}/              # Local environment-specific data (logs, cache, volumes, etc.)
│   ├── project.env                 # Main env file for host setup
│   └── project.env.template        # Example template to create project.env
├── infra/                        # Infrastructure configuration
│   ├── configuration/              # Templated .env and config files
│   │   ├── default/                  # Default versioned configuration (Replace 'TO_BE_REPLACED' values)
│   │   └── local/                    # Local overrides or secrets (Default local version for easy install)
│   └── docker/                     # Dockerfiles and docker-compose stacks
│       ├── docker-compose.yaml       # Main docker-compose stack
│       ├── elasticsearch/            # Elasticsearch service config
│       ├── rust/                     # Dockerfile and setup for backend
│       ├── typescript/               # Dockerfile for Dust frontend
│       └── utils/                    # Shared utility scripts (shell, kubectl)
├── src/                          # Application source code
│   └── dust/                       # Dust repository as a Git submodule (https://github.com/dust-tt/dust)
├── Taskfile.yaml                 # Main task runner configuration (setup, run, reset, etc.)
├── Taskfile.dust.yaml            # Dust-specific task definitions (dev, db, etc.)


## Initial Setup

```bash
# Step 1: Copy and customize your local environment file
cp env/project.env.template env/project.env

# Step 2: Run initial setup tasks
task host-init
task infra-init
```

> ⚠️ Note: The official `init_dev_container.sh` script from the Dust repository is **not** used here.
>
> This workspace uses its own Docker Compose and Taskfile setup, initializing both `dust_api` and `dust_front_test` PostgreSQL databases directly. The Dust script can be used as a reference but should **not be executed** as-is.


## Configuration Guidelines

* All configuration values should be stored in `.env` files under `infra/configuration/<DEPLOY_ENV>/`.
* The default configuration is under `default/`.
* ⚠️ If you use DEPLOY_ENV=local, `local/` configuration will be used (highly insecure but easy to install and tests).
* Environment variables are loaded explicitly by Docker Compose and the Taskfile to ensure reproducibility.


## Architecture Principles

* **Code & Infra Separation**: All infra logic is in `infra/`. No source code lives outside `src/`.
* **Docker by Default**: Nothing is installed on the host beyond Docker & Taskfile. All tooling is containerized.
* **Dual Database Support**: Separate databases are used for development and testing (`dust_api`, `dust_front_test`).
* **Taskfile as Entry Point**: Every common operation (init, up, test, reset) is encoded as a Taskfile task.


## Development Flow

1. **Run Dust (backend + frontend) locally with Docker Compose**

2. **Infra dependencies (Postgres, Redis, Qdrant, Elasticsearch)**
  * Third-party services are run in a local k3d cluster for production parity.
  * Use NodePorts or Docker network bridges to connect Docker Compose apps to k3d services.

  > Not yet implemented

## Code Guidelines

* Linting and formatting follow Dust conventions (via `eslint`, `prettier`, etc.).
* English (code, documentation and comments) and no fancy emoji.


## Testing & CI Compatibility

* A dedicated test database (`dust_front_test`) is configured to avoid polluting development data.
* Environment variables used for tests mimic the GitHub Actions setup:

```yaml
env:
  FRONT_DATABASE_URI: "postgres://test:test@localhost:5433/dust_front_test"
  REDIS_CACHE_URI: "redis://localhost:5434"
  NODE_ENV: test
```
