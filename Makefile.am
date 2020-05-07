SUBDIRS = crypto ssl tls include apps man
if ENABLE_TESTS
SUBDIRS += tests
endif
ACLOCAL_AMFLAGS = -I m4

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libcrypto.pc libssl.pc libtls.pc openssl.pc

EXTRA_DIST = README.md README.windows VERSION config scripts
EXTRA_DIST += CMakeLists.txt cmake_export_symbol.cmake cmake_uninstall.cmake.in FindLibreSSL.cmake

.PHONY: install_sw
install_sw: install
