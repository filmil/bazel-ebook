def _impl(ctx):
    in_file = ctx.file.input
    out_file = ctx.outputs.output
    asycc = ctx.executable._script
    ctx.actions.run_shell(
      inputs = [in_file],
      outputs = [out_file],
      tools = [asycc],
      command = """\
      INPUT={in_file} \
      OUTPUT={out_file} \
      {script}""".format(
          out_file=out_file.path, in_file=in_file.path, script=asycc.path),
    )

asy_to_png = rule(implementation = _impl,
    attrs = {
      "input": attr.label(
          allow_single_file = True,
          mandatory = True,
          doc = "The file to compile",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(default="//:asy_to_png", executable=True, cfg="host"),
    },
    doc = "Transform an asymptote file into png",
)

