# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
container_repositories()
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

