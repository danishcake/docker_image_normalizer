#!/bin/bash
# See https://github.com/podman-container-tools/podman/issues/14978
set -euo pipefail

readonly TMPD=/tmp/repackage-tar.$$
readonly INPUT=$1; shift

mkdir "$TMPD"

# Extract a filename list and sort it
tar -tf "$INPUT" | sort >"$TMPD/sorted_files"

# Check there are no absolute paths in the tarball, as this will break the re-packaging
if grep -q ^/ <"$TMPD/sorted_files"; then
    echo >&2 'Some records have absolute paths'
    exit 1
fi

# Extract and repackage the tarball with normalized timestamps, owners, and group IDs
echo "Repackaging"
mkdir "$TMPD/data"
tar -C "$TMPD/data" -xf "$INPUT"
tar -C "$TMPD/data" --sort=name --mtime=@0 --owner=0 --group=0 --numeric-owner \
    --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
    -cf ${INPUT} --no-recursion --verbatim-files-from -T "$TMPD/sorted_files"

echo "Done"