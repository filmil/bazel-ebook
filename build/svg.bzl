# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

"""Rasterises SVG to PNG without leaving the build.

The graphviz module this repository depends on can lay a graph out but cannot
write PNG: `-Tpng` needs a raster renderer plugin (libgd, or cairo plus pango)
that it does not build, so its only bitmap-free outputs are SVG and friends.
Rather than take on those C libraries, the figure rules render SVG and convert
it here with `resvg`, a self-contained binary pinned in multitool.lock.json.

Fonts are supplied explicitly. resvg *silently drops text* when it cannot find
a font -- the same graphviz SVG renders to 6436 bytes with a font present and
5986 without, and the only complaint is a warning on stderr. Relying on host
fonts would therefore produce diagrams with missing labels on some machines and
correct ones on others. `--skip-system-fonts` makes that failure mode
impossible: the only fonts available are the ones Bazel provides.
"""

# Attributes any rule needs in order to call rasterise().
RESVG_ATTRS = {
    "fonts": attr.label(
        allow_files = True,
        default = "@dejavu_fonts//:ttf",
        doc = "Fonts made available to the renderer. Host fonts are not " +
              "used, so text needing a font absent from here is dropped.",
    ),
    "serif_family": attr.string(
        default = "DejaVu Serif",
        doc = "Font family used for `serif`. graphviz emits `Times,serif`.",
    ),
    "sans_serif_family": attr.string(
        default = "DejaVu Sans",
        doc = "Font family used for `sans-serif`.",
    ),
    "zoom": attr.string(
        default = "",
        doc = "Optional scale factor, e.g. \"2\" for twice the size.",
    ),
    "_resvg": attr.label(
        cfg = "exec",
        default = "@multitool//tools/resvg",
        executable = True,
    ),
}

def rasterise(ctx, svg, png):
    """Registers an action turning one SVG file into one PNG file.

    The rule calling this must include RESVG_ATTRS in its attrs.

    Args:
        ctx: the rule context.
        svg: the input SVG File.
        png: the output PNG File to declare the action for.
    """
    fonts = ctx.files.fonts
    if not fonts:
        fail("{}: fonts must not be empty; resvg silently drops text without them".format(ctx.label))

    args = ctx.actions.args()
    args.add("--skip-system-fonts")
    args.add("--use-fonts-dir", fonts[0].dirname)
    args.add("--serif-family", ctx.attr.serif_family)
    args.add("--sans-serif-family", ctx.attr.sans_serif_family)
    if ctx.attr.zoom != "":
        args.add("--zoom", ctx.attr.zoom)
    args.add(svg)
    args.add(png)

    ctx.actions.run(
        arguments = [args],
        executable = ctx.executable._resvg,
        inputs = [svg] + fonts,
        mnemonic = "SvgToPng",
        outputs = [png],
        progress_message = "Rasterising %s" % svg.short_path,
    )

def _svg_to_png_impl(ctx):
    outputs = []
    for src in ctx.files.srcs:
        out = ctx.actions.declare_file(src.basename.removesuffix(".svg") + ".png")
        outputs.append(out)
        rasterise(ctx, src, out)
    return [DefaultInfo(files = depset(outputs))]

svg_to_png = rule(
    implementation = _svg_to_png_impl,
    attrs = RESVG_ATTRS | {
        "srcs": attr.label_list(
            allow_files = [".svg"],
            doc = "The SVG files to rasterise.",
        ),
    },
    doc = "Rasterise SVG files to PNG using a hermetic renderer and fonts.",
)
