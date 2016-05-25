# Introduction

This is an example of using Markdown to write an ebook.

# Prerequisites:

* scons (for `scons`)
* calibre (for `ebook-convert`)
* pandoc (for, you guessed it, pandoc)
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
