# Docker

Docker is the containerization platform used by wolf-workstation for local development and infrastructure services.

## Installation

Docker Engine is installed from the official Docker APT repository rather than the Ubuntu `docker.io` package or Snap.

The repository is configured at:

```text
/etc/apt/sources.list.d/docker.sources
```

The official repository signing key is stored at:

```text
/etc/apt/keyrings/docker.asc
```

## Installed Components

The workstation uses the following Docker components:

```text
docker-ce
docker-ce-cli
containerd.io
docker-buildx-plugin
docker-compose-plugin
```

Their roles are:

```text
Docker Engine       → container runtime and daemon
Docker CLI           → command-line interface
containerd           → container runtime
Buildx               → modern image building
Compose plugin       → multi-container applications
```

## User Access

The Linux user `wolf` belongs to the `docker` group.

This allows Docker commands to be executed without `sudo`:

```bash
docker ps
docker run hello-world
```

This is convenient for development, but membership in the `docker` group grants highly privileged access to the Docker daemon and should be treated accordingly.

## Validation

Docker installation was validated with:

```bash
docker --version
docker compose version
docker buildx version
systemctl status docker --no-pager
```

The Docker Engine was also tested by running:

```bash
docker run hello-world
```

The container successfully:

1. Connected the Docker client to the daemon.
2. Pulled the `hello-world` image from Docker Hub.
3. Created a container.
4. Executed the container.
5. Returned its output to the terminal.

Container listing was also verified:

```bash
docker ps
```

## Basic Commands

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

List local images:

```bash
docker images
```

Download an image:

```bash
docker pull IMAGE
```

Run a container:

```bash
docker run IMAGE
```

Stop a running container:

```bash
docker stop CONTAINER
```

Remove a container:

```bash
docker rm CONTAINER
```

Remove an image:

```bash
docker rmi IMAGE
```

## Compose

Docker Compose is installed as the Docker CLI plugin.

The modern syntax is:

```bash
docker compose
```

rather than the legacy:

```bash
docker-compose
```

Compose will be used to define reproducible local infrastructure such as databases, caches and development services.

## PostgreSQL Compose Test

A PostgreSQL test environment was created to validate Docker Compose, container lifecycle management, healthchecks and persistent volumes.

The test project is located in this repository at:

```text
~/Projects/wolf-workstation/projects/docker/wolf-infra-test
```

Its Compose configuration contains:

```text
PostgreSQL
Docker Compose
Persistent Docker volume
PostgreSQL healthcheck
Local port 5432
```

The environment can be started with:

```bash
cd ~/Projects/wolf-workstation/projects/docker/wolf-infra-test
docker compose up -d
```

Check its status with:

```bash
docker compose ps
```

The PostgreSQL service should eventually report a healthy status.

The database can be accessed with:

```bash
docker exec -it wolf-postgres psql -U wolf -d wolfdb
```

The test environment was validated by creating a PostgreSQL table and inserting data.

The container was then removed with:

```bash
docker compose down
```

The environment was recreated with:

```bash
docker compose up -d
```

The previously created database data remained available.

This confirms that the data is stored in a Docker volume rather than only in the container's writable layer.

Do not use:

```bash
docker compose down -v
```

when persistent data must be preserved, because the `-v` option removes the project's volumes.

## Persistence Model

The test demonstrates the following model:

```text
Docker Compose
│
├── PostgreSQL container
│   └── can be destroyed and recreated
│
└── Docker volume
    └── persists database data
```

Containers are treated as ephemeral compute environments, while persistent application data is stored separately in volumes.

## Security Note

The PostgreSQL password used in the local test environment is a development-only credential.

Real credentials must not be committed to Git.

Future projects should supply sensitive configuration through environment variables, `.env` files excluded from Git, or a dedicated secrets-management solution.

## Design Principle

Docker is used primarily for development infrastructure rather than replacing the host operating system.

The intended architecture is:

```text
Ubuntu host
│
├── Development tools
│   ├── Python
│   ├── Node.js
│   ├── C/C++
│   └── VS Code
│
└── Docker
    ├── PostgreSQL
    ├── Redis
    ├── Development services
    └── Other project dependencies
```

This keeps the host relatively clean while making project infrastructure reproducible and isolated.
