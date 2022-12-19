include $(top_srcdir)/Makefile.am.common

-include $(abs_top_builddir)/crypto/libcrypto_la_objects.mk
-include $(abs_top_builddir)/ssl/libssl_la_objects.mk
-include $(abs_top_builddir)/tls/libtls_la_objects.mk

if !ENABLE_LIBTLS_ONLY
bin_PROGRAMS = ocspcheck
dist_man_MANS = ocspcheck.8
else
noinst_PROGRAMS = ocspcheck
endif

EXTRA_DIST = ocspcheck.8
EXTRA_DIST += CMakeLists.txt

ocspcheck_LDADD = $(libcrypto_la_objects)
ocspcheck_LDADD += $(libcompat_la_objects)
ocspcheck_LDADD += $(libcompatnoopt_la_objects)
ocspcheck_LDADD += $(libssl_la_objects)
ocspcheck_LDADD += $(libtls_la_objects)
ocspcheck_LDADD += $(PLATFORM_LDADD) $(PROG_LDADD)

ocspcheck_SOURCES = http.c
ocspcheck_SOURCES += ocspcheck.c
noinst_HEADERS = http.h

if !HAVE_MEMMEM
ocspcheck_SOURCES += compat/memmem.c
endif
