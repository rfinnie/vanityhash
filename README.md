# vanityhash

http://www.finnie.org/software/vanityhash/

vanityhash is a tool that can discover data to be added to the end of a file to produce a desired hex hash fragment.
It searches a message space and runs a hashing algorithm against the original data plus the appended data to determine if the desired hash fragment is present.
vanityhash can run multiple parallel workers to effectively make use of multiple processors/cores/threads, and supports multiple hash digest types (MD5, SHA1, SHA256, etc).

## Installation

vanityhash requires Python 3.4 or newer, and no non-core Python moudules (though it will use several if present, see below).

Digest support depends on the OpenSSL features used to compile hashlib.
Run `vanityhash --list-digests` to get a list of usable digests.
The following may be available:

 * OpenSSL-provided (md5, sha1, sha256, etc)
 * xxHash, if the xxhash module is installed (xxh32, xxh64)
 * Additional digests (null, random, crc32, adler32, bsd, udp, 2ping) with the [hashlib_additional](https://pypi.org/project/hashlib-additional/) module

To "build" and install vanityhash:

```shell
make
make install
make clean
```

/usr/local is the default Makefile prefix, use PREFIX to override.

## Usage

Please see the man page for full details.

```shell
vanityhash [options] hexfragment < inputfile

vanityhash --append [options] hexfragment < inputfile > outputfile
```

## License

This document is provided under the following license:

    SPDX-PackageName: vanityhash
    SPDX-PackageSupplier: Ryan Finnie <ryan@finnie.org>
    SPDX-PackageDownloadLocation: https://forge.colobox.com/rfinnie/vanityhash
    SPDX-FileCopyrightText: © 2010 Ryan Finnie <ryan@finnie.org>
    SPDX-License-Identifier: CC-BY-SA-4.0
