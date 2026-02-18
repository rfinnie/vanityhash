# SPDX-PackageName: vanityhash
# SPDX-PackageSupplier: Ryan Finnie <ryan@finnie.org>
# SPDX-PackageDownloadLocation: https://github.com/rfinnie/vanityhash
# SPDX-FileCopyrightText: © 2010 Ryan Finnie <ryan@finnie.org>
# SPDX-License-Identifier: MPL-2.0

PREFIX := /usr/local

all: vanityhash

doc: vanityhash.1

%.1: %.md
	pandoc -s -t man -o $@ $<

install: all
	install -d -m 0755 $(DESTDIR)$(PREFIX)/bin
	install -d -m 0755 $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0755 vanityhash $(DESTDIR)$(PREFIX)/bin
	install -m 0644 vanityhash.1 $(DESTDIR)$(PREFIX)/share/man/man1

distclean: clean

clean:

doc-clean:
	rm -f vanityhash.1
