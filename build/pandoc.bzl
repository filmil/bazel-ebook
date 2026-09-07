load(":attrs.bzl", "ADDITIONAL_INPUTS")
load(":providers.bzl", "EbookInfo", "PandocMetadata", "merge_EbookInfo")
load(":toolchain.bzl", "EBOOK_TOOLCHAIN_TYPE", _ebook_tool = "ebook_tool")

"""
Pandoc metadata rules.

Use to add metadata that would otherwise become additional parameters.
"""

def _pandoc_html(
        ctx,
        format,
        output_artifact,
        output_suffix = "",
        self_contained = False):
    """
    Args:
    - `output_artifact`: this is the "final" output artifact.
    - `output_suffix`: string: name of the output file.
    - `self_contained`: If set, the output artifact is self-contained.
    """
    title = ctx.attr.title
    for meta in ctx.attr.metadata:
        if not title:
            title = meta[PandocMetadata].title

    name = ctx.label.name
    markdowns = []
    figures = []
    for dep in ctx.attr.deps:
        provider = dep[EbookInfo]
        markdowns += provider.markdowns or []
        figures += provider.figures or []
    data_p = merge_EbookInfo([p[EbookInfo] for p in ctx.attr.deps])

    # A filter is either an executable target, passed with --filter, or a
    # plain file: a .lua script goes to --lua-filter, anything else to --filter.
    # An executable is carried as its FilesToRunProvider rather than its bare
    # File, so its runfiles reach the action. Passing only the File dropped
    # them, and dropping the path entirely -- which is what this did before --
    # meant the filter was fetched, built and staged, and then never run.
    filters = []
    filters_paths = []
    lua_filters_paths = []
    filters_tools = []
    for filter in ctx.attr.filters:
        files_to_run = filter[DefaultInfo].files_to_run
        if files_to_run and files_to_run.executable:
            filters_tools += [files_to_run]
            filters_paths += [files_to_run.executable.path]
            continue
        for file in filter.files.to_list():
            filters += [file]
            if file.extension == "lua":
                lua_filters_paths += [file.path]
            else:
                filters_paths += [file.path]

    resource_paths = [file.dirname for file in markdowns + figures]
    dir_reference = markdowns[0]
    output_file = output_artifact
    markdowns_paths = [file.path for file in markdowns]

    _tools = ctx.toolchains[EBOOK_TOOLCHAIN_TYPE].ebook
    pandoc = _ebook_tool(_tools, "pandoc", markdowns_paths[0])

    # I think that run_shell does not support ctx.actions.args().
    # prefix is empty when pandoc runs directly, and enters the container
    # otherwise.
    # A filter may run pandoc itself: pandoc-include does, over each included
    # file, and finds it on PATH. (It also honours PANDOC_BIN, but the panflute
    # call it goes through re-enters convert_text for a panflute-typed input
    # and loses the path on the way, so PATH is what actually works.) That
    # inner pandoc applies the filter again, by name -- pandoc-include's
    # default options are `--filter=pandoc-include` -- so each executable
    # filter's own directory goes on PATH as well. Absolute, because a filter
    # is not run from the action's directory.
    path_dirs = [pandoc.cmd.rsplit("/", 1)[0]]
    for tool in filters_tools:
        directory = tool.executable.dirname
        if directory not in path_dirs:
            path_dirs.append(directory)
    args = [
        'PATH="{}:${{PATH:-}}"'.format(":".join(["$PWD/" + d for d in path_dirs])),
        pandoc.prefix + pandoc.cmd,
    ]
    args += ["--write", format]  # This is unchunked, standalone
    args += ["-o", "{}{}".format(output_file.path, output_suffix)]
    if title:
        # A title with spaces has to survive as one argument, and how many
        # shells it passes through differs by toolchain. Run directly there is
        # one, so single quotes are enough. Through the container wrapper there
        # is a second shell that strips one level, which is why the original
        # form escaped the quotes.
        if pandoc.prefix == "":
            args += ["--metadata", "'title={}'".format(title)]
        else:
            args += ["--metadata", 'title=\\"{}\\"'.format(title)]
    if ctx.attr.toc:
        args += ["--toc"]
    if resource_paths:
        args += ["--resource-path", ":".join(resource_paths)]
    args += ctx.attr.args

    for filter in filters_paths:
        args += ["--filter", "$PWD/{}".format(filter)]
    for filter in lua_filters_paths:
        args += ["--lua-filter", "$PWD/{}".format(filter)]

    args += markdowns_paths

    log_file = ctx.actions.declare_file("{}.log".format(ctx.attr.name))
    args += [" 2>&1 > {log} || ( cat {log} && exit 1 )".format(log = log_file.path)]

    ctx.actions.run_shell(
        progress_message = "Building equation environments for: {}".format(name),
        inputs = markdowns + figures + data_p.additional_inputs + filters,
        outputs = [output_file, log_file],
        tools = pandoc.tools + filters_tools,
        command = " ".join(args),
    )
    runfiles_files = []
    runfiles = None
    if not self_contained:
        runfiles_files = figures + data_p.additional_inputs
        runfiles = ctx.runfiles(files = runfiles_files)
    return [
        DefaultInfo(
            files = depset([output_file, log_file] + runfiles_files),
            runfiles = runfiles,
        ),
    ]

_ATTRS = ADDITIONAL_INPUTS | {
    "deps": attr.label_list(
        doc = "The markdown libraries, used in the order provided.",
        providers = [EbookInfo],
    ),
    "metadata": attr.label_list(
        doc = "Metadata in case it is needed.",
        providers = [PandocMetadata],
        allow_empty = True,
    ),
    "args": attr.string_list(
        doc = "Any additional args to insert",
        allow_empty = True,
    ),
    "toc": attr.bool(
        doc = "If set, generate a table of contents",
    ),
    "title": attr.string(
        doc = "If set, this will be used as the title of the HTML",
    ),
    "filters": attr.label_list(
        doc = "Targets representing filters binaries to use",
        cfg = "host",
    ),
}

def _pandoc_standalone_html(ctx):
    name = ctx.label.name
    return _pandoc_html(
        ctx,
        "html",
        ctx.actions.declare_file("{}.html".format(name)),
    )

pandoc_standalone_html = rule(
    implementation = _pandoc_standalone_html,
    doc = "Create a stand-alone HTML file from the Pandoc markdown",
    attrs = _ATTRS,
    toolchains = [EBOOK_TOOLCHAIN_TYPE],
)

def _pandoc_chunked_html(ctx):
    name = ctx.label.name
    return _pandoc_html(
        ctx,
        "chunkedhtml",
        ctx.actions.declare_directory("{}.d".format(name)),
        output_suffix = "/{}".format(name),
        self_contained = True,
    )

pandoc_chunked_html = rule(
    implementation = _pandoc_chunked_html,
    doc = "Create a chunked HTML file from the Pandoc markdown",
    attrs = _ATTRS,
    toolchains = [EBOOK_TOOLCHAIN_TYPE],
)
