# Introduction

This repository is a set of [bazel][bazel] build rules that allow you to write
a moderately complex book in the Markdown text format, and produce EPUB and
Kindle's MOBI formats from them.  You can also produce a PDF format book, which
allows you to preview the results slightly more convenient than by reading the
resulting books.

   [bazel]: https://bazel.io

The build rules currently support pure Markdown formatting, LaTeX-style
equations (though not cross-referencing, and in general the amount of
LaTeX supported is somewhat limited).

# Prerequisites

* [bazel](https://bazel.io), for building.
* [docker](https://docker.io), because part of the bazel build process needs
  docker

# Quick start

If you are impatient to see the rules in action, check out an example book in a
separate [ebook example github repository][example].

  [example]: https://www.github.com/filmil/ebook-example

# Defined build rules

The build rules are defined in the file [build/rules.bzl](build/rules.bzl).  A
quick list is here:

| Rule | Description |
|------|-------------|
| `asymptote(name, srcs, deps)` | This build rule converts [Asymptote][asy] source files into images that can be included in the book.\
\
This rule can take any `*.asy` file in `srcs` and can depend on any `asymptote` rule in `deps`. |
| `markdown_lib(name, srcs, deps)` |  This build rule makes a library out of `*/md` files.  `deps` may be any `markdown_lib` or `asymptote` or other such rule, and those will be used correctly. |
| `ebook_epub(name, deps, metadata_xml, title_yaml)` | This build rule assembles all `markdown_lib` rules in sequece and produces a book named `[name].epub` |
| `ebook_kindle(name, deps, metadata_xmp, title_yaml)` | This build rule assembles all `markdown_lib` rules in sequence and produces a book named `[name].mobi` |
| `ebook_pdf(name, deps, metadata_xmp, title_yaml)` | This build rule assembles all `markdown_lib` rules in sequence and produces a book named `[name].pdf` |

  [asy]: https://asymptote.sourceforge.io
