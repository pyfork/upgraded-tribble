# Changelog

- slug: `bash scripts/slug.sh "<title>"` prints the title as a lowercase ASCII slug (slug slice 1).
- slug: a missing title, more than one argument, or a title with no ASCII letter or digit now prints an error and exits non-zero instead of an empty slug (slug slice 2).
- slug: with `SLUG_CUT=1`, a slug over 20 characters is cut at a word boundary, with a notice on standard error (slug slice 3).
- slug: every slug over 20 characters is now cut at a word boundary, with a notice on standard error; `SLUG_CUT` no longer does anything. When the word cut would keep under 10 characters, the first 20 are kept instead (slug slice 4).
- wordcount: `bash scripts/wordcount.sh "<text>"` prints the number of words in the text as a bare number (wordcount slice 1).
- wordcount: with no argument, `bash scripts/wordcount.sh` counts the words on standard input instead of printing a usage message (wordcount slice 2).
- wordcount: the usage message for more than one argument also shows the piped form, `<command> | bash scripts/wordcount.sh` (wordcount slice 3).
- stamp: `bash scripts/stamp.sh <title> <YYYY-MM-DD>` prints the report header for that day, `(weekend)` on Saturday and Sunday (stamp slice 1).
- greet: `bash scripts/greet-shout.sh <name>` prints the Hello line in capitals (greet slice 2).
- bye: `bash scripts/bye-shout.sh <name>` prints the Bye line in capitals (bye slice 2).
