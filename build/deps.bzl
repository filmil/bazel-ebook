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
        container_pull(
            name = "ubuntu1804",
            registry = "index.docker.io",
            repository = "ubuntu",
            tag = "18.04",
        )

        load("@gotopt2//build:deps.bzl", "gotopt2_dependencies")
        gotopt2_dependencies()
