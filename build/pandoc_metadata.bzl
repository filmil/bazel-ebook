load(":script.bzl", _script_cmd = "script_cmd")

"""
Pandoc metadata rules.

Use to add metadata that would otherwise become additional parameters.
"""

PandocMetadata = provider(
    fields = {
        'title': 'String. Used as title where this is needed',
    },
)

