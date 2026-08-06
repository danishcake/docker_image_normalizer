#!/bin/bash
set -euo pipefail

# Usage: normalize.sh <TAG> <OUTPUT_TAR>
#        normalize.sh docker.io/docker/dockerfile:1 image.tar
# Ensure you have podman installed

# Stop git bash on Windows expanding paths with MSYS_NO_PATHCONV=1
export MSYS_NO_PATHCONV=1

# Download the image and save it as a tarball
rm -f "$2"
podman pull "$1"
podman save "$1" -o "$2"

# Normalize the tarball in a container (so that Windows works too)
podman run --rm -v "$PWD:/data" -w /data debian:bookworm bash -c "apt update && apt install -y tar && chmod +x normalize_impl.sh && /data/normalize_impl.sh /data/$2"
sha256sum "$2" > "$2.sha256"
