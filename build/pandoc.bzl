load(":script.bzl", _script_cmd = "script_cmd")
load(":providers.bzl", "EbookInfo", "PandocMetadata", "merge_EbookInfo")
load(":attrs.bzl", "ADDITIONAL_INPUTS")

"""
Pandoc metadata rules.

Use to add metadata that would otherwise become additional parameters.
"""

def _pandoc_html(ctx, format,
    output_artifact, output_suffix='', self_contained=False):
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

    filters = []
    filters_paths = []
    lua_filters = []
    lua_filters_paths = []
    for filter in ctx.attr.filters:
        filter_files = filter.files.to_list()
        for file in filter_files:
            filters += [file]
            if file.extension == 'lua':
                lua_filters_paths += [file.path]
            else:
                filters_paths += [file.path]

    resource_paths = [file.dirname for file in markdowns + figures]
    dir_reference = markdowns[0]
    output_file = output_artifact
    markdowns_paths = [file.path for file in markdowns]

    script = ctx.executable._script
    script_cmd = _script_cmd(script.path, markdowns_paths[0])

    # I think that run_shell does not support ctx.actions.args().
    args = [script_cmd, '--', 'pandoc']
    args += ['--write', format] # This is unchunked, standalone
    args += ['-o', '{}{}'.format(output_file.path, output_suffix)]
    if title:
        args += ['--metadata', 'title=\\"{}\\"'.format(title)]
    if ctx.attr.toc:
        args += ['--toc']
    if resource_paths:
        args += ['--resource-path', ":".join(resource_paths)]
    args += ctx.attr.args

    for filter in filters_paths:
        args += ['--filter', "$PWD/{}".format(filter)]
    for filter in lua_filters_paths:
        args += ['--lua-filter', "$PWD/{}".format(filter)]


    args += markdowns_paths

    log_file = ctx.actions.declare_file("{}.log".format(ctx.attr.name))
    args += [" 2>&1 > {log} || ( cat {log} && exit 1 )".format(log=log_file.path)]

    ctx.actions.run_shell(
        progress_message = 'Building equation environments for: {}'.format(name),
        inputs = markdowns + figures + data_p.additional_inputs + filters,
        outputs = [output_file, log_file],
        tools = [script] + filters,
        command = ' '.join(args),
    )
    runfiles_files = []
    runfiles = None
    if not self_contained:
        runfiles_files = figures + data_p.additional_inputs
        runfiles = ctx.runfiles(files=runfiles_files)
    return [
        DefaultInfo(
            files=depset([output_file, log_file] + runfiles_files),
        runfiles=runfiles),
    ]

_ATTRS = ADDITIONAL_INPUTS | {
    'deps': attr.label_list(
        doc = 'The markdown libraries, used in the order provided.',
        providers = [EbookInfo],
    ),
    'metadata': attr.label_list(
        doc = 'Metadata in case it is needed.',
        providers = [PandocMetadata],
        allow_empty = True,
    ),
    'args': attr.string_list(
        doc = 'Any additional args to insert',
        allow_empty = True,
    ),
    'toc': attr.bool(
        doc = 'If set, generate a table of contents',
    ),
    'title': attr.string(
        doc = 'If set, this will be used as the title of the HTML',
    ),
    "_script": attr.label(
        default="@bazel_rules_bid//build:docker_run",
        executable=True,
        cfg="host",
    ),
    "filters": attr.label_list(
        doc = 'Targets representing filters binaries to use',
        cfg="host",
    ),
}


def _pandoc_standalone_html(ctx):
    name = ctx.label.name
    return _pandoc_html(ctx, 'html',
        ctx.actions.declare_file('{}.html'.format(name)))


pandoc_standalone_html = rule(
    implementation = _pandoc_standalone_html,
    doc = "Create a stand-alone HTML file from the Pandoc markdown",
    attrs = _ATTRS,
)

def _pandoc_chunked_html(ctx):
    name = ctx.label.name
    return _pandoc_html(ctx, 'chunkedhtml',
        ctx.actions.declare_directory('{}.d'.format(name)),
        output_suffix = '/{}'.format(name),
        self_contained = True,
    )


pandoc_chunked_html = rule(
    implementation = _pandoc_chunked_html,
    doc = "Create a chunked HTML file from the Pandoc markdown",
    attrs = _ATTRS,
)

