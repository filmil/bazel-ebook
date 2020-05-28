# Build rules for building ebooks.

# This is the container
CONTAINER = "ebook-buildenv:latest"

EbookInfo = provider(fields=["figures", "foos"])

# Returns the docker_run script invocation command based on the
# script path and its reference directory.
#
# Params:
#   script_path: (string) The full path to the script to invoke
#   dir_reference: (string) The path to a file used for figuring out
#       the reference directories (build root and repo root).
def _script_cmd(script_path, dir_reference):
    return """\
      {script} \
        --container={container} \
        --dir-reference={dir_reference}""".format(
            script=script_path,
            container=CONTAINER,
            dir_reference=dir_reference,
       )


def _asymptote_impl(ctx):
    asycc = ctx.executable._script
    figures = []

    for target in ctx.attr.srcs:
        for src in target.files.to_list():
            in_file = src
            out_file = ctx.actions.declare_file(in_file.path + ".png")
            figures += [out_file]

            script_cmd = _script_cmd(asycc.path, in_file.path)
            ctx.actions.run_shell(
              progress_message = "ASY to PNG: {0}".format(in_file.short_path),
              inputs = [in_file],
              outputs = [out_file],
              tools = [asycc],
              command = """\
                {script} \
                  asy -render 5 -f png -o "{out_file}" "{in_file}"
              """.format(
                  out_file=out_file.path, in_file=in_file.path, script=script_cmd),
            )

    deps = []
    for target in ctx.attr.deps:
        ebook_provider = target[EbookInfo]
        if not ebook_provider:
            continue
        deps += ebook_provider.figures
    return [EbookInfo(figures=figures+deps), DefaultInfo(files=depset(figures+deps))]


asymptote = rule(implementation = _asymptote_impl,
    attrs = {
      "srcs": attr.label_list(
          allow_files = [".asy"],
          doc = "The file to compile",
        ),
      "deps": attr.label_list(
          doc = "The dependencies, any targets should be allowed",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="//build:docker_run",
        executable=True,
        cfg="host"),
    },
    doc = "Transform an asymptote file into png",
)


def _extract_equations_impl(ctx):
    input_files = []
    for target in ctx.attr.srcs:
        input_files += target.files.to_list()
    dir_reference = input_files[0].path
    in_files = " ".join([x.path for x in input_files])
    out_file = ctx.outputs.output
    script = ctx.executable._script
    ctx.actions.run_shell(
      progress_message = "Extracting equations",
      inputs = input_files,
      outputs = [out_file],
      tools = [script],
      command = """\
      INPUTS="{in_files}" \
      DIR_REFERENCE="{dir_reference}" \
      OUTPUT="{out_file}" \
      {script}""".format(
          in_files=in_files,
          out_file=out_file.path,
          script=script.path,
          dir_reference=dir_reference),
    )


extract_equations = rule(implementation = _extract_equations_impl,
    attrs = {
      "srcs": attr.label_list(
        allow_files = True,
        doc = "the source files",
      ),
      "deps": attr.label_list(
        doc = "Other source files",
      ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="//build:extract_equations",
        executable=True,
        cfg="host"),
    },
    doc = "Transform an asymptote file into png",
)


def _htex_impl(ctx):
    input_files = []
    for target in ctx.attr.srcs:
        input_files += target.files.to_list()
    dir_reference = input_files[0].path
    in_files = " ".join([x.path for x in input_files])
    out_file = ctx.outputs.output
    html_file = ctx.outputs.html
    script = ctx.executable._script
    ctx.actions.run_shell(
      progress_message = "Extracting equations",
      inputs = input_files,
      outputs = [out_file, html_file],
      tools = [script],
      command = """\
      INPUTS="{in_files}" \
      DIR_REFERENCE="{dir_reference}" \
      OUTPUT="{out_file}" \
      {script}""".format(
          in_files=in_files,
          out_file=out_file.path,
          script=script.path,
          dir_reference=dir_reference),
    )


htex = rule(implementation = _htex_impl,
    attrs = {
      "srcs": attr.label_list(
        allow_files = True,
        doc = "the source files",
      ),
      "output": attr.output(doc="The generated htex file"),
      "html": attr.output(doc="The generated HTML file"),
      "_script": attr.label(
        default="//build:htex",
        executable=True,
        cfg="host"),
    },
    doc = "Transform an asymptote file into png",
)

def _markdown_lib_impl(ctx):
    return [EbookInfo()]

markdown_lib = rule(
    implementation = _markdown_lib_impl,
    doc = "Declares a set of markdown files",
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".md"],
            doc = "The markdown source files",
        ),
        "deps": attr.label_list(
              doc = "The file to compile",
              providers = [EbookInfo],
        ),
    },
)

#ebook_epub = rule(
    #implementation = None,
    #attrs = {
        ## Could be autogenerated
        ##"metadata": attr.label(
            #allow_files = True,
            #doc = "The epub-metadata.xml file to use for this book",
        #),
        ## Could be autogenerated
        #"title": attr.label(
            #allow_files = True,
            #doc = "The title.yaml file to use for this book",
        #),
        #"deps": attr.label_list(
            #doc = "All the targets you need to make this book work.",
            #providers = [EbookInfo],
        #),
    #},
    #doc = "Generate an ebook in EPUB format"
#)
