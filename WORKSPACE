workspace(name = "com_github_deviavir_rules_helm")

load(":repos.bzl", "helm_repositories")

helm_repositories()

load("//tools:buildifier.bzl", "buildifier_repositories")
buildifier_repositories()

# Start stardoc rules
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "io_bazel_skydoc",
    remote = "https://github.com/bazelbuild/skydoc.git",
    tag = "0.3.0",
)
load("@io_bazel_skydoc//:setup.bzl", "skydoc_repositories")
skydoc_repositories()
load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
rules_sass_dependencies()
load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories")
node_repositories()
load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
sass_repositories()
# End stardoc rules
