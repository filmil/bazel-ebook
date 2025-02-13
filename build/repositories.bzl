# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def bazel_ebook_repositories():

    maybe(
        git_repository,
        name = "bazel_bats",
        remote = "https://github.com/filmil/bazel-bats",
        commit = "535f03ff9effd12694ff80d252375813e7ba9ae1",
        shallow_since = "1667200603 -0700",
    )

    maybe(
        git_repository,
        name = "gotopt2",
        remote = "https://github.com/filmil/gotopt2",
        commit = "21c007a22bc51ec580510e5bed4f997f84362e0b",
        shallow_since = "1734826764 -0800",
    )

    maybe(
        http_archive,
        name = "pandoc_crossref",
        urls = [
            "https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.18.1a/pandoc-crossref-Linux-X64.tar.xz",
        ],
        sha256 = "ef74b6682f447e8705105963624076e0410b964b2ae16c8072b2a3e241a044f2",
        build_file_content = """
package(default_visibility = ["//visibility:public"])
filegroup(
    name = "pandoc_crossref",
    srcs = [
        "pandoc-crossref",
    ],
)
        """,
    )

    maybe(
        new_git_repository,
        name = "pandoc_ext_include_files",
        remote = "https://github.com/pandoc-ext/include-files.git",
        commit = "364394eaa71bcc8539090e3f31746135d55f674d",
        build_file_content = """package(
    default_visibility = ["//visibility:public"],
)

filegroup(
    name = "filter",
    srcs = [ ":include-files.lua"],
)
"""
    )

    # This does not really work. :/
    maybe(
        http_archive,
        name = "pandoc_include_code",
        urls = [
            "https://github.com/owickstrom/pandoc-include-code/releases/download/v1.2.0.2/pandoc-include-code-linux-ghc8-pandoc-1-19.tar.gz",
        ],
        sha256 = "",
        build_file_content = """
package(default_visibility = ["//visibility:public"])
filegroup(
    name = "filter",
    srcs = [
        "pandoc-include-code",
    ],
)
        """,
    )
