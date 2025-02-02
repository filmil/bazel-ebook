# Copyright (C) 2020 Google Inc.
#
# This file has been licensed under Apache 2.0 license.  Please see the LICENSE
# file at the root of the repository.

load("@bazel_skylib//lib:paths.bzl", "paths")
load(":script.bzl", _script_cmd = "script_cmd")
load(":pandoc.bzl",
    _pandoc_standalone_html = "pandoc_standalone_html",
    _pandoc_chunked_html = "pandoc_chunked_html",
)
load(":providers.bzl", "EbookInfo")

pandoc_standalone_html = _pandoc_standalone_html
pandoc_chunked_html = _pandoc_chunked_html


def _plantuml_png_impl(ctx):
    cmd = "plantuml"
    docker_run = ctx.executable._script
    figures = []

    for target in ctx.attr.srcs:
        for src in target.files.to_list():
            in_file = src
            out_file = ctx.actions.declare_file(
                paths.replace_extension(in_file.basename, ".png"))
            figures += [out_file]

            #print("out file dirname: {}".format(out_file.dirname))
            #print(in_file.path)
            #print(out_file.path)
            script_cmd = _script_cmd(docker_run.path, in_file.path)
            ctx.actions.run_shell(
              progress_message = "plantuml diagram to PNG with {1}: {0}".format(in_file.short_path, cmd),
              inputs = [in_file],
              outputs = [out_file],
              tools = [docker_run],
              command = """\
                {script} \
                  {cmd} -Djava.awt.headless=true -o "$(realpath {out_dir})" "{in_file}"
              """.format(
                  cmd=cmd,
                  out_dir=out_file.dirname,
                  in_file=in_file.path,
                  script=script_cmd),
            )

    deps = []
    for target in ctx.attr.deps:
        ebook_provider = target[EbookInfo]
        if not ebook_provider:
            continue
        deps += ebook_provider.figures

    runfiles = ctx.runfiles(files = figures)
    return [
        EbookInfo(figures=figures+deps, markdowns=[]),
        DefaultInfo(files=depset(figures+deps), runfiles=runfiles),
    ]


plantuml_png = rule(implementation = _plantuml_png_impl,
    attrs = {
      "srcs": attr.label_list(
          allow_files = [".txt"],
          doc = "The file to compile",
        ),
      "deps": attr.label_list(
          doc = "The dependencies, any targets should be allowed",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="@bazel_rules_bid//build:docker_run",
        executable=True,
        cfg="host"),
    },
    doc = "Transform a timing diagram file into png using plantuml",
)


def _drawtiming_png_impl(ctx):
    cmd = "drawtiming"
    docker_run = ctx.executable._script
    figures = []

    for target in ctx.attr.srcs:
        for src in target.files.to_list():
            in_file = src
            out_file = ctx.actions.declare_file(in_file.basename + ".png")
            figures += [out_file]

            script_cmd = _script_cmd(docker_run.path, in_file.path)
            ctx.actions.run_shell(
              progress_message = "timing diagram to PNG with {1}: {0}".format(in_file.short_path, cmd),
              inputs = [in_file],
              outputs = [out_file],
              tools = [docker_run],
              command = """\
                {script} \
                  {cmd} --output "{out_file}" "{in_file}"
              """.format(
                  cmd=cmd,
                  out_file=out_file.path,
                  in_file=in_file.path,
                  script=script_cmd),
            )

    deps = []
    for target in ctx.attr.deps:
        ebook_provider = target[EbookInfo]
        if not ebook_provider:
            continue
        deps += ebook_provider.figures

    runfiles = ctx.runfiles(files = figures)
    return [
        EbookInfo(figures=figures+deps, markdowns=[]),
        DefaultInfo(files=depset(figures+deps), runfiles=runfiles),
    ]



drawtiming_png = rule(implementation = _drawtiming_png_impl,
    attrs = {
      "srcs": attr.label_list(
          allow_files = [".t"],
          doc = "The file to compile",
        ),
      "deps": attr.label_list(
          doc = "The dependencies, any targets should be allowed",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="@bazel_rules_bid//build:docker_run",
        executable=True,
        cfg="host"),
    },
    doc = "Transform a timing diagram file into png using drawtiming",
)


def _generalized_graphviz_rule_impl(ctx, cmd):
    docker_run = ctx.executable._script
    figures = []

    for target in ctx.attr.srcs:
        for src in target.files.to_list():
            in_file = src
            out_file = ctx.actions.declare_file(in_file.basename + ".png")
            figures += [out_file]

            script_cmd = _script_cmd(docker_run.path, in_file.path)
            ctx.actions.run_shell(
              progress_message = "graphviz to PNG with {1}: {0}".format(in_file.short_path, cmd),
              inputs = [in_file],
              outputs = [out_file],
              tools = [docker_run],
              command = """\
                {script} \
                  {cmd} -Tpng -o "{out_file}" "{in_file}"
              """.format(
                  cmd=cmd,
                  out_file=out_file.path,
                  in_file=in_file.path,
                  script=script_cmd),
            )

    deps = []
    for target in ctx.attr.deps:
        ebook_provider = target[EbookInfo]
        if not ebook_provider:
            continue
        deps += ebook_provider.figures

    runfiles = ctx.runfiles(files = figures)
    return [
        EbookInfo(figures=figures+deps, markdowns=[]),
        DefaultInfo(files=depset(figures+deps), runfiles=runfiles),
    ]



def _neato_png_impl(ctx):
    return _generalized_graphviz_rule_impl(ctx, "neato")


neato_png = rule(implementation = _neato_png_impl,
    attrs = {
      "srcs": attr.label_list(
          allow_files = [".dot"],
          doc = "The file to compile",
        ),
      "deps": attr.label_list(
          doc = "The dependencies, any targets should be allowed",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="@bazel_rules_bid//build:docker_run",
        executable=True,
        cfg="host"),
    },
    doc = "Transform a graphviz dot file into png using neato",
)


def _dot_png_impl(ctx):
    return _generalized_graphviz_rule_impl(ctx, "dot")


dot_png = rule(implementation = _dot_png_impl,
    attrs = {
      "srcs": attr.label_list(
          allow_files = [".dot"],
          doc = "The file to compile",
        ),
      "deps": attr.label_list(
          doc = "The dependencies, any targets should be allowed",
        ),
      "output": attr.output(doc="The generated file"),
      "_script": attr.label(
        default="@bazel_rules_bid//build:docker_run",
        executable=True,
        cfg="host"),
    },
    doc = "Transform a graphviz dot file into png using dot",
)


def _asymptote_impl(ctx):
    asycc = ctx.executable._script
    figures = []

    for target in ctx.attr.srcs:
        for src in target.files.to_list():
            in_file = src
            out_file = ctx.actions.declare_file(in_file.basename + ".png")
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
              out_file=out_file.path[:-4], in_file=in_file.path, script=script_cmd),
            )

    deps = []
    for target in ctx.attr.deps:
        ebook_provider = target[EbookInfo]
        if not ebook_provider:
            continue
        deps += ebook_provider.figures

    runfiles = ctx.runfiles(files=figures+deps)
    for dep in ctx.attr.deps:
        runfiles = runfiles.merge(dep[DefaultInfo].data_runfiles)

    return [
        EbookInfo(figures=figures+deps, markdowns=[]),
        DefaultInfo(files=depset(figures+deps), runfiles=runfiles),
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
        default="@bazel_rules_bid//build:docker_run",
        executable=True,
        cfg="host"),
    },
    doc = "Transform an asymptote file into png",
)


def _copy_file_to_workdir_renamed(ctx, src):
    src_copy = ctx.actions.declare_file("{}_{}".format(ctx.label.name, src.short_path))
    ctx.actions.run_shell(
        progress_message = "Copying {} to {}".format(src.short_path, src_copy.short_path),
        outputs = [src_copy],
        inputs = [src],
        command="cp {} {}".format(src.path, src_copy.path),
    )
    return src_copy


def _copy_file_to_workdir(ctx, src):
    src_copy = ctx.actions.declare_file(src.basename)
    ctx.actions.run_shell(
        progress_message = "Copying {}".format(src.short_path),
        outputs = [src_copy],
        inputs = [src],
        command="cp {} {}".format(src.path, src_copy.path),
    )
    return src_copy


def _markdown_lib_impl(ctx):
    markdowns = []
    figures = []
    for target in ctx.attr.srcs:
        if EbookInfo in target:
            provider = target[EbookInfo]
            figures += (provider.figures or [])
            markdowns += (provider.markdowns or [])
        else:
            for src in target.files.to_list():
                markdowns += [_copy_file_to_workdir(ctx, src)]
    for target in ctx.attr.deps:
        provider = target[EbookInfo]
        figures += (provider.figures or [])
        markdowns += (provider.markdowns or [])

    runfiles = ctx.runfiles(files=figures+markdowns)
    for dep in ctx.attr.deps:
        runfiles = runfiles.merge(dep[DefaultInfo].data_runfiles)

    return [
      EbookInfo(figures=figures, markdowns=markdowns),
      DefaultInfo(
        files=depset(figures+markdowns),
        runfiles=runfiles,
      ),
    ]


markdown_lib = rule(
    implementation = _markdown_lib_impl,
    doc = "Declares a set of markdown files",
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".md"],
            providers = [EbookInfo],
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
    # This is duplicated in _ebook_pdf_impl.
    # steps
    # run htex on all *md, gives book.htex
    markdowns = []
    figures = []
    for dep in ctx.attr.deps:
        provider = dep[EbookInfo]
        markdowns += provider.markdowns
        figures += provider.figures
    dir_reference = markdowns[0]
    htex_file = ctx.actions.declare_file("{}.htex".format(name))

    markdowns_paths = [file.path for file in markdowns]
    markdowns_paths_stripped =  _strip_reference_dir_from_files(dir_reference, markdowns)

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
        """.format(
            script=script_cmd,
            target=htex_file.path,
            sources=" ".join(markdowns_paths))
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
            {script} --cd-to-dir-reference \
                env LC_ALL=en_US gladtex -f 12 -d {outdir} {htex_file} \
        """.format(
            script=script_cmd,
            outdir=_strip_reference_dir(dir_reference, outdir.path),
            htex_file=_strip_reference_dir(dir_reference, htex_file.path),
        )
    )
    outdir_tar = ctx.actions.declare_file("{}.tar".format(outdir.basename))
    tar_command = "(cd {base} ; tar cf {archive} {dir})".format(
        base=outdir_tar.dirname,
        archive=outdir_tar.basename,
        dir=outdir.basename)
    ctx.actions.run_shell(
        progress_message = "Archiving equations: {}".format(outdir_tar.short_path),
        inputs = [outdir],
        outputs = [outdir_tar],
        command = tar_command,
    )

    # run htexepub to obtain book.epub.
    # This is gonna be fun!
    epub_metadata = ctx.attr.metadata_xml.files.to_list()[0]
    epub_metadata = _copy_file_to_workdir_renamed(ctx, epub_metadata)
    title_yaml = ctx.attr.title_yaml.files.to_list()[0]
    title_yaml = _copy_file_to_workdir_renamed(ctx, epub_metadata)
    ebook_epub = ctx.actions.declare_file("{}.epub".format(name))
    inputs = [epub_metadata, title_yaml, html_file, outdir, outdir_tar] + markdowns + figures

    ctx.actions.run_shell(
        progress_message = "Building EPUB for: {}".format(name),
        inputs = inputs,
        tools = [script],
        outputs = [ebook_epub],
        command = """\
            {script} --cd-to-dir-reference \
                pandoc --epub-metadata={epub_metadata} \
                  -f html -t epub3 -o {ebook_epub} {html_file} \
        """.format(
            script=script_cmd,
            epub_metadata=_strip_reference_dir(dir_reference, epub_metadata.path),
            ebook_epub=_strip_reference_dir(dir_reference, ebook_epub.path),
            html_file=_strip_reference_dir(dir_reference, html_file.path),
        ))
    runfiles = ctx.runfiles(files=[ebook_epub])
    for dep in ctx.attr.deps:
        runfiles = runfiles.merge(dep[DefaultInfo].data_runfiles)
    return [
        dep[EbookInfo],
        DefaultInfo(
            files=depset([ebook_epub, outdir, outdir_tar]),
            runfiles=runfiles,
        )
    ]


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
          default="@bazel_rules_bid//build:docker_run",
          executable=True,
          cfg="host"),
    },
    doc = "Generate an ebook in EPUB format"
)


def _strip_reference_dir(reference_dir, path):
    return path.replace(reference_dir.dirname+"/", "")


def _strip_reference_dir_from_files(reference_dir, files):
    return [ _strip_reference_dir(reference_dir, file.path) for file in files]


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
    dir_reference = markdowns[0]

    # Fixed up paths -- relative to the directory dir_reference, not the
    # directory where the build happens!  This is needed because we can not control
    # figure inclusion.
    markdowns_paths = _strip_reference_dir_from_files(dir_reference, markdowns)

    script = ctx.executable._script
    script_cmd = _script_cmd(script.path, dir_reference.path)

    # run htexepub to obtain book.epub.
    # This is gonna be fun!
    epub_metadata = ctx.attr.metadata_xml.files.to_list()[0]
    epub_metadata = _copy_file_to_workdir(ctx, epub_metadata)
    title_yaml = ctx.attr.title_yaml.files.to_list()[0]
    title_yaml = _copy_file_to_workdir(ctx, title_yaml)

    ebook_pdf = ctx.actions.declare_file("{}.pdf".format(name))
    inputs = [epub_metadata, title_yaml] + markdowns + figures

    ctx.actions.run_shell(
        progress_message = "Building PDF for: {}".format(name),
        inputs = inputs,
        tools = [script],
        outputs = [ebook_pdf],
        command = """\
            {script} --cd-to-dir-reference \
                pandoc --epub-metadata={epub_metadata} \
                  --mathml -o {ebook_pdf} {markdowns} \
        """.format(
            script=script_cmd,
            epub_metadata=_strip_reference_dir(dir_reference, epub_metadata.path),
            ebook_pdf=_strip_reference_dir(dir_reference, ebook_pdf.path),
            markdowns=" ".join(markdowns_paths),
        ))
    runfiles = ctx.runfiles(files=[ebook_pdf])
    for dep in ctx.attr.deps:
        runfiles = runfiles.merge(dep[DefaultInfo].data_runfiles)
    return [
        DefaultInfo(
            files=depset([ebook_pdf]),
            runfiles=runfiles,
        )
    ]


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
          default="@bazel_rules_bid//build:docker_run",
          executable=True,
          cfg="host"),
    },
    doc = "Generate an ebook in PDF format"
)


def _ebook_kindle_impl(ctx):
    mobi_file = ctx.actions.declare_file("{}.mobi".format(ctx.label.name))
    # First provider is EbookInfo, second is DefaultInfo.
    (ebook_info, default_info) = _ebook_epub_impl(ctx)
    # There can be only one such file
    outputs = default_info.files.to_list()
    epub_file = outputs[0]
    equation_outdir = outputs[1]
    equation_outdir_tar = outputs[2]
    captured_output = ctx.actions.declare_file(
        "{}.untar-out".format(ctx.label.name))

    # untar the equation dir
    # Maybe this is not needed.
    tar_command = "(cd {base} ; tar xvf {archive}) > {output}".format(
        base=equation_outdir_tar.dirname,
        archive=equation_outdir_tar.basename,
        output=captured_output.path)
    ctx.actions.run_shell(
        progress_message = "Unarchiving equations: {}".format(equation_outdir_tar.short_path),
        inputs = [equation_outdir_tar],
        outputs = [captured_output],
        command = tar_command,
    )

    dir_reference = epub_file

    script = ctx.executable._script
    name = ctx.label.name
    script_cmd = _script_cmd(script.path, epub_file.path)
    ctx.actions.run_shell(
        progress_message = "Building MOBI for: {}".format(name),
        inputs = [epub_file, equation_outdir],
        tools = [script],
        outputs = [mobi_file],
        command = """\
            {script} --cd-to-dir-reference \
                ebook-convert {epub_file} {mobi_file} \
        """.format(
            script=script_cmd,
            epub_file=_strip_reference_dir(dir_reference, epub_file.path),
            mobi_file=_strip_reference_dir(dir_reference, mobi_file.path),
        ))
    runfiles = ctx.runfiles(files=[mobi_file])
    for dep in ctx.attr.deps:
        runfiles = runfiles.merge(dep[DefaultInfo].data_runfiles)
    return [
        DefaultInfo(
            files=depset([mobi_file, captured_output]),
            runfiles=runfiles,
        )
    ]


ebook_kindle = rule(
    implementation = _ebook_kindle_impl,
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
          default="@bazel_rules_bid//build:docker_run",
          executable=True,
          cfg="host"),
    },
    doc = "Generate an ebook in the Kindle's MOBI format"
)

