include $(top_srcdir)/Makefile.am.common

lib_LTLIBRARIES = libtls.la

EXTRA_DIST = VERSION

libtls_la_LDFLAGS = -version-info @LIBTLS_VERSION@ -no-undefined
libtls_la_LIBADD = ../crypto/libcrypto.la ../ssl/libssl.la $(PLATFORM_LDADD)

libtls_la_SOURCES = tls.c
libtls_la_SOURCES += tls_client.c
libtls_la_SOURCES += tls_config.c
libtls_la_SOURCES += tls_server.c
libtls_la_SOURCES += tls_util.c
libtls_la_SOURCES += tls_verify.c
noinst_HEADERS = tls_internal.h

if !HAVE_STRSEP
libtls_la_SOURCES += strsep.c
endif
