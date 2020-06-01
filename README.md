![Build Status](https://github.com/filmil/bazel-ebook/workflows/Build/badge.svg)

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

> This is not an officially supported Google product.  Even though Google owns
> the copyright. I just happened to work there while I worked on this tool.

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
| `asymptote(name, srcs, deps)` | This build rule converts [Asymptote][asy] source files into images that can be included in the book. This rule can take any `*.asy` file in `srcs` and can depend on any `asymptote` rule in `deps`. |
| `markdown_lib(name, srcs, deps)` |  This build rule makes a library out of `*/md` files.  `deps` may be any `markdown_lib` or `asymptote` or other such rule, and those will be used correctly. |
| `ebook_epub(name, deps, metadata_xml, title_yaml)` | This build rule assembles all `markdown_lib` rules in sequece and produces a book named `[name].epub` |
| `ebook_kindle(name, deps, metadata_xmp, title_yaml)` | This build rule assembles all `markdown_lib` rules in sequence and produces a book named `[name].mobi` |
| `ebook_pdf(name, deps, metadata_xmp, title_yaml)` | This build rule assembles all `markdown_lib` rules in sequence and produces a book named `[name].pdf` |

  [asy]: https://asymptote.sourceforge.io

# Underlying software

These build rules, of course, only explain to bazel how the ebook is to be
built.  The actual workhorses for building are, in order, [Docker][docker],
[pandoc][pandoc], [calibre][calibre], [LaTeX][latex] and [Asymptote][asy].

  [docker]: https://www.docker.io
  [pandoc]: https://www.pandoc.org
  [calibre]: https://calibre-ebook.com
  [latex]: https://www.latex-project.org

These software packages are quite complex, and their installation can also be
quite challenging.  As I wanted to work around that complication, I devised a
way to package all this software into a [buildenv container][buildenv] and then
invoke each in a special command for each action inside a custom docker
container.

This means, if you can ensure that your computer has `docker` and `bazel`
installed, you don't need to worry about installing any other additional
software!  Everything else, `bazel` will pull for you from the Internet.

  [buildenv]: https://hub.docker.com/repository/docker/filipfilmar/ebook-buildenv

I am kind of proud of the way this was done, and you can see some more detail
in the script [docker_run.sh](build/docker_run.sh).


# Limitations

There are a few constraints to note however:

1. Sadly, the way bazel sandboxes things puts some limitations on what rules
   can be included where.  The general rule is, if you have a build rule in a
   directory `X` you can mention only rules that are in `X` itself, or a
   subdirectory of `X`, like `X/dir`, or `X/dir1/dir2`.  It is not possible to
   refer to `X/dir1:rule` from `X/dir2:rule`.

1. The build rules pull the container [filipfilmar/ebook-buildenv][buildenv]
   from the Internet.  While I know what is inside (and you can check the
   intended contents in [docker/](docker/)), it's still your build system
   downloading random stuff from the Internet and running on your machine.  This
   may be OK for you to the extent that you trust me to provide you with the
   software that I tell you I'm providing.

   In case this doesn't fulfill your trust critera, you are of course free to
   fork this repository, and use your own buildenv, since all the recipes are
   there.

   Another possibility, which has been left for some future, is to add the
   container build and upload recipes to these rules, so that you can choose to
   build and use your own container easily.

1. As currently written, the rules probably only work on Linux, which is the
   same platform as my dev box.  It should in principle be possible to rig the
   build rules so that they do the correct thing cross-platform, but I don't
   have an immediate plan to do so, as long as the rules satisfy my own needs.

