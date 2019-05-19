load("@io_bazel_skydoc//stardoc:stardoc.bzl", "stardoc")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

bzl_library(
    name = "skylib_paths",
    srcs = ["@bazel_skylib//lib:paths.bzl"],
)

stardoc(
    name = "docs",
    out = "docs.md",
    input = "//helm:helm.bzl",
    deps = [
        ":skylib_paths",
    ],
)
