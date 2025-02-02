# Build rules for building ebooks.

EbookInfo = provider(fields=["figures", "markdowns"])


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
