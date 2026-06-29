#!/bin/bash

set -e

echo "====================================="
echo "Starting Trivy Security Scan"
echo "====================================="

echo "Scanning project filesystem..."
trivy fs --severity HIGH,CRITICAL .

echo "Filesystem scan completed."

if [ -n "$IMAGE_NAME" ] && [ -n "$TAG" ]; then
    echo "Scanning Docker image..."
    trivy image --severity HIGH,CRITICAL ${IMAGE_NAME}:${TAG}
    echo "Docker image scan completed."
else
    echo "Skipping Docker image scan (IMAGE_NAME or TAG not set)."
fi

echo "====================================="
echo "Trivy Scan Finished"
echo "====================================="
