# Instructions

Firstly, read README.md to understand how to build and what the purpose of
things is.

Never auto-modify the following files:
* //tools/bazel
* Any dotfile.
* Any `*.lock` files.
* Any `*.nix` files.

Unless otherwise instructed, only apply maintenance tasks to files in the git
index, or uncommitted files, to avoid redoing work on files that are already
committed to git.

# General change rules

Read the file `//ai/AI_GIT.md` for instructions.

# License maintenance

When maintaining the license files do not modify the following:

* Files under the directory `//third_party`.
* Any files with filenames beginning with a dot.

For all source files and all BUILD files, verify that they have a license
reference at the beginning of the file.

If a file does not have a license reference, add the following text in the
header, appropriately enclosed in comments that are appropriate for the
source file type in question:

```
LICENSE sha256: <value>
```

where `<value>` must be replaced by the `sha256sum` of the file `//LICENSE`.

# `//third_party` maintenance

Every subdir under `//third_party` must have a LICENSE file with the appropriate
license copied from its source distribution.

# Public API documentation maintenance

Ensure that the repository is clean before starting this procedure.

For all source files, we want to maintain an up-to-date documentation of their
respective public API.

# Publish to Bazel central registry

Read the file `//ai/AI_BCR.md` for publication instructions.

