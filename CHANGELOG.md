# Changelog

- slug: `bash scripts/slug.sh "<title>"` prints the title as a lowercase ASCII slug (slug slice 1).
- slug: a missing title, more than one argument, or a title with no ASCII letter or digit now prints an error and exits non-zero instead of an empty slug (slug slice 2).
- slug: with `SLUG_CUT=1`, a slug over 20 characters is cut at a word boundary, with a notice on standard error (slug slice 3).
