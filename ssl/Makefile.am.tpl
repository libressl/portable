include $(top_srcdir)/Makefile.am.common

lib_LTLIBRARIES = libssl.la

libssl_la_LDFLAGS = -version-info libssl-version

libssl_la_CFLAGS = $(CFLAGS) $(USER_CFLAGS)
libssl_la_SOURCES =
noinst_HEADERS =
