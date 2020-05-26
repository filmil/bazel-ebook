#! /bin/bash
set -euo pipefail
set -x

if [[ ${INPUTS} == "" ]]; then
  echo "variable \$INPUTS undefined."
  exit 1
fi
if [[ ${OUTPUT} == "" ]]; then
  echo "variable \$OUTPUT undefined."
  exit 1
fi
if [[ ${DIR_REFERENCE} == "" ]]; then
  echo "variable \$DIR_REFERENCE undefined."
  exit 1
fi

readonly _real_source_dir="$(dirname $(readlink -m $DIR_REFERENCE))"
readonly _build_root="${PWD%%/_bazel_*}"
readonly _uid="$(id -u)"
readonly _gid="$(id -g)"

readonly _output_basename="$(basename ${OUTPUT})"
readonly _output_dirname="$(dirname ${OUTPUT})"

readonly _cmdline="\
  gladtex -v -r 200 -d "${OUTPUT}.dir" ${INPUTS} && \
  ( cd ${_output_dirname} ; tar cf ${_output_basename} ${_output_basename}.dir )\
  "

docker run --rm --interactive \
  -u "${_uid}:${_gid}" \
  -v "${_build_root}:${_build_root}:rw" \
  -v "${_real_source_dir}:${_real_source_dir}:ro" \
  -v "${PWD}:/src" \
  -w "/src" \
  ebook-buildenv:latest \
    bash -c "${_cmdline}"

