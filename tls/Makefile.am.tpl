include $(top_srcdir)/Makefile.am.common

lib_LTLIBRARIES = libtls.la

libtls_la_LDFLAGS = -version-info libtls-version

libtls_la_CFLAGS = $(CFLAGS) $(USER_CFLAGS)
libtls_la_SOURCES =
noinst_HEADERS =

