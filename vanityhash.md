% VANITYHASH(1) | vanityhash
% Ryan Finnie
# NAME

vanityhash - A hex hash fragment creation tool

# SYNOPSIS

vanityhash [*options*] hexfragment < inputfile

vanityhash *--append* [*options*] hexfragment < inputfile > outputfile

# DESCRIPTION

`vanityhash` is a tool that can discover data to be added to the end of a file to produce a desired hex hash fragment.
It searches a message space and runs a hashing algorithm against the original data plus the appended data to determine if the desired hash fragment is present.
vanityhash can run multiple parallel workers to effectively make use of multiple processors/cores/threads, and supports multiple hash digest types (MD5, SHA1, SHA256, etc).

vanityhash can be used to append data to files that are capable of ignoring garbage data at the end of the file (such as ISO images and some types of graphic images), in order to produce a "vanity" hash.
vanityhash is fast, as it only reads the base input data once, and then reverts back to that base state over and over while it permeates the search space, rather than hashing the entire source during each permeation.

vanityhash operates on the concept of a "search space".
For example, given a 24-bit search space, vanityhash will run from 0x00000000 to 0x00ffffff, append the 4-byte packed version of each number to the end of the input data, calculate the resulting hash, and search the hash value for the desired hex fragment pattern.
A desired hex fragment can be larger than the search space (for example, searching for "abcdef" in a 16-bit search space), but the chances of finding a match reduce drastically the larger the desired hex fragment is.

In its default operation, vanityhash will search the entire specified search space and output all matching results to STDOUT, one result per line, in the form "extradata hash", where both "extradata" and "hash" are in hex form.
When the *--append* option is specified, this behavior changes.
If a match is found, the original input data plus the extra data (in byte form) are outputted, and searching ends after the first successful match.
If no matches are found, the original data only is outputted.

# OPTIONS

-b *bits*, --bits=*bits*
:   Space to be searched, in bits.  Allowed values range from 1 to 64.  
    Default is 32.
    Search spaces larger than the host operating system's native (i.e. 64 on a 32-bit operating system) will incur a performance penalty.

-t *bits*, --bits-pack=*bits*
:   By default, the size used to contain the search space is computed automatically.
    For example, a 24-bit search space requires a 32-bit (4-byte) pack.
    If you would like to use a larger pack size, this can be specified.
    For example, to search a 24-bit space by appending 8 bytes, use "--bits=24 --bits-pack=64".
    Must be 8, 16, 32, or 64, and must be equal to or larger than --bits.

-p *position*, --position=*position*
:   The position within the hex hash to look for the desired fragment, in hex digits.
    The beginning starts at 0.
    Default is 0.
    Negative numbers extend backward from the end of the hash.

-y, --any-position
:   When enabled, this option will override --position and will return hashes that contain the desired fragment in any position within the hash.

-n, --byte-order=*order*
:   Used to set the byte order (endianness) of the space being searched.
    Values are "native", "little" or "big".
    Default is "native".
    Use this when spreading workers over multiple machines whose architectures differ in endianness (but this incurs a performance penalty).

-s *seconds*, --progress=*seconds*
:   The number of seconds between printing of progress lines, default 5 seconds.
    A decimal value may be specified.
    A value of 0 disabled printing progress lines.

-w *workers*, --workers=*workers*
:   The number of workers to be spawned.
    Default is the number of logical processors if this can be determined, otherwise 1.
    Recommended value is the number of logical processors on the running system.

    This option can also be used to specify a "worker space", and then specify which workers within that space to actually launch.
    This way the work can be split up among multiple vanityhash invocations on different systems.
    For example:

        host1$ vanityhash -w 8:1,3,5,7 < inputfile
        host2$ vanityhash -w 8:2,4,6,8 < inputfile

    This sets a worker space of 8 workers, but only launches workers 1, 3, 5 and 7 on host1, and 2, 4, 6 and 8 on host2.
    To do this, the input data must be on all hosts, and ideally the vanityhash version should be the same as well.

--deadline=*seconds*
:   The maximum number of seconds to run workers before finishing.

--list-digests
:   Print a list of available digests and exit.

-d *digesttype*, --digest=*digesttype*
:   The hashing digest type to use.  Default is "md5".
    Digests available depend on the OpenSSL compiled against Python.

-a, --append
:   When enabled, the original data is outputted back to STDOUT.
    Then, when/if the first matching hash is found, the data fragment used to produce the matching hash is outputted to STDOUT.
    STDOUT can then be redirected to another file to produce the modified file.

-e, --append-empty
:   When using --append, if a match is not found, add empty (zeroed) pack bytes anyway.
    This way, the STDOUT data will always be the same byte length no matter if a match is found or not.

-q, --quiet
:   Normally vanityhash sends a fair amount of status information to STDERR during operation.
    When enabled, all non-error status information is instead suppressed.

--debug
:   Print extra debugging information.

-h, --help
:   Print a synposis and exit.

# BUGS / LIMITATIONS

vanityhash should work on any POSIX operating system, and has been tested on Linux and Mac OS X.
It currently does not work on Windows, due to Python multiprocessing limitations.

# CREDITS

`vanityhash` was written by Ryan Finnie <ryan@finnie.org>.
vanityhash was inspired by Seth David Schoen's 2003 program, hash_search.
