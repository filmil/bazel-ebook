---
codeBlockCaptions: True
figureTitle: |
  Figure #
lofTitle: |
  ## List of Figures
lotTitle: |
  ## List of Tables
lolTitle: |
  ## List of Listings
tableTemplate: |
  *$$tableTitle$$ $$i$$*$$titleDelim$$ $$t$$
autoSectionLabels: True
title: pandoc-crossref demo document
---
# Hello world!

# Chapter 1. Figures {#sec:sec1}

> This part is lifted from the [pandoc crossref demo][pcr]

[pcr]: https://raw.githubusercontent.com/lierdakil/pandoc-crossref/master/docs/demo/demo.md

I'm a test Markdown document.

**Here's some bold text** and *here's some italic text*. `This is inline code`.

# Chapter 2. Equations {#sec:sec2}

Display equations are labelled and numbered

$$ P_i(x) = \sum_i a_i x^i $$ {#eq:eqn1}

# Code blocks

There are a couple options for code block labels. Those work only if code block id starts with `lst:`, e.g. `{#lst:label}`

## `caption` attribute {#sec:caption-attr}

`caption` attribute will be treated as code block caption. If code block has both id and `caption` attributes, it will be treated as numbered code block.

```{#lst:captionAttr .haskell caption="Listing caption"}
main :: IO ()
main = putStrLn "Hello World!"
```

# Markdown Tables

First Name  |  Last Name  |  Location           |  Allegiance
------------|-------------|---------------------|-----------------
Mance       |  Rayder     |  North of the Wall  |  Wildlings
Margaery    |  Tyrell     |  The Reach          |  House Tyrell
Danerys     |  Targaryen  |  Meereen            |  House Targaryen
Tyrion      |  Lannister  |  King's Landing     |  House Lannister

# Code blocks

    This code
    is in
    a code block.

Here's a syntax-highlighted code block:

```python
#!/usr/bin/env python3

import sys

if __name__ == '__main__':
    print('This is highlighted Python code!')
    sys.exit(0)
```

# Page Layout with \LaTeX\ Commands

Here's a forced page break.

\pagebreak

# LaTeX support

This document supports inline \LaTeX!

Here's the proof: $\frac{n!}{k!(n-k)!} = \binom{n}{k}$

Creating a footnote is easy.\footnote{An example footnote.}

Here's an equation:

$$
  x = a_0 + \cfrac{1}{a_1
          + \cfrac{1}{a_2
          + \cfrac{1}{a_3 + \cfrac{1}{a_4} } } }
$$

Here are some numbered equations:

$$
 f(x)=(x+a)(x+b)
$$

$$
5^2 - 5 = 20
$$

$$
a = bq + r
$$

Here's some multi-line math stuff:

\begin{align*}
 f(x) &= (x+a)(x+b) \\
 &= x^2 + (a+b)x + ab
\end{align*}

# Images

Let's try some images.

![Here is an image of a Pythagorean tree.](test.asy.png)


