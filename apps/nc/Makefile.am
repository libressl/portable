include $(top_srcdir)/Makefile.am.common

if HOST_OPENBSD

if HAVE_POLL

noinst_PROGRAMS = nc

EXTRA_DIST = nc.1

nc_LDADD = $(PLATFORM_LDADD) $(PROG_LDADD)
nc_LDADD += $(top_builddir)/tls/libtls.la

nc_SOURCES = atomicio.c
nc_SOURCES += netcat.c
nc_SOURCES += socks.c
noinst_HEADERS = atomicio.h

if !HAVE_STRTONUM
nc_SOURCES += strtonum.c
endif

endif

endif
