#
# Copyright (c) 2015 Brent Cook
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

if BUILD_NC

if ENABLE_NC
bin_PROGRAMS = nc
dist_man_MANS = nc.1
else
noinst_PROGRAMS = nc
endif

EXTRA_DIST = nc.1
EXTRA_DIST += CMakeLists.txt

nc_LDADD = $(libcrypto_la_objects)
nc_LDADD += $(libcompat_la_objects)
nc_LDADD += $(libcompatnoopt_la_objects)
nc_LDADD += $(libssl_la_objects)
nc_LDADD += $(libtls_la_objects)

nc_LDADD += $(PLATFORM_LDADD) $(PROG_LDADD)

AM_CPPFLAGS += -I$(top_srcdir)/apps/nc/compat

nc_SOURCES = atomicio.c
nc_SOURCES += netcat.c
nc_SOURCES += socks.c
noinst_HEADERS = atomicio.h
noinst_HEADERS += compat/sys/socket.h

nc_SOURCES += compat/socket.c

if !HAVE_B64_NTOP
nc_SOURCES += compat/base64.c
endif

if !HAVE_ACCEPT4
nc_SOURCES += compat/accept4.c
endif

if !HAVE_READPASSPHRASE
nc_SOURCES += compat/readpassphrase.c
endif

endif
