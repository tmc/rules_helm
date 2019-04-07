workspace(name = "com_github_tmc_rules_helm")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

http_archive(
    name = "helm",
    sha256 = "c1967c1dfcd6c921694b80ededdb9bd1beb27cb076864e58957b1568bc98925a",
    urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz"],
    build_file = "@//:helm.BUILD",
    #
)

http_archive(
    name = "helm_osx",
    sha256 = "c9564c4133349b98a8c1dda42fdb6545f6e4bfdf0980cdfc38cf76d2f8e5e701",
    urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-darwin-amd64.tar.gz"],
    build_file = "@//:helm.BUILD",
)

new_git_repository(
    name = "helm_tiller",
    remote = "https://github.com/rimusz/helm-tiller",
    commit = "3e715983bfd23c33d12b9c87d325ec5490b0ed6e",
    shallow_since = "1553679518 +0000",
    build_file = "@//:helm.BUILD",
)

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

