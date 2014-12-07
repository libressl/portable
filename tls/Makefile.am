include $(top_srcdir)/Makefile.am.common

if ENABLE_LIBTLS
lib_LTLIBRARIES = libtls.la

EXTRA_DIST = VERSION

libtls_la_LDFLAGS = -version-info @LIBTLS_VERSION@
libtls_la_CFLAGS = $(CFLAGS) $(USER_CFLAGS)

libtls_la_SOURCES = tls.c
libtls_la_SOURCES += tls_client.c
libtls_la_SOURCES += tls_config.c
libtls_la_SOURCES += tls_server.c
libtls_la_SOURCES += tls_util.c
libtls_la_SOURCES += tls_verify.c
noinst_HEADERS = tls_internal.h
endif
