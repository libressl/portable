include $(top_srcdir)/Makefile.am.common

AM_CPPFLAGS += -I $(top_srcdir)/crypto/modes
AM_CPPFLAGS += -I $(top_srcdir)/crypto/asn1

LDADD = $(PLATFORM_LDADD) $(PROG_LDADD)
LDADD += $(top_builddir)/ssl/libssl.la
LDADD += $(top_builddir)/crypto/libcrypto.la

CFLAGS += $(CODE_COVERAGE_CFLAGS)
LDFLAGS += $(CODE_COVERAGE_LDFLAGS)

TESTS =
check_PROGRAMS =
EXTRA_DIST =
DISTCLEANFILES = pidwraptest.txt

