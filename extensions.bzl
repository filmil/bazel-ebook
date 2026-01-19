load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def _bazel_ebook_extension_impl(_ctx):

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
        git_repository,
        name = "pandoc_ext_include_files",
        remote = "https://github.com/pandoc-ext/include-files.git",
        commit = "364394eaa71bcc8539090e3f31746135d55f674d",
        build_file_content = """package(default_visibility = ["//visibility:public"],
)

filegroup(
    name = "filter",
    srcs = [ ":include-files.lua"],
)
"""
    )

    maybe(
        git_repository,
        name = "pandoc_include",
        remote = "https://github.com/DCsunset/pandoc-include",
        commit = "2d0942933aa49b9143044d1f4075f392cff37740",
        build_file_content = """\
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "srcs",
    srcs = glob(["pandoc_include/*.py"]),
)

"""
    )


bazel_ebook_extension = module_extension(
    implementation = _bazel_ebook_extension_impl,
)
