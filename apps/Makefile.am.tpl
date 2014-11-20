include $(top_srcdir)/Makefile.am.common

bin_PROGRAMS = openssl

openssl_CFLAGS = $(USER_CFLAGS)
openssl_LDADD = $(PLATFORM_LDADD) $(PROG_LDADD)
openssl_LDADD += $(top_builddir)/ssl/libssl.la
openssl_LDADD += $(top_builddir)/crypto/libcrypto.la

openssl_SOURCES =
noinst_HEADERS =

if !HAVE_STRTONUM
openssl_SOURCES += strtonum.c
endif

if !HAVE_POLL
if HOST_WIN
openssl_SOURCES += poll.c
endif
endif
