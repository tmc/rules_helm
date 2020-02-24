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
        sha256 = "cdd7ad304e2615c583dde0ffb0cb38fc1336cd7ce8ff3b5f237434dcadb28c98",
        urls = ["https://get.helm.sh/helm-v3.1.1-linux-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
        #
    )

    http_archive(
        name = "helm_osx",
        sha256 = "2ce00e6c44ba18fbcbec21c493476e919128710d480789bb35bd228ae695cd66",
        urls = ["https://get.helm.sh/helm-v3.1.1-darwin-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )
