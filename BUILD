sh_binary(
    name = "helm",
    srcs = ["helm.sh"],
    data = [
        "@helm//:allfiles",
        "@helm_osx//:allfiles",
        "@helm_tiller//:allfiles",
        ":runfiles_bash",
    ],
    args = ["$(location :runfiles_bash)"],
    visibility = ["//visibility:public"],
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
