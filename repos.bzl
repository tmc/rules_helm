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
        sha256 = "12632bdf85144d8883de07d257f892f447a8bccc84de82276e111059ac8437b1",
        urls = ["https://get.helm.sh/helm-v3.0.0-alpha.1-linux-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        #
    )

    http_archive(
        name = "helm_osx",
        sha256 = "f562e5bbb5b8b8a6a46c080970c1fea35ff908a1402f56e5d4c8f327c9ff4835",
        urls = ["https://get.helm.sh/helm-v3.0.0-alpha.1-darwin-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )
