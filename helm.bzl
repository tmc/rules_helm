load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

HELM_CMD_PREFIX = """
echo "#!/bin/bash" > $@
cat $(location @com_github_tmc_rules_helm//:runfiles_bash) >> $@
echo "export NAMESPACE=$$(grep NAMESPACE bazel-out/stable-status.txt | cut -d ' ' -f 2)" >> $@
echo "export BUILD_USER=$$(grep BUILD_USER bazel-out/stable-status.txt | cut -d ' ' -f 2)" >> $@
cat <<EOF >> $@
#export RUNFILES_LIB_DEBUG=1 # For runfiles debugging

export HELM=\$$(rlocation com_github_tmc_rules_helm/helm)
PATH=\$$(dirname \$$HELM):\$$PATH
"""

def helm_chart(name, srcs, update_deps = False):
    filegroup_name = name + "_filegroup"
    helm_cmd_name = name + "_package.sh"
    package_flags = ""
    if update_deps:
        package_flags = "-u"
    native.filegroup(
        name = filegroup_name,
        srcs = srcs,
    )
    native.genrule(
        name = name,
        #srcs = ["@com_github_tmc_rules_helm//:runfiles_bash", filegroup_name, "@bazel_tools//tools/bash/runfiles"],
        srcs = [filegroup_name],
        outs = ["%s_chart.tar.gz" % name],
        tools = ["@com_github_tmc_rules_helm//:helm"],
        cmd = """
# find Chart.yaml in the filegroup
CHARTLOC=missing
for s in $(SRCS); do
  if [[ $$s =~ .*Chart.yaml ]]; then
    CHARTLOC=$$(dirname $$s)
    break
  fi
done
$(location @com_github_tmc_rules_helm//:helm) package {package_flags} $$CHARTLOC
mv *tgz $@
""".format(
            package_flags = package_flags,
        ),
    )

def helm_cmd(cmd, args, name, helm_cmd_name, values_yaml):
    native.sh_binary(
        name = name + "." + cmd,
        srcs = [helm_cmd_name],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        data = [values_yaml, "@com_github_tmc_rules_helm//:helm"],
        args = args,
    )

def helm_release(name, release_name, chart, values_yaml, namespace = ""):
    helm_cmd_name = name + "_run_helm_cmd.sh"
    native.genrule(
        name = name,
        srcs = ["@com_github_tmc_rules_helm//:runfiles_bash", chart, values_yaml],
        stamp = True,
        outs = [helm_cmd_name],
        cmd = HELM_CMD_PREFIX + """
export CHARTLOC=$(location """ + chart + """)
EXPLICIT_NAMESPACE=""" + namespace + """
NAMESPACE=\$${EXPLICIT_NAMESPACE:-\$$NAMESPACE}
export NS=\$${NAMESPACE:-\$${BUILD_USER}}
if [ "\$$1" == "upgrade" ]; then
    helm tiller run \$$NS -- helm \$$@ --namespace \$$NS """ + release_name + """ \$$CHARTLOC --values=$(location """ + values_yaml + """)
elif [ "\$$1" == "test" ]; then
    helm tiller run \$$NS -- helm test --cleanup """ + release_name + """
else
    helm tiller run \$$NS -- helm \$$@ """ + release_name + """
fi

EOF""",
    )
    helm_cmd("install", ["upgrade", "--install"], name, helm_cmd_name, values_yaml)
    helm_cmd("install.wait", ["upgrade", "--install", "--wait"], name, helm_cmd_name, values_yaml)
    helm_cmd("status", ["status"], name, helm_cmd_name, values_yaml)
    helm_cmd("delete", ["delete", "--purge"], name, helm_cmd_name, values_yaml)
    helm_cmd("test", ["test", "--cleanup"], name, helm_cmd_name, values_yaml)
    helm_cmd("test.noclean", ["test"], name, helm_cmd_name, values_yaml)
