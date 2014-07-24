include $(top_srcdir)/Makefile.am.common

AM_CPPFLAGS += -I $(top_srcdir)/crypto/modes
AM_CPPFLAGS += -I $(top_srcdir)/crypto/asn1

TESTS =
check_PROGRAMS =
EXTRA_DIST =

if !NO_ARC4RANDOM_BUF
TESTS += pidwraptest.sh
endif
