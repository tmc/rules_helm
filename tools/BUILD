package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "buildifier",
    srcs = ["buildifier.sh"],
    data = [
        "@buildifier//file",
        "@buildifier_osx//file",
    ],
)

sh_binary(
    name = "lint",
    srcs = ["lint.sh"],
    data = [
        ":buildifier",
    ],
)

sh_binary(
    name = "lintfix",
    srcs = ["lintfix.sh"],
    data = [
        ":buildifier",
    ],
)
