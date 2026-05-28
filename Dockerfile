# Use the official Go image as the build stage.
# Alpine keeps the build environment lightweight.
FROM golang:1.23-alpine AS builder

# Set the working directory inside the build container.
WORKDIR /app

# Copy the Go module file first.
# This helps Docker cache dependencies between builds.
COPY go.mod ./

# Download Go dependencies.
# In this project there are no external dependencies yet, but this is a good practice.
RUN go mod download

# Copy the rest of the application source code.
COPY . .

# Build the Go application as a static Linux binary.
# CGO_ENABLED=0 makes the binary easier to run in a minimal container image.
RUN CGO_ENABLED=0 GOOS=linux go build -o devops-local-pipeline-lab ./cmd/server

# Use a small Alpine image for the final runtime container.
FROM alpine:3.20

# Create a non-root user and group for better container security.
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory inside the runtime container.
WORKDIR /app

# Copy only the compiled binary from the builder stage.
# Source code and build tools are not included in the final image.
COPY --from=builder /app/devops-local-pipeline-lab .

# Run the application as a non-root user.
USER appuser

# Document that the application listens on port 8080.
EXPOSE 8080

# Set the default application port.
ENV APP_PORT=8080

# Set the default application version shown by the /version endpoint.
ENV APP_VERSION=1.0.0

# Define a container healthcheck.
# Docker will periodically call the /health endpoint to verify that the app is running.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

# Start the application.
CMD ["./devops-local-pipeline-lab"]
