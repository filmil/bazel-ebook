# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

"""Builds the TeX state that installing a Debian package would have produced.

A rootfs assembled by `apt.install` is the contents of the .deb files and
nothing else: no maintainer script has run. For most packages that does not
matter, but TeX is configured almost entirely by its postinst. Two pieces are
missing, and pdflatex will not start without either:

  - fmtutil.cnf, which Debian assembles with `update-fmtutil` from the
    fragments each texlive package drops in /var/lib/tex-common/fmtutil-cnf,
    and the format files themselves (pdflatex.fmt and friends), which
    `fmtutil` then compiles from the .ini files in the distribution.
  - updmap.cfg, assembled the same way out of /var/lib/tex-common/fontmap-cfg,
    and the font maps `updmap` generates from it. Without those, a document
    that asks for Latin Modern gets bitmap fonts, and pdfTeX stops with
    "auto expansion is only possible with scalable fonts".

All of it is produced here, at build time, by the TeX in the rootfs. Nothing
is downloaded and nothing is taken from the machine running the build.
"""

load("//build:toolchain.bzl", "tex_environment")

def _texmf_tree_impl(ctx):
    rootfs = ctx.file.rootfs
    out = ctx.actions.declare_directory(ctx.label.name)

    env = tex_environment(
        rootfs = '$PWD/{}'.format(rootfs.path),
        texmf = '$PWD/{}'.format(out.path),
    )
    exports = "\n".join([
        'export {}="{}"'.format(name, value)
        for name, value in sorted(env.items())
    ])

    ctx.actions.run_shell(
        progress_message = "Compiling TeX formats: {}".format(
            ", ".join(ctx.attr.formats),
        ),
        inputs = [rootfs],
        outputs = [out],
        tools = [
            ctx.attr.fmtutil[DefaultInfo].files_to_run,
            ctx.attr.updmap[DefaultInfo].files_to_run,
        ],
        command = """set -euo pipefail
mkdir -p "$PWD"/{out}/web2c
# What update-fmtutil and update-updmap do: a header plus one fragment per
# package that ships fonts or formats.
cat {rootfs}/usr/share/texlive/texmf-dist/web2c/fmtutil-hdr.cnf \
    {rootfs}/var/lib/tex-common/fmtutil-cnf/texlive/*.cnf \
    > "$PWD"/{out}/web2c/fmtutil.cnf
cat {rootfs}/usr/share/texlive/texmf-dist/web2c/updmap-hdr.cfg \
    {rootfs}/var/lib/tex-common/fontmap-cfg/*/*.cfg \
    > "$PWD"/{out}/web2c/updmap.cfg
# Both refuse to run without somewhere to put per-user state, and a Bazel
# action starts with no HOME.
HOME="$(mktemp -d)"
export HOME
{exports}
for format in {formats}; do
  {fmtutil} --sys --byfmt "$format" >/dev/null
done
# --copy, because without it updmap links pdftex.map to the variant it chose
# by shelling out to `ln`, and the shell it starts inherits a PATH of
# relative rootfs directories that stop resolving the moment it chdirs.
{updmap} --sys --copy --cnffile "$PWD"/{out}/web2c/updmap.cfg >/dev/null
# The logs record the time of the build, which is no use to anyone reading
# the output tree and only makes the action non-reproducible.
find "$PWD"/{out} -name '*.log' -delete
""".format(
            exports = exports,
            fmtutil = ctx.executable.fmtutil.path,
            formats = " ".join(ctx.attr.formats),
            out = out.path,
            rootfs = rootfs.path,
            updmap = ctx.executable.updmap.path,
        ),
    )

    return [DefaultInfo(files = depset([out]))]

texmf_tree = rule(
    implementation = _texmf_tree_impl,
    doc = "Builds the TeX formats and font maps a postinst would have made.",
    attrs = {
        "rootfs": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "The rootfs holding the texlive installation.",
        ),
        "fmtutil": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
            doc = "fmtutil out of the same rootfs.",
        ),
        "updmap": attr.label(
            cfg = "exec",
            executable = True,
            mandatory = True,
            doc = "updmap out of the same rootfs.",
        ),
        "formats": attr.string_list(
            mandatory = True,
            doc = "Format names to compile, as they appear in fmtutil.cnf.",
        ),
    },
)
