# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def bazel_ebook_repositories():
    excludes = native.existing_rules().keys()

    if "bazel_bats" not in excludes:
        git_repository(
            name = "bazel_bats",
            remote = "https://github.com/filmil/bazel-bats",
            commit = "535f03ff9effd12694ff80d252375813e7ba9ae1",
            shallow_since = "1667200603 -0700",
        )

    if "gotopt2" not in excludes:
        git_repository(
            name = "gotopt2",
            remote = "https://github.com/filmil/gotopt2",
            commit = "97d6b1b0663a976eba231cac93aefbfdca52f9d6",
            shallow_since = "1593765180 -0700",
        )

