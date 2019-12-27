# rules_helm

This repository contains Bazel rules to install and manipulate Helm charts with Bazel.

This allows you to describe Kubernetes applications in a deterministic manner.

Originally forked from https://github.com/tmc/rules_helm

## Features

* Helm v3

## Documentation

* See [Rule and macro defintions](./docs/docs.md) for macro documentation.

### API

* helm_chart - describes a helm chart.
* helm_release - describes a helm release.

### Getting started

In your Bazel `WORKSPACE` file add this repository as a dependency:

```
git_repository(
    name = "com_github_deviavir_rules_helm",
    tag = "0.0.1",
    remote = "https://github.com/deviavir/rules_helm.git",
)
```

Then in your `BUILD` files include the `helm_chart` and/or `helm_release` rules:

`charts/a-great-chart/zBUILD`:
```python
load("@com_github_deviavir_rules_helm//:helm.bzl", "helm_chart")

package(default_visibility = ["//visibility:public"])

helm_chart(
    name = "a_great_chart",
    srcs = glob(["**"]),
)
```

Referencing the chart with helm_release:

`BUILD`:
```python
load("@com_github_deviavir_rules_helm//:helm.bzl", "helm_release")

helm_release(
    name = "a_great_release",
    chart = "//charts/a-great-chart:chart",
    release_name = "a-great-release-1",
    values_yaml = "//:a-great-release-values.yaml",
)
```

This defines targets you can now use to manage the release:
```
:a_great_release.test
:a_great_release.status
:a_great_release.install.wait
:a_great_release.install
:a_great_release.delete
```

You could now install, test, and clean up the chart via:
`bazel run :a_great_release.install.wait && bazel run :a_great_release.test && bazel run :a_great_release.delete`
