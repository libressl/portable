#
# Copyright (c) 2017 Brent Cook
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

include $(top_srcdir)/Makefile.am.common

-include $(abs_top_builddir)/crypto/libcrypto_la_objects.mk
-include $(abs_top_builddir)/ssl/libssl_la_objects.mk
-include $(abs_top_builddir)/tls/libtls_la_objects.mk

if !ENABLE_LIBTLS_ONLY
bin_PROGRAMS = ocspcheck
dist_man_MANS = ocspcheck.8
else
noinst_PROGRAMS = ocspcheck
endif

EXTRA_DIST = ocspcheck.8
EXTRA_DIST += CMakeLists.txt

ocspcheck_LDADD = $(libcrypto_la_objects)
ocspcheck_LDADD += $(libcompat_la_objects)
ocspcheck_LDADD += $(libcompatnoopt_la_objects)
ocspcheck_LDADD += $(libssl_la_objects)
ocspcheck_LDADD += $(libtls_la_objects)
ocspcheck_LDADD += $(PLATFORM_LDADD) $(PROG_LDADD)

ocspcheck_SOURCES = http.c
ocspcheck_SOURCES += ocspcheck.c
noinst_HEADERS = http.h

if !HAVE_MEMMEM
ocspcheck_SOURCES += compat/memmem.c
endif
