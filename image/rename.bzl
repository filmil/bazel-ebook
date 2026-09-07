# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

"""Presents an executable under a different file name.

pandoc decides which LaTeX engine it is talking to from the base name of what
`--pdf-engine` points at: anything that is not pdflatex, lualatex, xelatex or
one of a handful of others is rejected outright. `rootfs_binary` names its
generated script after the target, so the wrapper for pdflatex arrives as
`pdflatex_runner.sh` and pandoc will not take it.

This makes a symlink with the name the caller needs, carrying the wrapped
binary's runfiles along, so the wrapper still finds its rootfs when it runs.
"""

def _renamed_binary_impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    src = ctx.attr.binary[DefaultInfo].files_to_run.executable

    ctx.actions.symlink(
        output = out,
        target_file = src,
        is_executable = True,
    )

    runfiles = ctx.runfiles(files = [src])
    runfiles = runfiles.merge(ctx.attr.binary[DefaultInfo].default_runfiles)

    return [DefaultInfo(
        executable = out,
        files = depset([out]),
        runfiles = runfiles,
    )]

renamed_binary = rule(
    implementation = _renamed_binary_impl,
    executable = True,
    doc = "Exposes an executable under the target's own name.",
    attrs = {
        "binary": attr.label(
            cfg = "target",
            executable = True,
            mandatory = True,
            doc = "The executable to present under this target's name.",
        ),
    },
)
