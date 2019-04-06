#!/bin/bash
./tools/buildifier -mode=fix "$(find "${BUILD_WORKSPACE_DIRECTORY}" -name BUILD -or -name BUILD.bazel -or -name *.bzl )"
