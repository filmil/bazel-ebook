# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

"""Runs pandoc-include as the package it is.

pandoc_include/main.py imports its siblings relatively, so it only works when
imported as part of the pandoc_include package. Handing it to py_binary as
`main` runs it as a bare script instead, and the first relative import fails
with "attempted relative import with no known parent package".
"""

from pandoc_include.main import main

if __name__ == "__main__":
    main()
