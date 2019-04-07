RUNFILES_LIB = """
# Copy-pasted from Bazel's Bash runfiles library (tools/bash/runfiles/runfiles.bash).
set -euo pipefail
if [[ ! -d "${RUNFILES_DIR:-/dev/null}" && ! -f "${RUNFILES_MANIFEST_FILE:-/dev/null}" ]]; then
  if [[ -f "$0.runfiles_manifest" ]]; then
    export RUNFILES_MANIFEST_FILE="$0.runfiles_manifest"
  elif [[ -f "$0.runfiles/MANIFEST" ]]; then
    export RUNFILES_MANIFEST_FILE="$0.runfiles/MANIFEST"
  elif [[ -f "$0.runfiles/bazel_tools/tools/bash/runfiles/runfiles.bash" ]]; then
    export RUNFILES_DIR="$0.runfiles"
  fi
fi
if [[ -f "${RUNFILES_DIR:-/dev/null}/bazel_tools/tools/bash/runfiles/runfiles.bash" ]]; then
  source "${RUNFILES_DIR}/bazel_tools/tools/bash/runfiles/runfiles.bash"
elif [[ -f "${RUNFILES_MANIFEST_FILE:-/dev/null}" ]]; then
  source "$(grep -m1 "^bazel_tools/tools/bash/runfiles/runfiles.bash " \
            "$RUNFILES_MANIFEST_FILE" | cut -d ' ' -f 2-)"
else
  echo >&2 "ERROR: cannot find @bazel_tools//tools/bash/runfiles:runfiles.bash"
  exit 1
fi
"""

def helm_chart_installer_alt(name, release_name, chart, values_yaml):
    native.sh_binary(
        name = "install_" + name,
        srcs = ["helm_install.sh"],
        data = [chart, values_yaml, "@com_github_tmc_rules_helm//:helm"],
        args = ["foo", "$(location @com_github_tmc_rules_helm//:helm)"],
    )

def helm_chart_installer(name, release_name, chart, values_yaml):
    native.genrule(
        name = name,
        srcs = ["@com_github_tmc_rules_helm//:runfiles_bash", chart, values_yaml],
        outs = ["runhelm.sh"],
        #executable = 1,
        #tools = ["@com_github_tmc_rules_helm//:helm"],
        cmd = """
cp $(location @com_github_tmc_rules_helm//:runfiles_bash) $@
cat <<EOF >> $@
export RUNFILES_LIB_DEBUG=1

set -x
export HELM=\$$(rlocation com_github_tmc_rules_helm/helm)
echo \$$HELM
PATH=\$$PATH:\$$(dirname \$$HELM)
\$$HELM tiller run -- \$$HELM upgrade --install """ + release_name + """ \
./$(location """ + chart + """) --values=$(location """ + values_yaml + """)
EOF""",
    )
    native.sh_binary(
        name = "install_" + name,
        srcs = ["runhelm.sh"],
        deps = ["@bazel_tools//tools/bash/runfiles"],
        data = [chart, values_yaml, "@com_github_tmc_rules_helm//:helm"],
        #args = ["$(location @com_github_tmc_rules_helm//:helm)"],
    )
