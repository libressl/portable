#
# Copyright (c) 2014 Brent Cook
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

SUBDIRS = include crypto ssl tls apps man
if ENABLE_TESTS
SUBDIRS += tests
endif
ACLOCAL_AMFLAGS = -I m4

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libtls.pc
if !ENABLE_LIBTLS_ONLY
pkgconfig_DATA += libcrypto.pc libssl.pc openssl.pc
endif

EXTRA_DIST = README.md README.mingw.md VERSION config scripts
EXTRA_DIST += CMakeLists.txt cmake_export_symbol.cmake cmake_uninstall.cmake.in FindLibreSSL.cmake LibreSSLConfig.cmake.in
EXTRA_DIST += cert.pem openssl.cnf x509v3.cnf

.PHONY: install_sw
install_sw: install

install-exec-hook:
	@if [ "@OPENSSLDIR@x" != "x" ]; then \
		OPENSSLDIR="$(DESTDIR)@OPENSSLDIR@"; \
	else \
		OPENSSLDIR="$(DESTDIR)$(sysconfdir)/ssl"; \
	fi; \
	mkdir -p "$$OPENSSLDIR/certs"; \
	for i in cert.pem openssl.cnf x509v3.cnf; do \
		if [ ! -f "$$OPENSSLDIR/$i" ]; then \
			$(INSTALL) -m 644 "$(srcdir)/$$i" "$$OPENSSLDIR/$$i"; \
		else \
			echo " $$OPENSSLDIR/$$i already exists, install will not overwrite"; \
		fi \
	done

uninstall-local:
	@if [ "@OPENSSLDIR@x" != "x" ]; then \
		OPENSSLDIR="$(DESTDIR)@OPENSSLDIR@"; \
	else \
		OPENSSLDIR="$(DESTDIR)$(sysconfdir)/ssl"; \
	fi; \
	for i in cert.pem openssl.cnf x509v3.cnf; do \
		if cmp -s "$$OPENSSLDIR/$$i" "$(srcdir)/$$i"; then \
			rm -f "$$OPENSSLDIR/$$i"; \
		fi \
	done
