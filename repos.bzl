load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

def helm_repositories():
    skylib_version = "0.8.0"
    http_archive(
        name = "bazel_skylib",
        type = "tar.gz",
        url = "https://github.com/bazelbuild/bazel-skylib/releases/download/{}/bazel-skylib.{}.tar.gz".format(skylib_version, skylib_version),
        sha256 = "2ef429f5d7ce7111263289644d233707dba35e39696377ebab8b0bc701f7818e",
    )

    http_archive(
        name = "helm",
        sha256 = "b5f6a1e642971af1363cadbe1f7f37c029c11dd93813151b521c0dbeacfbdaa9",
        urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        #
    )

    http_archive(
        name = "helm_osx",
        sha256 = "92ae686de2dc74783aebfb0b7f1a95ebf2b3b62814c37adae2b2e7fa9cc92ceb",
        urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-darwin-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )

    new_git_repository(
        name = "helm_tiller",
        remote = "https://github.com/rimusz/helm-tiller",
        commit = "a77f505e062d8337e8fd638796bfecc8a4a00bcc",
        shallow_since = "1553679518 +0000",
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )
