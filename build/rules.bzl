# Build rules for building ebooks.

def _asy_to_png_impl(ctx):
    in_file = ctx.file.input
    out_file = ctx.outputs.output
    asycc = ctx.executable._script
    ctx.actions.run_shell(
      progress_message = "ASY to PNG: {0}".format(in_file.short_path),
      inputs = [in_file],
      outputs = [out_file],
      tools = [asycc],
      command = """\
      INPUT={in_file} \
      OUTPUT={out_file} \
      {script}""".format(
          out_file=out_file.path, in_file=in_file.path, script=asycc.path),
    )


asy_to_png = rule(implementation = _asy_to_png_impl,
    attrs = {
      "input": attr.label(
          allow_single_file = True,
          mandatory = True,
          doc = "The file to compile",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="//build:asy_to_png",
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


