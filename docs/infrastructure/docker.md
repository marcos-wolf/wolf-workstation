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
