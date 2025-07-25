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

if !ENABLE_LIBTLS_ONLY
bin_PROGRAMS = openssl
dist_man_MANS = openssl.1
else
noinst_PROGRAMS = openssl
endif

openssl_LDADD = $(libcrypto_la_objects)
openssl_LDADD += $(libcompat_la_objects)
openssl_LDADD += $(libcompatnoopt_la_objects)
openssl_LDADD += $(libssl_la_objects)
openssl_LDADD += $(PLATFORM_LDADD) $(PROG_LDADD)

openssl_SOURCES = apps.c
openssl_SOURCES += asn1pars.c
openssl_SOURCES += ca.c
openssl_SOURCES += ciphers.c
openssl_SOURCES += crl.c
openssl_SOURCES += crl2p7.c
openssl_SOURCES += cms.c
openssl_SOURCES += dgst.c
openssl_SOURCES += dh.c
openssl_SOURCES += dhparam.c
openssl_SOURCES += dsa.c
openssl_SOURCES += dsaparam.c
openssl_SOURCES += ec.c
openssl_SOURCES += ecparam.c
openssl_SOURCES += enc.c
openssl_SOURCES += errstr.c
openssl_SOURCES += gendh.c
openssl_SOURCES += gendsa.c
openssl_SOURCES += genpkey.c
openssl_SOURCES += genrsa.c
openssl_SOURCES += ocsp.c
openssl_SOURCES += openssl.c
openssl_SOURCES += passwd.c
openssl_SOURCES += pkcs12.c
openssl_SOURCES += pkcs7.c
openssl_SOURCES += pkcs8.c
openssl_SOURCES += pkey.c
openssl_SOURCES += pkeyparam.c
openssl_SOURCES += pkeyutl.c
openssl_SOURCES += prime.c
openssl_SOURCES += rand.c
openssl_SOURCES += req.c
openssl_SOURCES += rsa.c
openssl_SOURCES += rsautl.c
openssl_SOURCES += s_cb.c
openssl_SOURCES += s_client.c
openssl_SOURCES += s_server.c
openssl_SOURCES += s_socket.c
openssl_SOURCES += s_time.c
openssl_SOURCES += sess_id.c
openssl_SOURCES += smime.c
openssl_SOURCES += speed.c
openssl_SOURCES += ts.c
openssl_SOURCES += verify.c
openssl_SOURCES += version.c
openssl_SOURCES += x509.c

if BUILD_CERTHASH
openssl_SOURCES += certhash.c
else
openssl_SOURCES += certhash_win.c
endif

if HOST_WIN
openssl_SOURCES += apps_win.c
else
openssl_SOURCES += apps_posix.c
endif

if !HAVE_POLL
if HOST_WIN
openssl_SOURCES += compat/poll_win.c
endif
endif

if !HAVE_CLOCK_GETTIME
if HOST_DARWIN
openssl_SOURCES += compat/clock_gettime_osx.c
endif
endif

noinst_HEADERS = apps.h

EXTRA_DIST = CMakeLists.txt

