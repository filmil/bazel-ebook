# README.md

| Workflow | Status |
|---|---|
| Build | [![Build](https://github.com/filmil/bazel-ebook/actions/workflows/build.yml/badge.svg)](https://github.com/filmil/bazel-ebook/actions/workflows/build.yml) |
| Publish to my custom Bazel registry | [![Publish to my custom Bazel registry](https://github.com/filmil/bazel-ebook/actions/workflows/publish-my-bcr.yml/badge.svg)](https://github.com/filmil/bazel-ebook/actions/workflows/publish-my-bcr.yml) |
| Publish to official Bazel Central Registry | [![Publish to official Bazel Central Registry](https://github.com/filmil/bazel-ebook/actions/workflows/publish-official-bcr.yml/badge.svg)](https://github.com/filmil/bazel-ebook/actions/workflows/publish-official-bcr.yml) |
| Release to GitHub Pages | [![Release to GitHub Pages](https://github.com/filmil/bazel-ebook/actions/workflows/release-gh-pages.yml/badge.svg)](https://github.com/filmil/bazel-ebook/actions/workflows/release-gh-pages.yml) |
| Release to GitHub | [![Tag and release](https://github.com/filmil/bazel-ebook/actions/workflows/tag-and-release.yml/badge.svg)](https://github.com/filmil/bazel-ebook/actions/workflows/tag-and-release.yml) |

## Introduction

This repository is a set of [bazel][bazel] build rules that allow you to write
a moderately complex book in the Markdown text format, and produce EPUB and
Kindle's AZW3 formats from them.  You can also produce a PDF format book, which
allows you to preview the results slightly more convenient than by reading the
resulting books.

The documentation is available in the following formats:

* [HTML][xht]
* [PDF][xpd]

[xht]: https://hdlfactory.com/bazel_ebook_html
[xpd]: https://hdlfactory.com/bazel_ebook_pdf/bazel_ebook_pdf.pdf
[bazel]: https://bazel.io

The build rules currently support pure Markdown formatting, LaTeX-style
equations (though not cross-referencing, and in general the amount of
LaTeX supported is somewhat limited).

> This is not an officially supported Google product.  Even though Google owns
> the copyright. I just happened to work there while I worked on this tool.

## Usage

`bazel_ebook` and several of its dependencies are published in
[my Bazel registry][reg] rather than the Bazel Central Registry, so a project
that depends on it must declare both registries.

Add the registry to your `.bazelrc` file.

```
common --registry=https://raw.githubusercontent.com/filmil/bazel-registry/main
common --registry=https://bcr.bazel.build
```

Bazel consults registries in the order listed and takes the first one that has
the module, so the custom registry goes **first**: that lets it override a
module that also exists in the Bazel Central Registry. This matches this
repo's own `.bazelrc` and `integration/.bazelrc`.

Then declare the dependency in `MODULE.bazel`:

```starlark
bazel_dep(name = "bazel_ebook", version = "2.0.15")

bazel_ebook_extension = use_extension(
    "@bazel_ebook//:extensions.bzl",
    "bazel_ebook_extension",
)
use_repo(
    bazel_ebook_extension,
    "pandoc_crossref",
    "pandoc_ext_include_files",
)
```

Without the extra `--registry` line the build fails at module resolution with
`module bazel_ebook@... not found in registries`.

[reg]: https://github.com/filmil/bazel-registry

## Prerequisites

* [docker](https://docker.io), because part of the bazel build process needs
  docker for the [build-in-docker][bid] method.
* [bazel](https://bazel.io), for building. I recommend an installation using
  the [bazelisk method][ba].

[ba]: https://hdlfactory.com/note/2024/08/24/bazel-installation-via-the-bazelisk-method/
[bid]: https://github.com/filmil/bazel-rules-bid

## Quick start

### Build

If you are impatient to see the rules in action, check out an example book in
[the integration repository][example].

  [example]: integration/README.md

The easiest way to dig in is to run the following one-liner:

```
cd integration && bazel build //...
```

This will build *all the examples* for you to appreciate.

### Examine results

Check out a [built example here][xmp].

[xmp]: https://www.hdlfactory.com/html_chunked

## API Documentation

Detailed, automatically generated documentation for all public API items in the `.bzl` files is available below:
* [build/attrs.md](build/attrs.md)
* [build/deps.md](build/deps.md)
* [build/pandoc.md](build/pandoc.md)
* [build/pandoc_metadata.md](build/pandoc_metadata.md)
* [build/providers.md](build/providers.md)
* [build/repositories.md](build/repositories.md)
* [build/rules.md](build/rules.md)
* [build/script.md](build/script.md)

## Defined build rules

The build rules are defined in the file [build/rules.bzl](build/rules.bzl).  A
quick list is here:

| Rule | Description |
|------|-------------|
| `asymptote(name, srcs, deps, output)` | This build rule converts [Asymptote][asy] source files into images that can be included in the book. This rule can take any `*.asy` file in `srcs` and can depend on any `asymptote` rule in `deps`. |
| `dot_png(name, srcs, deps, output)` | This build rule converts a [Graphviz][gvz] source files into PNG images that can be included in the book.  This rule can take any `*.dot` file in `srcs` and can depend on any rule in `deps`. The `.dot` file is laid out using the graphviz program `dot`. |
| `drawtiming_png(name, srcs, deps, output, args)` | Typeset a timing diagram using [drawtiming][dtg]. |
| `ebook_epub(name, deps, metadata_xml, title_yaml, args, additional_inputs)` | This build rule assembles all `markdown_lib` rules in sequece and produces a book named `[name].epub` |
| `ebook_kindle(name, deps, metadata_xml, title_yaml, args)` | This build rule assembles all `markdown_lib` rules in sequence and produces a book named `[name].azw3` |
| `ebook_pdf(name, deps, metadata_xml, title_yaml, args, additional_inputs)` | This build rule assembles all `markdown_lib` rules in sequence and produces a book named `[name].pdf` |
| `markdown_lib(name, srcs, deps, additional_inputs)` |  This build rule makes a library out of `*/md` files.  `deps` may be any `markdown_lib` or `asymptote` or other such rule, and those will be used correctly. |
| `neato_png(name, srcs, deps, output)` | This build rule converts a [Graphviz][gvz] source files into PNG images that can be included in the book.  This rule can take any `*.dot` file in `srcs` and can depend on any rule in `deps`. The `.dot` file is laid out using the graphviz program `neato`. |
| `pandoc_chunked_html(name, deps, metadata, toc, title, args, filters, additional_inputs)` | Use [pandoc][pandoc] to convert the `markdown_lib` deps listed into a set of chaptered HTML resources. This is probably the best way to generate a set of self-contained files.|
| `pandoc_standalone_html(name, deps, metadata, toc, title, args, filters, additional_inputs)` | Use [pandoc][pandoc] to convert the `markdown_lib` deps listed into a standalone HTML file.|
| `plantuml_png(name, srcs, deps, output)` | This build rule converts a [PlantUML][plantuml] source files into PNG images that can be included in the book.  This rule can take any PlantUML-formatted `*.txt` file in `srcs` and can depend on any rule in `deps`. |

  [asy]: https://asymptote.sourceforge.io
  [gvz]: https://graphviz.org
  [plantuml]: https://plantuml.com
  [dtg]: https://drawtiming.sourceforge.net/

### Common parameters

* `args`: (`list[string]`): verbatim arguments to be passed to the underlying
  program.
* `deps`: (`list[Label]`): dependency labels, can be any generated targets.
* `filters`: (`list[Label]`): a list of [pandoc][pandoc] filters to apply, in
  the order that they need to appear in the `pandoc` command line.
* `toc`: (`bool`): whether to generate a table of contents.
* `metadata`: (`Label`): A label representing a YAML metadata file. Note that
  quite a few of these may be specified as preamble to regular `pandoc`
  markdown.

## Underlying software

These build rules, of course, only explain to bazel how the ebook is to be
built.  The actual workhorses for building are [Docker][docker],
[pandoc][pandoc], [calibre][calibre], [LaTeX][latex], [Graphviz][gvz],
[Asymptote][asy], [drawtiming][dtg] and [PlantUML][plantuml].

  [docker]: https://www.docker.io
  [pandoc]: https://www.pandoc.org
  [calibre]: https://calibre-ebook.com
  [latex]: https://www.latex-project.org

I used automated coding assistance (Claude Code) to rework my prior setup
requiring docker, into a plain, fully hermetic setup.

## Releasing and publishing

`Tag and Release` in `.github/workflows/tag-and-release.yml` runs weekly and
on `workflow_dispatch`.
It releases only when a commit landed since the last tag, computes the
version from the conventional-commit titles since that tag, and pushes it.
The release itself goes through bazel-contrib's `release_ruleset.yaml`:
it runs `bazel test //...` at the tag, has
`.github/workflows/release_prep.sh` build `bazel-ebook-<tag>.zip` and the
release notes, and attests the archive's provenance.
A release then lists the archive and `bazel-ebook-<tag>.zip.intoto.jsonl`.

The same run publishes the release to [my Bazel registry][reg] as a pull
request, through `.github/workflows/publish-my-bcr.yml`.
When the repository variable `PUBLISH_TO_BCR` is `true`, it also opens a
pull request against the Bazel Central Registry through
`.github/workflows/publish-official-bcr.yml`, with attested `MODULE.bazel`
and `source.json`, which is what the BCR presubmit verifies with
`slsa-verifier`.
Only that publish attests: two attesting publishes would overwrite each
other's attestation files on the release.
The variable stays `false` until every dependency is on the Bazel Central
Registry.

To check a release the way the BCR does, with the archive downloaded from
the release:

```
slsa-verifier verify-github-attestation \
  --attestation-path bazel-ebook-<tag>.zip.intoto.jsonl \
  --source-uri github.com/filmil/bazel-ebook \
  --builder-id https://github.com/bazel-contrib/.github/.github/workflows/release_ruleset.yaml \
  bazel-ebook-<tag>.zip
```

## Limitations

There are a few constraints to note however:

1. **Hermeticized build rules are hefty.** You need to have your caching
   set up well to avoid recompiling the build environment as much as
   possible. Otherwise, you may pay for costly downloads and infra
   recompiles.
