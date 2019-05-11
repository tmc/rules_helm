# rules_helm

This repository contains Bazel rules to install and manipulate Helm charts with Bazel.

This allows you to describe Kubernetes applications in a deterministic manner.

## Features

* Tillerless - rules_helm uses [tillerless helm](https://rimusz.net/tillerless-helm/).

## Documentation

* See [Rule and macro defintions](./docs.md) for macro documentation.

## API

* helm_chart - describes a helm chart.
* helm_release - describes a helm release.


## Examples

See [rules_helm_examples](https://github.com/tmc/rules_helm_example) for usage examples.

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
