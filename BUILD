sh_binary(
    name = "helm",
    srcs = ["helm.sh"],
    data = [
        "@helm//:allfiles",
        "@helm_osx//:allfiles",
        "@helm_tiller//:allfiles",
    ],
    visibility = ["//visibility:public"],
)

sh_test(
    name = "dummy_test",
    size = "small",
    srcs = [
        ".dummy_test.sh",
    ],
)
