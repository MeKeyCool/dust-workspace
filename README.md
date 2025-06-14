Voici une version mise à jour et enrichie du `README.md` de ton projet **Dust-Workspace**, incluant :

* La structure réelle du dossier `infra`
* Des explications concrètes sur la commande `bootstrap`
* Le cycle de vie global des tâches (préparation, montée, initialisation)
* La logique de gestion des environnements (`env/`, `infra/configuration/`)

# Dust-Workspace

A custom local environment designed to develop and contribute to the [Dust](https://github.com/dust-tt/dust) open-source AI platform.

This workspace uses `docker-compose`, `Taskfile`, and `k3d` to provide a robust and reproducible development environment, with a clear separation between infrastructure services and application code.

### Objectives

* Run Dust locally with ease
* Understand its architecture in depth
* Explore and contribute to the codebase (bugfixes, docs, features)
* Prepare for potential collaboration or contributions to the Dust project

## Prerequisites

To run this project locally, only the following tools are required:

* [Docker](https://docs.docker.com/engine/install/)
* [Taskfile](https://taskfile.dev/installation/)
* [k3d](https://k3d.io/stable/#releases)

## Project Structure

```text
.
├── doc/                        # Project documentation (notes, references, etc.)
├── env/                        # Environment config and state data
│   ├── backup/                   # Backups of previous env states
│   ├── ${DEPLOY_ENV}/            # Per-env generated config (copied from template)
│   ├── project.env               # Main env file loaded by Taskfile
│   └── project.env.template      # Example template to create project.env
├── infra/
│   ├── configuration/            # Versioned .env templates
│   │   ├── default/                # Default values (not secure)
│   │   └── local/                  # Ready-to-use local values (dev only)
│   ├── docker/
│   │   ├── docker-compose.*.yaml   # Docker Compose stacks (app, infra, tools)
│   │   ├── elasticsearch/
│   │   ├── rust/
│   │   ├── typescript/
│   │   ├── kubectl/
│   │   └── utils/
│   └── kubernetes/               # K8s infra (under work)
│       ├── manifests/
│       └── ...
├── src/
│   └── dust/                     # Git submodule to https://github.com/dust-tt/dust
├── Taskfile.yaml               # Main Taskfile (entry point)
├── Taskfile.infra.yaml         # Infra-specific tasks
├── Taskfile.app.yaml           # App-specific tasks (frontend + backend)
```

## Environment & Config Management

The workspace uses two layers of configuration:

1. **Project-level config**: `env/project.env`

   * Sets global variables (like `DSW_DEPLOY_ENV`)
   * Loaded automatically in all tasks

2. **Environment-specific `.env` files**:

   * Located in `infra/configuration/<env>/`
   * One `.env` file per service: `dust.backend.env`, `dust.front.env`, `dust.db.env`, etc.
   * These files are copied into `env/<env>/` during setup

### Example:

```bash
# Prepare local config
task env-config-prepare

# Open config in your editor
task env-config-edit
```

## Lifecycle Overview

The project lifecycle is structured into **3 phases**, each handled by a dedicated Taskfile layer:

### Phase 0 — Preparation (no containers)

```bash
task prep       # Prepare folders, copy configs, volumes
task purge      # Remove all preparation (but keep backups)
task rebase     # Full reset (purge + prep)
```

### Phase 1 — Runtime (containers)

```bash
task up         # Start containers (infra + app)
task down       # Stop containers
task restart    # Full restart
```

### Phase 2 — Initialization (services)

```bash
task init       # Init DBs, search indexes, builds
task clean      # Clean volumes/state
task reset      # Clean + init
```

## Recommended Bootstrap

Set project env file :

```bash
cp env/project.env.template env/project.env
```
Then edit `DSW_DEPLOY_ENV`value.


To get everything running in one go:

```bash
task bootstrap
```

This runs the following:

1. `task host-init` → clone submodules
2. `task env-config-prepare` → copy default or local env templates
  > For first local run, you may select 'local' (unsecure but easy to test)
3. `task prep` → prepare local folders, volumes
4. `task up` → launch Docker services
5. `task init` → initialize DBs, indexes, builds

## Architecture Principles

* **Code vs Infra**: Strictly separated (`src/` vs `infra/`)
* **Container-only Tooling**: All tools run in Docker; no global installs needed
* **Environment Isolation**: Each `DEPLOY_ENV` is scoped and backed up
* **App vs Infra Separation**: Compose files and Taskfiles are split cleanly
* **Stateless Host**: Reset and reproduce easily; Git is your source of truth

## Testing & CI Compatibility

A dedicated test DB (`dust_front_test`) is included for test tasks and CI compatibility.

Example test `.env` snippet:

```yaml
env:
  FRONT_DATABASE_URI: "postgres://test:test@localhost:5433/dust_front_test"
  REDIS_CACHE_URI: "redis://localhost:5434"
  NODE_ENV: test
```

## Kubernetes Support

UNDER WORK

## Troubleshooting & Utilities

```bash
task status-all     # Show status of prep / up / init
task log-system     # Show Docker/system diagnostics
task host-clean     # Stop and remove containers/volumes
task host-purge     # Full Docker purge + optional env cleanup
```

## Contributing

Please follow the conventions from the main Dust repo, including:

* Code formatting with Prettier / ESLint
* English-only code/comments
* No emoji or unnecessary decoration

