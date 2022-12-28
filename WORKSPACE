load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "099a9fb96a376ccbbb7d291ed4ecbdfd42f6bc822ab77ae6f1b5cb9e914e94fa",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.35.0/rules_go-v0.35.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.35.0/rules_go-v0.35.0.zip",
    ],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = "efbbba6ac1a4fd342d5122cbdfdb82aeb2cf2862e35022c752eaddffada7c3f3",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.27.0/bazel-gazelle-v0.27.0.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.27.0/bazel-gazelle-v0.27.0.tar.gz",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies", "go_repository")

go_rules_dependencies()

go_register_toolchains(version = "1.18.3")

gazelle_dependencies()

load("//build:repositories.bzl", "bazel_ebook_repositories")

bazel_ebook_repositories()

#load(
    #"@io_bazel_rules_docker//repositories:repositories.bzl",
    #container_repositories = "repositories",
#)
#container_repositories()
#load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

#container_deps()
#load(
    #"@io_bazel_rules_docker//container:container.bzl",
    #"container_pull",
#)
#container_pull(
    #name = "ubuntu1804",
    #registry = "index.docker.io",
    #repository = "ubuntu",
    #tag = "18.04",
#)

load("@gotopt2//build:deps.bzl", "gotopt2_dependencies")
gotopt2_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()
