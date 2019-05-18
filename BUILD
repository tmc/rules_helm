sh_binary(
    name = "helm",
    srcs = ["helm.sh"],
    data = select({
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
