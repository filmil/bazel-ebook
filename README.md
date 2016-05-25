# Introduction

Here is a minimal example of using Markdown to write a sciency book that includes source code listings or equations.  "Sciency" because it's assumed that the amount of listings or equations is small, and their relationship uncomplicated.

The book content is generated in several formats:

* PDF (e.g. for printing on paper)
* ePub (for electronic readers that support it, basically anything *except* Kindle)
* mobi (for Kindle)

# Prerequisites

TODO(filmil): The "prerequisites" section is very skimpy and doesn't explain setting up in enough details.

* scons (for `scons`, a nice build system)
* calibre (for `ebook-convert` that produces mobi format content)
* pandoc (for, you guessed it, `pandoc` that produces epub format content)
* texlive (for producing PDF)

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

* The builder does not produce equations for Kindle's mobi format.  
  This is because Kindle doesn't support formulas. I'm still 
  thinking how to have formulas rendered on Kindle.