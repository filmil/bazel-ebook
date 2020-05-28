#! /bin/bash
# Converts an Asymptote .asy file to a PNG.
#
# Parameters are passed in via environment variables, which is pedestrian, but
# does not require flag parsing.
#
# INPUT: the relative path (with respect to the current directory) of the input
# file to convert.
# OUTPUT: the relative path (same as above) of the output file.
set -euo pipefail

if [[ ${INPUT} == "" ]]; then
  echo "variable \$INPUT undefined."
  exit 1
fi
if [[ ${OUTPUT} == "" ]]; then
  echo "variable \$OUTPUT undefined."
  exit 1
fi

# --- begin runfiles.bash initialization ---
# Copy-pasted from Bazel's Bash runfiles library (tools/bash/runfiles/runfiles.bash).
set -eo pipefail
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
# --- end runfiles.bash initialization ---
readonly _docker_run="$(rlocation __main__/build/docker_run.sh)"
# --- end manual script lookup.

"${_docker_run}" --container=ebook-buildenv:latest \
  --dir-reference=${INPUT} \
    "asy -render 5 -f png -o \"${OUTPUT}\" \"${INPUT}\""

