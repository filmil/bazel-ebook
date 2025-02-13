# Build rules for building ebooks.

def _new_ebookinfo(figures=[], markdowns=[], additional_inputs=[]):
    return {
        'figures': figures,
        'markdowns': markdowns,
        'additional_inputs': additional_inputs,
    }


EbookInfo, _ebookinfo_init = provider(
    fields={
        "figures": "The figurs targets to use.",
        "markdowns": "The markdown files, in order",
        "additional_inputs": "Additional inputs do not appear in any command lines, but are present in sandboxes at compile time.",
    },
    init = _new_ebookinfo,
)


def merge_EbookInfo(infos):
    figures = []
    markdowns = []
    additional_inputs = []

    for m in infos:
        figures += m.figures
        markdowns += m.markdowns
        additional_inputs += m.additional_inputs

    result =  _ebookinfo_init(
        figures=figures,
        markdowns=markdowns,
        additional_inputs=additional_inputs)

    return result


def _new_pandoc_metadata(name, title=None):
    return {
        'title': title,
    }


PandocMetadata ,_pandoc_metadata_init = provider(
    fields = {
        'title': 'String. Used as title where this is needed',
    },
    init = _new_pandoc_metadata,
)


def pandoc_metadata(title=None):
    return _new_pandoc_metadata(title)

