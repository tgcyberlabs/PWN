#!/bin/bash
set -euo pipefail

show_usage() {
    echo "Usage: $0 <docker-name> <host-port>"
    echo "Example: $0 ctf-challenge 1337"
    echo "Note: Maps <host-port> to container port 9999"
    exit 1
}

if [ "$#" -ne 2 ]; then show_usage; fi

DOCKER_NAME="$1"
HOST_PORT="$2"

if ! [[ "$HOST_PORT" =~ ^[0-9]+$ ]] || [ "$HOST_PORT" -lt 1 ] || [ "$HOST_PORT" -gt 65535 ]; then
    echo "Error: Invalid port number"
    show_usage
fi

if ! command -v docker &> /dev/null; then
    echo "Error: Docker not found. Please install Docker first."
    exit 1
fi

echo "[+] Building Docker image: ${DOCKER_NAME}"
docker build -t "${DOCKER_NAME}" .

if docker ps -a --format '{{.Names}}' | grep -wq "^${DOCKER_NAME}$"; then
    echo "[+] Removing existing container: ${DOCKER_NAME}"
    docker rm -f "${DOCKER_NAME}" || true
fi

echo "[+] Starting container on port ${HOST_PORT}"
docker run -d --name "${DOCKER_NAME}" -p "${HOST_PORT}:4444" "${DOCKER_NAME}"

sleep 1
if ! docker ps --format '{{.Names}}' | grep -wq "^${DOCKER_NAME}$"; then
    echo "[!] Container failed to start. Check logs with: docker logs ${DOCKER_NAME}"
    exit 1
fi

echo "[+] Container started successfully"
echo "[+] Connect using: nc 127.0.0.1 ${HOST_PORT}"