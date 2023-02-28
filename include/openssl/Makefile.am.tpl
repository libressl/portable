include $(top_srcdir)/Makefile.am.common

if !ENABLE_LIBTLS_ONLY
opensslincludedir=$(includedir)/openssl

BUILT_SOURCES = opensslconf.h
CLEANFILES = opensslconf.h

opensslconf.h: Makefile
	-echo "generating opensslconf.h ..."
if HOST_AARCH64
	-cp $(top_srcdir)/include/arch/aarch64/opensslconf.h opensslconf.h
endif
if HOST_ARM
	-cp $(top_srcdir)/include/arch/arm/opensslconf.h opensslconf.h
endif
if HOST_I386
	-cp $(top_srcdir)/include/arch/i386/opensslconf.h opensslconf.h
endif
if HOST_MIPS64
	-cp $(top_srcdir)/include/arch/mips64/opensslconf.h opensslconf.h
endif
if HOST_POWERPC
	-cp $(top_srcdir)/include/arch/powerpc/opensslconf.h opensslconf.h
endif
if HOST_POWERPC64
	-cp $(top_srcdir)/include/arch/powerpc64/opensslconf.h opensslconf.h
endif
if HOST_RISCV64
	-cp $(top_srcdir)/include/arch/riscv64/opensslconf.h opensslconf.h
endif
if HOST_SPARC64
	-cp $(top_srcdir)/include/arch/sparc64/opensslconf.h opensslconf.h
endif
if HOST_X86_64
	-cp $(top_srcdir)/include/arch/amd64/opensslconf.h opensslconf.h
endif

opensslinclude_HEADERS = opensslconf.h
