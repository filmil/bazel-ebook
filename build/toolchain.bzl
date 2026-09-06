# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

"""A toolchain describing the external programs the ebook rules invoke.

Historically every rule in this repository hardcoded both the name of the
program it ran (`pandoc`, `plantuml`, ...) and the mechanism used to run it
(`@rules_bid//build:docker_run`, i.e. a container). That made the set of
required binaries invisible: it could only be recovered by reading the rule
implementations and the `docker/Dockerfile` side by side.

This toolchain makes the set explicit. A toolchain supplies, for each logical
tool name, the command used to invoke it, plus an optional `wrapper`
executable that every invocation is routed through.

The `wrapper` is what allows the container-based implementation to keep
working unchanged: for the docker toolchain the commands are bare names
resolved on the container's `PATH`, and the wrapper enters the container. A
future hermetic toolchain instead supplies real paths to binaries built or
fetched by Bazel and no wrapper at all.
"""

# The toolchain type the ebook rules resolve.
EBOOK_TOOLCHAIN_TYPE = "//build:toolchain_type"

# The logical name of every external binary the ebook rules need.
#
# Keep this list in sync with docker/Dockerfile: an entry here is a program
# that must be made available by every toolchain implementation.
EBOOK_TOOLS = [
    # Renders .asy figures to PNG.
    "asy",
    # Graphviz, laying out with `dot`.
    "dot",
    # Renders timing diagrams to PNG.
    "drawtiming",
    # Calibre, used to convert EPUB to Kindle formats.
    "ebook-convert",
    # Extracts LaTeX equations out of HTML.
    "gladtex",
    # Graphviz, laying out with `neato`.
    "neato",
    # The document converter everything else is built around.
    "pandoc",
    # Renders UML diagrams to PNG.
    "plantuml",
]

EbookToolchainInfo = provider(
    doc = "The external programs used by the ebook rules.",
    fields = {
        "tools": "dict: logical tool name (see EBOOK_TOOLS) -> the command " +
                 "used to invoke it. For a container-based toolchain these " +
                 "are bare names resolved on the container PATH; for a " +
                 "hermetic toolchain they are paths to Bazel-provided binaries.",
        "wrapper": "FilesToRunProvider: an executable that every tool " +
                   "invocation is routed through, or None when the tools are " +
                   "invoked directly. Carrying the whole provider (rather " +
                   "than just the File) keeps the wrapper's runfiles attached " +
                   "when it is passed to an action's `tools`.",
    },
)

def _ebook_toolchain_impl(ctx):
    missing = [t for t in EBOOK_TOOLS if t not in ctx.attr.tools]
    if missing:
        fail("ebook_toolchain {} does not provide: {}".format(
            ctx.label,
            ", ".join(missing),
        ))
    unknown = [t for t in ctx.attr.tools if t not in EBOOK_TOOLS]
    if unknown:
        fail("ebook_toolchain {} provides unknown tools: {}".format(
            ctx.label,
            ", ".join(unknown),
        ))
    return [platform_common.ToolchainInfo(
        ebook = EbookToolchainInfo(
            tools = ctx.attr.tools,
            wrapper = ctx.attr.wrapper[DefaultInfo].files_to_run if ctx.attr.wrapper else None,
        ),
    )]

ebook_toolchain = rule(
    implementation = _ebook_toolchain_impl,
    attrs = {
        "tools": attr.string_dict(
            mandatory = True,
            doc = "Maps each name in EBOOK_TOOLS to the command that runs it.",
        ),
        "wrapper": attr.label(
            cfg = "exec",
            executable = True,
            doc = "Executable each tool invocation is routed through, if any.",
        ),
    },
    doc = "Declares how the ebook rules reach the programs they need.",
)
