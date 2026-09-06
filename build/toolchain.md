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

ebook_toolchain(<a href="#ebook_toolchain-name">name</a>, <a href="#ebook_toolchain-tools">tools</a>, <a href="#ebook_toolchain-wrapper">wrapper</a>)
</pre>

Declares how the ebook rules reach the programs they need.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="ebook_toolchain-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="ebook_toolchain-tools"></a>tools |  Maps each name in EBOOK_TOOLS to the command that runs it.   | <a href="https://bazel.build/rules/lib/core/dict">Dictionary: String -> String</a> | required |  |
| <a id="ebook_toolchain-wrapper"></a>wrapper |  Executable each tool invocation is routed through, if any.   | <a href="https://bazel.build/concepts/labels">Label</a> | optional |  `None`  |


<a id="EbookToolchainInfo"></a>

## EbookToolchainInfo

<pre>
load("@bazel_ebook//build:toolchain.bzl", "EbookToolchainInfo")

EbookToolchainInfo(<a href="#EbookToolchainInfo-tools">tools</a>, <a href="#EbookToolchainInfo-wrapper">wrapper</a>)
</pre>

The external programs used by the ebook rules.

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="EbookToolchainInfo-tools"></a>tools |  dict: logical tool name (see EBOOK_TOOLS) -> the command used to invoke it. For a container-based toolchain these are bare names resolved on the container PATH; for a hermetic toolchain they are paths to Bazel-provided binaries.    |
| <a id="EbookToolchainInfo-wrapper"></a>wrapper |  FilesToRunProvider: an executable that every tool invocation is routed through, or None when the tools are invoked directly. Carrying the whole provider (rather than just the File) keeps the wrapper's runfiles attached when it is passed to an action's `tools`.    |


