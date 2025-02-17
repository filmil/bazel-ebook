# Introduction

This document explains the [bazel-ebook][be] repository and its functionality.
Bazel ebook is a set of tools you can use to publish electronic books of
moderate complexity. It relies on existing [pandoc][pdc], which is a universal
document format converter. bazel-ebook uses pandoc for most of its heavy
lifting.

The contribution of bazel-ebook is in automatic installation of all needed
dependencies and the unification of the ebook build process.

Using the tools provided in bazel-ebook, you can produce quality documentation for
say a piece of software, or a publishable ebook, in any of the following formats:

* One-file HTML
* Multi-file ("chunked") HTML
* PDF
* MOBI (the Amazon Kindle format)
* EPUB (the open ebook format)

In proof of this claim, you can find this document

* [HTML][xht]
* [PDF][xpd]

[xht]: https://hdlfactory.com/bazel_ebook_html
[xpd]: https://hdlfactory.com/bazel_ebook_pdf/bazel_ebook_pdf.pdf


[pdc]: https://pandoc.org
[be]: https://github.com/filmil/bazel-ebook
