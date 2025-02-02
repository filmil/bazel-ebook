load("@bazel_rules_bid//build:rules.bzl", "run_docker_cmd")

"""
The scripts for invoking docker containers.
"""

# This is the container used to run the typesetting programs.
CONTAINER = "filipfilmar/ebook-buildenv:2.0"

# Use this for quick local runs.
#CONTAINER = "ebook-buildenv:local"

# Returns the docker_run script invocation command based on the
# script path and its reference directory.
#
# Params:
#   script_path: (string) The full path to the script to invoke
#   dir_reference: (string) The path to a file used for figuring out
#       the reference directories (build root and repo root).
def script_cmd(script_path, dir_reference):
    return run_docker_cmd(CONTAINER, script_path, dir_reference)
