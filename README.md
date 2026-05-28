# DevOps Local Pipeline Lab

Small Go-based microservice used to demonstrate a basic DevOps workflow:
local development, Docker multi-stage build, GitLab CI validation and Kubernetes-ready service endpoints.

## Features

- HTTP service written in Go
- `/health`, `/ready` and `/version` endpoints
- Multi-stage Docker build
- Non-root container runtime
- Docker healthcheck
- GitLab CI pipeline for tests and Docker build
- Simple Makefile for local workflow

## Project structure

```text
devops-local-pipeline-lab/
├── cmd/server/
│   ├── main.go
│   └── main_test.go
├── Dockerfile
├── .dockerignore
├── .gitlab-ci.yml
├── Makefile
├── go.mod
└── README.md
```

## Run locally

```bash
go run ./cmd/server
```

## Test locally

```bash
go test ./...
```

## Build Docker image

```bash
docker build -t devops-local-pipeline-lab:1.0.0 .
```

## Run Docker container

```bash
docker run --rm -p 8080:8080 devops-local-pipeline-lab:1.0.0
```

## Run Docker container in detached mode

```bash
docker run -d --name devops-lab -p 8080:8080 devops-local-pipeline-lab:1.0.0
```

## Test endpoints

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
curl http://localhost:8080/ready
curl http://localhost:8080/version
```

## Stop detached container

```bash
docker stop devops-lab
docker rm devops-lab
```

## Makefile commands

```bash
make test
make run
make docker-build
make docker-run
make docker-run-detached
make docker-stop
```

## GitLab CI

The included `.gitlab-ci.yml` validates the application by running Go tests and building the Docker image.

Pipeline stages:

1. `test`
2. `docker-build`

## DevOps purpose

This project demonstrates a simple production-style service lifecycle:

1. Application code
2. Local tests
3. Multi-stage container build
4. Health and readiness endpoints
5. Docker healthcheck
6. CI pipeline validation
7. Foundation for future Kubernetes deployment
