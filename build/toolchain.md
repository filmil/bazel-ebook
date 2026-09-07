<!-- Generated with Stardoc: http://skydoc.bazel.build -->

A toolchain describing the external programs the ebook rules invoke.

Historically every rule in this repository hardcoded both the name of the
program it ran (`pandoc`, `plantuml`, ...) and the mechanism used to run it
(`@rules_bid//build:docker_run`, i.e. a container). That made the set of
required binaries invisible: it could only be recovered by reading the rule
implementations and the `docker/Dockerfile` side by side.

This toolchain makes the set explicit. A toolchain supplies, for each logical
tool name, the command used to invoke it, plus an optional `wrapper`
executable that every invocation is routed through.

The `wrapper` is what allows the container-based implementation to keep
working unchanged: for the docker toolchain the commands are bare names
resolved on the container's `PATH`, and the wrapper enters the container. A
future hermetic toolchain instead supplies real paths to binaries built or
fetched by Bazel and no wrapper at all.

<a id="ebook_toolchain"></a>

## ebook_toolchain

<pre>
load("@bazel_ebook//build:toolchain.bzl", "ebook_toolchain")

ebook_toolchain(<a href="#ebook_toolchain-name">name</a>, <a href="#ebook_toolchain-hermetic_tools">hermetic_tools</a>, <a href="#ebook_toolchain-path_roots">path_roots</a>, <a href="#ebook_toolchain-tools">tools</a>, <a href="#ebook_toolchain-wrapper">wrapper</a>)
</pre>

Declares how the ebook rules reach the programs they need.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ebook_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ebook_toolchain-hermetic_tools"></a>hermetic_tools |  Maps a name in EBOOK_TOOLS to an executable target that Bazel provides. Such a tool is run directly, without the wrapper.   | Dictionary: String -> Label | optional |  `{}`  |
| <a id="ebook_toolchain-path_roots"></a>path_roots |  Rootfs directories to put on PATH for tools that start other programs themselves.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="ebook_toolchain-tools"></a>tools |  Maps each name in EBOOK_TOOLS not covered by hermetic_tools to the command that runs it.   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="ebook_toolchain-wrapper"></a>wrapper |  Executable each tool invocation is routed through, if any.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="EbookToolchainInfo"></a>

## EbookToolchainInfo

<pre>
load("@bazel_ebook//build:toolchain.bzl", "EbookToolchainInfo")

EbookToolchainInfo(<a href="#EbookToolchainInfo-tools">tools</a>, <a href="#EbookToolchainInfo-hermetic">hermetic</a>, <a href="#EbookToolchainInfo-path_roots">path_roots</a>, <a href="#EbookToolchainInfo-wrapper">wrapper</a>)
</pre>

The external programs used by the ebook rules.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="EbookToolchainInfo-tools"></a>tools |  dict: logical tool name (see EBOOK_TOOLS) -> the command used to invoke it. For a container-based toolchain these are bare names resolved on the container PATH; for a hermetic toolchain they are paths to Bazel-provided binaries.    |
| <a id="EbookToolchainInfo-hermetic"></a>hermetic |  dict: logical tool name -> FilesToRunProvider for a binary Bazel builds or fetches itself. A tool listed here is invoked directly and bypasses the wrapper entirely; anything absent falls back to `tools` and the wrapper. This is what lets the migration off the container happen one tool at a time.    |
| <a id="EbookToolchainInfo-path_roots"></a>path_roots |  list of File: rootfs directories whose bin and usr/bin are put on PATH. Some tools start other programs themselves rather than being told where they are: pandoc runs rsvg-convert for SVG figures and pdflatex to make a PDF. Those cannot be passed as arguments, so they have to be findable.    |
| <a id="EbookToolchainInfo-wrapper"></a>wrapper |  FilesToRunProvider: an executable that every non-hermetic invocation is routed through, or None when the tools are invoked directly. Carrying the whole provider (rather than just the File) keeps the wrapper's runfiles attached when it is passed to an action's `tools`.    |


<a id="ebook_path"></a>

## ebook_path

<pre>
load("@bazel_ebook//build:toolchain.bzl", "ebook_path")

ebook_path(<a href="#ebook_path-info">info</a>)
</pre>

Returns a PATH value covering the toolchain's rootfs directories.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="ebook_path-info"></a>info |  <p align="center"> - </p>   |  none |

**RETURNS**

A struct with `value`, the PATH string, and `inputs`, the files that
  have to reach the action for it to be usable.


<a id="ebook_tool"></a>

## ebook_tool

<pre>
load("@bazel_ebook//build:toolchain.bzl", "ebook_tool")

ebook_tool(<a href="#ebook_tool-info">info</a>, <a href="#ebook_tool-name">name</a>, <a href="#ebook_tool-dir_reference">dir_reference</a>, <a href="#ebook_tool-script_cmd">script_cmd</a>)
</pre>

Describes how to invoke one tool.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="ebook_tool-info"></a>info |  the EbookToolchainInfo from the resolved toolchain.   |  none |
| <a id="ebook_tool-name"></a>name |  a logical tool name from EBOOK_TOOLS.   |  none |
| <a id="ebook_tool-dir_reference"></a>dir_reference |  path used by the wrapper to locate the build root.   |  none |
| <a id="ebook_tool-script_cmd"></a>script_cmd |  function(wrapper_path, dir_reference) -> wrapper invocation.   |  none |

**RETURNS**

A struct with:
      prefix: text to place before the command ("" when hermetic).
      cmd: the command that runs the tool.
      tools: what to pass to the action's `tools` argument.


