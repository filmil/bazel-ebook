# Build rules for building ebooks.

# This is the container
CONTAINER = "filipfilmar/ebook-buildenv:testing"

EbookInfo = provider(fields=["figures", "markdowns"])

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
    return [
        EbookInfo(figures=figures+deps, markdowns=[]),
        DefaultInfo(files=depset(figures+deps)),
    ]


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


def _markdown_lib_impl(ctx):
    markdowns = []
    for target in ctx.attr.srcs:
        for src in target.files.to_list():
            markdowns += [src]
    figures = []
    for target in ctx.attr.deps:
        provider = target[EbookInfo]
        figures += (provider.figures or [])
        markdowns += (provider.markdowns or [])
    return [
      EbookInfo(figures=figures, markdowns=markdowns),
      DefaultInfo(files=depset(figures+markdowns)),
    ]

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

def _ebook_epub_impl(ctx):
    name = ctx.label.name
    # steps
    # run htex on all *md, gives book.htex
    markdowns = []
    figures = []
    for dep in ctx.attr.deps:
        provider = dep[EbookInfo]
        markdowns += provider.markdowns
        figures += provider.figures
    htex_file = ctx.actions.declare_file("{}.htex".format(name))

    markdowns_paths = [file.path for file in markdowns]

    script = ctx.executable._script
    script_cmd = _script_cmd(script.path, markdowns_paths[0])

    ctx.actions.run_shell(
        progress_message = "Building equation environments for: {}".format(name),
        inputs = markdowns,
        outputs = [htex_file],
        tools = [script],
        command = """\
            {script} \
                pandoc -s --gladtex -o {target} {sources} \
        """.format(script=script_cmd, target=htex_file.path, sources=" ".join(markdowns_paths))
    )

    # run gladtex on the resulting htex to obtain html and output directory with figures.
    outdir = ctx.actions.declare_directory("{}.eqn".format(name))
    html_file = ctx.actions.declare_file("{}.html".format(name))
    ctx.actions.run_shell(
        progress_message = "Extracting equations for: {}".format(name),
        inputs = [htex_file],
        outputs = [outdir, html_file],
        tools = [script],
        command = """\
            {script} \
                gladtex -r 200 -d {outdir} {htex_file} \
        """.format(script=script_cmd, outdir=outdir.path, htex_file=htex_file.path)
    )

    # run htexepub to obtain book.epub.
    # This is gonna be fun!
    epub_metadata = ctx.attr.metadata_xml.files.to_list()[0]
    title_yaml = ctx.attr.title_yaml.files.to_list()[0]
    ebook_epub = ctx.actions.declare_file("{}.epub".format(name))
    inputs = [epub_metadata, title_yaml, html_file] + markdowns + figures

    print("inputs = %s" % inputs)
    ctx.actions.run_shell(
        progress_message = "Building EPUB for: {}".format(name),
        inputs = inputs,
        tools = [script],
        outputs = [ebook_epub],
        command = """\
            {script} \
                pandoc --epub-metadata={epub_metadata} \
                  -f html -t epub3 -o {ebook_epub} {markdowns} \
        """.format(
            script=script_cmd,
            epub_metadata=epub_metadata.path,
            ebook_epub=ebook_epub.path,
            markdowns=" ".join(markdowns_paths),
        ))
    return [DefaultInfo(files=depset([ebook_epub]))]

ebook_epub = rule(
    implementation = _ebook_epub_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "All the targets you need to make this book work.",
            providers = [EbookInfo],
        ),
        "title_yaml": attr.label(
            allow_files = True,
            doc = "The title.yaml file to use for this book",
        ),
        "metadata_xml": attr.label(
            allow_files = True,
            doc = "The epub-metadata.xml file to use for this book",
        ),
        "_script": attr.label(
          default="//build:docker_run",
          executable=True,
          cfg="host"),
    },
    doc = "Generate an ebook in EPUB format"
)

def _ebook_pdf_impl(ctx):
    name = ctx.label.name
    # steps
    # run htex on all *md, gives book.htex
    markdowns = []
    figures = []
    for dep in ctx.attr.deps:
        provider = dep[EbookInfo]
        markdowns += provider.markdowns
        figures += provider.figures
    markdowns_paths = [file.path for file in markdowns]

    script = ctx.executable._script
    script_cmd = _script_cmd(script.path, markdowns_paths[0])

    # run htexepub to obtain book.epub.
    # This is gonna be fun!
    epub_metadata = ctx.attr.metadata_xml.files.to_list()[0]
    title_yaml = ctx.attr.title_yaml.files.to_list()[0]
    ebook_pdf = ctx.actions.declare_file("{}.pdf".format(name))
    inputs = [epub_metadata, title_yaml] + markdowns + figures

    print("\n\n\ninputs: {}\n\n\n".format(inputs))

    ctx.actions.run_shell(
        progress_message = "Building PDF for: {}".format(name),
        inputs = inputs,
        tools = [script],
        outputs = [ebook_pdf],
        command = """\
            {script} \
                pandoc --epub-metadata={epub_metadata} \
                  --mathml -o {ebook_pdf} {markdowns} \
        """.format(
            script=script_cmd,
            epub_metadata=epub_metadata.path,
            ebook_pdf=ebook_pdf.path,
            markdowns=" ".join(markdowns_paths),
        ))
    return [DefaultInfo(files=depset([ebook_pdf]))]

ebook_pdf = rule(
    implementation = _ebook_pdf_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "All the targets you need to make this book work.",
            providers = [EbookInfo],
        ),
        "title_yaml": attr.label(
            allow_files = True,
            doc = "The title.yaml file to use for this book",
        ),
        "metadata_xml": attr.label(
            allow_files = True,
            doc = "The epub-metadata.xml file to use for this book",
        ),
        "_script": attr.label(
          default="//build:docker_run",
          executable=True,
          cfg="host"),
    },
    doc = "Generate an ebook in PDF format"
)
