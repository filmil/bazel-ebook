# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def bazel_ebook_repositories():
    excludes = native.existing_rules().keys()

    if "io_bazel_rules_docker" not in excludes:
        http_archive(
            name = "io_bazel_rules_docker",
            sha256 = "dc97fccceacd4c6be14e800b2a00693d5e8d07f69ee187babfd04a80a9f8e250",
            strip_prefix = "rules_docker-0.14.1",
            urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.1/rules_docker-v0.14.1.tar.gz"],
        )

    if "baze_images_docker" not in excludes:
        http_archive(
            name = "base_images_docker",
            sha256 = "ce6043d38aa7fad421910311aecec865beb060eb56d8c3eb5af62b2805e9379c",
            strip_prefix = "base-images-docker-7657d04ad9e30b9b8d981b96ae57634cd45ba18a",
            urls = ["https://github.com/GoogleCloudPlatform/base-images-docker/archive/7657d04ad9e30b9b8d981b96ae57634cd45ba18a.tar.gz"],
        )

    if "bazel_bats" not in excludes:
        git_repository(
            name = "bazel_bats",
            remote = "https://github.com/filmil/bazel-bats",
            commit = "78da0822ea339bd0292b5cc0b5de6930d91b3254",
            shallow_since = "1569564445 -0700",
        )

    if "gotopt2" not in excludes:
        git_repository(
            name = "gotopt2",
            remote = "https://github.com/filmil/gotopt2",
            commit = "6eeeeb74c6dcd1a94a0daccccbda09b3ba7b2e51",
            shallow_since = "1593765180 -0700",
        )
