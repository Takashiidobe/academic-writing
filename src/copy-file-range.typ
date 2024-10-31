#bibliography("copy-file-range.bib")

== Copy File Range
<copy-file-range>

There are times that you may want to copy a file from one location to another.
If you use the normal posix functions (open/read/write/close), you'll have to
copy data from the kernel to user space and then back to the kernel.

*copy_file_range* allows you to copy a section of one file to another without having to
do the kernel to userspace dance:

```c
ssize_t copy_file_range(int fd_in, off_t *_Nullable off_in,
                        int fd_out, off_t *_Nullable off_out,
                        size_t len, unsigned int flags);
```

@copyfilerange2024 for more details.
