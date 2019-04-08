load("@bazel_skylib//lib:paths.bzl", "paths")

def helm_chart_installer(name, release_name, chart, values_yaml):
    # Unclear why we need this genrule to expose the chart tarball.
    tarball_name = name + "_chart.tar.gz"
    native.genrule(
        name = name + "_chart",
        outs = [tarball_name],
        srcs = [chart],
        cmd = "cp $(location " + chart + ") $@",
    )
    native.genrule(
        name = name,
        srcs = ["@com_github_tmc_rules_helm//:runfiles_bash", tarball_name, values_yaml],
        outs = ["run_helm_cmd.sh"],
        cmd = """
echo "#!/bin/bash" > $@
cat $(location @com_github_tmc_rules_helm//:runfiles_bash) >> $@
cat <<EOF >> $@
#export RUNFILES_LIB_DEBUG=1

export HELM=\$$(rlocation com_github_tmc_rules_helm/helm)
PATH=\$$PATH:\$$(dirname \$$HELM)
export CHARTLOC=\$$(rlocation __main__/""" + tarball_name + """)

if [ "\$$1" == "upgrade" ]; then
    helm tiller run default -- helm \$$@ """ + release_name + """ \$$CHARTLOC --values=$(location """ + values_yaml + """)
else
    helm tiller run default -- helm \$$@ """ + release_name + """
fi

EOF""",
    )
    native.sh_binary(
        name = name + ".install",
        srcs = ["run_helm_cmd.sh"],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        data = [tarball_name, values_yaml, "@com_github_tmc_rules_helm//:helm"],
        args = ["upgrade", "--install"],
    )
    native.sh_binary(
        name = name + ".delete",
        srcs = ["run_helm_cmd.sh"],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        data = [tarball_name, "@com_github_tmc_rules_helm//:helm"],
        args = ["delete", "--purge"],
    )
