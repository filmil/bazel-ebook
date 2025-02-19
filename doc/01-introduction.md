# Introduction

This document explains the [bazel-ebook][be] source code repository on Github
and its functionality.

bazel-ebook is a set of tools you can use to publish electronic books of
moderate complexity. It relies on existing [pandoc][pdc], which is a universal
document format converter. bazel-ebook uses pandoc for most of its heavy
lifting.

The contribution of bazel-ebook is in automatic installation of all needed
dependencies and the unification of the ebook build process. This is useful for
documenting large code bases and pieces of software, especially those that use
[bazel][bzl] as their build system.

Using the tools provided in bazel-ebook, you can produce quality documentation for
say a piece of software, or a publishable ebook, in any of the following formats:

* One-file HTML
* Multi-file ("chunked") HTML
* PDF
* MOBI (the Amazon Kindle format)
* EPUB (the open ebook format)

In proof of this claim, you can find this document in one of the serveral formats
at the links below.

* [HTML][xht]
* [PDF][xpd]


## Why?

Pedantically, each step of the publication flow offered by bazel-ebook is already
covered by some piece of software. Why, then, go through the trouble of providing
yet another way of achieving essentially the same thing?

* Most such software is not amenable to automation. I wanted something that would
  be able to automate the entire workflow from start to finish.
* LaTeX exists, but is primarily geared towards printed publication, which is a
  bar I did not need to meet. It is also quite involved to weave into modern
  build workflows, and even more involved to have it generate publication quality
  HTML documentation.
* EPUB can be produced by many pieces of software, not the least of which is
  [Google Docs][gdcs]. But, again, keeping your publication in sync with especially
  software artifacts is then a completely manual process.  I wanted something
  fully automated.
* A bazel-based downflow weaves well into other work I do with bazel. I usually
  deal with very heterogeneous builds, where having partial build solutions leads
  to confusing, redundant, and many times incorrect results. Bazel can take in
  all of these processes and order them in a way that produces fast and correct
  full or incremental builds. This is something I highly value.


[xht]: https://hdlfactory.com/bazel_ebook_html
[xpd]: https://hdlfactory.com/bazel_ebook_pdf/bazel_ebook_pdf.pdf
[pdc]: https://pandoc.org
[be]: https://github.com/filmil/bazel-ebook
[bzl]: https://bazel.build
[gdcs]: https://docs.google.com
