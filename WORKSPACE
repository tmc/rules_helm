workspace(name = "com_github_tmc_rules_helm")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

load(":repos.bzl", "helm_repositories")
helm_repositories()

http_file(
    name = "buildifier",
    executable = True,
    sha256 = "25159de982ec8896fc8213499df0a7003dfb4a03dd861f90fa5679d16faf0f99",
    urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.22.0/buildifier"],
)

http_file(
    name = "buildifier_osx",
    executable = True,
    sha256 = "ceeedbd3ae0479dc2a5161e17adf7eccaba146b650b07063976df58bc37d7c44",
    urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.22.0/buildifier.osx"],
)

