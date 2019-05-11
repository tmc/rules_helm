sh_binary(
    name = "helm",
    srcs = ["helm.sh"],
    data = [
        "@helm_tiller//:allfiles",
    ] + select({
        "@bazel_tools//src/conditions:linux_x86_64": ["@helm//:allfiles"],
        "@bazel_tools//src/conditions:darwin": ["@helm_osx//:allfiles"],
    }),
    visibility = ["//visibility:public"],
    deps = ["@bazel_tools//tools/bash/runfiles"],
)

sh_library(
    name = "runfiles_bash",
    srcs = ["runfiles.bash"],
    visibility = ["//visibility:public"],
)

sh_test(
    name = "dummy_test",
    size = "small",
    srcs = [
        ".dummy_test.sh",
    ],
)

load("@io_bazel_skydoc//stardoc:stardoc.bzl", "stardoc")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

# package(default_visibility = ["//visibility:public"])
package(default_visibility = ["//visibility:public"])

load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

bzl_library(

    name = "skylib_paths",
    srcs = ["@bazel_skylib//lib:paths.bzl"],
)
# bzl_library(
#     name = "bazel_tools_pkg",
#     srcs = ["@bazel_tools//tools:srcs"],
# )

stardoc(
    name = "docs",
    out = "docs.md",
    input = "helm.bzl",
    deps = [
        ":skylib_paths",
        # ":bazel_tools_pkg",
    ],
)
