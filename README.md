# Docker image normalizer

This script can be used to modify Docker images into reproducible tar files, allowing you to obtain the image on two machines and check that they hash the same.

## Setup

You need Podman to use this tool. It generates content identical tar files between Windows and Linux hosts.
This script then normalizes the tar metadata.

## Usage

```bash
./normalize.sh python:3.12.13
# Write python_3.12.13.tar, python_3.12.13.tar.gz and corresponding .sha256 files
```

You may want to tone down the default -9 compression in normalize_impl.sh