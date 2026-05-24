<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="script_cmd"></a>

## script_cmd

<pre>
load("@bazel_ebook//build:script.bzl", "script_cmd")

script_cmd(<a href="#script_cmd-script_path">script_path</a>, <a href="#script_cmd-dir_reference">dir_reference</a>)
</pre>

Creates a script command string adjusting the script path relative to a directory reference.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="script_cmd-script_path"></a>script_path |  The script path.   |  none |
| <a id="script_cmd-dir_reference"></a>dir_reference |  The directory reference path.   |  none |

**RETURNS**

The command string.


