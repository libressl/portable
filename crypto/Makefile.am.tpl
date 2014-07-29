include $(top_srcdir)/Makefile.am.common

AM_CPPFLAGS += -I$(top_srcdir)/crypto/asn1
AM_CPPFLAGS += -I$(top_srcdir)/crypto/evp
AM_CPPFLAGS += -I$(top_srcdir)/crypto/modes

lib_LTLIBRARIES = libcrypto.la

libcrypto_la_LIBADD = libcompat.la libcompatnoopt.la
libcrypto_la_LDFLAGS = -version-info libcrypto-version
libcrypto_la_CFLAGS = $(CFLAGS) $(USER_CFLAGS) -DOPENSSL_NO_HW_PADLOCK

noinst_LTLIBRARIES = libcompat.la libcompatnoopt.la

# compatibility functions that need to be built without optimizations
libcompatnoopt_la_CFLAGS = -O0
libcompatnoopt_la_SOURCES =

if NO_EXPLICIT_BZERO
libcompatnoopt_la_SOURCES += compat/explicit_bzero.c
endif

# other compatibility functions
libcompat_la_CFLAGS = $(CFLAGS) $(USER_CFLAGS)
libcompat_la_SOURCES =
libcompat_la_LIBADD = $(PLATFORM_LDADD)

if NO_STRLCAT
libcompat_la_SOURCES += compat/strlcat.c
endif

if NO_STRLCPY
libcompat_la_SOURCES += compat/strlcpy.c
endif

if NO_STRNDUP
libcompat_la_SOURCES += compat/strndup.c
libcompat_la_SOURCES += compat/strnlen.c
endif

if NO_ASPRINTF
libcompat_la_SOURCES += compat/asprintf.c
endif

if NO_REALLOCARRAY
libcompat_la_SOURCES += compat/reallocarray.c
endif

if NO_TIMINGSAFE_MEMCMP
libcompat_la_SOURCES += compat/timingsafe_memcmp.c
endif

if NO_TIMINGSAFE_BCMP
libcompat_la_SOURCES += compat/timingsafe_bcmp.c
endif

if NO_ARC4RANDOM_BUF
libcompat_la_SOURCES += compat/arc4random.c

if NO_GETENTROPY
if HOST_LINUX
libcompat_la_SOURCES += compat/getentropy_linux.c
endif
if HOST_DARWIN
libcompat_la_SOURCES += compat/getentropy_osx.c
endif
if HOST_SOLARIS
libcompat_la_SOURCES += compat/getentropy_solaris.c
endif
if HOST_WIN
libcompat_la_SOURCES += compat/getentropy_win.c
endif
endif

endif

if NO_ISSETUGID
if HOST_LINUX
libcompat_la_SOURCES += compat/issetugid_linux.c
endif
endif

noinst_HEADERS = des/ncbc_enc.c
noinst_HEADERS += compat/arc4random.h
noinst_HEADERS += compat/arc4random_linux.h
noinst_HEADERS += compat/arc4random_osx.h
noinst_HEADERS += compat/arc4random_solaris.h
noinst_HEADERS += compat/arc4random_win.h
noinst_HEADERS += compat/chacha_private.h
libcrypto_la_SOURCES =
EXTRA_libcrypto_la_SOURCES =
