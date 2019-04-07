#!/usr/bin/env bash
set -euo pipefail
rfloc="${1}"
shift

echo "${rfloc}"
source "${rfloc}"
echo $(rlocation helm_osx/:allfiles)

platform=$(uname)
if [ "$platform" == "Darwin" ]; then
    BINARY=external/helm_osx/darwin-amd64/helm
elif [ "$platform" == "Linux" ]; then
    BINARY=external/helm/linux-amd64/helm
else
    echo "Helm does not have a binary for $platform"
    exit 1
fi

HOME="$(pwd)"
set -x
$BINARY init --client-only # >/dev/null
$BINARY plugin list | grep -qc tiller || $BINARY plugin install external/helm_tiller
$BINARY $*
