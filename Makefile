APP_NAME=devops-local-pipeline-lab
IMAGE_NAME=devops-local-pipeline-lab
IMAGE_TAG=1.0.0

.PHONY: test run docker-build docker-run docker-run-detached docker-stop clean

test:
	go test ./...

run:
	go run ./cmd/server

docker-build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

docker-run:
	docker run --rm -p 8080:8080 $(IMAGE_NAME):$(IMAGE_TAG)

docker-run-detached:
	docker run -d --name devops-lab -p 8080:8080 $(IMAGE_NAME):$(IMAGE_TAG)

docker-stop:
	docker stop devops-lab || true
	docker rm devops-lab || true

clean:
	docker rmi $(IMAGE_NAME):$(IMAGE_TAG) || true

helm-lint:
	helm lint charts/microservice

helm-template:
	helm template devops-local-pipeline-lab charts/microservice
