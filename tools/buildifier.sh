#!/usr/bin/env bash
set -euo pipefail
platform=$(uname)
if [ "$platform" == "Darwin" ]; then
    BINARY=external/buildifier_osx/file/downloaded
elif [ "$platform" == "Linux" ]; then
    BINARY=external/buildifier/file/downloaded
else
    echo "Buildifier does not have a binary for $platform"
    exit 1
fi

$BINARY $*
