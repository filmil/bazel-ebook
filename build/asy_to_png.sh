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

# These tricks are used to figure out what the real source and build root
# directories are, so that they could be made available to the running
# container command.

# Try to follow the symlinks of the input file as far as we can.  Once we're
# done, the directory that we're left with is the directory we need to mount
# in.
readonly _real_source_dir="$(dirname $(readlink -m $INPUT))"

# Figure out the bazel build root: using the knowledge that the build root
# seems to have the string "/_bazel_" at the beginning of the directory that
# is the user build root directory.
readonly _build_root="${PWD%%/_bazel_*}"

# Required, so that the docker command runs as your UID:GID, so that the output
# file is created with your permissions.  Otherwise it will get created as
# owned by "root:root", and bazel will complain that the target didn't 
readonly _uid="$(id -u)"
readonly _gid="$(id -g)"

readonly _cmdline="asy -render 5 -f png -o \"${OUTPUT}\" \"${INPUT}\""
docker run --rm --interactive \
  -u "${_uid}:${_gid}" \
  -v "${_build_root}:${_build_root}:rw" \
  -v "${_real_source_dir}:${_real_source_dir}:ro" \
  -v "${PWD}:/src" \
  -w "/src" \
  ebook-buildenv:latest \
    bash -c "${_cmdline}"

