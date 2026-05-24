<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="asymptote"></a>

## asymptote

<pre>
load("@bazel_ebook//build:rules.bzl", "asymptote")

asymptote(<a href="#asymptote-name">name</a>, <a href="#asymptote-deps">deps</a>, <a href="#asymptote-srcs">srcs</a>, <a href="#asymptote-output">output</a>)
</pre>

Transform an asymptote file into png

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="asymptote-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="asymptote-deps"></a>deps |  The dependencies, any targets should be allowed   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="asymptote-srcs"></a>srcs |  The file to compile   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="asymptote-output"></a>output |  The generated file   | <a href="https://bazel.build/concepts/labels">Label</a>; <a href="https://bazel.build/reference/be/common-definitions#configurable-attributes">nonconfigurable</a> | optional |  `None`  |


<a id="dot_png"></a>

## dot_png

<pre>
load("@bazel_ebook//build:rules.bzl", "dot_png")

dot_png(<a href="#dot_png-name">name</a>, <a href="#dot_png-deps">deps</a>, <a href="#dot_png-srcs">srcs</a>, <a href="#dot_png-output">output</a>)
</pre>

Transform a graphviz dot file into png using dot

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="dot_png-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="dot_png-deps"></a>deps |  The dependencies, any targets should be allowed   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dot_png-srcs"></a>srcs |  The file to compile   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="dot_png-output"></a>output |  The generated file   | <a href="https://bazel.build/concepts/labels">Label</a>; <a href="https://bazel.build/reference/be/common-definitions#configurable-attributes">nonconfigurable</a> | optional |  `None`  |


<a id="drawtiming_png"></a>

## drawtiming_png

<pre>
load("@bazel_ebook//build:rules.bzl", "drawtiming_png")

drawtiming_png(<a href="#drawtiming_png-name">name</a>, <a href="#drawtiming_png-deps">deps</a>, <a href="#drawtiming_png-srcs">srcs</a>, <a href="#drawtiming_png-args">args</a>, <a href="#drawtiming_png-output">output</a>)
</pre>

Transform a timing diagram file into png using drawtiming

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="drawtiming_png-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="drawtiming_png-deps"></a>deps |  The dependencies, any targets should be allowed   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="drawtiming_png-srcs"></a>srcs |  The file to compile   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="drawtiming_png-args"></a>args |  A list of arguments prepended verbatim to the invocation of drawtiming   | List of strings | optional |  `[]`  |
| <a id="drawtiming_png-output"></a>output |  The generated file   | <a href="https://bazel.build/concepts/labels">Label</a>; <a href="https://bazel.build/reference/be/common-definitions#configurable-attributes">nonconfigurable</a> | optional |  `None`  |


<a id="ebook_epub"></a>

## ebook_epub

<pre>
load("@bazel_ebook//build:rules.bzl", "ebook_epub")

ebook_epub(<a href="#ebook_epub-name">name</a>, <a href="#ebook_epub-deps">deps</a>, <a href="#ebook_epub-additional_inputs">additional_inputs</a>, <a href="#ebook_epub-args">args</a>, <a href="#ebook_epub-metadata_xml">metadata_xml</a>, <a href="#ebook_epub-title_yaml">title_yaml</a>)
</pre>

Generate an ebook in EPUB format

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ebook_epub-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ebook_epub-deps"></a>deps |  All the targets you need to make this book work.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ebook_epub-additional_inputs"></a>additional_inputs |  Any additional source files necessary   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ebook_epub-args"></a>args |  Any additional args to insert   | List of strings | optional |  `[]`  |
| <a id="ebook_epub-metadata_xml"></a>metadata_xml |  The epub-metadata.xml file to use for this book   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ebook_epub-title_yaml"></a>title_yaml |  The title.yaml file to use for this book   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="ebook_kindle"></a>

## ebook_kindle

<pre>
load("@bazel_ebook//build:rules.bzl", "ebook_kindle")

ebook_kindle(<a href="#ebook_kindle-name">name</a>, <a href="#ebook_kindle-deps">deps</a>, <a href="#ebook_kindle-args">args</a>, <a href="#ebook_kindle-metadata_xml">metadata_xml</a>, <a href="#ebook_kindle-title_yaml">title_yaml</a>)
</pre>

Generate an ebook in the Kindle's MOBI format

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ebook_kindle-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ebook_kindle-deps"></a>deps |  All the targets you need to make this book work.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ebook_kindle-args"></a>args |  Any additional args to insert   | List of strings | optional |  `[]`  |
| <a id="ebook_kindle-metadata_xml"></a>metadata_xml |  The epub-metadata.xml file to use for this book   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ebook_kindle-title_yaml"></a>title_yaml |  The title.yaml file to use for this book   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="ebook_pdf"></a>

## ebook_pdf

<pre>
load("@bazel_ebook//build:rules.bzl", "ebook_pdf")

ebook_pdf(<a href="#ebook_pdf-name">name</a>, <a href="#ebook_pdf-deps">deps</a>, <a href="#ebook_pdf-additional_inputs">additional_inputs</a>, <a href="#ebook_pdf-args">args</a>, <a href="#ebook_pdf-metadata_xml">metadata_xml</a>, <a href="#ebook_pdf-title_yaml">title_yaml</a>, <a href="#ebook_pdf-toc">toc</a>)
</pre>

Generate an ebook in PDF format

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ebook_pdf-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ebook_pdf-deps"></a>deps |  All the targets you need to make this book work.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ebook_pdf-additional_inputs"></a>additional_inputs |  Any additional source files necessary   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ebook_pdf-args"></a>args |  Any additional args to insert   | List of strings | optional |  `[]`  |
| <a id="ebook_pdf-metadata_xml"></a>metadata_xml |  The epub-metadata.xml file to use for this book   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ebook_pdf-title_yaml"></a>title_yaml |  The title.yaml file to use for this book   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |
| <a id="ebook_pdf-toc"></a>toc |  Set to true to generate a Table of Contents   | Boolean | optional |  `False`  |


<a id="markdown_lib"></a>

## markdown_lib

<pre>
load("@bazel_ebook//build:rules.bzl", "markdown_lib")

markdown_lib(<a href="#markdown_lib-name">name</a>, <a href="#markdown_lib-deps">deps</a>, <a href="#markdown_lib-srcs">srcs</a>, <a href="#markdown_lib-additional_inputs">additional_inputs</a>)
</pre>

Declares a set of markdown files

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="markdown_lib-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="markdown_lib-deps"></a>deps |  The file to compile   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="markdown_lib-srcs"></a>srcs |  The markdown source files   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="markdown_lib-additional_inputs"></a>additional_inputs |  Any additional source files necessary   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |


<a id="neato_png"></a>

## neato_png

<pre>
load("@bazel_ebook//build:rules.bzl", "neato_png")

neato_png(<a href="#neato_png-name">name</a>, <a href="#neato_png-deps">deps</a>, <a href="#neato_png-srcs">srcs</a>, <a href="#neato_png-output">output</a>)
</pre>

Transform a graphviz dot file into png using neato

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="neato_png-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="neato_png-deps"></a>deps |  The dependencies, any targets should be allowed   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="neato_png-srcs"></a>srcs |  The file to compile   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="neato_png-output"></a>output |  The generated file   | <a href="https://bazel.build/concepts/labels">Label</a>; <a href="https://bazel.build/reference/be/common-definitions#configurable-attributes">nonconfigurable</a> | optional |  `None`  |


<a id="pandoc_chunked_html"></a>

## pandoc_chunked_html

<pre>
load("@bazel_ebook//build:rules.bzl", "pandoc_chunked_html")

pandoc_chunked_html(<a href="#pandoc_chunked_html-name">name</a>, <a href="#pandoc_chunked_html-deps">deps</a>, <a href="#pandoc_chunked_html-additional_inputs">additional_inputs</a>, <a href="#pandoc_chunked_html-args">args</a>, <a href="#pandoc_chunked_html-filters">filters</a>, <a href="#pandoc_chunked_html-metadata">metadata</a>, <a href="#pandoc_chunked_html-title">title</a>, <a href="#pandoc_chunked_html-toc">toc</a>)
</pre>

Create a chunked HTML file from the Pandoc markdown

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="pandoc_chunked_html-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="pandoc_chunked_html-deps"></a>deps |  The markdown libraries, used in the order provided.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_chunked_html-additional_inputs"></a>additional_inputs |  Any additional source files necessary   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_chunked_html-args"></a>args |  Any additional args to insert   | List of strings | optional |  `[]`  |
| <a id="pandoc_chunked_html-filters"></a>filters |  Targets representing filters binaries to use   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_chunked_html-metadata"></a>metadata |  Metadata in case it is needed.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_chunked_html-title"></a>title |  If set, this will be used as the title of the HTML   | String | optional |  `""`  |
| <a id="pandoc_chunked_html-toc"></a>toc |  If set, generate a table of contents   | Boolean | optional |  `False`  |


<a id="pandoc_standalone_html"></a>

## pandoc_standalone_html

<pre>
load("@bazel_ebook//build:rules.bzl", "pandoc_standalone_html")

pandoc_standalone_html(<a href="#pandoc_standalone_html-name">name</a>, <a href="#pandoc_standalone_html-deps">deps</a>, <a href="#pandoc_standalone_html-additional_inputs">additional_inputs</a>, <a href="#pandoc_standalone_html-args">args</a>, <a href="#pandoc_standalone_html-filters">filters</a>, <a href="#pandoc_standalone_html-metadata">metadata</a>, <a href="#pandoc_standalone_html-title">title</a>, <a href="#pandoc_standalone_html-toc">toc</a>)
</pre>

Create a stand-alone HTML file from the Pandoc markdown

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="pandoc_standalone_html-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="pandoc_standalone_html-deps"></a>deps |  The markdown libraries, used in the order provided.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_standalone_html-additional_inputs"></a>additional_inputs |  Any additional source files necessary   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_standalone_html-args"></a>args |  Any additional args to insert   | List of strings | optional |  `[]`  |
| <a id="pandoc_standalone_html-filters"></a>filters |  Targets representing filters binaries to use   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_standalone_html-metadata"></a>metadata |  Metadata in case it is needed.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="pandoc_standalone_html-title"></a>title |  If set, this will be used as the title of the HTML   | String | optional |  `""`  |
| <a id="pandoc_standalone_html-toc"></a>toc |  If set, generate a table of contents   | Boolean | optional |  `False`  |


<a id="plantuml_png"></a>

## plantuml_png

<pre>
load("@bazel_ebook//build:rules.bzl", "plantuml_png")

plantuml_png(<a href="#plantuml_png-name">name</a>, <a href="#plantuml_png-deps">deps</a>, <a href="#plantuml_png-srcs">srcs</a>, <a href="#plantuml_png-output">output</a>)
</pre>

Transform a timing diagram file into png using plantuml

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="plantuml_png-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="plantuml_png-deps"></a>deps |  The dependencies, any targets should be allowed   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="plantuml_png-srcs"></a>srcs |  The file to compile   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="plantuml_png-output"></a>output |  The generated file   | <a href="https://bazel.build/concepts/labels">Label</a>; <a href="https://bazel.build/reference/be/common-definitions#configurable-attributes">nonconfigurable</a> | optional |  `None`  |


