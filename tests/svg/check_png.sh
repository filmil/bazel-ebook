#!/bin/bash
# Verifies that the rasterised PNG is a real PNG and that its text was
# rendered. resvg drops text silently when no font matches, so a size check
# against a known text-free floor is the cheapest way to catch a missing font.
set -o errexit -o nounset -o pipefail

readonly _png="${1}"

if [[ ! -s "${_png}" ]]; then
    echo "FAIL: ${_png} is missing or empty"
    exit 1
fi

# PNG signature: 89 50 4E 47 0D 0A 1A 0A
readonly _magic="$(head -c 8 "${_png}" | od -An -tx1 | tr -d ' \n')"
if [[ "${_magic}" != "89504e470d0a1a0a" ]]; then
    echo "FAIL: ${_png} is not a PNG (magic: ${_magic})"
    exit 1
fi

# A render of this fixture with no font available is 5986 bytes; with DejaVu
# Serif it is ~6436. Anything at or below the floor means the labels were
# dropped.
# wc -c rather than stat: runfiles entries are symlinks, and stat reports
# the size of the link itself rather than of its target.
readonly _size="$(wc -c < "${_png}")"
if (( _size <= 6000 )); then
    echo "FAIL: ${_png} is ${_size} bytes, at or below the no-font floor;"
    echo "      the node labels were probably dropped for want of a font."
    exit 1
fi

echo "PASS: ${_png} is a ${_size} byte PNG with text rendered"
