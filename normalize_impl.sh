#!/bin/sh
# See https://github.com/podman-container-tools/podman/issues/14978
set -eu

tmpd=/tmp/repackage-tar.$$

f=$1; shift

mkdir "$tmpd"
tar -tf "$f" | sort >"$tmpd/before"

if grep -q ^/ <"$tmpd/before"; then
        echo >&2 'Some records have absolute paths'
        exit 1
fi

mkdir "$tmpd/data"
tar -C "$tmpd/data" -xf "$f"
tar -C "$tmpd/data" --sort=name --mtime=@0 --owner=0 --group=0 --numeric-owner \
    --pax-option=exthdr.name=%d/PaxHeaders/%f,delete=atime,delete=ctime \
    -cf "$f" --no-recursion --verbatim-files-from -T "$tmpd/before"
