# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y \
	python3 \
	texlive-fonts-recommended \
    asymptote \
    bash \
    calibre \
    gladtex \
    pandoc \
    scons \
    graphviz

# Typesetting timing diagrams
RUN apt-get install -y \
    drawtiming
