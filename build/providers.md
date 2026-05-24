<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="EbookInfo"></a>

## EbookInfo

<pre>
load("@bazel_ebook//build:providers.bzl", "EbookInfo")

EbookInfo(<a href="#EbookInfo-figures">figures</a>, <a href="#EbookInfo-markdowns">markdowns</a>, <a href="#EbookInfo-additional_inputs">additional_inputs</a>)
</pre>

**FIELDS**

| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="EbookInfo-figures"></a>figures | The figurs targets to use. | `[]` |
| <a id="EbookInfo-markdowns"></a>markdowns | The markdown files, in order | `[]` |
| <a id="EbookInfo-additional_inputs"></a>additional_inputs | Additional inputs do not appear in any command lines, but are present in sandboxes at compile time. | `[]` |


<a id="PandocMetadata"></a>

## PandocMetadata

<pre>
load("@bazel_ebook//build:providers.bzl", "PandocMetadata")

PandocMetadata(<a href="#PandocMetadata-_init-name">name</a>, <a href="#PandocMetadata-_init-title">title</a>)
</pre>

**CONSTRUCTOR PARAMETERS**

| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="PandocMetadata-_init-name"></a>name | <p align="center">-</p> | none |
| <a id="PandocMetadata-_init-title"></a>title | String. Used as title where this is needed | `None` |

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="PandocMetadata-title"></a>title |  String. Used as title where this is needed    |


<a id="merge_EbookInfo"></a>

## merge_EbookInfo

<pre>
load("@bazel_ebook//build:providers.bzl", "merge_EbookInfo")

merge_EbookInfo(<a href="#merge_EbookInfo-infos">infos</a>)
</pre>

Merges a list of EbookInfo providers.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="merge_EbookInfo-infos"></a>infos |  A list of EbookInfo providers.   |  none |

**RETURNS**

An EbookInfo provider.


<a id="pandoc_metadata"></a>

## pandoc_metadata

<pre>
load("@bazel_ebook//build:providers.bzl", "pandoc_metadata")

pandoc_metadata(<a href="#pandoc_metadata-title">title</a>)
</pre>

Creates a pandoc metadata struct.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="pandoc_metadata-title"></a>title |  The title of the document.   |  `None` |

**RETURNS**

A struct with pandoc metadata.


