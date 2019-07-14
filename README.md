# rules_helm

This repository contains Bazel rules to install and manipulate Helm charts with Bazel.

This allows you to describe Kubernetes applications in a deterministic manner.

## Features

* Tillerless - rules_helm uses [tillerless helm](https://rimusz.net/tillerless-helm/).

## Documentation

* See [Rule and macro defintions](./docs/docs.md) for macro documentation.

### API

* helm_chart - describes a helm chart.
* helm_release - describes a helm release.

### Getting started

In your Bazel `WORKSPACE` file add this repository as a dependency:

```
git_repository(
    name = "com_github_tmc_rules_helm",
    tag = "0.3.0",
    remote = "https://github.com/tmc/rules_helm.git",
)
```

Then in your `BUILD` files include the `helm_chart` and/or `helm_release` rules:

`charts/a-great-chart/zBUILD`:
```python
load("@com_github_tmc_rules_helm//:helm.bzl", "helm_chart")

package(default_visibility = ["//visibility:public"])

helm_chart(
    name = "a_great_chart",
    srcs = glob(["**"]),
)
```

Referencing the chart with helm_release:

`BUILD`:
```python
load("@com_github_tmc_rules_helm//:helm.bzl", "helm_release")

helm_release(
    name = "a_great_release",
    chart = "//charts/a-great-chart:chart",
    release_name = "a-great-release-1",
    values_yaml = "//:a-great-release-values.yaml",
)
```

This defines targets you can now use to manage the release:
```
:a_great_release.test.noclean
:a_great_release.test
:a_great_release.status
:a_great_release.install.wait
:a_great_release.install
:a_great_release.delete
```

You could now install, test, and clean up the chart via:
`bazel run :a_great_release.install.wait && bazel run :a_great_release.test && bazel run :a_great_release.delete`

See [rules_helm_examples](https://github.com/tmc/rules_helm_example) for detailed usage examples.

### Istio Example

These rules demonstrae  describing an installation of Istio. See
https://github.com/tmc/rules_helm_example/tree/master/charts/istio for details.

```python
load("@com_github_tmc_rules_helm//:helm.bzl", "helm_release")

package(default_visibility = ["//visibility:public"])

helm_release(
    name = "istio_init",
    chart = "@com_github_istio_istio//:istio_init",
    namespace = "istio-system",
    release_name = "istio-init",
    values_yaml = ":istio_values.yaml",
)

helm_release(
    name = "istio",
    chart = "@com_github_istio_istio//:istio",
    namespace = "istio-system",
    release_name = "istio",
    values_yaml = ":istio_values.yaml",
)
```

The releases above create the following targets:
```
:istio_init.test.noclean
:istio_init.test
:istio_init.status
:istio_init.install.wait
:istio_init.install
:istio_init.delete
```
And:
```
:istio.test.noclean
:istio.test
:istio.status
:istio.install.wait
:istio.install
:istio.delete
```

Running `bazel run :istio_init.install` and a subsequent `bazel run :istio.install` (waiting for the CRDs to be created) will install Istio. See [rules_helm_examples](https://github.com/tmc/rules_helm_example) for detailed usage examples.
