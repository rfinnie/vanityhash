PREFIX := /usr/local

all: vanityhash

# Docs are shipped pre-compiled
doc: vanityhash.1 vanityhash.1.html

vanityhash.1: vanityhash.pod
	pod2man -c '' -r '' -s 1 $< >$@

vanityhash.1.html: vanityhash.pod
	pod2html $< >$@
	rm -f pod2htmd.tmp pod2htmi.tmp

install: all
	install -d -m 0755 $(DESTDIR)$(PREFIX)/bin
	install -d -m 0755 $(DESTDIR)$(PREFIX)/share/man/man1
	install -m 0755 vanityhash $(DESTDIR)$(PREFIX)/bin
	install -m 0644 vanityhash.1 $(DESTDIR)$(PREFIX)/share/man/man1

distclean: clean

clean:

doc-clean:
	rm -f vanityhash.1 vanityhash.1.html
