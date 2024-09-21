# Idempotent per-user configuration management
Contained here is a project whose structure facilitates cross-platform
configuration management with no dependencies outside the bare minimum
set of programs available on the unix-like operating systems I use.

Instead of sticking to the annoyingly restrictive POSIX shell, scripts
here make use of extensions common to GNU `bash` and OpenBSD's `ksh`.

The top-level `Makefile` works non-recursively by using `.include`
directives.  While the makefiles have that going for them, they're
generally less clear than they would have been if I were targeting GNU
Make exclusively; GNU Make offers features like `VPATH` searching and
built-in string manipulation functions that I'd otherwise have used
extensively here.  In order to use this as the first program I run on
a fresh OpenBSD installation, however, I have to use their `make`
implementation.  To be fair, OpenBSD's `make` is thoroughly correct in
its behavior, and it offers several features I haven't made use of, so
some of that is on me.
