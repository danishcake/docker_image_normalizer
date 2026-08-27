#!/bin/bash
set -euo pipefail

# Usage: normalize.sh <TAG>
#        normalize.sh docker.io/docker/dockerfile:1
# Ensure you have podman installed

# Stop git bash on Windows expanding paths with MSYS_NO_PATHCONV=1
export MSYS_NO_PATHCONV=1

# Calculate the output name
readonly OUTPUT="${1//[\/:]/_}.tar"

# Download the image and save it as a tarball. This is not currently compressed
rm -f "$OUTPUT"
podman pull "$1"
podman save "$1" -o "$OUTPUT"

# Normalize the tarball in a container (so that Windows works too)
podman run --rm -v "$PWD:/data" -w /data debian:bookworm bash -c "chmod +x normalize_impl.sh && /data/normalize_impl.sh /data/$OUTPUT"
sha256sum "$OUTPUT" > "$OUTPUT.sha256"
cat "$OUTPUT.sha256"