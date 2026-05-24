<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="pandoc_chunked_html"></a>

## pandoc_chunked_html

<pre>
load("@bazel_ebook//build:pandoc.bzl", "pandoc_chunked_html")

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
load("@bazel_ebook//build:pandoc.bzl", "pandoc_standalone_html")

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


