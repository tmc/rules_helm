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
        sha256 = "804f745e6884435ef1343f4de8940f9db64f935cd9a55ad3d9153d064b7f5896",
        urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.14.1-linux-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )

    http_archive(
        name = "helm_osx",
        sha256 = "392ec847ecc5870a48a39cb0b8d13c8aa72aaf4365e0315c4d7a2553019a451c",
        urls = ["https://storage.googleapis.com/kubernetes-helm/helm-v2.14.1-darwin-amd64.tar.gz"],
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )

    new_git_repository(
        name = "helm_tiller",
        remote = "https://github.com/rimusz/helm-tiller",
        commit = "a77f505e062d8337e8fd638796bfecc8a4a00bcc",
        shallow_since = "1553679518 +0000",
        build_file = "@com_github_tmc_rules_helm//:helm.BUILD",
    )
