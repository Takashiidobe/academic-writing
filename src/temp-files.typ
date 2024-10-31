#bibliography("temp-files.bib")

== Temporary Files
<temporary-files>

Temporary files are useful in the case that you want to create a file with the
guarantee that it is a new file and no other process is using it.

Unfortunately there are many ways to create a temporary file, with some are insecure.

tmpfile, tmpnam, tmpnam_r, mktemp are all insecure in various ways, and the recommended
ways are mkstemp and mkdtemp. Files opened with mkstemp are opened with O_EXCL set,
so the file is opened exclusively.

For more info: @tempfiles2024
