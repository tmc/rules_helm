load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def helm_repositories():
    skylib_version = "0.8.0"
    http_archive(
        name = "bazel_skylib",
        type = "tar.gz",
        url = "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib.{}.tar.gz".format (skylib_version, skylib_version),
        sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
    )

    http_archive(
        name = "helm",
        sha256 = "c1967c1dfcd6c921694b80ededdb9bd1beb27cb076864e58957b1568bc98925a",
        urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        #
    )

    http_archive(
        name = "helm_osx",
        sha256 = "c9564c4133349b98a8c1dda42fdb6545f6e4bfdf0980cdfc38cf76d2f8e5e701",
        urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-darwin-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )

    new_git_repository(
        name = "helm_tiller",
        remote = "https://github.com/rimusz/helm-tiller",
        commit = "3e715983bfd23c33d12b9c87d325ec5490b0ed6e",
        shallow_since = "1553679518 +0000",
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )
