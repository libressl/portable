SUBDIRS = crypto ssl tls include apps tests man
ACLOCAL_AMFLAGS = -I m4

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libcrypto.pc libssl.pc openssl.pc

if ENABLE_LIBTLS
pkgconfig_DATA += libtls.pc
endif

EXTRA_DIST = VERSION
