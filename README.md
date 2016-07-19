# Introduction

Here is a minimal example of using Markdown to write a sciency book that
includes source code listings or equations.  "Sciency" because it's assumed
that the amount of listings or equations is small, and their relationship
uncomplicated.

The book content is generated in several formats:

* PDF (e.g. for printing on paper)
* ePub (for electronic readers that support it, basically anything *except*
  Kindle)
* mobi (for Kindle)

# Prerequisites

TODO(filmil): The "prerequisites" section is very skimpy and doesn't explain
setting up in enough details.

* scons (for `scons`, a nice build system)
* calibre (for `ebook-convert` that produces mobi format content)
* pandoc (for, you guessed it, `pandoc` that produces epub format content)
* texlive (for producing PDF)
* gladtex (to produce equation images)

# Building

```
scons
```

Yes, it's that easy.  This will run the commands needed to produce a PDF file
(`example.pdf`), an ePub file (`example.epub`) and a mobi (Kindle) format file
(`example.mobi`).

# Cleanup

```
scons -c
```

Yes, it's that easy.

# Caveats

* The equations for the mobi format are generated as 300dpi files.  Epub is
  currently unusable because of this; if epub is needed, then we need a
  completely separate epub build rule that builds it directly. 
* The build script generates html with embedded images for equations.  Probably
  we need something similar to epub production above.
* The `epub-metadata.xml` file actually *must not* be well-formed XML.  Only
  bare "Dublin core" markup elements are allowed if you want that markup XML to
  make it into the actual book contents.   I don't quite understand why, but
  that is how things are today.
* Apparently the `epub-metadata.xml` gets ignored if you build your ebook from
  markdown.  This matters for the directly-generated epub version which is made
  directly from the Markdown source (in contrast to the `.mobi` version which
  requires several steps to produce)

# TODO

* Add an example title page.
* Add an example generated figure e.g. with tikZ or some other involved
  drawing program.

