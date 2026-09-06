<!-- Generated with Stardoc: http://skydoc.bazel.build -->

Rasterises SVG to PNG without leaving the build.

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

<a id="svg_to_png"></a>

## svg_to_png

<pre>
load("@bazel_ebook//build:svg.bzl", "svg_to_png")

svg_to_png(<a href="#svg_to_png-name">name</a>, <a href="#svg_to_png-srcs">srcs</a>, <a href="#svg_to_png-fonts">fonts</a>, <a href="#svg_to_png-sans_serif_family">sans_serif_family</a>, <a href="#svg_to_png-serif_family">serif_family</a>, <a href="#svg_to_png-zoom">zoom</a>)
</pre>

Rasterise SVG files to PNG using a hermetic renderer and fonts.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="svg_to_png-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="svg_to_png-srcs"></a>srcs |  The SVG files to rasterise.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="svg_to_png-fonts"></a>fonts |  Fonts made available to the renderer. Host fonts are not used, so text needing a font absent from here is dropped.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `"@dejavu_fonts//:ttf"`  |
| <a id="svg_to_png-sans_serif_family"></a>sans_serif_family |  Font family used for `sans-serif`.   | String | optional |  `"DejaVu Sans"`  |
| <a id="svg_to_png-serif_family"></a>serif_family |  Font family used for `serif`. graphviz emits `Times,serif`.   | String | optional |  `"DejaVu Serif"`  |
| <a id="svg_to_png-zoom"></a>zoom |  Optional scale factor, e.g. "2" for twice the size.   | String | optional |  `""`  |


