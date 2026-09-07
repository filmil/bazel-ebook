# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

"""A toolchain describing the external programs the ebook rules invoke.

Every rule used to hardcode both the name of the program it ran (`pandoc`,
`plantuml`, ...) and the mechanism used to run it, which was a container. That
made the set of required binaries invisible: it could only be recovered by
reading the rule implementations and the Dockerfile side by side.

This toolchain makes the set explicit. A toolchain supplies, for each logical
tool name, the command used to invoke it, plus an optional `wrapper`
executable that every invocation is routed through.

Every tool is now supplied by Bazel, so the toolchain in this repository sets
`hermetic_tools` and neither `tools` nor `wrapper`. The wrapper fields remain
in the provider so that a toolchain outside this repository can still route a
tool through something else.
"""

# The toolchain type the ebook rules resolve.
EBOOK_TOOLCHAIN_TYPE = "//build/toolchains:toolchain_type"

# The logical name of every external binary the ebook rules need.
#
# Keep this list in sync with docker/Dockerfile: an entry here is a program
# that must be made available by every toolchain implementation.
EBOOK_TOOLS = [
    # Renders .asy figures to PNG.
    "asy",
    # Ghostscript. asymptote shells out to it to write PNG, and a rootfs
    # binary cannot simply be exec'd, so it has to be a tool in its own right.
    "gs",
    # Graphviz. One binary serves every layout engine; the engine is
    # selected with -K, which is how upstream ships neato, fdp and the rest.
    "dot",
    # Renders timing diagrams to PNG.
    "drawtiming",
    # Calibre, used to convert EPUB to Kindle formats.
    "ebook-convert",
    # Extracts LaTeX equations out of HTML.
    "gladtex",
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
        "hermetic": "dict: logical tool name -> FilesToRunProvider for a " +
                    "binary Bazel builds or fetches itself. A tool listed " +
                    "here is invoked directly and bypasses the wrapper " +
                    "entirely; anything absent falls back to `tools` and the " +
                    "wrapper. This is what lets the migration off the " +
                    "container happen one tool at a time.",
        "path_roots": "list of File: rootfs directories whose bin and usr/bin " +
                      "are put on PATH. Some tools start other programs " +
                      "themselves rather than being told where they are: " +
                      "pandoc runs rsvg-convert for SVG figures and pdflatex " +
                      "to make a PDF. Those cannot be passed as arguments, so " +
                      "they have to be findable.",
        "wrapper": "FilesToRunProvider: an executable that every non-hermetic " +
                   "invocation is routed through, or None when the tools are " +
                   "invoked directly. Carrying the whole provider (rather " +
                   "than just the File) keeps the wrapper's runfiles attached " +
                   "when it is passed to an action's `tools`.",
    },
)

def _ebook_toolchain_impl(ctx):
    hermetic = {
        name: target[DefaultInfo].files_to_run
        for name, target in ctx.attr.hermetic_tools.items()
    }
    unknown_hermetic = [t for t in hermetic if t not in EBOOK_TOOLS]
    if unknown_hermetic:
        fail("ebook_toolchain {} provides unknown hermetic tools: {}".format(
            ctx.label,
            ", ".join(unknown_hermetic),
        ))

    # A hermetic binary satisfies the requirement on its own, so only the
    # remainder has to be named in `tools`.
    missing = [
        t
        for t in EBOOK_TOOLS
        if t not in ctx.attr.tools and t not in hermetic
    ]
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
            hermetic = hermetic,
            path_roots = ctx.files.path_roots,
            tools = ctx.attr.tools,
            wrapper = ctx.attr.wrapper[DefaultInfo].files_to_run if ctx.attr.wrapper else None,
        ),
    )]

ebook_toolchain = rule(
    implementation = _ebook_toolchain_impl,
    attrs = {
        "hermetic_tools": attr.string_keyed_label_dict(
            cfg = "exec",
            doc = "Maps a name in EBOOK_TOOLS to an executable target that " +
                  "Bazel provides. Such a tool is run directly, without the " +
                  "wrapper.",
        ),
        "path_roots": attr.label_list(
            allow_files = True,
            doc = "Rootfs directories to put on PATH for tools that start " +
                  "other programs themselves.",
        ),
        "tools": attr.string_dict(
            doc = "Maps each name in EBOOK_TOOLS not covered by " +
                  "hermetic_tools to the command that runs it.",
        ),
        "wrapper": attr.label(
            cfg = "exec",
            executable = True,
            doc = "Executable each tool invocation is routed through, if any.",
        ),
    },
    doc = "Declares how the ebook rules reach the programs they need.",
)

def ebook_tool(info, name, dir_reference):
    """Describes how to invoke one tool.

    Args:
        info: the EbookToolchainInfo from the resolved toolchain.
        name: a logical tool name from EBOOK_TOOLS.
        dir_reference: retained for the wrapper case, which no longer has an
            implementation in this repository.

    Returns:
        A struct with:
            prefix: text to place before the command ("" when hermetic).
            cmd: the command that runs the tool.
            tools: what to pass to the action's `tools` argument.
    """
    hermetic = info.hermetic.get(name)
    if hermetic != None:
        return struct(
            cmd = hermetic.executable.path,
            prefix = "",
            tools = [hermetic],
        )
    fail("ebook_toolchain provides no hermetic binary for '{}'".format(name))

def ebook_path(info):
    """Returns a PATH value covering the toolchain's rootfs directories.

    Returns:
        A struct with `value`, the PATH string, and `inputs`, the files that
        have to reach the action for it to be usable.
    """
    entries = []
    for root in info.path_roots:
        entries.append("{}/usr/bin".format(root.path))
        entries.append("{}/bin".format(root.path))
    return struct(
        inputs = info.path_roots,
        value = ":".join(entries),
    )
