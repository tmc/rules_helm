#!/bin/bash
./tools/buildifier -mode=check "$(find "${BUILD_WORKSPACE_DIRECTORY}" -name BUILD -or -name BUILD.bazel )"
