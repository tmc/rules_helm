load("@bazel_skylib//lib:paths.bzl", "paths")

load("@bazel_tools//tools/build_defs/pkg:pkg.bzl", "pkg_tar")

HELM_CMD_PREFIX = """
echo "#!/bin/bash" > $@
cat $(location @com_github_tmc_rules_helm//:runfiles_bash) >> $@
echo "export NAMESPACE=$$(grep NAMESPACE bazel-out/stable-status.txt | cut -d ' ' -f 2)" >> $@
echo "export BUILD_USER=$$(grep BUILD_USER bazel-out/stable-status.txt | cut -d ' ' -f 2)" >> $@
cat <<EOF >> $@
#export RUNFILES_LIB_DEBUG=1

export HELM=\$$(rlocation com_github_tmc_rules_helm/helm)
PATH=\$$(dirname \$$HELM):\$$PATH
"""

def helm_chart(name, srcs):
    filegroup_name = name + "_filegroup"
    tarball_name = name + "_chart.tar.gz"
    helm_cmd_name = name + "_package.sh"
    #pkg_tar(
    #    name = name + "_tarball",
    #    outs = [tarball_name],
    #    srcs = srcs,
    #    extension = "tar.gz",
    #    #package_dir = ".",
    #    strip_prefix = ".",
    #)
    native.filegroup(
        name = filegroup_name,
        srcs = srcs,
    )
    native.genrule(
        name = name,
        #srcs = ["@com_github_tmc_rules_helm//:runfiles_bash", filegroup_name, "@bazel_tools//tools/bash/runfiles"],
        srcs = [filegroup_name],
        outs = ["file"],
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
$(location @com_github_tmc_rules_helm//:helm) package -u $$CHARTLOC
mv *tgz $@
"""
    )

def helm_cmd(cmd, args, name, helm_cmd_name, tarball_name, values_yaml):
    nativecmd = native.sh_binary
    if cmd == "test":
        nativecmd = native.sh_test
    nativecmd(
        name = name + "." + cmd,
        srcs = [helm_cmd_name],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        data = [tarball_name, values_yaml, "@com_github_tmc_rules_helm//:helm"],
        args = args,
    )

def helm_release(name, release_name, chart, values_yaml):
    # Unclear why we need this genrule to expose the chart tarball.
    tarball_name = name + "_chart.tar.gz"
    helm_cmd_name = name + "_run_helm_cmd.sh"
    native.genrule(
        name = name + "_tarball",
        outs = [tarball_name],
        srcs = [chart],
        cmd = "cp $(location " + chart + ") $@",
# cmd = """
# cp $(location " + chart + ") $@",
# """,

    )
    native.genrule(
        name = name,
        srcs = ["@com_github_tmc_rules_helm//:runfiles_bash", tarball_name, values_yaml],
        stamp = True,
        outs = [helm_cmd_name],
        cmd =  HELM_CMD_PREFIX + """
export CHARTLOC=\$$(rlocation __main__/""" + tarball_name + """)

export NS=\$${NAMESPACE:-\$${BUILD_USER}}
if [ "\$$1" == "upgrade" ]; then
    helm tiller run \$$NS -- helm \$$@ --namespace \$$NS """ + release_name + """ \$$CHARTLOC --values=$(location """ + values_yaml + """)
else
    helm tiller run \$$NS -- helm \$$@ """ + release_name + """
fi

EOF""",
    )
    helm_cmd("install", ["upgrade", "--install"], name, helm_cmd_name, tarball_name, values_yaml)
    helm_cmd("install.wait", ["upgrade", "--install", "--wait"], name, helm_cmd_name, tarball_name, values_yaml)
    helm_cmd("status", ["status"], name, helm_cmd_name, tarball_name, values_yaml)
    helm_cmd("delete", ["delete", "--purge"], name, helm_cmd_name, tarball_name, values_yaml)
    helm_cmd("test", ["test", "--cleanup"], name, helm_cmd_name, tarball_name, values_yaml)
    helm_cmd("test.noclean", ["test"], name, helm_cmd_name, tarball_name, values_yaml)
