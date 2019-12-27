load("@bazel_skylib//lib:paths.bzl", "paths")

HELM_CMD_PREFIX = """
echo "#!/usr/bin/env bash" > $@
cat $(location @com_github_deviavir_rules_helm//:runfiles_bash) >> $@
echo "export NAMESPACE=$$(grep NAMESPACE bazel-out/stable-status.txt | cut -d ' ' -f 2)" >> $@
echo "export BUILD_USER=$$(grep BUILD_USER bazel-out/stable-status.txt | cut -d ' ' -f 2)" >> $@
cat <<EOF >> $@
#export RUNFILES_LIB_DEBUG=1 # For runfiles debugging

export HELM=\$$(rlocation com_github_deviavir_rules_helm/helm)
PATH=\$$(dirname \$$HELM):\$$PATH
"""

def helm_chart(name, srcs, update_deps = False):
    """Defines a helm chart (directory containing a Chart.yaml).

    Args:
        name: A unique name for this rule.
        srcs: Source files to include as the helm chart. Typically this will just be glob(["**"]).
        update_deps: Whether or not to run a helm dependency update prior to packaging.
    """
    filegroup_name = name + "_filegroup"
    helm_cmd_name = name + "_package.sh"
    package_flags = ""
    if update_deps:
        package_flags = "--dependency-update"
    native.filegroup(
        name = filegroup_name,
        srcs = srcs,
    )
    native.genrule(
        name = name,
        srcs = [filegroup_name],
        outs = ["%s_chart.tar.gz" % name],
        tools = ["@com_github_deviavir_rules_helm//:helm"],
        cmd = """
# find Chart.yaml in the filegroup
CHARTLOC=missing
for s in $(SRCS); do
  if [[ $$s =~ .*Chart.yaml ]]; then
    CHARTLOC=$$(dirname $$s)
    break
  fi
done
$(location @com_github_deviavir_rules_helm//:helm) package {package_flags} $$CHARTLOC
mv *tgz $@
""".format(
            package_flags = package_flags,
        ),
    )

def _build_helm_set_args(values):
    set_args = ["--set=%s=%s" % (key, values[key]) for key in sorted((values or {}).keys())]
    return " ".join(set_args)

def _helm_cmd(cmd, args, name, helm_cmd_name, values_yaml = None, values = None):
    binary_data = ["@com_github_deviavir_rules_helm//:helm"]
    if values_yaml:
        binary_data.append(values_yaml)
    if values:
        args.append(_build_helm_set_args(values))

    native.sh_binary(
        name = name + "." + cmd,
        srcs = [helm_cmd_name],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        data = binary_data,
        args = args,
    )

def helm_release(name, release_name, chart, values_yaml = None, values = None, namespace = ""):
    """Defines a helm release.

    A given target has the following executable targets generated:

    `(target_name).install`
    `(target_name).install.wait`
    `(target_name).status`
    `(target_name).delete`
    `(target_name).test`

    Args:
        name: A unique name for this rule.
        release_name: name of the release.
        chart: The chart defined by helm_chart.
        values_yaml: The values.yaml file to supply for the release.
        values: A map of additional values to supply for the release.
        namespace: The namespace to install the release into. If empty will default the NAMESPACE environment variable and will fall back the the current username (via BUILD_USER).
    """
    helm_cmd_name = name + "_run_helm_cmd.sh"
    genrule_srcs = ["@com_github_deviavir_rules_helm//:runfiles_bash", chart]

    # build --set params
    set_params = _build_helm_set_args(values)

    # build --values param
    values_param = ""
    if values_yaml:
        values_param = "-f $(location %s)" % values_yaml
        genrule_srcs.append(values_yaml)

    native.genrule(
        name = name,
        stamp = True,
        srcs = genrule_srcs,
        outs = [helm_cmd_name],
        cmd = HELM_CMD_PREFIX + """
export CHARTLOC=$(location """ + chart + """)
EXPLICIT_NAMESPACE=""" + namespace + """
NAMESPACE=\$${EXPLICIT_NAMESPACE:-\$$NAMESPACE}
export NS=\$${NAMESPACE:-\$${BUILD_USER}}
if [ "\$$1" == "upgrade" ]; then
    helm \$$@ """ + release_name + " \$$CHARTLOC --namespace \$$NS " + set_params + " " + values_param + """
else
    helm \$$@ """ + release_name + " --namespace \$$NS " + """
fi

EOF""",
    )
    _helm_cmd("install", ["upgrade", "--install"], name, helm_cmd_name, values_yaml, values)
    _helm_cmd("install.wait", ["upgrade", "--install", "--wait"], name, helm_cmd_name, values_yaml, values)
    _helm_cmd("status", ["status"], name, helm_cmd_name)
    _helm_cmd("delete", ["delete"], name, helm_cmd_name)
    _helm_cmd("test", ["test"], name, helm_cmd_name)
